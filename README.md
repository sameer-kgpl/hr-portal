## Recruitment Portal (On-Prem, Offline)

A simple on-prem candidate search & recruitment portal. Runs entirely on your infrastructure.

### Stack
- Backend: Node.js + Express (TypeScript)
- Frontend: React + Vite (static build)
- Database: MySQL 8
- Web server: nginx or Apache (your choice)

### Features (initial)
- JWT auth and role placeholders (Admin, Recruiter, Candidate)
- Candidate model, basic search API (backend WIP routes to be added)
- Resume and keyword tables (processing to be added next)
- Minimal frontend pages: Login, Recruiter Search, Candidate Profile, Admin Users

---

## 1) Prerequisites (Ubuntu LTS)
- Node.js 20+ and npm
- MySQL 8+
- nginx or Apache2
- systemd

## 2) Database setup
```bash
mysql -uroot -p < db/schema.sql
mysql -uroot -p < db/seed.sql
```
Create DB user and grant permissions if needed:
```sql
CREATE USER IF NOT EXISTS 'recruitment_user'@'localhost' IDENTIFIED BY 'recruitment_pass';
GRANT ALL PRIVILEGES ON recruitment_portal.* TO 'recruitment_user'@'localhost';
FLUSH PRIVILEGES;
```

## 3) Backend build
```bash
cd backend
cp .env.example .env
# edit .env for DB credentials, JWT_SECRET, UPLOAD_DIR
npm ci
npm run build
```
Optionally set default passwords for seeded users (admin/recruiter/candidate) using bcrypt via Node REPL or script. Example:
```bash
node -e "const b=require('bcryptjs');console.log(b.hashSync('Admin@123',10));"
# update users table with the hash for admin@example.com
```

## 4) Frontend build
```bash
cd frontend
cp .env.example .env
# set VITE_API_BASE_URL (e.g., http://localhost:4000 or http://yourhost/api)
npm ci
npm run build
sudo mkdir -p /var/www/recruitment-portal-frontend
sudo cp -r dist/* /var/www/recruitment-portal-frontend/
```

## 5) Run backend as a systemd service
Install files to `/opt` and systemd unit:
```bash
sudo mkdir -p /opt/recruitment-portal
sudo cp -r backend /opt/recruitment-portal/
# ensure /opt/recruitment-portal/backend/dist exists from build

sudo mkdir -p /var/lib/recruitment-portal/uploads
sudo chown -R www-data:www-data /var/lib/recruitment-portal

sudo cp deploy/recruitment-portal-api.service /etc/systemd/system/recruitment-portal-api.service
sudo systemctl daemon-reload
sudo systemctl enable --now recruitment-portal-api
sudo systemctl status recruitment-portal-api
```
Adjust environment values in the unit file as needed (DB creds, JWT secret, etc.).

## 6A) nginx configuration
```bash
sudo cp deploy/nginx-site.conf /etc/nginx/sites-available/recruitment-portal
sudo ln -sf /etc/nginx/sites-available/recruitment-portal /etc/nginx/sites-enabled/recruitment-portal
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```
- Frontend served at `http://yourhost/`
- API proxied at `http://yourhost/api/*` to Node backend on `127.0.0.1:4000`

## 6B) Apache configuration (alternative)
Enable needed modules and site:
```bash
sudo a2enmod proxy proxy_http headers rewrite
sudo cp deploy/apache-site.conf /etc/apache2/sites-available/recruitment-portal.conf
sudo a2ensite recruitment-portal
sudo systemctl reload apache2
```
- Frontend served from `/var/www/recruitment-portal-frontend`
- API proxied at `/api/*` to `127.0.0.1:4000`

## 7) Environment notes
- backend `.env`: `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `JWT_SECRET`, `UPLOAD_DIR`
- frontend `.env`: `VITE_API_BASE_URL` (use `/api` if fronted by web server proxy)

## 8) Security
- Change `JWT_SECRET` and user passwords
- Lock down MySQL to local access where possible
- Limit upload size and file types (handled in backend; ensure filesystem perms)
- Configure HTTPS with your certs on nginx/Apache

## 9) Troubleshooting
- Backend logs: `journalctl -u recruitment-portal-api -f`
- nginx: `sudo nginx -t && sudo tail -f /var/log/nginx/error.log`
- Apache: `sudo tail -f /var/log/apache2/error.log`
- DB connectivity: verify `.env` and MySQL grants

---

### Paths
- Frontend build root: `/var/www/recruitment-portal-frontend`
- Backend service root: `/opt/recruitment-portal/backend`
- Uploads dir: `/var/lib/recruitment-portal/uploads`
- Configs: `deploy/nginx-site.conf`, `deploy/apache-site.conf`, `deploy/recruitment-portal-api.service`