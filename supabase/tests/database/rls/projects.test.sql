begin;

select plan(7);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'projects'),
  'RLS is active on projects'
);

insert into public.projects (id, name, description)
  values ('00000000-0000-0000-bbbb-000000000001', 'RLS Test Project', 'Inserted by superuser for RLS verification');

-- anon: can select, cannot insert
select tests.jwt_anon();
set local role anon;

select isnt_empty(
  $$ select * from public.projects $$,
  'anon can select from projects'
);

select throws_ok(
  $$ insert into public.projects (name, description) values ('Blocked', 'Should fail') $$,
  '42501',
  NULL,
  'anon cannot insert into projects'
);

-- non-admin authenticated: cannot insert
set local role postgres;
select tests.jwt_authenticated();
set local role authenticated;

select throws_ok(
  $$ insert into public.projects (name, description) values ('Blocked', 'Should fail') $$,
  '42501',
  NULL,
  'non-admin cannot insert into projects'
);

-- admin: can insert, update, delete
set local role postgres;
select tests.jwt_admin();
set local role authenticated;

select lives_ok(
  $$ insert into public.projects (id, name, description) values ('00000000-0000-0000-bbbb-000000000002', 'Admin Insert', 'inserted by admin') $$,
  'admin can insert into projects'
);

select lives_ok(
  $$ update public.projects set description = 'updated by admin' where id = '00000000-0000-0000-bbbb-000000000002' $$,
  'admin can update projects'
);

select lives_ok(
  $$ delete from public.projects where id = '00000000-0000-0000-bbbb-000000000002' $$,
  'admin can delete from projects'
);

select * from finish();

rollback;
