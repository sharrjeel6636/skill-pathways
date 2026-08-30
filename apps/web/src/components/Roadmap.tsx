import React from 'react';

interface Node {
  id: number;
  title: string;
  status: 'locked' | 'active' | 'mastered';
}

const Roadmap = ({ nodes }: { nodes: Node[] }) => {
  return (
    <div className="roadmap-container">
      <h2>Your Pathway Roadmap</h2>
      <div className="roadmap-tree">
        {nodes.map((node, index) => (
          <div key={node.id} className={`node-item ${node.status}`}>
            <div className="node-circle">{index + 1}</div>
            <div className="node-content">
              <h3>{node.title}</h3>
              <p className="status-label">{node.status.toUpperCase()}</p>
            </div>
            {index < nodes.length - 1 && <div className="connector"></div>}
          </div>
        ))}
      </div>
    </div>
  );
};

export default Roadmap;
