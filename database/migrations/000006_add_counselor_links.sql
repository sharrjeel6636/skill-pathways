-- 000006_add_counselor_links.sql

create table if not exists public.counselor_links (
  id uuid primary key default uuid_generate_v4(),
  student_id uuid references auth.users(id) on delete cascade not null,
  counselor_id uuid references auth.users(id) on delete cascade,
  invite_code text unique not null,
  expires_at timestamp with time zone not null default (now() + interval '24 hours'),
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique(student_id, counselor_id)
);

create index if not exists idx_counselor_links_invite_code on public.counselor_links(invite_code);
create index if not exists idx_counselor_links_counselor_id on public.counselor_links(counselor_id);
create index if not exists idx_counselor_links_student_id on public.counselor_links(student_id);
