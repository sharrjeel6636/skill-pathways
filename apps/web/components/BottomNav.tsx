import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function BottomNav() {
  const pathname = usePathname();
  const items = [
    { name: 'Home', path: '/home', icon: '⌂' },
    { name: 'Roadmap', path: '/roadmap', icon: '🧭' },
    { name: 'Chat', path: '/chatbot', icon: '💬' },
    { name: 'Profile', path: '/profile', icon: '👤' },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-ink/10 flex justify-around p-3">
      {items.map((item) => (
        <Link
          key={item.path}
          href={item.path}
          className={`flex flex-col items-center ${pathname === item.path ? 'text-teal' : 'text-ink/50'}`}
        >
          <span className="text-xl">{item.icon}</span>
          <span className="text-[10px] font-bold mt-1">{item.name}</span>
        </Link>
      ))}
    </nav>
  );
}
