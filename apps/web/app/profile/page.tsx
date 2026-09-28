'use client';
export const dynamic = 'force-dynamic';
import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { fetchWithAuth } from '@/lib/api';
import { useLanguage } from '@/lib/LanguageContext';
import { useRouter } from 'next/navigation';

export default function ProfilePage() {
  const { language, setLanguage } = useLanguage();
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [inviteCode, setInviteCode] = useState<string | null>(null);
  const [loadingCode, setLoadingCode] = useState(false);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      setUser(data.user);
    });
  }, []);

  async function generateParentCode() {
    setLoadingCode(true);
    try {
      const res = await fetchWithAuth('/parent-link/generate', {
        method: 'POST',
        body: JSON.stringify({})
      });
      setInviteCode(res.code);
    } catch (e: any) {
      alert(`Error generating code: ${e.message}`);
    } finally {
      setLoadingCode(false);
    }
  }

  async function handleLogout() {
    await supabase.auth.signOut();
    router.push('/login');
  }

  return (
    <div className="p-6 text-ink">
      <h1 className="font-serif text-2xl font-bold mb-2">
        {language === 'ur' ? 'صارف پروفائل اور سیٹنگز' : 'Profile & Settings'}
      </h1>
      <p className="text-sm text-ink/70 mb-6">
        {language === 'ur' ? 'اپنے اکاؤنٹ کی معلومات اور ترتیبات کا انتظام کریں۔' : 'Manage your account details, linking codes, and language preference.'}
      </p>

      <div className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-4 mb-6">
        <div>
          <span className="text-xs text-ink/50 uppercase tracking-wider block">Email Address</span>
          <span className="font-bold text-sm">{user?.email || 'student@example.com'}</span>
        </div>
        <div>
          <span className="text-xs text-ink/50 uppercase tracking-wider block">Language Preference</span>
          <div className="flex gap-2 mt-2">
            <button
              onClick={() => setLanguage('en')}
              className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${language === 'en' ? 'bg-teal text-white' : 'bg-gray-100 text-ink'}`}
            >
              English
            </button>
            <button
              onClick={() => setLanguage('ur')}
              className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${language === 'ur' ? 'bg-teal text-white' : 'bg-gray-100 text-ink'}`}
              dir="rtl"
            >
              اردو
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-4 mb-6">
        <h2 className="font-bold text-sm">Parent Account Linking</h2>
        <p className="text-xs text-ink/60">Generate an invite code to share with your parent so they can monitor your progress.</p>
        {inviteCode ? (
          <div className="p-4 bg-teal/5 border border-teal/20 rounded-xl text-center">
            <span className="text-xs text-ink/70 block mb-1">Your Parent Invite Code:</span>
            <span className="font-mono text-2xl font-bold text-teal tracking-widest">{inviteCode}</span>
          </div>
        ) : (
          <button
            onClick={generateParentCode}
            disabled={loadingCode}
            className="w-full bg-amber text-teal p-3 rounded-xl font-bold text-sm hover:bg-amber/90 transition-all"
          >
            {loadingCode ? 'Generating...' : 'Generate Parent Invite Code'}
          </button>
        )}
      </div>

      <button
        onClick={handleLogout}
        className="w-full bg-red-50 text-red-600 border border-red-200 p-3 rounded-xl font-bold text-sm hover:bg-red-100 transition-all"
      >
        Log Out
      </button>
    </div>
  );
}
