begin;

select plan(3);

select ok(
  (select rowsecurity from pg_tables
   where schemaname = 'public' and tablename = 'contact_reasons'),
  'RLS is active on contact_reasons'
);

-- Insert test data as postgres (superuser bypasses RLS)
insert into public.contact_reasons (label, "order")
  values ('RLS Test Reason', 99);

-- Switch to anonymous role for policy tests
set local role anon;

-- contact_reasons_public_read policy allows anon SELECT
select isnt_empty(
  $$ select * from public.contact_reasons $$,
  'anon can select from contact_reasons'
);

-- No insert policy means anon INSERT is denied
select throws_ok(
  $$ insert into public.contact_reasons (label, "order") values ('Blocked', 100) $$,
  '42501',
  NULL,
  'anon cannot insert into contact_reasons'
);

select * from finish();

rollback;
