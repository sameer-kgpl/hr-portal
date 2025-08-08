import { ResultSetHeader, RowDataPacket } from 'mysql2';
import { getDbPool } from '../config/db.js';

export interface User {
  id: number;
  full_name: string;
  email: string;
  phone: string | null;
  password_hash: string;
  role_id: number;
  is_active: 0 | 1;
  created_at: string;
  updated_at: string;
}

export async function findUserByEmail(email: string): Promise<User | null> {
  const [rows] = await getDbPool().query<(User & RowDataPacket)[]>(
    'SELECT * FROM users WHERE email = ? LIMIT 1',
    [email]
  );
  return rows[0] ?? null;
}

export async function findUserById(id: number): Promise<User | null> {
  const [rows] = await getDbPool().query<(User & RowDataPacket)[]>(
    'SELECT * FROM users WHERE id = ? LIMIT 1',
    [id]
  );
  return rows[0] ?? null;
}

export interface CreateUserInput {
  full_name: string;
  email: string;
  phone?: string | null;
  password_hash: string;
  role_id: number;
  is_active?: 0 | 1;
}

export async function createUser(input: CreateUserInput): Promise<number> {
  const [res] = await getDbPool().execute<ResultSetHeader>(
    `INSERT INTO users (full_name, email, phone, password_hash, role_id, is_active)
     VALUES (:full_name, :email, :phone, :password_hash, :role_id, :is_active)`,
    {
      full_name: input.full_name,
      email: input.email,
      phone: input.phone ?? null,
      password_hash: input.password_hash,
      role_id: input.role_id,
      is_active: input.is_active ?? 1,
    }
  );
  return res.insertId;
}