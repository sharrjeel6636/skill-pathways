-- 000002_rls_indexes_and_improvements.sql
-- Adds RLS, extra indexes, updated_at trigger. Does NOT recreate tables.
-- 1. updated_at helper
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;
-- 2. Triggers
drop trigger if exists handle_profiles_updated_at on public.profiles;
create trigger handle_profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.handle_updated_at();
drop trigger if exists handle_user_progress_updated_at on public.user_progress;
create trigger handle_user_progress_updated_at
  before update on public.user_progress
  for each row execute procedure public.handle_updated_at();
-- 3. Enable RLS
alter table public.profiles enable row level security;
alter table public.user_pathways enable row level security;
alter table public.user_progress enable row level security;
alter table public.pathways enable row level security;alter table public.pathway_steps enable row level security;
alter table public.learning_materials enable row level security;
alter table public.quiz_questions enable row level security;
alter table public.quiz_options enable row level security;
-- 4. Profiles policies
drop policy if exists "Users can read own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;
drop policy if exists "Users can insert own profile" on public.profiles;
create policy "Users can read own profile"
  on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);
create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);
-- 5. User pathways / progress
drop policy if exists "Users can read own pathways" on public.user_pathways;
drop policy if exists "Users can write own pathways" on public.user_pathways;
drop policy if exists "Users can read own progress" on public.user_progress;
drop policy if exists "Users can write own progress" on public.user_progress;
create policy "Users can read own pathways"
  on public.user_pathways for select using (auth.uid() = user_id);
create policy "Users can insert own pathways"
  on public.user_pathways for insert with check (auth.uid() = user_id);
create policy "Users can delete own pathways"
  on public.user_pathways for delete using (auth.uid() = user_id);
create policy "Users can read own progress"
  on public.user_progress for select using (auth.uid() = user_id);
create policy "Users can insert own progress"
  on public.user_progress for insert with check (auth.uid() = user_id);
create policy "Users can update own progress"
  on public.user_progress for update using (auth.uid() = user_id);
-- 6. Public read for content tables
drop policy if exists "Public can read pathways" on public.pathways;
drop policy if exists "Public can read pathway_steps" on public.pathway_steps;
drop policy if exists "Public can read learning_materials" on public.learning_materials;
drop policy if exists "Public can read quiz_questions" on public.quiz_questions;
drop policy if exists "Public can read quiz_options" on public.quiz_options;
create policy "Public can read pathways"
  on public.pathways for select using (true);
create policy "Public can read pathway_steps"
  on public.pathway_steps for select using (true);
create policy "Public can read learning_materials"
  on public.learning_materials for select using (true);
create policy "Public can read quiz_questions"
  on public.quiz_questions for select using (true);
create policy "Public can read quiz_options"
  on public.quiz_options for select using (true);
-- 7. Extra indexes
create index if not exists idx_pathway_steps_order
  on public.pathway_steps(pathway_id, step_order);
create index if not exists idx_user_progress_step_id
  on public.user_progress(step_id);
create index if not exists idx_learning_materials_tag
  on public.learning_materials(pathway_tag);
create index if not exists idx_user_pathways_pathway_id
  on public.user_pathways(pathway_id);
