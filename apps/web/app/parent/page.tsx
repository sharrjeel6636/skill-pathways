'use client';
export const dynamic = 'force-dynamic';
import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { fetchWithAuth } from '@/lib/api';
import { useLanguage } from '@/lib/LanguageContext';

export default function ParentDashboardPage() {
  const { language } = useLanguage();
  const [code, setCode] = useState('');
  const [linked, setLinked] = useState(false);
  const [loading, setLoading] = useState(false);
  const [childData, setChildData] = useState<any>(null);

  useEffect(() => {
    checkParentLink();
  }, []);

  async function checkParentLink() {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) return;
      const res = await fetchWithAuth(`/dashboard/${session.user.id}`);
      if (res) {
        setChildData(res);
        setLinked(true);
      }
    } catch (e) {
      console.error(e);
    }
  }

  async function handleRedeem(e: React.FormEvent) {
    e.preventDefault();
    if (!code.trim()) return;
    setLoading(true);
    try {
      const res = await fetchWithAuth('/parent-link/redeem', {
        method: 'POST',
        body: JSON.stringify({ code: code.trim() })
      });
      alert(res.message || 'Linked successfully!');
      setLinked(true);
      checkParentLink();
    } catch (err: any) {
      alert(`Error linking: ${err.message}`);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="p-6 text-ink">
      <h1 className="font-serif text-2xl font-bold mb-2">
        {language === 'ur' ? 'والدین کا ڈیش بورڈ' : 'Parent Dashboard'}
      </h1>
      <p className="text-sm text-ink/70 mb-6">
        {language === 'ur' 
          ? 'اپنے بچے کی تعلیمی پیشرفت اور روڈ میپ کی نگرانی کریں۔' 
          : 'Monitor your child’s educational progress and pathway milestones.'}
      </p>

      {!linked ? (
        <div className="bg-white p-6 rounded-2xl border border-ink/10 shadow-sm">
          <h2 className="font-bold text-lg mb-2">
            {language === 'ur' ? 'طالب علم کا اکاؤنٹ لنک کریں' : 'Link Student Account'}
          </h2>
          <p className="text-xs text-ink/60 mb-4">
            {language === 'ur'
              ? 'اپنے بچے کی ایپ سے 6 ہندسوں کا انوائٹ کوڈ درج کریں۔'
              : 'Enter the 6-digit invite code generated from your student’s app profile.'}
          </p>
          <form onSubmit={handleRedeem} className="space-y-4">
            <input
              type="text"
              placeholder="e.g. ABC123"
              value={code}
              onChange={(e) => setCode(e.target.value)}
              className="w-full p-3 rounded-xl border border-ink/20 uppercase tracking-widest font-mono text-center font-bold text-lg"
              maxLength={6}
            />
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-teal text-white p-3 rounded-xl font-bold hover:bg-teal/90 transition-all"
            >
              {loading ? 'Linking...' : 'Link Student'}
            </button>
          </form>
        </div>
      ) : (
        <div className="space-y-6">
          <div className="bg-teal text-paper p-6 rounded-2xl shadow-md">
            <span className="text-xs uppercase tracking-wider bg-amber text-teal px-2 py-0.5 rounded-full font-bold">Linked Student</span>
            <h2 className="font-serif text-2xl font-bold mt-2">{childData?.child_name || 'Ayesha'}</h2>
            <p className="text-sm opacity-90 mt-1">Pathway: {childData?.pathway_title || 'Pre-Engineering'}</p>
          </div>

          <div className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-4">
            <div className="flex justify-between items-center">
              <span className="font-bold text-sm">Roadmap Progress</span>
              <span className="font-bold text-teal">{childData?.progress_percent || 40}%</span>
            </div>
            <div className="w-full bg-gray-100 h-3 rounded-full overflow-hidden">
              <div className="bg-teal h-full" style={{ width: `${childData?.progress_percent || 40}%` }}></div>
            </div>
            <div className="text-xs text-ink/70">
              <span className="font-bold">Next Milestone:</span> {childData?.next_step || 'University Entry Test Preparation'}
            </div>
          </div>

          <div className="bg-amber/10 p-5 rounded-2xl border border-amber/30">
            <h3 className="font-bold text-sm mb-1">Counselor Note</h3>
            <p className="text-xs text-ink/80 italic">“Encourage consistency in mathematics practice for upcoming entry test simulations.”</p>
          </div>
        </div>
      )}
    </div>
  );
}
