import { ResultSetHeader, RowDataPacket } from 'mysql2';
import { getDbPool } from '../config/db.js';

export type NoticePeriod = 'Immediate' | '15 days' | '30 days';

export interface Candidate {
  id: number;
  user_id: number | null;
  full_name: string;
  email: string | null;
  phone: string | null;
  current_location: string | null;
  preferred_location: string | null;
  total_experience_years: number;
  notice_period: NoticePeriod;
  availability_date: string | null; // YYYY-MM-DD
  skills_json: any | null; // JSON array
  skills_flat: string | null;
  last_updated: string;
  generic_notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface CreateCandidateInput {
  user_id?: number | null;
  full_name: string;
  email?: string | null;
  phone?: string | null;
  current_location?: string | null;
  preferred_location?: string | null;
  total_experience_years: number;
  notice_period: NoticePeriod;
  availability_date?: string | null;
  skills_json?: any[] | null;
  skills_flat?: string | null;
  generic_notes?: string | null;
}

export async function createCandidate(input: CreateCandidateInput): Promise<number> {
  const [res] = await getDbPool().execute<ResultSetHeader>(
    `INSERT INTO candidates (
       user_id, full_name, email, phone, current_location, preferred_location,
       total_experience_years, notice_period, availability_date, skills_json, skills_flat, generic_notes
     ) VALUES (
       :user_id, :full_name, :email, :phone, :current_location, :preferred_location,
       :total_experience_years, :notice_period, :availability_date, :skills_json, :skills_flat, :generic_notes
     )`,
    {
      user_id: input.user_id ?? null,
      full_name: input.full_name,
      email: input.email ?? null,
      phone: input.phone ?? null,
      current_location: input.current_location ?? null,
      preferred_location: input.preferred_location ?? null,
      total_experience_years: input.total_experience_years,
      notice_period: input.notice_period,
      availability_date: input.availability_date ?? null,
      skills_json: input.skills_json ? JSON.stringify(input.skills_json) : null,
      skills_flat: input.skills_flat ?? null,
      generic_notes: input.generic_notes ?? null,
    }
  );
  return res.insertId;
}

export async function findCandidateById(id: number): Promise<Candidate | null> {
  const [rows] = await getDbPool().query<(Candidate & RowDataPacket)[]>(
    'SELECT * FROM candidates WHERE id = ? LIMIT 1',
    [id]
  );
  return rows[0] ?? null;
}

export interface SearchCandidatesParams {
  name?: string;
  skills?: string[];
  location?: string;
  minExp?: number;
  maxExp?: number;
  notice?: NoticePeriod | 'Any';
  updatedWithinDays?: number; // e.g. 30
  page?: number;
  pageSize?: number;
  sort?: 'recent' | 'experience_desc' | 'experience_asc';
}

export interface PagedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

export async function searchCandidates(params: SearchCandidatesParams): Promise<PagedResult<Candidate>> {
  const conditions: string[] = [];
  const values: any[] = [];

  if (params.name) {
    conditions.push('(full_name LIKE ? OR email LIKE ?)');
    values.push(`%${params.name}%`, `%${params.name}%`);
  }
  if (params.location) {
    conditions.push('(current_location = ? OR preferred_location = ?)');
    values.push(params.location, params.location);
  }
  if (params.minExp !== undefined) {
    conditions.push('total_experience_years >= ?');
    values.push(params.minExp);
  }
  if (params.maxExp !== undefined) {
    conditions.push('total_experience_years <= ?');
    values.push(params.maxExp);
  }
  if (params.notice && params.notice !== 'Any') {
    conditions.push('notice_period = ?');
    values.push(params.notice);
  }
  if (params.updatedWithinDays !== undefined) {
    conditions.push('last_updated >= DATE_SUB(NOW(), INTERVAL ? DAY)');
    values.push(params.updatedWithinDays);
  }
  if (params.skills && params.skills.length > 0) {
    const likeConds = params.skills.map(() => 'skills_flat LIKE ?').join(' AND ');
    conditions.push(`(${likeConds})`);
    params.skills.forEach((s) => values.push(`%${s}%`));
  }

  const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

  let orderBy = 'ORDER BY last_updated DESC';
  if (params.sort === 'experience_desc') orderBy = 'ORDER BY total_experience_years DESC';
  if (params.sort === 'experience_asc') orderBy = 'ORDER BY total_experience_years ASC';

  const page = params.page ?? 1;
  const pageSize = params.pageSize ?? 20;
  const offset = (page - 1) * pageSize;

  const [rows] = await getDbPool().query<(Candidate & RowDataPacket)[]>(
    `SELECT SQL_CALC_FOUND_ROWS * FROM candidates ${whereClause} ${orderBy} LIMIT ? OFFSET ?`,
    [...values, pageSize, offset]
  );
  const [countRows] = await getDbPool().query<RowDataPacket[]>('SELECT FOUND_ROWS() as total');
  const total = Number(countRows[0].total ?? 0);

  return { items: rows as Candidate[], total, page, pageSize };
}