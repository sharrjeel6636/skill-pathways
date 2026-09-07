import React from 'react';

const tokens = [
  { name: 'Teal — trust', hex: '#164B3C' },
  { name: 'Teal deep', hex: '#0E362A' },
  { name: 'Amber — progress', hex: '#E8A33D' },
  { name: 'Rust — signal', hex: '#B5502F' },
  { name: 'Sage — verified', hex: '#8FAE86' },
  { name: 'Paper', hex: '#F5F2E9' },
];

const HeroSection = () => {
  return (
    <header className="flex flex-col gap-[22px] mb-[88px]">
      {/* Eyebrow */}
      <div className="flex items-center gap-3 text-[13px] font-bold uppercase tracking-[0.14em] text-teal">
        <span className="w-[7px] h-[7px] rounded-full bg-amber"></span>
        SkillPathways — Design Direction · Alkhidmat Skill Pathways Initiative
      </div>

      {/* Title */}
      <h1 className="font-serif font-semibold text-[clamp(40px,6vw,84px)] leading-[0.98] tracking-[-0.01em] text-ink">
        Every path<br />
        <em className="italic font-medium text-teal">should be visible</em>.
      </h1>

      {/* Urdu Text */}
      <p className="urdu text-[26px] text-rust" dir="rtl">
        ہر راستہ صاف نظر آنا چاہیے
      </p>

      {/* Sub-paragraph */}
      <p className="text-[18px] leading-[1.6] text-ink/72 max-w-[640px] font-sans">
        A career-guidance companion for students who feel lost between too much advice and not enough proof. The design's one job: turn "I don't know what path to take" into a path you can see, trust, and walk — one unlocked step at a time.
      </p>

      {/* Color Tokens Grid */}
      <div className="grid grid-cols-2 md:grid-cols-6 border-t border-b border-[rgba(30,42,34,0.12)] mt-6">
        {tokens.map((token, i) => (
          <div
            key={token.name}
            className={`p-4 border-r border-[rgba(30,42,34,0.12)] ${i % 2 === 1 ? 'border-r-0 md:border-r' : ''} ${i === 5 ? 'md:border-r-0' : ''}`}
          >
            <div
              className="w-full h-[38px] rounded-[8px] mb-[10px]"
              style={{ backgroundColor: token.hex }}
            ></div>
            <div className="text-[12px] font-bold uppercase tracking-[0.06em] text-ink">{token.name}</div>
            <div className="text-[12px] text-ink/55 tabular-nums">{token.hex}</div>
          </div>
        ))}
      </div>
    </header>
  );
};

export default HeroSection;
