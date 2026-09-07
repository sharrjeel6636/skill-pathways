import './globals.css';
import { Fraunces, Manrope, Noto_Nastaliq_Urdu } from 'next/font/google';

const fraunces = Fraunces({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  style: ['normal', 'italic'],
  variable: '--font-fraunces',
});

const manrope = Manrope({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-manrope',
});

const notoUrdu = Noto_Nastaliq_Urdu({
  subsets: ['latin'],
  weight: ['600'],
  variable: '--font-noto-urdu',
});

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${fraunces.variable} ${manrope.variable} ${notoUrdu.variable}`}>
      <body className="font-sans antialiased">{children}</body>
    </html>
  );
}
