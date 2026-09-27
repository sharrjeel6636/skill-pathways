-- 000004_add_parent_links.sql

create table if not exists public.parent_links (
  id uuid primary key default uuid_generate_v4(),
  student_id uuid references auth.users(id) on delete cascade not null,
  parent_id uuid references auth.users(id) on delete cascade,
  invite_code text unique not null,
  expires_at timestamp with time zone not null default (now() + interval '24 hours'),
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique(student_id, parent_id)
);

create index idx_parent_links_invite_code on public.parent_links(invite_code);
create index idx_parent_links_student_id on public.parent_links(student_id);
