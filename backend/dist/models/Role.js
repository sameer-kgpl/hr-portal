import { getDbPool } from '../config/db.js';
export async function findRoleByName(name) {
    const [rows] = await getDbPool().query('SELECT * FROM roles WHERE name = ? LIMIT 1', [name]);
    return rows[0] ?? null;
}
export async function listRoles() {
    const [rows] = await getDbPool().query('SELECT * FROM roles ORDER BY id ASC');
    return rows;
}
//# sourceMappingURL=Role.js.map