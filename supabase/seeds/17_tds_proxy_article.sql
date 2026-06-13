-- Draft article idea: TDS protocol internals from building the SQL Server connection proxy

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000021',
    'TDS from the Inside: Reverse-Engineering SQL Server''s Wire Protocol',
    'tds-from-the-inside-reverse-engineering-sql-servers-wire-protocol',
    '',
    '',
    (select id from public.article_categories where slug = 'software-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'idea',
    null,
    now(),
    now()
);
