-- Public read access for featured_articles (mirrors featured_projects pattern)
create policy "Enable read access for all users"
    on public.featured_articles
    for select
    to public
    using (true);
