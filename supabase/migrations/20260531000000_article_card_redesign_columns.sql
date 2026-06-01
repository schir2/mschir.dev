alter table public.articles
    add column summary text;

alter table public.article_categories
    add column color       varchar,
    add column image_url   text;

alter table public.article_series
    add column image_url text;
