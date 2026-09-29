'use client';
import { use, useEffect, useState } from 'react';

export default function MentorProfile({ params }: { params: Promise<{ id: string }> }) {
  const resolvedParams = use(params);
  const id = resolvedParams.id;
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`http://localhost:8000/mentors/${id}`)
      .then(res => res.json())
      .then(setData);
  }, [id]);

  if (!data) return <div>Loading...</div>;

  return (
    <div className="p-5">
      <h1 className="text-xl font-bold">{data.mentor[0].name}</h1>
      <p>{data.mentor[0].bio}</p>
      <h2 className="mt-4 font-bold">Reviews</h2>
      {data.reviews.map((r: any) => (
        <div key={r.id} className="border-b py-2">{r.comment} - {r.rating} stars</div>
      ))}
    </div>
  );
}
