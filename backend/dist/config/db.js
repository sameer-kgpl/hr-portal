import mysql from 'mysql2/promise';
import { env } from './env.js';
let pool = null;
export function getDbPool() {
    if (pool)
        return pool;
    const options = {
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
export async function healthcheckDb() {
    const p = getDbPool();
    const conn = await p.getConnection();
    try {
        await conn.query('SELECT 1');
    }
    finally {
        conn.release();
    }
}
//# sourceMappingURL=db.js.map