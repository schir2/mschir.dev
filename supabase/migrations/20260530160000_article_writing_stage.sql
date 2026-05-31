create type writing_stage as enum ('idea', 'outline', 'draft', 'ready');

alter table public.articles
    add column writing_stage writing_stage not null default 'idea',
    add column published_at  timestamptz,
    add column archived_at   timestamptz;

-- Migrate existing rows: published articles get published_at = created_at (best approximation)
-- and writing_stage = 'ready'; unpublished articles become drafts.
update public.articles set published_at = created_at, writing_stage = 'ready' where is_published = true;
update public.articles set writing_stage = 'draft' where is_published = false;

-- Replace the is_published-based RLS policy with the timestamp-based equivalent.
drop policy "Public can read published articles" on public.articles;

create policy "Public can read published articles"
    on public.articles
    for select
    to public
    using (published_at is not null);

alter table public.articles
    drop column is_published;

create index idx_articles_published_at on public.articles (published_at);