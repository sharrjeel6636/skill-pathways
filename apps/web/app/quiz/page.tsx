'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';

export default function QuizPage() {
  const [questions, setQuestions] = useState<any[]>([]);
  const [currentIdx, setCurrentIdx] = useState(0);
  const [answers, setAnswers] = useState<Record<number, number>>({});
  const router = useRouter();

  useEffect(() => {
    fetch('http://localhost:8000/quiz/questions')
      .then(res => res.json())
      .then(data => setQuestions(data))
      .catch(err => console.error('Error fetching questions:', err));
  }, []);

  const handleSubmit = async () => {
    const res = await fetch('http://localhost:8000/quiz/submit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user_id: 'mock-user-123', answers })
    });
    const data = await res.json();
    if (data.recommended_pathway_id) {
      router.push(`/roadmap/${data.recommended_pathway_id}`);
    }
  };

  if (questions.length === 0) return <div className="p-12 text-ink">Loading...</div>;

  const progress = ((currentIdx + 1) / questions.length) * 100;
  const currentQuestion = questions[currentIdx];

  return (
    <div className="max-w-[480px] mx-auto px-[22px] py-12">
      {/* Top Header */}
      <div className="flex items-center gap-3 mb-4.5">
        <div className="w-[34px] h-[34px] rounded-full bg-card flex items-center justify-center text-[16px] shadow-[0_2px_6px_rgba(0,0,0,0.06)] cursor-pointer" onClick={() => currentIdx > 0 && setCurrentIdx(currentIdx - 1)}>
          ←
        </div>
        <div className="flex-1 h-[6px] rounded-[6px] bg-sage-soft overflow-hidden">
          <div className="h-full bg-teal transition-all duration-300" style={{ width: `${progress}%` }}></div>
        </div>
        <div className="text-[12px] font-bold text-ink/50">{currentIdx + 1}/{questions.length}</div>
      </div>

      {/* Content */}
      <div className="text-[12px] font-extrabold tracking-widest uppercase text-rust mb-2.5">Interest check</div>
      <h1 className="font-serif font-semibold text-[23px] leading-[1.25] text-ink mb-6.5">
        {currentQuestion.question_text}
      </h1>

      <div className="space-y-3 mb-8">
        {currentQuestion.options.map((opt: any) => {
          const isSelected = answers[currentQuestion.id] === opt.id;
          return (
            <div
              key={opt.id}
              onClick={() => setAnswers({ ...answers, [currentQuestion.id]: opt.id })}
              className={`group cursor-pointer bg-card border-[1.5px] rounded-[16px] p-[15px_16px] flex items-center gap-3 text-[14.5px] font-semibold transition-all ${
                isSelected ? 'border-teal bg-sage-soft' : 'border-[rgba(30,42,34,0.12)]'
              }`}
            >
              <span className="text-[20px] w-[30px] text-center">🛠️</span>
              <span className="flex-1">{opt.option_text}</span>
              {isSelected && (
                <div className="w-5 h-5 rounded-full bg-teal text-white flex items-center justify-center text-[12px]">✓</div>
              )}
            </div>
          );
        })}
      </div>

      {/* Next Button */}
      <div className="mt-auto">
        <button
          onClick={() => {
            if (currentIdx < questions.length - 1) {
              setCurrentIdx(currentIdx + 1);
            } else {
              handleSubmit();
            }
          }}
          className="btn-primary w-full"
          style={{ background: 'var(--color-teal)', color: '#fff' }}
        >
          Next question <span>→</span>
        </button>
      </div>
    </div>
  );
}
