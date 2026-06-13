alter table public.projects
  alter column description drop not null,
  add column repo_url    text,
  add column project_url text,
  add column is_public   boolean not null default false;