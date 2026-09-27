'use client';
import { useEffect, useState } from 'react';
import { fetchWithAuth } from '../../lib/api';
import BottomNav from '../../components/BottomNav';

export default function RoadmapPage() {
  const [steps, setSteps] = useState<any[]>([]);

  useEffect(() => {
    fetchWithAuth('/pathways/1/steps') // Assuming pathway 1 for demo
      .then(setSteps)
      .catch(console.error);
  }, []);

  return (
    <div className="min-h-screen bg-paper pb-20 p-6">
      <h1 className="text-2xl font-bold mb-6">Your Roadmap</h1>
      <div className="space-y-4">
        {steps.map((step, i) => (
          <div key={i} className="p-4 bg-white rounded-2xl border border-ink/10">
            <h3 className="font-bold">{step.title}</h3>
            <p className="text-sm text-ink/60">{step.description}</p>
          </div>
        ))}
      </div>
      <BottomNav />
    </div>
  );
}
