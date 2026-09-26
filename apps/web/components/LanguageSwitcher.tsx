'use client';
import { useLanguage } from '../lib/LanguageContext';

export default function LanguageSwitcher() {
  const { language, setLanguage } = useLanguage();

  return (
    <button
      onClick={() => setLanguage(language === 'en' ? 'ur' : 'en')}
      className="fixed top-4 right-4 bg-teal text-paper px-4 py-2 rounded-full font-bold text-sm"
    >
      {language === 'en' ? 'اردو' : 'English'}
    </button>
  );
}
