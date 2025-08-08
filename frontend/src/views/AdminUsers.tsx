import { useEffect, useState } from 'react';
import { api } from '../shared/api';

interface UserRow {
  id: number;
  full_name: string;
  email: string;
  role: string;
  is_active: number;
}

export default function AdminUsers() {
  const [users, setUsers] = useState<UserRow[]>([]);

  useEffect(() => {
    (async () => {
      try {
        const res = await api.get('/admin/users');
        setUsers(res.data || []);
      } catch {}
    })();
  }, []);

  return (
    <div>
      <h2>Users</h2>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {users.map((u) => (
            <tr key={u.id}>
              <td>{u.id}</td>
              <td>{u.full_name}</td>
              <td>{u.email}</td>
              <td>{u.role}</td>
              <td>{u.is_active ? 'Active' : 'Inactive'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}