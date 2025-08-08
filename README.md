## Recruitment Portal (On-Prem, Offline)

A simple on-prem candidate search & recruitment portal. Runs entirely on your infrastructure.

### Stack
- Backend: Node.js + Express (TypeScript)
- Frontend: React + Vite
- Database: MySQL 8
- Containerization: Dockerfiles + docker-compose (optional)

### Features (initial)
- JWT auth and role placeholders (Admin, Recruiter, Candidate)
- Candidate model, basic search API (backend WIP routes to be added)
- Resume and keyword tables (processing to be added next)
- Minimal frontend pages: Login, Recruiter Search, Candidate Profile, Admin Users

---

## 1) Prerequisites
- Ubuntu LTS
- Node.js 20+ and npm
- MySQL 8+
- nginx (for serving frontend) or use Docker

## 2) Database setup
Run:
```bash
mysql -uroot -p < db/schema.sql
mysql -uroot -p < db/seed.sql
```
Or use docker-compose which auto-initializes with these files.

## 3) Configuration
Copy env examples and adjust values:
```bash
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```
Important keys:
- backend `.env`: `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `JWT_SECRET`, `UPLOAD_DIR`
- frontend `.env`: `VITE_API_BASE_URL` (e.g., `http://localhost:4000`)

## 4) Manual install on Ubuntu
Use the script:
```bash
chmod +x setup.sh
./setup.sh
```
What it does:
- Installs Node.js 20, MySQL 8, nginx, PM2
- Creates DB, user, imports schema and seed
- Builds backend and frontend
- Sets default passwords:
  - admin@example.com / Admin@123
  - recruiter@example.com / Recruiter@123
  - candidate@example.com / Candidate@123
- Runs backend via PM2 and serves frontend at `http://localhost/`

## 5) Docker (recommended for quick start)
```bash
docker compose build
docker compose up -d
```
- Frontend: http://localhost:5173
- Backend API: http://localhost:4000
- MySQL: localhost:3306 (user: `recruitment_user`, pass: `recruitment_pass`)

## 6) Development
- Backend:
```bash
cd backend
npm ci
npm run dev
```
- Frontend:
```bash
cd frontend
npm ci
npm run dev
```

## 7) NLP options (to be added)
- Node-only pipeline (natural/compromise/wink-nlp)
- Python microservice (spaCy) over localhost
Switching will be controlled via backend env & a small adapter. Instructions will be added when services are committed.

## 8) Security & notes
- All services are local-only by default
- Change `JWT_SECRET` in production
- Ensure `UPLOAD_DIR` has restricted permissions
- Configure nginx/HTTPS via your certificate management

## 9) Next
- Backend routes (auth, candidates CRUD, resumes upload, search/ranking)
- Swagger/OpenAPI and Postman collection
- Unit tests and E2E outline

---

### Paths of interest
- Frontend: `frontend/` (entry: `index.html`, `src/main.tsx`, `src/App.tsx`)
- Backend API: `backend/` (entry: `src/server.ts`)
- Database: `db/schema.sql`, `db/seed.sql`
- Deployment: `docker-compose.yml`, `setup.sh`, `deploy/nginx-frontend.conf`