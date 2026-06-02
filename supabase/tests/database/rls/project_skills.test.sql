begin;

select plan(6);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'project_skills'),
  'RLS is active on project_skills'
);

insert into public.projects (id, name, description, slug)
  values ('00000000-0000-0000-dddd-000000000001', 'RLS Test Project', 'Inserted by superuser for RLS verification', 'rls-test-project-dddd');

insert into public.skill_categories (id, name)
  values ('00000000-0000-0000-dddd-000000000002', 'RLS Test Category');

insert into public.skills (id, name, category_id)
  values ('00000000-0000-0000-dddd-000000000003', 'RLS Test Skill', '00000000-0000-0000-dddd-000000000002');

insert into public.project_skills (project_id, skill_id)
  values ('00000000-0000-0000-dddd-000000000001', '00000000-0000-0000-dddd-000000000003');

-- anon: can select, cannot insert
select tests.jwt_anon();
set local role anon;

select isnt_empty(
  $$ select * from public.project_skills $$,
  'anon can select from project_skills'
);

select throws_ok(
  $$ insert into public.project_skills (project_id, skill_id) values (gen_random_uuid(), gen_random_uuid()) $$,
  '42501',
  NULL,
  'anon cannot insert into project_skills'
);

-- non-admin authenticated: cannot insert
set local role postgres;
select tests.jwt_authenticated();
set local role authenticated;

select throws_ok(
  $$ insert into public.project_skills (project_id, skill_id) values (gen_random_uuid(), gen_random_uuid()) $$,
  '42501',
  NULL,
  'non-admin cannot insert into project_skills'
);

-- admin: can insert and delete
set local role postgres;
select tests.jwt_admin();
set local role authenticated;

select lives_ok(
  $$ delete from public.project_skills
     where project_id = '00000000-0000-0000-dddd-000000000001'
       and skill_id   = '00000000-0000-0000-dddd-000000000003' $$,
  'admin can delete from project_skills'
);

select lives_ok(
  $$ insert into public.project_skills (project_id, skill_id)
     values ('00000000-0000-0000-dddd-000000000001', '00000000-0000-0000-dddd-000000000003') $$,
  'admin can insert into project_skills'
);

select * from finish();

rollback;
