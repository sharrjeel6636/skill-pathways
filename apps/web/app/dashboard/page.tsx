'use client';
import { useEffect, useState } from 'react';

export default function DashboardPage() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`http://localhost:8000/dashboard/mock-user-123`)
      .then(res => res.json())
      .then(data => setData(data))
      .catch(err => console.error('Error fetching dashboard:', err));
  }, []);

  if (!data) return <div className="p-12 text-ink">Loading...</div>;

  return (
    <div className="min-h-screen pb-24">
      <div className="max-w-[480px] mx-auto px-[22px] pt-12">
        {/* Top Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <div className="text-[12px] text-ink/55 font-semibold">Welcome back</div>
            <div className="font-serif text-[20px] font-semibold">{data.user_name}</div>
          </div>
          <div className="w-[38px] h-[38px] rounded-full bg-rust text-white flex items-center justify-center font-extrabold text-[14px]">
            {data.user_name?.[0] || 'A'}
          </div>
        </div>

        {/* Ring Card */}
        <div className="ring-card">
          <div className="w-16 h-16 rounded-full flex items-center justify-center flex-shrink-0"
               style={{ background: `conic-gradient(var(--color-amber) 0deg ${data.percent * 3.6}deg, rgba(255,255,255,0.18) ${data.percent * 3.6}deg 360deg)` }}>
            <div className="w-12 h-12 rounded-full bg-teal flex items-center justify-center font-extrabold text-[13px] text-paper">
              {data.percent}%
            </div>
          </div>
          <div className="flex flex-col">
            <small className="text-[11px] text-paper/65 font-bold uppercase tracking-wider">UI/UX Track</small>
            <strong className="font-serif font-semibold text-[16px]">{data.unlocked_steps} of {data.total_steps} steps unlocked</strong>
          </div>
        </div>

        {/* Quick Action Grid */}
        <div className="grid grid-cols-2 gap-3 mb-[18px]">
          <div className="mini-card">
            <div className="w-8 h-8 rounded-[9px] bg-sage-soft flex items-center justify-center mb-2.5 text-[15px]">💬</div>
            <div className="text-[13px] font-extrabold">Ask a mentor</div>
            <div className="text-[11px] text-ink/50 mt-0.5">Reply in ~2 hrs</div>
          </div>
          <div className="mini-card">
            <div className="w-8 h-8 rounded-[9px] bg-sage-soft flex items-center justify-center mb-2.5 text-[15px]">🎓</div>
            <div className="text-[13px] font-extrabold">Scholarships</div>
            <div className="text-[11px] text-ink/50 mt-0.5">3 closing soon</div>
          </div>
        </div>

        {/* List Rows */}
        <div className="space-y-[10px]">
          {data.list_items?.map((item: any) => (
            <div key={item.id} className="list-row">
              <div className="w-[34px] h-[34px] rounded-[10px] bg-amber flex items-center justify-center text-[15px] flex-shrink-0">📘</div>
              <div className="flex-1">
                <div className="text-[13px] font-bold">{item.title}</div>
                <div className="text-[11px] text-ink/50">{item.subtitle}</div>
              </div>
              <div className="text-ink/30 text-[18px]">›</div>
            </div>
          )) || (
            <>
              <div className="list-row">
                <div className="w-[34px] h-[34px] rounded-[10px] bg-amber flex items-center justify-center text-[15px] flex-shrink-0">📘</div>
                <div className="flex-1">
                  <div className="text-[13px] font-bold">Figma Studio — Module 3</div>
                  <div className="text-[11px] text-ink/50">Verified · 45 min left</div>
                </div>
                <div className="text-ink/30 text-[18px]">›</div>
              </div>
              <div className="list-row">
                <div className="w-[34px] h-[34px] rounded-[10px] bg-amber flex items-center justify-center text-[15px] flex-shrink-0">⭐</div>
                <div className="flex-1">
                  <div className="text-[13px] font-bold">Rate your last module</div>
                  <div className="text-[11px] text-ink/50">Help other students</div>
                </div>
                <div className="text-ink/30 text-[18px]">›</div>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Bottom Navbar */}
      <nav className="navbar">
        <div className="ni active">
          <span className="text-[17px]">⌂</span>
          <span>Home</span>
        </div>
        <div className="ni">
          <span className="text-[17px]">🧭</span>
          <span>Path</span>
        </div>
        <div className="ni">
          <span className="text-[17px]">💬</span>
          <span>Chat</span>
        </div>
        <div className="ni">
          <span className="text-[17px]">👤</span>
          <span>Profile</span>
        </div>
      </nav>
    </div>
  );
}
