'use client';
import { useEffect, useState } from 'react';

export default function RoadmapPage({ params }: { params: { id: string } }) {
  const [steps, setSteps] = useState<any[]>([]);

  useEffect(() => {
    fetch(`http://localhost:8000/pathways/${params.id}/steps?user_id=mock-user-123`)
      .then(res => res.json())
      .then(data => setSteps(data))
      .catch(err => console.error('Error fetching steps:', err));
  }, [params.id]);

  if (steps.length === 0) return <div className="p-12 text-ink">Loading roadmap...</div>;

  const currentStep = steps.find(s => s.status === 'current') || steps[0];

  return (
    <div className="min-h-screen bg-paper relative flex flex-col max-w-[480px] mx-auto overflow-hidden">
      {/* Header */}
      <div className="pt-8 px-[22px] pb-[14px]">
        <div className="text-[11px] font-extrabold uppercase tracking-widest text-rust">Your pathway</div>
        <h3 className="font-serif font-semibold text-[21px] mt-1.5 text-ink">Full Stack Development</h3>
      </div>

      {/* Pathway Canvas (The Trail) */}
      <div className="flex-1 relative overflow-hidden min-h-[400px]">
        <svg className="absolute inset-0 w-full h-full" viewBox="0 0 296 400" preserveAspectRatio="none">
          <path
            d="M 40 30 C 120 60, 20 110, 90 140 S 220 190, 160 230 S 60 260, 130 350"
            stroke="#C9C1A8"
            strokeWidth="4"
            fill="none"
            strokeLinecap="round"
            strokeDasharray="1 14"
          />
          <path
            d="M 40 30 C 120 60, 20 110, 90 140"
            stroke="#164B3C"
            strokeWidth="4"
            fill="none"
            strokeLinecap="round"
          />
        </svg>

        {/* Nodes (Step markers) */}
        {steps.map((step, i) => {
          // Absolute positions mapped roughly to the SVG path
          const positions = [
            { top: '14px', left: '16px' },
            { top: '96px', left: '56px' },
            { top: '118px', left: '150px' },
            { top: '198px', left: '172px' },
            { top: '270px', left: '60px' },
            { top: '340px', left: '150px' },
          ];
          const pos = positions[i] || { top: `${i * 60}px`, left: '50px' };

          return (
            <div
              key={step.id}
              className={`absolute flex items-center gap-2.5 transition-transform hover:scale-105 cursor-pointer ${
                step.status === 'done' ? 'text-teal' : step.status === 'current' ? 'text-amber' : 'text-ink/35'
              }`}
              style={{ top: pos.top, left: pos.left }}
            >
              <div className={`w-[46px] h-[46px] rounded-full flex items-center justify-center font-extrabold text-[18px] border-[3px] border-paper shadow-[0_6px_14px_rgba(14,54,42,0.18)] ${
                step.status === 'done' ? 'bg-teal text-white' :
                step.status === 'current' ? 'bg-amber text-teal-2 shadow-[0_0_0_6px_rgba(232,163,61,0.25)]' :
                'bg-[#E7E2D3]'
              }`}>
                {step.status === 'done' ? '✓' : step.status === 'current' ? i + 1 : '🔒'}
              </div>
              <div className={`label bg-card px-3 py-1.5 rounded-[12px] text-[12.5px] font-bold shadow-[0_3px_8px_rgba(0,0,0,0.06)] whitespace-nowrap ${
                step.status === 'locked' ? 'text-ink/40' : 'text-ink'
              }`}>
                {step.title}
              </div>
            </div>
          );
        })}
      </div>

      {/* Sticky Footer */}
      <div className="sticky bottom-0 left-0 right-0 p-4 pt-[16px] px-[22px] pb-[22px] bg-card border-t border-[rgba(30,42,34,0.12)] z-10 shadow-[0_-4px_12px_rgba(0,0,0,0.03)]">
        <div className="text-[11px] font-extrabold uppercase tracking-widest text-teal">Current step</div>
        <h4 className="font-serif text-[17px] mt-1 mb-2 text-ink">{currentStep.title} — Module {currentStep.id}</h4>
        <p className="text-[13px] text-ink/60 leading-relaxed mb-3.5">Verified material from 2 mentors · avg. 4 hrs/week</p>
        <button className="btn-primary w-full" style={{ background: 'var(--color-teal)', color: '#fff' }}>
          Continue <span>→</span>
        </button>
      </div>
    </div>
  );
}
