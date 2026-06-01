begin;

select plan(4);

select ok(
    (select rowsecurity
     from pg_tables
     where schemaname = 'public'
       and tablename = 'article_audit_log'),
    'RLS is active on article_audit_log'
);

-- Insert test data as superuser (bypasses RLS)
insert into public.article_audit_log (operation, old_data, new_data)
values ('INSERT', null, '{"test": true}'::jsonb);

-- Anon cannot SELECT
select tests.jwt_anon();
set local role anon;

select throws_ok(
    $$ select * from public.article_audit_log $$,
    '42501',
    NULL,
    'anon cannot select from article_audit_log'
);

-- Non-admin authenticated user cannot SELECT
set local role postgres;
select tests.jwt_authenticated('00000000-0000-0000-0000-000000000001');
set local role authenticated;

select throws_ok(
    $$ select * from public.article_audit_log $$,
    '42501',
    NULL,
    'non-admin authenticated user cannot select from article_audit_log'
);

-- Admin user can SELECT
set local role postgres;
select tests.jwt_admin('00000000-0000-0000-0000-000000000002');
set local role authenticated;

select isnt_empty(
    $$ select * from public.article_audit_log $$,
    'admin user can select from article_audit_log'
);

select * from finish();

rollback;
