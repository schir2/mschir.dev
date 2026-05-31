-- ============================================================
-- Articles
-- ============================================================

-- Public can read published articles
create policy "Public can read published articles"
    on public.articles
    for select
    to public
    using (is_published = true);

-- Admin can read all articles (including drafts)
create policy "Admin can read all articles"
    on public.articles
    for select
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can insert articles"
    on public.articles
    for insert
    to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update articles"
    on public.articles
    for update
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete articles"
    on public.articles
    for delete
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ============================================================
-- Article Topics (reference data — public read, admin write)
-- ============================================================

create policy "Public can read article topics"
    on public.article_topics
    for select
    to public
    using (true);

create policy "Admin can insert article topics"
    on public.article_topics
    for insert
    to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article topics"
    on public.article_topics
    for update
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article topics"
    on public.article_topics
    for delete
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ============================================================
-- Article Tags (reference data — public read, admin write)
-- ============================================================

create policy "Public can read article tags"
    on public.article_tags
    for select
    to public
    using (true);

create policy "Admin can insert article tags"
    on public.article_tags
    for insert
    to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article tags"
    on public.article_tags
    for update
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article tags"
    on public.article_tags
    for delete
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ============================================================
-- Article Series (reference data — public read, admin write)
-- ============================================================

create policy "Public can read article series"
    on public.article_series
    for select
    to public
    using (true);

create policy "Admin can insert article series"
    on public.article_series
    for insert
    to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article series"
    on public.article_series
    for update
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article series"
    on public.article_series
    for delete
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ============================================================
-- Article Tags Links (admin read/write)
-- ============================================================

create policy "Public can read article tags links"
    on public.article_tags_links
    for select
    to public
    using (true);

create policy "Admin can insert article tags links"
    on public.article_tags_links
    for insert
    to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article tags links"
    on public.article_tags_links
    for delete
    to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
