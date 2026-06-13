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
        (select id from public.projects where name = 'Recurring Service Quoting Portal'),
        'End-to-end quoting workflow that cut sales turnaround time in half.',
        1
    ),
    (
        (select id from public.projects where name = 'NYCHA XRF Lead Inspection and Reporting Platform'),
        'Cut NYCHA lead inspection reporting from three hours to three minutes on a $5M contract.',
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
    ),
    (
        (select id from public.projects where name = 'MM Portal'),
        'Built on top of a 2007-era field service system, now the operations hub for 50-plus daily users at M&M Environmental, with GPS routing and an AI pipeline connecting calls and job data to HubSpot.',
        6
    )
on conflict (project_id) do nothing;
