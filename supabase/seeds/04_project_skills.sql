insert into public.project_skills (project_id, skill_id)
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Customer Quoting Application (Vue/Nuxt present — JS dropped)
                                            'Django', 'Python', 'Figma', 'SQLite', 'VUE', 'Nuxt', 'REST', 'Vuetify'
    )
where p.name = 'Customer Quoting Application'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Lead Analyzer Reporting Platform (HTMX present — JS dropped)
                                            'Django', 'Python', 'Figma', 'HTMX', 'Digital Ocean', 'Postgres'
    )
where p.name = 'Lead Analyzer Reporting Platform'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Vehicle GPS Alerting System (PHP/vanilla JS — no framework, JS kept)
                                            'MSSQL', 'MySQL', 'Linux', 'PHP', 'JS'
    )
where p.name = 'Vehicle GPS Alerting System for Field Service Workers'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Field Service Management API
                                            'Python', 'MSSQL', 'Linux', 'REST', 'Flask'
    )
where p.name = 'Field Service Management API'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Visual Lead Inspection Job Tracking System (Django present — JS dropped)
                                            'Django', 'Python', 'Digital Ocean', 'Linux', 'Postgres'
    )
where p.name = 'Visual Lead Inspection Job Tracking System'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Field Service Management System Extension (Django/HTMX present — JS dropped)
                                            'Django', 'Python', 'Windows', 'Bootstrap', 'Figma', 'HTMX',
                                            'MSSQL', 'MySQL', 'SQLite', 'Linux'
    )
where p.name = 'Field Service Management System Extension'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Automated User Lookup and Reporting System
                                            'Python', 'MSSQL', 'MySQL'
    )
where p.name = 'Automated User Lookup and Reporting System'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Arcus
                                            'Nuxt', 'VUE', 'TypeScript', 'Tailwind', 'Supabase', 'Postgres'
    )
where p.name = 'Arcus'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Calcura
                                            'Nuxt', 'VUE', 'TypeScript', 'Tailwind', 'Django', 'Python', 'REST', 'Postgres'
    )
where p.name = 'Calcura'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- EPA Pesticide Registry Scraper
                                            'Python', 'Web Scraping'
    )
where p.name = 'EPA Pesticide Registry Scraper'

on conflict do nothing;