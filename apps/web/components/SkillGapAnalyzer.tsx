'use client';
import { useEffect, useState } from 'react';

export default function SkillGapAnalyzer({ userId }: { userId: string }) {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`http://localhost:8000/user/${userId}/skill-gap`, {
        headers: { 'Authorization': 'Bearer mock-token' } // Mock auth for now
    })
      .then(res => res.json())
      .then(data => setData(data))
      .catch(err => console.error('Error fetching skill gap:', err));
  }, [userId]);

  if (!data) return <div className="p-6 text-ink/60">Analyzing skills...</div>;
  if (data.error) return <div className="p-6 text-rust">{data.error}</div>;

  return (
    <div className="p-6 bg-card rounded-[20px] border border-ink/10 shadow-[0_4px_12px_rgba(0,0,0,0.05)]">
      <h2 className="font-serif text-[20px] text-ink mb-4">Skill Gap: {data.target_role}</h2>
      
      <div className="mb-6">
        <h3 className="text-[12px] font-bold text-ink/60 uppercase tracking-widest mb-2">Mastered Skills</h3>
        <div className="flex flex-wrap gap-2">
            {data.current_skills.map((skill: string) => (
                <span key={skill} className="px-3 py-1 bg-teal/10 text-teal rounded-full text-[13px] font-bold">✓ {skill}</span>
            ))}
        </div>
      </div>

      <div>
        <h3 className="text-[12px] font-bold text-ink/60 uppercase tracking-widest mb-2">Recommended Steps</h3>
        <ul className="space-y-2">
            {data.skill_gaps.map((gap: any) => (
                <li key={gap.step_id} className="p-3 bg-sage-soft rounded-[12px] text-[14px] text-ink flex items-center justify-between">
                    <span className="font-bold">{gap.title}</span> 
                    <span className="text-[11px] bg-white px-2 py-1 rounded-[6px] text-ink/70">{gap.difficulty}</span>
                </li>
            ))}
        </ul>
      </div>
    </div>
  );
}
