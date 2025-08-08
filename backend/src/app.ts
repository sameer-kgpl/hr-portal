import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import morgan from 'morgan';
import { env } from './config/env.js';

const app = express();

app.use(helmet());
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(
  cors({
    origin: env.security.corsOrigin === '*' ? true : env.security.corsOrigin,
    credentials: true,
  })
);
app.use(
  rateLimit({
    windowMs: env.security.rateLimitWindowMs,
    max: env.security.rateLimitMax,
    standardHeaders: true,
    legacyHeaders: false,
  })
);
app.use(morgan('combined'));

// Health endpoint
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// TODO: mount routes here (auth, users, candidates, search, resumes)

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((err: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  const status = err.status || 500;
  const message = err.message || 'Internal Server Error';
  res.status(status).json({ error: message });
});

export default app;