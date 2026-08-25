-- Quiz Questions
create table public.quiz_questions (
  id serial primary key,
  question_text text not null,
  options jsonb not null
);

-- Quiz Answers
create table public.quiz_answers (
  id serial primary key,
  user_id uuid references auth.users not null,
  question_id int references public.quiz_questions not null,
  selected_option text not null,
  created_at timestamp with time zone default now()
);

-- Pathways
create table public.pathways (
  id serial primary key,
  title text not null,
  description text,
  tags text[]
);

-- User Pathways
create table public.user_pathways (
  id serial primary key,
  user_id uuid references auth.users not null,
  pathway_id int references public.pathways not null,
  saved_at timestamp with time zone default now()
);

-- Seed data for pathways
insert into public.pathways (title, description, tags) values
('Web Dev', 'Learn HTML, CSS, JS, and React.', '{"tech", "coding"}'),
('Data Analytics', 'Master SQL, Python, and PowerBI.', '{"data", "stats"}'),
('UI/UX', 'Design intuitive interfaces and user flows.', '{"design", "creativity"}'),
('Digital Marketing', 'Learn SEO, SEM, and content strategy.', '{"marketing", "strategy"}'),
('Graphic Design', 'Create visual content with Adobe Suite.', '{"design", "visual"}');
