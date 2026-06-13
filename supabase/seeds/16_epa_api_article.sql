-- Idea: building a clean API on top of a scraped government portal (inspired by the EPA PPLS scraper)

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000020',
    'Building a Clean API on Top of a Government Portal',
    'building-a-clean-api-on-top-of-a-government-portal',
    '',
    null,
    (select id from public.article_categories where slug = 'software-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'idea',
    null,
    now(),
    now()
);
