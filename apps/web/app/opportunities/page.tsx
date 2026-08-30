'use client';
import { useEffect, useState } from 'react';

export default function OpportunitiesPage() {
  const [opportunities, setOpportunities] = useState<any[]>([]);

  useEffect(() => {
    fetch('http://localhost:8000/opportunities')
      .then(res => res.json())
      .then(setOpportunities);
  }, []);

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-4">Opportunities</h1>
      {opportunities.map(opp => {
        const isUrgent = new Date(opp.deadline).getTime() - new Date().getTime() < 5 * 24 * 60 * 60 * 1000;
        return (
          <div key={opp.id} className="border-b py-4">
            <h2 className="font-bold">{opp.title}</h2>
            <p className={isUrgent ? 'text-red-500' : ''}>Deadline: {opp.deadline}</p>
          </div>
        );
      })}
    </div>
  );
}
