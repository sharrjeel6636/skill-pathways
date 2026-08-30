-- Profiles table
create table if not exists public.profiles (
  id uuid references auth.users not null primary key,
  name text,
  email text,
  age int,
  role text check (role in ('student', 'employee', 'self-employed')),
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Pathways
create table if not exists public.pathways (
  id serial primary key,
  title text not null,
  description text,
  tags text[]
);

-- Pathway Steps (formerly pathway_nodes)
create table if not exists public.pathway_steps (
  id serial primary key,
  pathway_id int references public.pathways not null,
  step_order int not null,
  title text not null,
  description text,
  resources jsonb,
  prerequisites int[]
);

-- User Path Progress
create table if not exists public.user_progress (
  id serial primary key,
  user_id uuid references auth.users not null,
  step_id int references public.pathway_steps not null,
  status text check (status in ('locked', 'active', 'mastered')) default 'locked',
  updated_at timestamp with time zone default now()
);

-- User Pathways
create table if not exists public.user_pathways (
  id serial primary key,
  user_id uuid references auth.users not null,
  pathway_id int references public.pathways not null,
  saved_at timestamp with time zone default now()
);

-- Quiz Questions
create table if not exists public.quiz_questions (
  id serial primary key,
  question_text text not null
);

-- Quiz Options
create table if not exists public.quiz_options (
  id serial primary key,
  question_id int references public.quiz_questions not null,
  option_text text not null,
  is_correct boolean default false
);

-- Mentors
create table if not exists public.mentors (
  id serial primary key,
  name text not null,
  expertise text,
  bio text
);

-- Learning Materials
create table if not exists public.learning_materials (
  id serial primary key,
  title text not null,
  type text check (type in ('video', 'article', 'course')) not null,
  duration text,
  is_verified boolean default false,
  pathway_tag text not null,
  content_url text not null,
  created_at timestamp with time zone default now()
);

-- Reviews
create table if not exists public.reviews (
  id serial primary key,
  user_id uuid references auth.users not null,
  material_id int references public.learning_materials not null,
  rating int check (rating >= 1 and rating <= 5),
  comment text
);

-- Opportunities
create table if not exists public.opportunities (
  id serial primary key,
  title text not null,
  description text,
  link text,
  deadline timestamp with time zone -- Added deadline column
);

-- Seed data for pathways and steps
insert into public.pathways (title, description, tags) values
('Web Dev', 'Learn HTML, CSS, JS, and React.', '{"tech", "coding"}'),
('Data Analytics', 'Master SQL, Python, and PowerBI.', '{"data", "stats"}'),
('UI/UX', 'Design intuitive interfaces and user flows.', '{"design", "creativity"}'),
('Digital Marketing', 'Learn SEO, SEM, and content strategy.', '{"marketing", "strategy"}'),
('Graphic Design', 'Create visual content with Adobe Suite.', '{"design", "visual"}');

-- Seeding some steps for Web Dev
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(1, 1, 'HTML Basics', 'Learn structure'),
(1, 2, 'CSS Basics', 'Learn styling'),
(1, 3, 'JavaScript Basics', 'Learn scripting'),
(1, 4, 'React Framework', 'Build UIs');
