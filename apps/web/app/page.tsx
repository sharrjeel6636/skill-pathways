import Dashboard from '../src/components/Dashboard.tsx';
import BottomNav from '../src/components/BottomNav.tsx';

export default async function Page() {
  // In a real app, fetch from backend:
  // const res = await fetch('http://localhost:8000/api/dashboard/stats', { ... })
  const stats = {
    active_pathway: { title: "Web Dev", progress: 65 },
    saved_resources: 12,
    upcoming_deadlines: 2
  };

  return (
    <div>
      <Dashboard stats={stats} />
      <BottomNav />
    </div>
  );
}
