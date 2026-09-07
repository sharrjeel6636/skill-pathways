import React from 'react';
import Link from 'next/link';

const InterestQuizScreen = () => {
  return (
    <div className="max-w-md mx-auto min-h-screen bg-paper flex flex-col px-6 py-8 relative shadow-2xl border-x border-black/10">
      
      {/* Header: Back Button & Progress Bar */}
      <div className="flex items-center gap-4 mb-10">
        <Link href="/" className="text-ink/50 text-xl font-bold cursor-pointer hover:text-ink">
          ←
        </Link>
        <div className="flex-1 h-1.5 bg-sage-soft rounded-full overflow-hidden">
          <div className="h-full bg-teal w-1/4 rounded-full"></div>
        </div>
        <div className="text-[12px] font-bold text-teal">1/4</div>
      </div>

      {/* Question Section */}
      <div className="mb-2 font-serif text-[13px] font-bold text-teal tracking-widest uppercase">
        Interest Check
      </div>
      <h2 className="font-urdu text-[26px] text-ink leading-[1.4] mb-8" dir="rtl">
        کام کرتے وقت آپ کو سب سے زیادہ کیا چیز توانائی دیتی ہے؟
      </h2>

      {/* Options */}
      <div className="flex flex-col gap-3 mb-auto">
        {/* Selected Option */}
        <div className="bg-card border-2 border-teal rounded-[16px] p-4 flex items-center gap-4 cursor-pointer shadow-sm">
          <div className="text-[24px]">🛠️</div>
          <div className="font-bold text-[15px] text-ink">Building and fixing things</div>
          <div className="ml-auto w-5 h-5 rounded-full bg-teal text-white flex items-center justify-center text-[12px]">✓</div>
        </div>
        
        {/* Unselected Option */}
        <div className="bg-card border-[1.5px] border-black/10 rounded-[16px] p-4 flex items-center gap-4 cursor-pointer hover:border-black/20 transition-colors">
          <div className="text-[24px]">🧮</div>
          <div className="font-bold text-[15px] text-ink/75">Solving with numbers and logic</div>
        </div>

        {/* Unselected Option */}
        <div className="bg-card border-[1.5px] border-black/10 rounded-[16px] p-4 flex items-center gap-4 cursor-pointer hover:border-black/20 transition-colors">
          <div className="text-[24px]">🎨</div>
          <div className="font-bold text-[15px] text-ink/75">Designing and thinking visually</div>
        </div>

        {/* Unselected Option */}
        <div className="bg-card border-[1.5px] border-black/10 rounded-[16px] p-4 flex items-center gap-4 cursor-pointer hover:border-black/20 transition-colors">
          <div className="text-[24px]">🗣️</div>
          <div className="font-bold text-[15px] text-ink/75">Talking and explaining to people</div>
        </div>
      </div>

      {/* Bottom Action */}
      <div className="pt-8">
        <Link href="/dashboard" className="btn-primary w-full block text-center">
          Next question <span>→</span>
        </Link>
      </div>
      
    </div>
  );
};

export default InterestQuizScreen;