import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import morgan from 'morgan';
import path from 'path';
import { fileURLToPath } from 'url';
import { env } from './config/env.js';
const app = express();
app.use(helmet());
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(cors({
    origin: env.security.corsOrigin === '*' ? true : env.security.corsOrigin,
    credentials: true,
}));
app.use(rateLimit({
    windowMs: env.security.rateLimitWindowMs,
    max: env.security.rateLimitMax,
    standardHeaders: true,
    legacyHeaders: false,
}));
app.use(morgan('combined'));
// Health endpoint
app.get('/health', (_req, res) => {
    res.json({ status: 'ok' });
});
// Static frontend (serve built React app if present)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const publicDir = path.resolve(__dirname, '../public');
app.use(express.static(publicDir));
// TODO: mount API routes here (prefix with /api)
// SPA fallback (after API routes)
app.get('*', (_req, res, next) => {
    if (_req.path.startsWith('/api/'))
        return next();
    res.sendFile(path.join(publicDir, 'index.html'));
});
// 404 handler
app.use((_req, res) => {
    res.status(404).json({ error: 'Not found' });
});
// Error handler
// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((err, _req, res, _next) => {
    const status = err.status || 500;
    const message = err.message || 'Internal Server Error';
    res.status(status).json({ error: message });
});
export default app;
//# sourceMappingURL=app.js.map