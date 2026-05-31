begin;

select plan(3);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'skills'),
  'RLS is active on skills'
);

insert into public.skill_categories (name, "order") values ('Test Category', 99)
  on conflict (name) do nothing;

insert into public.skills (name, proficiency, category_id)
  values ('RLS Test Skill', 'intermediate', (select id from public.skill_categories where name = 'Test Category'));

set local role anon;

select isnt_empty(
  $$ select * from public.skills $$,
  'anon can select from skills'
);

select throws_ok(
  $$ insert into public.skills (name, proficiency) values ('Blocked', 'beginner') $$,
  '42501',
  NULL,
  'anon cannot insert into skills'
);

select * from finish();

rollback;
