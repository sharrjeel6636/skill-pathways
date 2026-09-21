-- 000001_initial_schema.sql

-- Profiles
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

-- Pathway Steps
create table if not exists public.pathway_steps (
  id serial primary key,
  pathway_id int references public.pathways(id) on delete cascade not null,
  step_order int not null,
  title text not null,
  description text,
  resources jsonb,
  prerequisites int[]
);

-- User Path Progress
create table if not exists public.user_progress (
  id serial primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  step_id int references public.pathway_steps(id) on delete cascade not null,
  status text check (status in ('locked', 'active', 'mastered')) default 'locked',
  updated_at timestamp with time zone default now()
);

-- User Pathways
create table if not exists public.user_pathways (
  id serial primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  pathway_id int references public.pathways(id) on delete cascade not null,
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
  question_id int references public.quiz_questions(id) on delete cascade not null,
  option_text text not null,
  maps_to_pathway_id int references public.pathways(id) on delete set null,
  weight int default 1
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
  deleted_at timestamp null,
  created_at timestamp with time zone default now()
);

-- Indexes for performance
create index idx_pathway_steps_pathway_id on public.pathway_steps(pathway_id);
create index idx_user_progress_user_id on public.user_progress(user_id);
create index idx_user_pathways_user_id on public.user_pathways(user_id);
create index idx_quiz_options_question_id on public.quiz_options(question_id);
