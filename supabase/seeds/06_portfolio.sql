-- Mark highlighted skills for the portfolio snapshot
update public.skills
set is_highlighted = true
where name in (
    'Python',
    'Django',
    'VUE',
    'Nuxt',
    'Postgres',
    'Tailwind',
    'HTMX',
    'HTML',
    'CSS',
    'REST'
);

-- Featured projects for the portfolio showcase
insert into public.featured_projects (project_id, tagline, display_order)
values
    (
        (select id from public.projects where name = 'Customer Quoting Application'),
        'End-to-end quoting workflow that cut sales turnaround time in half.',
        1
    ),
    (
        (select id from public.projects where name = 'Lead Analyzer Reporting Platform'),
        'Analytics platform that gave the sales team real-time visibility into inbound leads.',
        2
    ),
    (
        (select id from public.projects where name = 'Vehicle GPS Alerting System for Field Service Workers'),
        'Real-time GPS alerting system keeping field technicians safe and accountable.',
        3
    ),
    (
        (select id from public.projects where name = 'Arcus'),
        'Asana and Linear-inspired task manager built from the ground up with Nuxt, Supabase, and TypeScript.',
        4
    ),
    (
        (select id from public.projects where name = 'Calcura'),
        'Interactive retirement scenario simulator built with Nuxt, Naive UI, and Chart.js.',
        5
    )
on conflict (project_id) do nothing;
