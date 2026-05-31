begin;

select plan(6);

select has_table('public', 'article_audit_log', 'article_audit_log table exists');

select has_column('public', 'article_audit_log', 'id', 'has id column');
select has_column('public', 'article_audit_log', 'operation', 'has operation column');
select has_column('public', 'article_audit_log', 'old_data', 'has old_data column');
select has_column('public', 'article_audit_log', 'new_data', 'has new_data column');
select has_column('public', 'article_audit_log', 'changed_at', 'has changed_at column');

select * from finish();

rollback;
