import { createBrowserRouter } from 'react-router-dom';
import App from './App';
import Login from './views/Login';
import RecruiterSearch from './views/RecruiterSearch';
import CandidateProfile from './views/CandidateProfile';
import AdminUsers from './views/AdminUsers';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      { index: true, element: <RecruiterSearch /> },
      { path: 'login', element: <Login /> },
      { path: 'recruiter/search', element: <RecruiterSearch /> },
      { path: 'candidate/profile', element: <CandidateProfile /> },
      { path: 'admin/users', element: <AdminUsers /> },
    ],
  },
]);