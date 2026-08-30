'use client';
import { useState, useEffect } from 'react';

export default function QuizPage() {
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState<Record<number, number>>({});
  const [recommendation, setRecommendation] = useState(null);

  useEffect(() => {
    fetch('http://localhost:8000/quiz/questions')
      .then(res => res.json())
      .then(data => setQuestions(data));
  }, []);

  const handleSubmit = async () => {
    const res = await fetch('http://localhost:8000/quiz/submit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user_id: 'mock-user-123', answers })
    });
    const data = await res.json();
    setRecommendation(data.recommendation || { title: 'General Path' });
  };

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-4">Interest Quiz</h1>
      {questions.map((q: any) => (
        <div key={q.id} className="mb-4">
          <p>{q.question_text}</p>
          {q.options.map((opt: any) => (
            <button key={opt.id} onClick={() => setAnswers({...answers, [q.id]: opt.id})} className="block bg-gray-200 p-2 my-1">
              {opt.option_text}
            </button>
          ))}
        </div>
      ))}
      <button onClick={handleSubmit} className="bg-blue-500 text-white p-2 rounded">Submit</button>
      {recommendation && <div className="mt-4 p-4 border">{recommendation.title}</div>}
    </div>
  );
}
