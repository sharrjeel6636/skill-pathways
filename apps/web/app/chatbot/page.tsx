'use client';
import { useState } from 'react';

export default function ChatbotPage() {
  const [messages, setMessages] = useState<any[]>([]);
  const [input, setInput] = useState('');

  const handleSend = async () => {
    const newMessages = [...messages, { sender: 'user', text: input }];
    setMessages(newMessages);
    setInput('');

    const res = await fetch('http://localhost:8000/chatbot/message', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: input })
    });
    const data = await res.json();
    setMessages([...newMessages, { sender: 'bot', text: data.reply }]);
  };

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-4">Chatbot</h1>
      <div className="h-64 overflow-y-scroll border p-4 mb-4">
        {messages.map((m, i) => <div key={i} className={m.sender === 'bot' ? 'text-green-700' : 'text-blue-700'}>{m.text}</div>)}
      </div>
      <input value={input} onChange={e => setInput(e.target.value)} className="border p-2 w-full" />
      <button onClick={handleSend} className="bg-blue-500 text-white p-2 w-full mt-2">Send</button>
    </div>
  );
}
