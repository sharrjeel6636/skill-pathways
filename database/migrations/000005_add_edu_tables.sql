-- 000005_add_edu_tables.sql

create table if not exists public.universities (
  id serial primary key,
  name text not null,
  city text not null,
  province text not null,
  description text,
  website_url text
);

create table if not exists public.scholarships (
  id serial primary key,
  title text not null,
  provider text not null,
  description text,
  eligibility_criteria text,
  deadline date,
  website_url text
);
