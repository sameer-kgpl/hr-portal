import { useEffect, useState } from 'react';
import { api } from '../shared/api';

interface Candidate {
  id: number;
  full_name: string;
  current_location: string | null;
  total_experience_years: number;
  notice_period: string;
  skills_flat: string | null;
  match_percentage?: number;
}

export default function RecruiterSearch() {
  const [name, setName] = useState('');
  const [location, setLocation] = useState('');
  const [skills, setSkills] = useState('react,node');
  const [minExp, setMinExp] = useState<number | ''>('');
  const [maxExp, setMaxExp] = useState<number | ''>('');
  const [results, setResults] = useState<Candidate[]>([]);
  const [loading, setLoading] = useState(false);

  const search = async () => {
    setLoading(true);
    try {
      const res = await api.get('/candidates/search', {
        params: {
          name: name || undefined,
          location: location || undefined,
          skills: skills || undefined,
          minExp: minExp || undefined,
          maxExp: maxExp || undefined,
          page: 1,
          pageSize: 20,
        },
      });
      setResults(res.data.items || res.data || []);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    search();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div>
      <h2>Candidate Search</h2>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 8, maxWidth: 900 }}>
        <input placeholder="Name" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="Location" value={location} onChange={(e) => setLocation(e.target.value)} />
        <input placeholder="Skills (comma separated)" value={skills} onChange={(e) => setSkills(e.target.value)} />
        <input placeholder="Min Exp" type="number" value={minExp} onChange={(e) => setMinExp(e.target.value === '' ? '' : Number(e.target.value))} />
        <input placeholder="Max Exp" type="number" value={maxExp} onChange={(e) => setMaxExp(e.target.value === '' ? '' : Number(e.target.value))} />
      </div>
      <button style={{ marginTop: 10 }} onClick={search} disabled={loading}>{loading ? 'Searching...' : 'Search'}</button>

      <ul>
        {results.map((c) => (
          <li key={c.id} style={{ padding: 10, borderBottom: '1px solid #eee' }}>
            <strong>{c.full_name}</strong> — {c.current_location || 'N/A'} — {c.total_experience_years} yrs — {c.notice_period}
            <div>Skills: {c.skills_flat || 'N/A'}</div>
            {typeof c.match_percentage === 'number' && (
              <div>Match: {Math.round(c.match_percentage)}%</div>
            )}
          </li>
        ))}
      </ul>
    </div>
  );
}