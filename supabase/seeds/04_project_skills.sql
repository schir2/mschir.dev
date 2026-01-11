insert into public.project_skills (project_id, skill_id)
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Customer Quoting Application
                                            'Django', 'HTML', 'Python', 'CSS', 'Figma', 'SQLite', 'VUE', 'Nuxt3', 'REST', 'Vuetify', 'JS'
    )
where p.name = 'Customer Quoting Application'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Lead Analyzer Reporting Platform
                                            'Django', 'HTML', 'Python', 'CSS', 'Figma', 'HTMX', 'Digital Ocean', 'Postgres', 'JS'
    )
where p.name = 'Lead Analyzer Reporting Platform'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Vehicle GPS Alerting System
                                            'HTML', 'CSS', 'MSSQL', 'MySQL', 'Linux', 'PHP', 'JS'
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
    -- Visual Lead Inspection Job Tracking System
                                            'Django', 'HTML', 'Python', 'CSS', 'Digital Ocean', 'Linux', 'Postgres', 'JS'
    )
where p.name = 'Visual Lead Inspection Job Tracking System'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Field Service Management System Extension
                                            'Django', 'HTML', 'Python', 'Windows', 'Bootstrap', 'CSS', 'Figma', 'HTMX',
                                            'MSSQL', 'MySQL', 'SQLite', 'Linux', 'JS'
    )
where p.name = 'Field Service Management System Extension'

union all
select
    p.id,
    s.id
from public.projects p
         join public.skills s on s.name in (
    -- Automated User Lookup and Reporting System
                                            'HTML', 'Python', 'CSS', 'MSSQL', 'MySQL'
    )
where p.name = 'Automated User Lookup and Reporting System'

on conflict do nothing;
