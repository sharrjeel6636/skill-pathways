'use client';
import { useEffect, useState } from 'react';

export default function RoadmapPage({ params }: { params: { id: string } }) {
  const [steps, setSteps] = useState([]);

  useEffect(() => {
    fetch(`http://localhost:8000/pathways/${params.id}/steps`)
      .then(res => res.json())
      .then(data => setSteps(data));
  }, [params.id]);

  return (
    <div className="roadmap-container">
      <h1 className="text-2xl font-bold mb-4">Roadmap</h1>
      <div className="roadmap-tree">
        {steps.map((step: any, index: number) => (
          <div key={step.id}>
            <div className={`node-item ${step.status || 'locked'}`}>
              <div className="node-circle">{index + 1}</div>
              <div>
                <p className="font-bold">{step.title}</p>
                <p>{step.description}</p>
              </div>
            </div>
            {index < steps.length - 1 && <div className="connector"></div>}
          </div>
        ))}
      </div>
    </div>
  );
}
