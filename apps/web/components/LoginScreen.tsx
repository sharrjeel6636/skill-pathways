import React from 'react';
import Link from 'next/link';

const LoginScreen = () => {
  return (
    <div className="max-w-md mx-auto min-h-screen relative flex flex-col p-6 bg-paper shadow-2xl overflow-hidden">
      {/* Quiz Top: Back */}
      <div className="py-[6px] pb-[18px]">
        <div className="w-[34px] h-[34px] rounded-full bg-card flex items-center justify-center text-[16px] shadow-[0_2px_6px_rgba(0,0,0,0.06)] cursor-pointer">
          ←
        </div>
      </div>

      <div className="flex-1 flex flex-col justify-center">
        <div className="text-[12px] font-extrabold tracking-[0.08em] uppercase text-rust mb-[10px]">
          Welcome back
        </div>
        <h2 className="font-serif font-semibold text-[26px] leading-[1.25] text-ink mb-[26px]">
          Log in to your account
        </h2>

        {/* Form Placeholder */}
        <div className="bg-card border-[1.5px] border-line rounded-[14px] p-[14px_16px] mb-3 text-[13px] text-ink/45">
          Mobile number
        </div>
        <div className="bg-card border-[1.5px] border-line rounded-[14px] p-[14px_16px] mb-6 text-[13px] text-ink/45">
          ••••••
        </div>

        {/* Login CTA */}
        <Link href="/dashboard" className="btn-primary w-full block text-center bg-teal text-white">
          Login <span>→</span>
        </Link>

        <div className="text-center my-[18px] text-[12px] text-ink/40">
          یا پھر
        </div>

        {/* Social Auth */}
        <div className="flex gap-[10px]">
          <button className="flex-1 border-[1.5px] border-line rounded-full p-3 text-center text-[12.5px] font-bold bg-card">
            Google
          </button>
          <button className="flex-1 border-[1.5px] border-line rounded-full p-3 text-center text-[12.5px] font-bold bg-card">
            WhatsApp
          </button>
        </div>
      </div>

      {/* Signup Link */}
      <p className="text-center text-[12px] text-ink/50 mb-5">
        New here?{' '}
        <Link href="/signup" className="font-bold text-teal">
          Create an account
        </Link>
      </p>
    </div>
  );
};

export default LoginScreen;
