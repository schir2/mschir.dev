insert into public.project_skills (project_id, skill_id)
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Recurring Service Quoting Portal
                                            'Django', 'Python', 'HTMX', 'VUE', 'HubSpot', 'Docker', 'Nuxt', 'Tailwind', 'Vuetify'
    )
where p.name = 'Recurring Service Quoting Portal'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- NYCHA XRF Lead Inspection and Reporting Platform
                                            'Django', 'Python', 'HTMX', 'Bootstrap'
    )
where p.name = 'NYCHA XRF Lead Inspection and Reporting Platform'

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
    -- MM Portal
                                            'Django', 'Python', 'Bootstrap', 'HTMX', 'MySQL', 'MSSQL',
                                            'Linux', 'REST', 'Web Scraping', 'HubSpot', 'Pydantic AI'
    )
where p.name = 'MM Portal'

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

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- SQL Server Connection Proxy
                                            'Python', 'Docker', 'MSSQL'
    )
where p.name = 'SQL Server Connection Proxy'

on conflict do nothing;