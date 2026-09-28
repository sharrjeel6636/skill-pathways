'use client';
export const dynamic = 'force-dynamic';
import React, { useState, useEffect } from 'react';
import { fetchWithAuth } from '@/lib/api';
import { useLanguage } from '@/lib/LanguageContext';

export default function ScholarshipsPage() {
  const { language } = useLanguage();
  const [scholarships, setScholarships] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');

  useEffect(() => {
    fetchWithAuth('/scholarships')
      .then(data => setScholarships(Array.isArray(data) ? data : []))
      .catch(err => console.error(err))
      .finally(() => setLoading(false));
  }, []);

  const filtered = scholarships.filter(s => 
    s.title?.toLowerCase().includes(search.toLowerCase()) ||
    s.provider?.toLowerCase().includes(search.toLowerCase()) ||
    s.description?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="p-6 text-ink">
      <h1 className="font-serif text-2xl font-bold mb-2">
        {language === 'ur' ? 'سکالرشپس اور وظائف' : 'Scholarships & Financial Aid'}
      </h1>
      <p className="text-sm text-ink/70 mb-6">
        {language === 'ur'
          ? 'پاکستان میں طلباء کے لیے دستیاب میرٹ اور نیڈ بیسڈ وظائف۔'
          : 'Merit and need-based scholarships available for undergraduate students in Pakistan.'}
      </p>

      <input
        type="text"
        placeholder="Search scholarships (e.g. HEC, PEEF)..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="w-full p-3 rounded-xl border border-ink/20 mb-6 bg-white text-sm"
      />

      {loading ? (
        <div className="text-center py-12 text-ink/50">Loading scholarships...</div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-12 text-ink/50">No scholarships found.</div>
      ) : (
        <div className="space-y-4">
          {filtered.map((s, idx) => (
            <div key={idx} className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-2">
              <span className="text-xs bg-teal/10 text-teal px-2 py-0.5 rounded-md font-bold">{s.provider}</span>
              <h2 className="font-bold text-base text-ink">{s.title}</h2>
              <p className="text-xs text-ink/70">{s.description}</p>
              <div className="text-xs font-semibold text-ink/80 pt-2 border-t border-ink/5 flex justify-between items-center">
                <span>Eligibility: {s.eligibility_criteria}</span>
                <span className="text-amber">Deadline: {s.deadline}</span>
              </div>
              {s.website_url && (
                <a
                  href={s.website_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-block mt-2 text-xs font-bold text-teal hover:underline"
                >
                  Official Portal →
                </a>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
