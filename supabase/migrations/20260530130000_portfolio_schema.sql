-- Add portfolio highlight flag to skills
alter table public.skills
  add column is_highlighted boolean not null default false;

-- Public read policy for skills (mirrors projects table pattern)
drop policy if exists "Enable read access for all users" on public.skills;

create policy "Enable read access for all users"
    on public.skills
    for select
    to public
    using (true);

-- Public read policy for project_skills join table
drop policy if exists "Enable read access for all users" on public.project_skills;

create policy "Enable read access for all users"
    on public.project_skills
    for select
    to public
    using (true);

-- Featured projects: curated showcase with portfolio-specific copy
create table public.featured_projects
(
    id            uuid primary key     default gen_random_uuid(),
    project_id    uuid        not null unique
        references public.projects (id) on delete cascade,
    tagline       text        not null,
    display_order smallint    not null default 1,
    created_at    timestamptz not null default now(),
    updated_at    timestamptz not null default now()
);

alter table public.featured_projects enable row level security;

create policy "Enable read access for all users"
    on public.featured_projects
    for select
    to public
    using (true);
