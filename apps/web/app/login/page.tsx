'use client';
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '../lib/supabase';
import { useLanguage } from '../../lib/LanguageContext';

export default function AuthPage() {
  const router = useRouter();
  const { language } = useLanguage();
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    if (!isLogin && password !== confirmPassword) {
      setError(language === 'en' ? 'Passwords do not match' : 'پاس ورڈز آپس میں نہیں ملتے');
      setLoading(false);
      return;
    }

    try {
      if (isLogin) {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        router.push('/home');
      } else {
        const { error } = await supabase.auth.signUp({ 
          email, 
          password, 
          options: { data: { full_name: fullName } } 
        });
        if (error) throw error;
        router.push('/onboarding');
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-paper flex flex-col p-8 justify-center max-w-[430px] mx-auto">
      <h1 className="font-serif text-3xl font-bold text-ink mb-6">
        {isLogin ? (language === 'en' ? 'Log in' : 'لاگ ان') : (language === 'en' ? 'Create account' : 'اکاؤنٹ بنائیں')}
      </h1>
      
      {error && <p className="text-red-500 text-sm mb-4 bg-red-100 p-3 rounded-lg">{error}</p>}

      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        {!isLogin && (
          <input 
            type="text" 
            placeholder={language === 'en' ? "Full Name" : "پورا نام"}
            value={fullName} 
            onChange={(e) => setFullName(e.target.value)} 
            className="p-4 rounded-2xl border border-ink/10 bg-white"
            required
          />
        )}
        <input 
          type="email" 
          placeholder={language === 'en' ? "Email" : "ای میل"}
          value={email} 
          onChange={(e) => setEmail(e.target.value)} 
          className="p-4 rounded-2xl border border-ink/10 bg-white"
          required
        />
        <input 
          type="password" 
          placeholder={language === 'en' ? "Password" : "پاس ورڈ"}
          value={password} 
          onChange={(e) => setPassword(e.target.value)} 
          className="p-4 rounded-2xl border border-ink/10 bg-white"
          required
        />
        {!isLogin && (
          <input 
            type="password" 
            placeholder={language === 'en' ? "Confirm Password" : "پاس ورڈ کی تصدیق"}
            value={confirmPassword} 
            onChange={(e) => setConfirmPassword(e.target.value)} 
            className="p-4 rounded-2xl border border-ink/10 bg-white"
            required
          />
        )}
        <button 
          type="submit" 
          disabled={loading}
          className="bg-teal text-white p-4 rounded-2xl font-bold hover:bg-teal/90 disabled:opacity-50 mt-2"
        >
          {loading ? (language === 'en' ? 'Loading...' : '...لوڈ ہو رہا ہے') : (isLogin ? (language === 'en' ? 'Log in' : 'لاگ ان') : (language === 'en' ? 'Sign up' : 'سائن اپ'))}
        </button>
      </form>

      <button 
        onClick={() => setIsLogin(!isLogin)} 
        className="mt-6 text-teal font-bold underline underline-offset-4"
      >
        {isLogin 
          ? (language === 'en' ? "Don't have an account? Sign up" : "اکاؤنٹ نہیں ہے؟ سائن اپ کریں") 
          : (language === 'en' ? "Already have an account? Log in" : "پہلے سے اکاؤنٹ ہے؟ لاگ ان کریں")}
      </button>
    </div>
  );
}
