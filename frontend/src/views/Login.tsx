import { useState } from 'react';
import { useAuth } from '../shared/AuthContext';

export default function Login() {
  const { login } = useAuth();
  const [email, setEmail] = useState('admin@example.com');
  const [password, setPassword] = useState('Admin@123');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await login(email, password);
    } catch (err: any) {
      setError(err?.response?.data?.error || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 360 }}>
      <h2>Login</h2>
      <form onSubmit={onSubmit}>
        <label>Email</label>
        <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" required />
        <label>Password</label>
        <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" required />
        <button type="submit" disabled={loading}>{loading ? 'Signing in...' : 'Login'}</button>
        {error && <div style={{ color: 'crimson', marginTop: 8 }}>{error}</div>}
      </form>
    </div>
  );
}