import { getDbPool } from '../config/db.js';
export async function findUserByEmail(email) {
    const [rows] = await getDbPool().query('SELECT * FROM users WHERE email = ? LIMIT 1', [email]);
    return rows[0] ?? null;
}
export async function findUserById(id) {
    const [rows] = await getDbPool().query('SELECT * FROM users WHERE id = ? LIMIT 1', [id]);
    return rows[0] ?? null;
}
export async function createUser(input) {
    const [res] = await getDbPool().execute(`INSERT INTO users (full_name, email, phone, password_hash, role_id, is_active)
     VALUES (:full_name, :email, :phone, :password_hash, :role_id, :is_active)`, {
        full_name: input.full_name,
        email: input.email,
        phone: input.phone ?? null,
        password_hash: input.password_hash,
        role_id: input.role_id,
        is_active: input.is_active ?? 1,
    });
    return res.insertId;
}
//# sourceMappingURL=User.js.map