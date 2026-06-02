-- Add slug (NOT NULL UNIQUE) and summary (nullable text) to projects.
-- Slug is generated in the frontend on creation and is freely editable (no lock policy).

-- Step 1: add slug as nullable so existing rows are not rejected
alter table public.projects
  add column slug text,
  add column summary text;

-- Step 2: back-fill slug from name for any existing rows
update public.projects
set slug = regexp_replace(
  trim(
    both '-' from
    regexp_replace(
      lower(regexp_replace(name, '[^\w\s-]', '', 'gi')),
      '\s+', '-', 'g'
    )
  ),
  '-+', '-', 'g'
)
where slug is null;

-- Step 3: enforce NOT NULL and uniqueness
alter table public.projects
  alter column slug set not null,
  add constraint projects_slug_key unique (slug);
