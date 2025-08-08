import React, { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../shared/api';

type Role = 'admin' | 'recruiter' | 'candidate';

export interface AuthUser {
  id: number;
  fullName: string;
  role: Role;
  token: string;
}

interface AuthContextValue {
  user: AuthUser | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(() => {
    const stored = localStorage.getItem('auth_user');
    return stored ? (JSON.parse(stored) as AuthUser) : null;
  });

  useEffect(() => {
    if (user) {
      localStorage.setItem('auth_user', JSON.stringify(user));
      api.defaults.headers.common.Authorization = `Bearer ${user.token}`;
    } else {
      localStorage.removeItem('auth_user');
      delete api.defaults.headers.common.Authorization;
    }
  }, [user]);

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      async login(email: string, password: string) {
        const res = await api.post('/auth/login', { email, password });
        const { token, user: profile } = res.data;
        setUser({
          id: profile.id,
          fullName: profile.full_name,
          role: profile.role,
          token,
        });
      },
      logout() {
        setUser(null);
      },
    }),
    [user]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}