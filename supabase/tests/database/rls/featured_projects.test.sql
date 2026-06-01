begin;

select plan(7);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'featured_projects'),
  'RLS is active on featured_projects'
);

insert into public.projects (id, name, description)
  values ('00000000-0000-0000-cccc-000000000001', 'RLS Test Project', 'Inserted by superuser for RLS verification');

insert into public.featured_projects (id, project_id, tagline)
  values ('00000000-0000-0000-cccc-000000000002', '00000000-0000-0000-cccc-000000000001', 'A tagline for RLS testing');

-- anon: can select, cannot insert
select tests.jwt_anon();
set local role anon;

select isnt_empty(
  $$ select * from public.featured_projects $$,
  'anon can select from featured_projects'
);

select throws_ok(
  $$ insert into public.featured_projects (project_id, tagline) values (gen_random_uuid(), 'blocked') $$,
  '42501',
  NULL,
  'anon cannot insert into featured_projects'
);

-- non-admin authenticated: cannot insert
set local role postgres;
select tests.jwt_authenticated();
set local role authenticated;

select throws_ok(
  $$ insert into public.featured_projects (project_id, tagline) values (gen_random_uuid(), 'blocked') $$,
  '42501',
  NULL,
  'non-admin cannot insert into featured_projects'
);

-- admin: can insert, update, delete
set local role postgres;
select tests.jwt_admin();
set local role authenticated;

select lives_ok(
  $$ insert into public.featured_projects (id, project_id, tagline, display_order)
     values ('00000000-0000-0000-cccc-000000000003', '00000000-0000-0000-cccc-000000000001', 'Admin tagline', 2) $$,
  'admin can insert into featured_projects'
);

select lives_ok(
  $$ update public.featured_projects set tagline = 'updated tagline' where id = '00000000-0000-0000-cccc-000000000003' $$,
  'admin can update featured_projects'
);

select lives_ok(
  $$ delete from public.featured_projects where id = '00000000-0000-0000-cccc-000000000003' $$,
  'admin can delete from featured_projects'
);

select * from finish();

rollback;
