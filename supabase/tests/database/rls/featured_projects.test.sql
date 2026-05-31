begin;

select plan(3);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'featured_projects'),
  'RLS is active on featured_projects'
);

-- Insert test data as postgres (superuser bypasses RLS)
insert into public.projects (name, description)
  values ('RLS Test Project', 'Inserted by superuser for RLS verification');

insert into public.featured_projects (project_id, tagline)
  select id, 'A tagline for RLS testing'
  from public.projects
  where name = 'RLS Test Project';

-- Switch to anonymous role for policy tests
set local role anon;

-- Public read policy allows anon SELECT
select isnt_empty(
  $$ select * from public.featured_projects $$,
  'anon can select from featured_projects'
);

-- No insert policy means anon INSERT is denied
select throws_ok(
  $$ insert into public.featured_projects (project_id, tagline) values (gen_random_uuid(), 'blocked') $$,
  '42501',
  NULL,
  'anon cannot insert into featured_projects'
);

select * from finish();

rollback;
