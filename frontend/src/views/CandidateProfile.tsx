import { useEffect, useState } from 'react';
import { api } from '../shared/api';

export default function CandidateProfile() {
  const [fullName, setFullName] = useState('');
  const [location, setLocation] = useState('');
  const [preferred, setPreferred] = useState('');
  const [experience, setExperience] = useState<number | ''>('');
  const [notice, setNotice] = useState('30 days');
  const [skills, setSkills] = useState('');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    (async () => {
      try {
        const res = await api.get('/me/profile');
        const p = res.data;
        setFullName(p.full_name || '');
        setLocation(p.current_location || '');
        setPreferred(p.preferred_location || '');
        setExperience(p.total_experience_years || '');
        setNotice(p.notice_period || '30 days');
        setSkills(p.skills_flat || '');
      } catch {}
    })();
  }, []);

  const save = async () => {
    setSaving(true);
    try {
      await api.put('/me/profile', {
        full_name: fullName,
        current_location: location,
        preferred_location: preferred,
        total_experience_years: experience === '' ? 0 : Number(experience),
        notice_period: notice,
        skills_flat: skills,
      });
      alert('Saved');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div style={{ maxWidth: 600 }}>
      <h2>My Profile</h2>
      <label>Full name</label>
      <input value={fullName} onChange={(e) => setFullName(e.target.value)} />
      <label>Current location</label>
      <input value={location} onChange={(e) => setLocation(e.target.value)} />
      <label>Preferred location</label>
      <input value={preferred} onChange={(e) => setPreferred(e.target.value)} />
      <label>Total experience (years)</label>
      <input type="number" value={experience} onChange={(e) => setExperience(e.target.value === '' ? '' : Number(e.target.value))} />
      <label>Notice period</label>
      <select value={notice} onChange={(e) => setNotice(e.target.value)}>
        <option>Immediate</option>
        <option>15 days</option>
        <option>30 days</option>
      </select>
      <label>Skills (comma separated)</label>
      <input value={skills} onChange={(e) => setSkills(e.target.value)} />
      <button onClick={save} disabled={saving}>{saving ? 'Saving...' : 'Save'}</button>
    </div>
  );
}