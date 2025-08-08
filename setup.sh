#!/usr/bin/env bash
set -euo pipefail

# This script sets up the application on Ubuntu (latest LTS)
# - Installs Node.js 20, MySQL 8, nginx, PM2
# - Creates MySQL DB and user, imports schema and seed
# - Builds backend and frontend
# - Configures nginx to serve frontend build
# - Starts backend with PM2

APP_DIR="/workspace"
BACKEND_DIR="$APP_DIR/backend"
FRONTEND_DIR="$APP_DIR/frontend"
DB_DIR="$APP_DIR/db"
UPLOAD_DIR="$APP_DIR/storage/uploads"

# 1) System dependencies
sudo apt-get update
sudo apt-get install -y curl ca-certificates gnupg build-essential nginx mysql-server

# 2) Node.js 20.x
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# 3) PM2
sudo npm install -g pm2

# 4) MySQL secure setup (non-interactive minimal)
sudo systemctl enable --now mysql

# Set MySQL root password and auth method if needed
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpass'; FLUSH PRIVILEGES;" || true

# 5) Create DB, user and import schema + seed
mysql -uroot -prootpass -e "CREATE DATABASE IF NOT EXISTS recruitment_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot -prootpass -e "CREATE USER IF NOT EXISTS 'recruitment_user'@'%' IDENTIFIED BY 'recruitment_pass';"
mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON recruitment_portal.* TO 'recruitment_user'@'%'; FLUSH PRIVILEGES;"
mysql -uroot -prootpass recruitment_portal < "$DB_DIR/schema.sql"
mysql -uroot -prootpass recruitment_portal < "$DB_DIR/seed.sql"

# 6) Backend env
mkdir -p "$UPLOAD_DIR"
if [ ! -f "$BACKEND_DIR/.env" ]; then
  cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
  sed -i "s|DB_HOST=localhost|DB_HOST=localhost|" "$BACKEND_DIR/.env"
  sed -i "s|DB_USER=recruitment_user|DB_USER=recruitment_user|" "$BACKEND_DIR/.env"
  sed -i "s|DB_PASSWORD=change_me|DB_PASSWORD=recruitment_pass|" "$BACKEND_DIR/.env"
  sed -i "s|UPLOAD_DIR=../storage/uploads|UPLOAD_DIR=$UPLOAD_DIR|" "$BACKEND_DIR/.env"
fi

# 7) Backend build
pushd "$BACKEND_DIR"
npm ci
npm run build

# 8) Set default passwords (admin/recruiter/candidate) using bcrypt via Node
node -e "const bcrypt=require('bcryptjs'); const pw=process.argv[1]; const hash=bcrypt.hashSync(pw,10); console.log(hash);" 'Admin@123' > /tmp/admin.hash
node -e "const bcrypt=require('bcryptjs'); const pw=process.argv[1]; const hash=bcrypt.hashSync(pw,10); console.log(hash);" 'Recruiter@123' > /tmp/recruiter.hash
node -e "const bcrypt=require('bcryptjs'); const pw=process.argv[1]; const hash=bcrypt.hashSync(pw,10); console.log(hash);" 'Candidate@123' > /tmp/candidate.hash
mysql -uroot -prootpass recruitment_portal -e "UPDATE users SET password_hash='$(cat /tmp/admin.hash)' WHERE email='admin@example.com';"
mysql -uroot -prootpass recruitment_portal -e "UPDATE users SET password_hash='$(cat /tmp/recruiter.hash)' WHERE email='recruiter@example.com';"
mysql -uroot -prootpass recruitment_portal -e "UPDATE users SET password_hash='$(cat /tmp/candidate.hash)' WHERE email='candidate@example.com';"
rm -f /tmp/*.hash

# 9) Run backend via PM2
pm2 delete recruitment-portal-api || true
pm2 start dist/server.js --name recruitment-portal-api
pm2 save
popd

# 10) Frontend .env
if [ ! -f "$FRONTEND_DIR/.env" ]; then
  cp "$FRONTEND_DIR/.env.example" "$FRONTEND_DIR/.env"
fi

# 11) Frontend build and deploy to nginx
pushd "$FRONTEND_DIR"
npm ci
npm run build
sudo mkdir -p /var/www/recruitment-portal-frontend
sudo cp -r dist/* /var/www/recruitment-portal-frontend/
sudo cp "$APP_DIR/deploy/nginx-frontend.conf" /etc/nginx/sites-available/recruitment-portal-frontend
sudo ln -sf /etc/nginx/sites-available/recruitment-portal-frontend /etc/nginx/sites-enabled/recruitment-portal-frontend
sudo rm -f /etc/nginx/sites-enabled/default || true
sudo nginx -t
sudo systemctl reload nginx
popd

echo "Setup complete."
echo "Backend API: http://localhost:4000"
echo "Frontend UI: http://localhost/"