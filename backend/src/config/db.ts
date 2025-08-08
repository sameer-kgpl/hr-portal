import mysql, { Pool, PoolOptions } from 'mysql2/promise';
import { env } from './env.js';

let pool: Pool | null = null;

export function getDbPool(): Pool {
  if (pool) return pool;
  const options: PoolOptions = {
    host: env.db.host,
    port: env.db.port,
    user: env.db.user,
    password: env.db.password,
    database: env.db.name,
    connectionLimit: env.db.connectionLimit,
    waitForConnections: true,
    queueLimit: 0,
    charset: 'utf8mb4_general_ci',
    timezone: 'Z',
    supportBigNumbers: true,
    dateStrings: false,
    namedPlaceholders: true,
  };
  pool = mysql.createPool(options);
  return pool;
}

export async function healthcheckDb(): Promise<void> {
  const p = getDbPool();
  const conn = await p.getConnection();
  try {
    await conn.query('SELECT 1');
  } finally {
    conn.release();
  }
}