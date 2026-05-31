begin;

select plan(9);

-- The test user (id = '3a455a9e-...') is created by supabase/seeds/05_test_users.sql.
-- Seeds are applied during db:reset before tests run.
do $$
begin
    if not exists (select 1 from auth.users where id = '3a455a9e-9a96-4fa1-aef9-8591690084e6') then
        raise exception 'Test user not found — run pnpm run db:reset to apply seeds before running tests';
    end if;
end;
$$;

-- Insert a test article as superuser (bypasses RLS)
insert into public.articles (title, slug, content, author)
values ('Trigger Test Article', 'trigger-test-article', 'Content for trigger test', '3a455a9e-9a96-4fa1-aef9-8591690084e6');

-- INSERT should create an audit log entry
select ok(
    (select count(*) = 1
     from public.article_audit_log
     where operation = 'INSERT'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'INSERT on articles writes an audit log row with operation = INSERT'
);

select ok(
    (select old_data is null
     from public.article_audit_log
     where operation = 'INSERT'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'INSERT audit log row has null old_data'
);

select ok(
    (select new_data ->> 'slug' = 'trigger-test-article'
     from public.article_audit_log
     where operation = 'INSERT'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'INSERT audit log new_data contains the inserted row'
);

-- UPDATE should create an audit log entry
update public.articles
set title = 'Updated Title'
where slug = 'trigger-test-article';

select ok(
    (select count(*) = 1
     from public.article_audit_log
     where operation = 'UPDATE'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'UPDATE on articles writes an audit log row with operation = UPDATE'
);

select ok(
    (select old_data ->> 'title' = 'Trigger Test Article'
     from public.article_audit_log
     where operation = 'UPDATE'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'UPDATE audit log old_data contains the previous title'
);

select ok(
    (select new_data ->> 'title' = 'Updated Title'
     from public.article_audit_log
     where operation = 'UPDATE'
       and new_data ->> 'slug' = 'trigger-test-article'),
    'UPDATE audit log new_data contains the updated title'
);

-- DELETE should create an audit log entry
delete
from public.articles
where slug = 'trigger-test-article';

select ok(
    (select count(*) = 1
     from public.article_audit_log
     where operation = 'DELETE'
       and old_data ->> 'slug' = 'trigger-test-article'),
    'DELETE on articles writes an audit log row with operation = DELETE'
);

select ok(
    (select new_data is null
     from public.article_audit_log
     where operation = 'DELETE'
       and old_data ->> 'slug' = 'trigger-test-article'),
    'DELETE audit log row has null new_data'
);

select ok(
    (select old_data ->> 'slug' = 'trigger-test-article'
     from public.article_audit_log
     where operation = 'DELETE'
       and old_data ->> 'slug' = 'trigger-test-article'),
    'DELETE audit log old_data contains the deleted row'
);

select * from finish();

rollback;
