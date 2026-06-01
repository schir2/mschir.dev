begin;

select plan(7);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'companies'),
  'RLS is active on companies'
);

insert into public.companies (id, name)
  values ('00000000-0000-0000-eeee-000000000001', 'RLS Test Company');

-- anon: can select, cannot insert
select tests.jwt_anon();
set local role anon;

select isnt_empty(
  $$ select * from public.companies $$,
  'anon can select from companies'
);

select throws_ok(
  $$ insert into public.companies (name) values ('Blocked') $$,
  '42501',
  NULL,
  'anon cannot insert into companies'
);

-- non-admin authenticated: cannot insert
set local role postgres;
select tests.jwt_authenticated();
set local role authenticated;

select throws_ok(
  $$ insert into public.companies (name) values ('Blocked') $$,
  '42501',
  NULL,
  'non-admin cannot insert into companies'
);

-- admin: can insert, update, delete
set local role postgres;
select tests.jwt_admin();
set local role authenticated;

select lives_ok(
  $$ insert into public.companies (id, name) values ('00000000-0000-0000-eeee-000000000002', 'Admin Company') $$,
  'admin can insert into companies'
);

select lives_ok(
  $$ update public.companies set name = 'Admin Company Updated' where id = '00000000-0000-0000-eeee-000000000002' $$,
  'admin can update companies'
);

select lives_ok(
  $$ delete from public.companies where id = '00000000-0000-0000-eeee-000000000002' $$,
  'admin can delete from companies'
);

select * from finish();

rollback;
