import dotenv from 'dotenv';

dotenv.config();

function getEnv(key: string, fallback?: string): string {
  const value = process.env[key];
  if (value === undefined || value === '') {
    if (fallback !== undefined) return fallback;
    throw new Error(`Missing required env var: ${key}`);
  }
  return value;
}

export const env = {
  nodeEnv: getEnv('NODE_ENV', 'development'),
  port: parseInt(getEnv('PORT', '4000'), 10),
  db: {
    host: getEnv('DB_HOST', 'localhost'),
    port: parseInt(getEnv('DB_PORT', '3306'), 10),
    name: getEnv('DB_NAME', 'recruitment_portal'),
    user: getEnv('DB_USER', 'root'),
    password: getEnv('DB_PASSWORD', ''),
    connectionLimit: parseInt(getEnv('DB_CONN_LIMIT', '10'), 10),
  },
  auth: {
    jwtSecret: getEnv('JWT_SECRET'),
    jwtExpiresIn: getEnv('JWT_EXPIRES_IN', '1d'),
  },
  uploads: {
    dir: getEnv('UPLOAD_DIR', '../storage/uploads'),
    maxUploadMb: parseInt(getEnv('MAX_UPLOAD_MB', '10'), 10),
  },
  security: {
    corsOrigin: getEnv('CORS_ORIGIN', '*'),
    rateLimitWindowMs: parseInt(getEnv('RATE_LIMIT_WINDOW_MS', '60000'), 10),
    rateLimitMax: parseInt(getEnv('RATE_LIMIT_MAX', '100'), 10),
  },
};