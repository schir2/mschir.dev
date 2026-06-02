-- Admin write policies for featured_articles

create policy "admin can insert featured_articles"
    on public.featured_articles for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update featured_articles"
    on public.featured_articles for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete featured_articles"
    on public.featured_articles for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
