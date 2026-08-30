import React from 'react';
import Link from 'next/link';

const BottomNav = () => {
  return (
    <nav className="bottom-nav">
      <Link href="/">Home</Link>
      <Link href="/learn">Learn</Link>
      <Link href="/chat">Chat</Link>
      <Link href="/community">Community</Link>
      <Link href="/profile">Profile</Link>
    </nav>
  );
};

export default BottomNav;
