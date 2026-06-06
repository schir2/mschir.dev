-- =============================================================
-- Storage buckets
-- =============================================================

insert into storage.buckets (id, name, public, allowed_mime_types)
values
    ('icons',  'icons',  true, array['image/svg+xml', 'image/png', 'image/jpeg']),
    ('images', 'images', true, array['image/png', 'image/jpeg', 'image/webp'])
on conflict (id) do nothing;


-- =============================================================
-- Icons bucket policies
-- =============================================================

create policy "Public read on icons"
    on storage.objects for select
    using (bucket_id = 'icons');

create policy "Admin insert on icons"
    on storage.objects for insert to authenticated
    with check (
        bucket_id = 'icons' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

create policy "Admin update on icons"
    on storage.objects for update to authenticated
    using (
        bucket_id = 'icons' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    )
    with check (
        bucket_id = 'icons' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

create policy "Admin delete on icons"
    on storage.objects for delete to authenticated
    using (
        bucket_id = 'icons' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );


-- =============================================================
-- Images bucket policies
-- =============================================================

create policy "Public read on images"
    on storage.objects for select
    using (bucket_id = 'images');

create policy "Admin insert on images"
    on storage.objects for insert to authenticated
    with check (
        bucket_id = 'images' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

create policy "Admin update on images"
    on storage.objects for update to authenticated
    using (
        bucket_id = 'images' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    )
    with check (
        bucket_id = 'images' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

create policy "Admin delete on images"
    on storage.objects for delete to authenticated
    using (
        bucket_id = 'images' and
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );
