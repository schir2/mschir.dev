begin;

select plan(3);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'projects'),
  'RLS is active on projects'
);

-- Insert test data as postgres (superuser bypasses RLS)
insert into public.projects (name, description)
  values ('RLS Test Project', 'Inserted by superuser for RLS verification');

-- Switch to anonymous role for policy tests
set local role anon;

-- Public read policy allows anon SELECT
select isnt_empty(
  $$ select * from public.projects $$,
  'anon can select from projects'
);

-- No insert policy means anon INSERT is denied
select throws_ok(
  $$ insert into public.projects (name, description) values ('Blocked', 'Should fail') $$,
  '42501',
  NULL,
  'anon cannot insert into projects'
);

select * from finish();

rollback;
