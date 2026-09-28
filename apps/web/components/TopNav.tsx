'use client';
import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useLanguage } from '@/lib/LanguageContext';

export default function TopNav() {
  const pathname = usePathname();
  const { language } = useLanguage();

  const navItems = [
    { href: '/home', labelEn: 'Home', labelUr: 'ہوم' },
    { href: '/roadmap', labelEn: 'Roadmap', labelUr: 'روڈ میپ' },
    { href: '/scholarships', labelEn: 'Scholarships', labelUr: 'وظائف' },
    { href: '/universities', labelEn: 'Universities', labelUr: 'جامعات' },
    { href: '/career-explorer', labelEn: 'Careers', labelUr: 'کیریئر' },
    { href: '/parent', labelEn: 'Parent', labelUr: 'والدین' },
    { href: '/chatbot', labelEn: 'AI Mentor', labelUr: 'اے آئی مددگار' },
    { href: '/profile', labelEn: 'Profile', labelUr: 'پروفائل' },
  ];

  if (pathname === '/' || pathname === '/login' || pathname === '/onboarding') {
    return null;
  }

  return (
    <nav className="bg-teal text-white px-4 py-3 shadow-md flex items-center justify-between sticky top-0 z-50">
      <Link href="/home" className="font-serif font-bold text-lg text-amber flex items-center gap-2">
        <span className="w-8 h-8 rounded-full bg-amber text-teal flex items-center justify-center text-sm font-sans">SP</span>
        <span>Skill Pathways</span>
      </Link>
      
      <div className="flex items-center gap-2 overflow-x-auto text-sm">
        {navItems.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`px-3 py-1.5 rounded-lg transition-colors whitespace-nowrap ${
                isActive ? 'bg-white/20 font-bold text-amber' : 'hover:bg-white/10 text-white/90'
              }`}
            >
              {language === 'ur' ? item.labelUr : item.labelEn}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
