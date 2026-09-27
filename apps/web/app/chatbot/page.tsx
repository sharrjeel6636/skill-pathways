'use client';
import { useState, useEffect, useRef } from 'react';
import { useSearchParams } from 'next/navigation';
import { supabase } from '../../lib/supabase';
import { fetchWithAuth } from '../../lib/api';
import BottomNav from '../../components/BottomNav';

type Message = { text: string; sender: 'bot' | 'user' };

export default function ChatbotPage() {
  const searchParams = useSearchParams();
  const isParentMode = searchParams.get('mode') === 'parent';
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const greeting = isParentMode
      ? "Assalam-o-Alaikum! I'm here to support you in guiding your child. Feel free to ask any questions."
      : "Assalam-o-Alaikum! I'm here to guide you. How can I help you today?";
    setMessages([{ text: greeting, sender: 'bot' }]);
  }, [isParentMode]);

  useEffect(() => {
    scrollRef.current?.scrollTo(0, scrollRef.current.scrollHeight);
  }, [messages]);

  const sendMessage = async () => {
    if (!input.trim() || loading) return;

    const userText = input;
    setMessages(prev => [...prev, { text: userText, sender: 'user' }]);
    setInput('');
    setLoading(true);

    try {
      const data = await fetchWithAuth('/chatbot/message', {
        method: 'POST',
        body: JSON.stringify({
          text: userText,
          message: userText,
          context: {
            mode: isParentMode ? 'parent' : 'student',
            field_of_interest: 'Pre-Engineering', // Placeholder
          },
        }),
      });
      setMessages(prev => [...prev, { text: data.reply || data.response || "No response.", sender: 'bot' }]);
    } catch (e) {
      setMessages(prev => [...prev, { text: "Sorry, I'm having trouble connecting.", sender: 'bot' }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex flex-col h-screen bg-paper pb-20">
      <header className="p-4 bg-teal text-white flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-amber flex items-center justify-center font-bold">AI</div>
        <div>
          <h1 className="font-bold">Guidance Assistant</h1>
          <p className="text-xs opacity-80">Online · Answers in EN or Urdu</p>
        </div>
      </header>

      <div className="flex-1 p-4 overflow-y-auto space-y-4" ref={scrollRef}>
        {messages.map((m, i) => (
          <div key={i} className={`p-3 rounded-2xl max-w-[80%] ${m.sender === 'user' ? 'bg-teal text-white self-end ml-auto' : 'bg-white border border-ink/10 self-start'}`}>
            {m.text}
          </div>
        ))}
        {loading && <div className="p-3 text-sm text-ink/50">Typing...</div>}
      </div>

      <div className="p-4 bg-white border-t border-ink/10 flex gap-2">
        <input 
          className="flex-1 p-3 rounded-full border border-ink/10 bg-gray-100"
          placeholder="Type your question..."
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
        />
        <button className="bg-teal text-white px-6 rounded-full font-bold" onClick={sendMessage}>Send</button>
      </div>
      <BottomNav />
    </div>
  );
}
