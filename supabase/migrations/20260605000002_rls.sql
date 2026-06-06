-- =============================================================
-- Enable RLS on all tables
-- =============================================================

alter table public.article_categories    enable row level security;
alter table public.article_tags          enable row level security;
alter table public.article_series        enable row level security;
alter table public.articles              enable row level security;
alter table public.article_tags_links    enable row level security;
alter table public.comments              enable row level security;
alter table public.article_interactions  enable row level security;
alter table public.featured_articles     enable row level security;
alter table public.article_audit_log     enable row level security;

alter table public.companies             enable row level security;
alter table public.contact_reasons       enable row level security;
alter table public.contact_messages      enable row level security;
alter table public.skill_categories      enable row level security;
alter table public.skills                enable row level security;
alter table public.projects              enable row level security;
alter table public.project_skills        enable row level security;
alter table public.featured_projects     enable row level security;


-- =============================================================
-- Articles
-- =============================================================

create policy "Public can read published articles"
    on public.articles for select to public
    using (published_at is not null);

create policy "Admin can read all articles"
    on public.articles for select to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can insert articles"
    on public.articles for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update articles"
    on public.articles for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete articles"
    on public.articles for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Article categories
-- =============================================================

create policy "Public can read article categories"
    on public.article_categories for select to public
    using (true);

create policy "Admin can insert article categories"
    on public.article_categories for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article categories"
    on public.article_categories for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article categories"
    on public.article_categories for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Article tags
-- =============================================================

create policy "Public can read article tags"
    on public.article_tags for select to public
    using (true);

create policy "Admin can insert article tags"
    on public.article_tags for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article tags"
    on public.article_tags for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article tags"
    on public.article_tags for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Article series
-- =============================================================

create policy "Public can read article series"
    on public.article_series for select to public
    using (true);

create policy "Admin can insert article series"
    on public.article_series for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can update article series"
    on public.article_series for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article series"
    on public.article_series for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Article tag links
-- =============================================================

create policy "Public can read article tags links"
    on public.article_tags_links for select to public
    using (true);

create policy "Admin can insert article tags links"
    on public.article_tags_links for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin can delete article tags links"
    on public.article_tags_links for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Featured articles
-- =============================================================

create policy "Enable read access for all users"
    on public.featured_articles for select to public
    using (true);

create policy "admin can insert featured_articles"
    on public.featured_articles for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update featured_articles"
    on public.featured_articles for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete featured_articles"
    on public.featured_articles for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Article audit log
-- =============================================================

create policy "Admin can read audit log"
    on public.article_audit_log for select to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Companies
-- =============================================================

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


-- =============================================================
-- Contact reasons
-- =============================================================

create policy "contact_reasons_public_read"
    on public.contact_reasons for select to public
    using (true);


-- =============================================================
-- Contact messages
-- =============================================================

create policy "contact_messages_public_insert"
    on public.contact_messages for insert to public
    with check (true);

create policy "contact_messages_owner_select"
    on public.contact_messages for select to authenticated
    using (true);


-- =============================================================
-- Skill categories
-- =============================================================

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


-- =============================================================
-- Skills
-- =============================================================

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


-- =============================================================
-- Projects
-- =============================================================

create policy "Enable read access for all users"
    on public.projects for select to public
    using (true);

create policy "admin can insert projects"
    on public.projects for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update projects"
    on public.projects for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete projects"
    on public.projects for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Project skills
-- =============================================================

create policy "Enable read access for all users"
    on public.project_skills for select to public
    using (true);

create policy "admin can insert project_skills"
    on public.project_skills for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete project_skills"
    on public.project_skills for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');


-- =============================================================
-- Featured projects
-- =============================================================

create policy "Enable read access for all users"
    on public.featured_projects for select to public
    using (true);

create policy "admin can insert featured_projects"
    on public.featured_projects for insert to authenticated
    with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can update featured_projects"
    on public.featured_projects for update to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "admin can delete featured_projects"
    on public.featured_projects for delete to authenticated
    using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
