-- Admin write policies for projects, project_skills, featured_projects
-- Public SELECT + admin write policies for companies (currently has zero policies)

-- ──────────────────────────────────────────────
-- projects
-- ──────────────────────────────────────────────
drop policy if exists "admin can insert projects" on public.projects;
drop policy if exists "admin can update projects" on public.projects;
drop policy if exists "admin can delete projects" on public.projects;

create policy "admin can insert projects"
    on public.projects for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update projects"
    on public.projects for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete projects"
    on public.projects for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ──────────────────────────────────────────────
-- project_skills
-- ──────────────────────────────────────────────
drop policy if exists "admin can insert project_skills" on public.project_skills;
drop policy if exists "admin can delete project_skills" on public.project_skills;

create policy "admin can insert project_skills"
    on public.project_skills for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete project_skills"
    on public.project_skills for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ──────────────────────────────────────────────
-- featured_projects
-- ──────────────────────────────────────────────
drop policy if exists "admin can insert featured_projects" on public.featured_projects;
drop policy if exists "admin can update featured_projects" on public.featured_projects;
drop policy if exists "admin can delete featured_projects" on public.featured_projects;

create policy "admin can insert featured_projects"
    on public.featured_projects for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update featured_projects"
    on public.featured_projects for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete featured_projects"
    on public.featured_projects for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- ──────────────────────────────────────────────
-- companies (zero policies currently — reads are blocked)
-- ──────────────────────────────────────────────
drop policy if exists "Enable read access for all users" on public.companies;
drop policy if exists "admin can insert companies" on public.companies;
drop policy if exists "admin can update companies" on public.companies;
drop policy if exists "admin can delete companies" on public.companies;

create policy "Enable read access for all users"
    on public.companies for select to public
    using (true);

create policy "admin can insert companies"
    on public.companies for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update companies"
    on public.companies for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete companies"
    on public.companies for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
