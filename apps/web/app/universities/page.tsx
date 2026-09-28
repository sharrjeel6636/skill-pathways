'use client';
export const dynamic = 'force-dynamic';
import React, { useState, useEffect } from 'react';
import { fetchWithAuth } from '@/lib/api';
import { useLanguage } from '@/lib/LanguageContext';

export default function UniversitiesPage() {
  const { language } = useLanguage();
  const [universities, setUniversities] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');

  useEffect(() => {
    fetchWithAuth('/universities')
      .then(data => setUniversities(Array.isArray(data) ? data : []))
      .catch(err => console.error(err))
      .finally(() => setLoading(false));
  }, []);

  const filtered = universities.filter(u =>
    u.name?.toLowerCase().includes(search.toLowerCase()) ||
    u.city?.toLowerCase().includes(search.toLowerCase()) ||
    u.province?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="p-6 text-ink">
      <h1 className="font-serif text-2xl font-bold mb-2">
        {language === 'ur' ? 'جامعات اور ادارے' : 'Top Universities in Pakistan'}
      </h1>
      <p className="text-sm text-ink/70 mb-6">
        {language === 'ur'
          ? 'اعلیٰ تعلیم کے لیے معروف پاکستانی جامعات کی فہرست۔'
          : 'Discover accredited universities across Pakistan for engineering, medical, IT, and business.'}
      </p>

      <input
        type="text"
        placeholder="Search universities by name or city..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="w-full p-3 rounded-xl border border-ink/20 mb-6 bg-white text-sm"
      />

      {loading ? (
        <div className="text-center py-12 text-ink/50">Loading universities...</div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-12 text-ink/50">No universities found.</div>
      ) : (
        <div className="space-y-4">
          {filtered.map((u, idx) => (
            <div key={idx} className="bg-white p-5 rounded-2xl border border-ink/10 shadow-sm space-y-2">
              <div className="flex justify-between items-start">
                <h2 className="font-bold text-base text-ink">{u.name}</h2>
                <span className="text-xs bg-amber/20 text-ink px-2 py-0.5 rounded-md font-semibold">{u.city}, {u.province}</span>
              </div>
              <p className="text-xs text-ink/70">{u.description}</p>
              {u.website_url && (
                <a
                  href={u.website_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-block mt-2 text-xs font-bold text-teal hover:underline"
                >
                  Visit Website →
                </a>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
