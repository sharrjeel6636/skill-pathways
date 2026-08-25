-- Pathway Nodes
create table public.pathway_nodes (
  id serial primary key,
  pathway_id int references public.pathways not null,
  node_order int not null,
  title text not null,
  description text,
  resources jsonb, -- e.g., links, docs
  prerequisites int[] -- array of node_ids
);

-- User Node Progress
create table public.user_node_progress (
  id serial primary key,
  user_id uuid references auth.users not null,
  node_id int references public.pathway_nodes not null,
  status text check (status in ('locked', 'active', 'mastered')) default 'locked',
  updated_at timestamp with time zone default now()
);
