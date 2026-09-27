'use client';
import React from 'react';
import { useRouter } from 'next/navigation';
import { useLanguage } from '../../lib/LanguageContext';

export default function LanguageSelectionPage() {
  const router = useRouter();
  const { setLanguage } = useLanguage();

  const handleSelection = (lang: 'en' | 'ur') => {
    setLanguage(lang);
    router.push('/login');
  };

  return (
    <div className="min-h-screen bg-paper flex flex-col items-center justify-center p-6 text-ink">
      <div className="flex flex-col items-center text-center mb-12">
        <div className="w-20 h-20 rounded-full bg-amber flex items-center justify-center mb-6">
          <span className="text-3xl text-teal">SP</span>
        </div>
        <h1 className="font-serif text-4xl font-bold mb-2">Skill Pathway</h1>
        <p className="text-lg font-medium text-teal italic">Every path should be clearly visible</p>
        <p className="font-urdu text-lg font-medium text-teal mt-1" dir="rtl">ہر راستہ صاف دکھائی دینا چاہیے</p>
      </div>

      <div className="w-full max-w-[360px]">
        <p className="text-center font-bold text-ink/60 mb-4 uppercase tracking-wider text-sm">Choose your language</p>
        
        <div className="flex flex-col gap-4">
          <button
            onClick={() => handleSelection('en')}
            className="w-full p-5 rounded-2xl bg-white border border-ink/10 shadow-sm hover:border-teal transition-all text-left font-bold text-lg"
          >
            English
          </button>
          <button
            onClick={() => handleSelection('ur')}
            className="w-full p-5 rounded-2xl bg-white border border-ink/10 shadow-sm hover:border-teal transition-all text-right font-urdu text-lg"
            dir="rtl"
          >
            اردو
          </button>
        </div>
      </div>
    </div>
  );
}
