-- RLS policies for skills and skill_categories
-- Both tables had RLS enabled but zero policies, blocking all reads.

-- ──────────────────────────────────────────────
-- skill_categories
-- ──────────────────────────────────────────────
drop policy if exists "Public can read skill categories" on public.skill_categories;
drop policy if exists "Admin can insert skill categories" on public.skill_categories;
drop policy if exists "Admin can update skill categories" on public.skill_categories;
drop policy if exists "Admin can delete skill categories" on public.skill_categories;

create policy "Public can read skill categories"
    on public.skill_categories for select to public
    using (true);

create policy "Admin can insert skill categories"
    on public.skill_categories for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update skill categories"
    on public.skill_categories for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete skill categories"
    on public.skill_categories for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ──────────────────────────────────────────────
-- skills
-- ──────────────────────────────────────────────
drop policy if exists "Public can read skills" on public.skills;
drop policy if exists "Admin can insert skills" on public.skills;
drop policy if exists "Admin can update skills" on public.skills;
drop policy if exists "Admin can delete skills" on public.skills;

create policy "Public can read skills"
    on public.skills for select to public
    using (true);

create policy "Admin can insert skills"
    on public.skills for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update skills"
    on public.skills for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete skills"
    on public.skills for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
