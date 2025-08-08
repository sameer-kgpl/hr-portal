import { RowDataPacket } from 'mysql2';
import { getDbPool } from '../config/db.js';

export interface Role {
  id: number;
  name: 'admin' | 'recruiter' | 'candidate' | string;
  description: string | null;
  created_at: string;
  updated_at: string;
}

export async function findRoleByName(name: string): Promise<Role | null> {
  const [rows] = await getDbPool().query<(Role & RowDataPacket)[]>(
    'SELECT * FROM roles WHERE name = ? LIMIT 1',
    [name]
  );
  return rows[0] ?? null;
}

export async function listRoles(): Promise<Role[]> {
  const [rows] = await getDbPool().query<(Role & RowDataPacket)[]>(
    'SELECT * FROM roles ORDER BY id ASC'
  );
  return rows as Role[];
}