import React from 'react';

const options = [
  { emoji: '🛠️', label: 'Cheezein banana aur fix karna' },
  { emoji: '🧮', label: 'Numbers aur logic se solve karna' },
  { emoji: '🎨', label: 'Design aur visual sochna' },
  { emoji: '🗣️', label: 'Logon se baat aur samjhana' },
];

const InterestQuiz = () => {
  return (
    <div className="flex flex-col min-h-[620px] w-[296px] bg-paper rounded-[44px] p-[22px] pb-[24px]">
      {/* Quiz Top: Back, Progress, Count */}
      <div className="flex items-center gap-3 py-[6px] pb-[18px]">
        <div className="w-[34px] h-[34px] rounded-full bg-card flex items-center justify-center text-[16px] shadow-[0_2px_6px_rgba(0,0,0,0.06)]">
          ←
        </div>
        <div className="flex-1 h-[6px] rounded-full bg-sage-soft overflow-hidden">
          <div className="w-[42%] h-full bg-teal rounded-full" />
        </div>
        <div className="text-[12px] font-bold text-ink/50">3/7</div>
      </div>

      {/* Question */}
      <div className="text-[12px] font-extrabold tracking-[0.08em] uppercase text-rust mb-[10px]">
        Interest check
      </div>
      <h2 className="font-serif font-semibold text-[23px] leading-[1.25] text-ink mb-[26px]">
        Kaam karte waqt tumhe sabse zyada kya energy deta hai?
      </h2>

      {/* Options */}
      <div className="flex flex-col gap-3">
        {options.map((opt, index) => (
          <div
            key={index}
            className={`flex items-center gap-3 p-[15px_16px] rounded-[16px] border-[1.5px] cursor-pointer
              ${index === 0
                ? 'border-teal bg-sage-soft'
                : 'border-line bg-card'
              }`}
          >
            <span className="text-[20px] w-[30px] text-center">{opt.emoji}</span>
            <span className="font-semibold text-[14.5px] text-ink">{opt.label}</span>
            {index === 0 && (
              <div className="ml-auto w-[20px] h-[20px] rounded-full bg-teal text-white text-[12px] flex items-center justify-center">
                ✓
              </div>
            )}
          </div>
        ))}
      </div>

      {/* CTA */}
      <div className="mt-auto pt-6">
        <button className="btn-primary w-full bg-teal text-white">
          Next question <span>→</span>
        </button>
      </div>
    </div>
  );
};

export default InterestQuiz;
