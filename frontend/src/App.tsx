import { Link, Outlet } from 'react-router-dom';
import { useAuth } from './shared/AuthContext';

export default function App() {
  const { user, logout } = useAuth();
  return (
    <div style={{ fontFamily: 'system-ui, sans-serif', color: '#111' }}>
      <nav style={{ display: 'flex', gap: 16, padding: 12, borderBottom: '1px solid #ddd' }}>
        <Link to="/">Home</Link>
        <Link to="/recruiter/search">Search</Link>
        <Link to="/candidate/profile">My Profile</Link>
        <Link to="/admin/users">Users</Link>
        <div style={{ marginLeft: 'auto' }}>
          {user ? (
            <>
              <span style={{ marginRight: 12 }}>{user.fullName} ({user.role})</span>
              <button onClick={logout}>Logout</button>
            </>
          ) : (
            <Link to="/login">Login</Link>
          )}
        </div>
      </nav>
      <main style={{ padding: 16 }}>
        <Outlet />
      </main>
    </div>
  );
}