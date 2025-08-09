import { getDbPool } from '../config/db.js';
export async function createCandidate(input) {
    const [res] = await getDbPool().execute(`INSERT INTO candidates (
       user_id, full_name, email, phone, current_location, preferred_location,
       total_experience_years, notice_period, availability_date, skills_json, skills_flat, generic_notes
     ) VALUES (
       :user_id, :full_name, :email, :phone, :current_location, :preferred_location,
       :total_experience_years, :notice_period, :availability_date, :skills_json, :skills_flat, :generic_notes
     )`, {
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
    });
    return res.insertId;
}
export async function findCandidateById(id) {
    const [rows] = await getDbPool().query('SELECT * FROM candidates WHERE id = ? LIMIT 1', [id]);
    return rows[0] ?? null;
}
export async function searchCandidates(params) {
    const conditions = [];
    const values = [];
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
    if (params.sort === 'experience_desc')
        orderBy = 'ORDER BY total_experience_years DESC';
    if (params.sort === 'experience_asc')
        orderBy = 'ORDER BY total_experience_years ASC';
    const page = params.page ?? 1;
    const pageSize = params.pageSize ?? 20;
    const offset = (page - 1) * pageSize;
    const [rows] = await getDbPool().query(`SELECT SQL_CALC_FOUND_ROWS * FROM candidates ${whereClause} ${orderBy} LIMIT ? OFFSET ?`, [...values, pageSize, offset]);
    const [countRows] = await getDbPool().query('SELECT FOUND_ROWS() as total');
    const total = Number(countRows[0].total ?? 0);
    return { items: rows, total, page, pageSize };
}
//# sourceMappingURL=Candidate.js.map