'use client';
import React from 'react';
import Link from 'next/link';
import { useLanguage } from '../lib/LanguageContext';
import LanguageSwitcher from '../components/LanguageSwitcher';


export default function Page() {
  const { language } = useLanguage();

  return (
    <div className="min-h-screen bg-paper text-ink font-sans flex items-center">
      <LanguageSwitcher />
      <div className="max-w-[1400px] mx-auto px-8 w-full">
        
        <header className="flex flex-col gap-6">
          
          <div className="flex items-center gap-3 text-[13px] tracking-[0.14em] uppercase text-teal font-bold">
            <span className="w-[7px] h-[7px] rounded-full bg-amber"></span>
            {language === 'en' ? 'SkillPathways — Design Direction · Alkhidmat Skill Pathways Initiative' : 'اسکل پاتھ ویز - ڈیزائن ڈائریکشن · الخدمت اسکل پاتھ ویز اقدام'}
          </div>

          <h1 className="font-serif font-semibold text-[clamp(40px,6vw,84px)] leading-[0.98] tracking-[-0.01em] max-w-[15ch] m-0 text-ink">
            {language === 'en' ? (
              <>
                Every path<br />
                <em className="italic font-medium text-teal">should be visible.</em>
              </>
            ) : (
              <>
                ہر راستہ<br />
                <em className="italic font-medium text-teal">صاف نظر آنا چاہیے۔</em>
              </>
            )}
          </h1>

          <p className="text-[18px] leading-[1.6] max-w-[640px] text-ink/75 mt-2">
            {language === 'en' ? 'A career-guidance companion for students who feel lost between too much advice and not enough proof. The design\'s one job: turn "I don\'t know what path to take" into a path you can see, trust, and walk — one unlocked step at a time.' : 'طلباء کے لیے ایک کیریئر گائیڈنس ساتھی جو بہت زیادہ مشورے اور کم ثبوتوں کے درمیان کھوئے ہوئے محسوس کرتے ہیں۔ ڈیزائن کا ایک ہی کام ہے: "مجھے نہیں معلوم کہ کون سا راستہ اختیار کرنا ہے" کو ایک ایسے راستے میں تبدیل کریں جسے آپ دیکھ سکیں، بھروسہ کر سکیں، اور چل سکیں — ہر قدم کے ساتھ ایک نیا موقع۔'}
          </p>

          <div className="flex items-center gap-5 mt-6">
            <Link href="/onboarding" className="bg-amber text-teal-2 px-8 py-4 rounded-full font-extrabold text-[15px] flex items-center gap-2 transition-transform active:scale-[0.98] shadow-sm">
              {language === 'en' ? 'Start your path' : 'اپنا راستہ شروع کریں'} <span>→</span>
            </Link>
            <Link href="/login" className="text-teal font-bold text-[15px] hover:underline underline-offset-4 cursor-pointer">
              {language === 'en' ? 'Log in to account' : 'اکاؤنٹ میں لاگ ان کریں'}
            </Link>
          </div>

        </header>
      </div>
    </div>
  );
}