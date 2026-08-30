'use client';
import { useEffect, useState } from 'react';

export default function DashboardPage() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`http://localhost:8000/dashboard/mock-user-id`)
      .then(res => res.json())
      .then(data => setData(data));
  }, []);

  if (!data) return <div>Loading...</div>;

  return (
    <div className="dashboard">
      <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
      <div className="progress-card">
        <p>Active Pathway: {data.pathways[0]?.pathways.title || 'None'}</p>
        <p>Progress: {data.progress.length}%</p>
      </div>
      <div className="quick-stats">
        {/* Add quick links here */}
      </div>
    </div>
  );
}
