import React from 'react';

const Dashboard = ({ stats }: { stats: any }) => {
  return (
    <div className="flex flex-col min-h-screen bg-paper pb-20">
      {/* Header */}
      <div className="p-6 flex justify-between items-center">
        <div className="greet">
          <div className="hi text-[12px] text-ink/55 font-semibold">Welcome back</div>
          <div className="name font-serif text-[20px] font-semibold text-ink">Ayesha</div>
        </div>
        <div className="avatar w-[38px] h-[38px] rounded-full bg-rust flex items-center justify-center text-white font-extrabold text-[14px]">
          A
        </div>
      </div>

      {/* Active Pathway Card */}
      <div className="px-6">
        <div className="ring-card">
          <div className="ring w-[64px] h-[64px] rounded-full bg-[conic-gradient(var(--color-amber)_0deg_216deg,rgba(255,255,255,0.18)_216deg_360deg)] flex items-center justify-center flex-shrink-0">
            <div className="inner w-[48px] h-[48px] rounded-full bg-teal flex items-center justify-center text-[13px] font-extrabold text-paper">
              60%
            </div>
          </div>
          <div className="rt">
            <small className="block text-[11px] text-paper/65 font-bold uppercase tracking-[0.05em]">UI/UX Track</small>
            <strong className="font-serif font-semibold text-[16px]">3 of 6 steps unlocked</strong>
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="px-6 grid grid-cols-2 gap-3 mb-[18px]">
        <div className="mini-card">
          <div className="icon w-[32px] h-[32px] rounded-[9px] bg-sage-soft flex items-center justify-center mb-2.5 text-[15px]">💬</div>
          <div className="t text-[13px] font-extrabold">Ask a mentor</div>
          <div className="d text-[11px] text-ink/50 mt-0.5">Reply in ~2 hrs</div>
        </div>
        <div className="mini-card">
          <div className="icon w-[32px] h-[32px] rounded-[9px] bg-sage-soft flex items-center justify-center mb-2.5 text-[15px]">🎓</div>
          <div className="t text-[13px] font-extrabold">Scholarships</div>
          <div className="d text-[11px] text-ink/50 mt-0.5">3 closing soon</div>
        </div>
      </div>

      {/* List items */}
      <div className="px-6">
        <div className="list-row">
          <div className="tag w-[34px] h-[34px] rounded-[10px] bg-amber flex items-center justify-center text-[15px] flex-shrink-0">📘</div>
          <div>
            <div className="tt text-[13px] font-bold text-ink">Figma Studio — Module 3</div>
            <div className="ts text-[11px] text-ink/50">Verified · 45 min left</div>
          </div>
          <div className="chev ml-auto text-ink/30">›</div>
        </div>
        <div className="list-row">
          <div className="tag w-[34px] h-[34px] rounded-[10px] bg-amber flex items-center justify-center text-[15px] flex-shrink-0">⭐</div>
          <div>
            <div className="tt text-[13px] font-bold text-ink">Rate your last module</div>
            <div className="ts text-[11px] text-ink/50">Help other students</div>
          </div>
          <div className="chev ml-auto text-ink/30">›</div>
        </div>
      </div>

      {/* Bottom Navbar */}
      <div className="navbar">
        <div className="ni active">
          <span className="di text-[17px]">⌂</span>Home
        </div>
        <div className="ni">
          <span className="di text-[17px]">🧭</span>Path
        </div>
        <div className="ni">
          <span className="di text-[17px]">💬</span>Chat
        </div>
        <div className="ni">
          <span className="di text-[17px]">👤</span>Profile
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
