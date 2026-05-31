begin;

select plan(7);

select ok(
    (select rowsecurity from pg_tables
     where schemaname = 'public' and tablename = 'articles'),
    'RLS is active on articles'
);

insert into public.articles (id, title, slug, content, author, published_at, archived_at)
values
    ('00000000-0000-0000-aaaa-000000000001', 'Unpublished Article', 'unpublished-article', 'content', '3a455a9e-9a96-4fa1-aef9-8591690084e6', null, null),
    ('00000000-0000-0000-aaaa-000000000002', 'Published Article',   'published-article',   'content', '3a455a9e-9a96-4fa1-aef9-8591690084e6', now(), null),
    ('00000000-0000-0000-aaaa-000000000003', 'Archived Article',    'archived-article',    'content', '3a455a9e-9a96-4fa1-aef9-8591690084e6', now(), now());

select tests.jwt_anon();
set local role anon;

select is_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000001' $$,
    'anon cannot read unpublished article'
);

select isnt_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000002' $$,
    'anon can read published article'
);

select isnt_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000003' $$,
    'anon can read archived article'
);

set local role postgres;
select tests.jwt_admin('3a455a9e-9a96-4fa1-aef9-8591690084e6');
set local role authenticated;

select isnt_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000001' $$,
    'admin can read unpublished article'
);

select isnt_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000002' $$,
    'admin can read published article'
);

select isnt_empty(
    $$ select * from public.articles where id = '00000000-0000-0000-aaaa-000000000003' $$,
    'admin can read archived article'
);

select * from finish();

rollback;
