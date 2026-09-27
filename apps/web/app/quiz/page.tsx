'use client';
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';

const QUESTIONS = [
  { id: 1, text: "Which subjects do you enjoy the most?", options: ["Math/Physics", "Biology/Chemistry", "Arts/Design", "Business/Economics"] },
  { id: 2, text: "What do you like doing in your free time?", options: ["Coding/Gaming", "Volunteering/Help", "Drawing/Creating", "Planning/Organizing"] },
  { id: 3, text: "What kind of problems do you like solving?", options: ["Logical/Technical", "Human/Health", "Creative/Visual", "Strategic/Financial"] },
];

export default function QuizPage() {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const router = useRouter();

  const progress = ((currentIdx + 1) / QUESTIONS.length) * 100;

  const handleNext = () => {
    if (currentIdx < QUESTIONS.length - 1) {
      setCurrentIdx(currentIdx + 1);
      setSelected(null);
    } else {
      router.push('/quiz/result');
    }
  };

  return (
    <div className="min-h-screen bg-paper p-6 max-w-[430px] mx-auto flex flex-col">
      <div className="mb-6">
        <div className="text-sm font-bold text-ink/60 mb-2">Question {currentIdx + 1} of {QUESTIONS.length}</div>
        <div className="h-1 bg-ink/10 rounded-full">
          <div className="h-1 bg-teal rounded-full transition-all" style={{ width: `${progress}%` }} />
        </div>
      </div>

      <h1 className="text-2xl font-serif font-bold text-ink mb-8">{QUESTIONS[currentIdx].text}</h1>

      <div className="flex-1 flex flex-col gap-4">
        {QUESTIONS[currentIdx].options.map((option, idx) => (
          <button
            key={idx}
            onClick={() => setSelected(idx)}
            className={`w-full p-4 rounded-2xl border-2 text-left font-bold transition-all ${
              selected === idx ? 'border-teal bg-teal/5' : 'border-ink/10 bg-white'
            }`}
          >
            {option}
          </button>
        ))}
      </div>

      <button
        onClick={handleNext}
        disabled={selected === null}
        className="mt-8 w-full bg-teal text-white py-4 rounded-2xl font-bold disabled:opacity-50"
      >
        Next Question
      </button>
    </div>
  );
}
