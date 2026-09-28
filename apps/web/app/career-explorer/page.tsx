'use client';
export const dynamic = 'force-dynamic';
import React, { useState, useEffect } from 'react';
import { fetchWithAuth } from '@/lib/api';
import { useLanguage } from '@/lib/LanguageContext';
import Link from 'next/link';

export default function CareerExplorerPage() {
  const { language } = useLanguage();
  const [pathways, setPathways] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchWithAuth('/pathways')
      .then(data => setPathways(Array.isArray(data) ? data : []))
      .catch(err => console.error(err))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="p-6 text-ink">
      <h1 className="font-serif text-2xl font-bold mb-2">
        {language === 'ur' ? 'کیریئر کے راستے' : 'Career Explorer & Pathways'}
      </h1>
      <p className="text-sm text-ink/70 mb-6">
        {language === 'ur'
          ? 'مختلف کیریئر کے راستے اور تعلیمی مراحل دریافت کریں۔'
          : 'Explore structured career tracks and educational roadmaps tailored for Pakistani students.'}
      </p>

      {loading ? (
        <div className="text-center py-12 text-ink/50">Loading pathways...</div>
      ) : pathways.length === 0 ? (
        <div className="text-center py-12 text-ink/50">No pathways found.</div>
      ) : (
        <div className="space-y-4">
          {pathways.map((p) => (
            <div key={p.id} className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-3">
              <h2 className="font-bold text-lg text-teal">{p.title}</h2>
              <p className="text-xs text-ink/70">{p.description}</p>
              <div className="flex flex-wrap gap-1 pt-1">
                {p.tags?.map((tag: string, i: number) => (
                  <span key={i} className="text-[10px] bg-gray-100 text-ink/70 px-2 py-0.5 rounded font-medium">
                    #{tag}
                  </span>
                ))}
              </div>
              <Link
                href={`/roadmap/${p.id}`}
                className="inline-block mt-2 text-xs font-bold bg-teal/10 text-teal px-4 py-2 rounded-xl hover:bg-teal/20 transition-all"
              >
                View Roadmap Steps →
              </Link>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
