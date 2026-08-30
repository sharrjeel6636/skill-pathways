-- Learning Materials
create table public.learning_materials (
  id serial primary key,
  title text not null,
  type text check (type in ('video', 'article', 'course')) not null,
  duration text,
  is_verified boolean default false,
  pathway_tag text not null,
  content_url text not null,
  created_at timestamp with time zone default now()
);
