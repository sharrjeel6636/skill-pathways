import React from 'react';
import Link from 'next/link';

export default function Page() {
  return (
    <div className="min-h-screen bg-paper text-ink font-sans flex items-center">
      <div className="max-w-[1400px] mx-auto px-8 w-full">
        
        {/* Header / Thesis Section */}
        <header className="flex flex-col gap-6">
          
          {/* Eyebrow */}
          <div className="flex items-center gap-3 text-[13px] tracking-[0.14em] uppercase text-teal font-bold">
            <span className="w-[7px] h-[7px] rounded-full bg-amber"></span>
            SkillPathways — Design Direction · Alkhidmat Skill Pathways Initiative
          </div>

          {/* Main Title */}
          <h1 className="font-serif font-semibold text-[clamp(40px,6vw,84px)] leading-[0.98] tracking-[-0.01em] max-w-[15ch] m-0 text-ink">
            Every path<br />
            <em className="italic font-medium text-teal">should be visible.</em>
          </h1>

          {/* Proper Urdu Line */}
          <p className="font-urdu text-[26px] md:text-[32px] text-rust mt-4 w-[fit-content]" dir="rtl">
            ہر راستہ صاف نظر آنا چاہیے
          </p>

          {/* Subtitle */}
          <p className="text-[18px] leading-[1.6] max-w-[640px] text-ink/75 mt-2">
            A career-guidance companion for students who feel lost between too much advice and not enough proof. The design's one job: turn "I don't know what path to take" into a path you can see, trust, and walk — one unlocked step at a time.
          </p>

          {/* Action Buttons Linked to Routes */}
          <div className="flex items-center gap-5 mt-6">
            <Link href="/quiz" className="bg-amber text-teal-2 px-8 py-4 rounded-full font-extrabold text-[15px] flex items-center gap-2 transition-transform active:scale-[0.98] shadow-sm">
              Start your path <span>→</span>
            </Link>
            <Link href="/login" className="text-teal font-bold text-[15px] hover:underline underline-offset-4 cursor-pointer">
              Log in to account
            </Link>
          </div>

        </header>
      </div>
    </div>
  );
}