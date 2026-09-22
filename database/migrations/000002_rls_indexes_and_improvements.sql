-- 000002_rls_indexes_and_improvements.sql

-- 1. Helper function for updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- 2. Add Triggers for updated_at
-- Assuming 'updated_at' column exists or should exist.
-- If not in 000001, we might need to alter table. Based on 000001, profiles has it.
create trigger handle_updated_at before update on public.profiles
  for each row execute procedure public.handle_updated_at();

-- Note: user_progress in 000001 has 'updated_at' default now(), but need to check if it's updated on row update.
-- If not present, this trigger might fail if the table was created without updated_at column.
-- Assuming table schema allows it.
create trigger handle_updated_at before update on public.user_progress
  for each row execute procedure public.handle_updated_at();

-- 3. Enable RLS
alter table public.profiles enable row level security;
alter table public.user_pathways enable row level security;
alter table public.user_progress enable row level security;
alter table public.pathways enable row level security;
alter table public.pathway_steps enable row level security;
alter table public.learning_materials enable row level security;
alter table public.quiz_questions enable row level security;
alter table public.quiz_options enable row level security;

-- 4. RLS Policies

-- Public Read Policies
create policy "Public read access pathways" on public.pathways for select using (true);
create policy "Public read access steps" on public.pathway_steps for select using (true);
create policy "Public read access learning" on public.learning_materials for select using (true);
create policy "Public read access quiz questions" on public.quiz_questions for select using (true);
create policy "Public read access quiz options" on public.quiz_options for select using (true);

-- User-Specific Policies
-- Profiles: Users can read/update their own profile
create policy "Users can read own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- User Pathways/Progress: Users can read/write their own data
create policy "Users can read own pathways" on public.user_pathways for select using (auth.uid() = user_id);
create policy "Users can insert own pathways" on public.user_pathways for insert with check (auth.uid() = user_id);
create policy "Users can delete own pathways" on public.user_pathways for delete using (auth.uid() = user_id);

create policy "Users can read own progress" on public.user_progress for select using (auth.uid() = user_id);
create policy "Users can insert own progress" on public.user_progress for insert with check (auth.uid() = user_id);
create policy "Users can update own progress" on public.user_progress for update using (auth.uid() = user_id);

-- 5. Additional Indexes
create index if not exists idx_pathway_steps_order on public.pathway_steps(pathway_id, step_order);
create index if not exists idx_user_progress_step_id on public.user_progress(step_id);
create index if not exists idx_learning_materials_tag on public.learning_materials(pathway_tag);
