-- 000003_add_skill_tables.sql

-- Skill Gap Analysis Tables

-- Stores mapping of roles to required skills and their suggested learning order
create table if not exists public.role_skills (
  role_name text primary key,
  required_skills text[] not null,
  recommended_order text[] not null,
  created_at timestamp with time zone default now()
);

-- Stores student's current self-reported skills
create table if not exists public.user_skills (
  user_id uuid references auth.users(id) on delete cascade primary key,
  skills text[] default '{}',
  updated_at timestamp with time zone default now()
);

-- Enable RLS on these tables
alter table public.role_skills enable row level security;
alter table public.user_skills enable row level security;

-- Policies
create policy "Allow read access to all for role_skills" on public.role_skills for select using (true);
create policy "Allow users to read their own skills" on public.user_skills for select using (auth.uid() = user_id);
create policy "Allow users to update their own skills" on public.user_skills for insert with check (auth.uid() = user_id);
create policy "Allow users to update their own skills" on public.user_skills for update using (auth.uid() = user_id);
