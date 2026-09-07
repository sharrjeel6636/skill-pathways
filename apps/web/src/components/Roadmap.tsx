import React from 'react';

interface Node {
  id: number;
  title: string;
  status: 'locked' | 'active' | 'mastered';
}

const Roadmap = ({ nodes }: { nodes: Node[] }) => {
  return (
    <div className="p-8">
      <h2 className="text-2xl font-serif mb-6">Your Pathway Roadmap</h2>
      <div className="relative flex flex-col items-center gap-8">
        <svg className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-full -z-10">
          <path d={`M 150 0 V ${nodes.length * 100}`} stroke="#ddd" strokeWidth="2" fill="none" />
        </svg>
        {nodes.map((node, index) => (
          <div key={node.id} className={`flex items-center gap-4 p-4 bg-white rounded-lg w-[300px] border border-gray-200 ${node.status}`}>
            <div className={`w-10 h-10 rounded-full flex justify-center items-center font-bold ${
              node.status === 'mastered' ? 'bg-[var(--color-sage)] text-white' :
              node.status === 'active' ? 'bg-[var(--color-primary)] text-white' :
              'bg-gray-200 text-gray-500'
            }`}>
              {index + 1}
            </div>
            <div className="flex-1">
              <h3 className="font-bold">{node.title}</h3>
              <p className="text-sm">{node.status.toUpperCase()}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Roadmap;
