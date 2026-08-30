import React from 'react';

const Dashboard = ({ stats }: { stats: any }) => {
  return (
    <div className="dashboard">
      <h1>Hello, Learner!</h1>
      <div className="progress-card">
        <h3>Active Pathway: {stats.active_pathway.title}</h3>
        <p>Progress: {stats.active_pathway.progress}%</p>
      </div>
      <div className="quick-stats">
        <p>Resources Saved: {stats.saved_resources}</p>
        <p>Deadlines: {stats.upcoming_deadlines}</p>
      </div>
    </div>
  );
};

export default Dashboard;
