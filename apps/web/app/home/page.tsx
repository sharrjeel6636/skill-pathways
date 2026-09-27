'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '../../lib/supabase';
import BottomNav from '../../components/BottomNav';
import Link from 'next/link';
import { Session } from '@supabase/supabase-js';

export default function StudentHomePage() {
  const router = useRouter();
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!session) {
        router.push('/login');
      } else {
        setSession(session);
        setLoading(false);
      }
    });
  }, [router]);

  if (loading) return <div className="p-8 text-ink">Loading...</div>;

  const userName = session?.user?.user_metadata?.full_name || 'Student';

  return (
    <div className="min-h-screen bg-paper pb-24">
      <div className="max-w-[430px] mx-auto p-6 space-y-8">
        
        {/* Header */}
        <header>
          <h1 className="text-2xl font-serif font-bold text-ink">Assalam-o-Alaikum, {userName}</h1>
          <p className="text-ink/60">Class 10 · Science Group</p>
        </header>

        {/* Quiz Card */}
        <section className="bg-teal p-6 rounded-3xl text-white">
          <h2 className="text-xl font-bold mb-2">Take your Aptitude Quiz</h2>
          <p className="text-sm opacity-90 mb-6">Find out if Science, Arts or Commerce fits you best — 5 mins</p>
          <Link href="/quiz" className="block w-full text-center bg-amber text-teal font-bold py-3 rounded-2xl">
            Start Quiz Now
          </Link>
        </section>

        {/* Roadmap Section */}
        <section>
          <h3 className="font-bold text-ink mb-4">Your Roadmap</h3>
          <Link href="/roadmap" className="block bg-white p-5 rounded-2xl border border-ink/5 shadow-sm space-y-4">
            <div className="flex items-center gap-4">
              <div className="text-success">✅</div>
              <span className="font-bold">Aptitude test completed</span>
            </div>
            <div className="flex items-center gap-4">
              <div className="text-ink/30">🔒</div>
              <span className="text-ink/60">Strengthen Math & Physics</span>
            </div>
            <div className="flex items-center gap-4">
              <div className="text-ink/30">🔒</div>
              <span className="text-ink/60">Explore Intermediate options</span>
            </div>
          </Link>
        </section>

        {/* Parent Section */}
        <section>
          <h3 className="font-bold text-ink mb-4">For Your Parents</h3>
          <Link href="/parent" className="block bg-white p-5 rounded-2xl border border-ink/5 shadow-sm">
            <span className="font-bold">Share progress report with parents</span>
          </Link>
        </section>

        {/* Success Stories */}
        <section>
          <h3 className="font-bold text-ink mb-4">Success Stories</h3>
          <div className="bg-amber/10 p-5 rounded-2xl border border-amber/20 italic text-ink/80">
            “The roadmap helped me decide my field confidently!” — Student
          </div>
        </section>

      </div>
      <BottomNav />
    </div>
  );
}
