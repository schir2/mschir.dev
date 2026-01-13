insert into public.article_tags (name, slug)
values ('Python', 'python'),
       ('Django', 'django'),
       ('Algorithms', 'algorithms'),
       ('Data Structures', 'data-structures'),
       ('REST API', 'rest-api'),
       ('Design Patterns', 'design-patterns'),
       ('Code Optimization', 'code-optimization'),
       ('HTML', 'html'),
       ('CSS', 'css'),
       ('JavaScript', 'javascript'),
       ('React', 'react'),
       ('Vue.js', 'vue.js'),
       ('Tailwind CSS', 'tailwind-css'),
       ('Responsive Design', 'responsive-design'),
       ('Machine Learning', 'machine-learning'),
       ('Data Visualization', 'data-visualization'),
       ('Pandas', 'pandas'),
       ('NumPy', 'numpy'),
       ('Scikit-Learn', 'scikit-learn'),
       ('Matplotlib', 'matplotlib'),
       ('CI/CD', 'ci-cd'),
       ('Docker', 'docker'),
       ('Kubernetes', 'kubernetes'),
       ('Ansible', 'ansible'),
       ('Terraform', 'terraform'),
       ('Cloud', 'cloud'),
       ('Jenkins', 'jenkins'),
       ('Networking', 'networking'),
       ('Firewalls', 'firewalls'),
       ('VPN', 'vpn'),
       ('Security', 'security'),
       ('Linux', 'linux'),
       ('Windows Server', 'windows-server'),
       ('Troubleshooting', 'troubleshooting'),
       ('IT Support', 'it-support'),
       ('Helpdesk', 'helpdesk'),
       ('SysAdmin', 'sysadmin'),
       ('Scripting', 'scripting'),
       ('Bouldering', 'bouldering'),
       ('Sport Climbing', 'sport-climbing'),
       ('Trad Climbing', 'trad-climbing'),
       ('Training', 'training'),
       ('Gear Reviews', 'gear-reviews'),
       ('Marathon', 'marathon'),
       ('5K', '5k'),
       ('10K', '10k'),
       ('Training Plans', 'training-plans'),
       ('Gear', 'gear'),
       ('Trail Running', 'trail-running'),
       ('Strength Training', 'strength-training'),
       ('Flexibility', 'flexibility'),
       ('Cardio', 'cardio'),
       ('HIIT', 'hiit'),
       ('Yoga', 'yoga');

insert into public.article_topics (name, slug, description)
values ('Software Development',
        'software-development',
        'Articles about programming concepts, software design patterns, tutorials, and code samples.'),
       ('Web Development',
        'web-development',
        'Focused on frontend and backend web development, covering topics like HTML, CSS, JavaScript, Django, and APIs.'),
       ('Data Science & Analytics',
        'data-science-analytics',
        'Data analysis, machine learning, and insights on handling and visualizing data with Python or other tools.'),
       ('DevOps & Automation',
        'devops-automation',
        'Content on CI/CD, Docker, Kubernetes, server automation, and configuration management.'),
       ('IT Infrastructure',
        'it-infrastructure',
        'Topics on networking, servers, security, and infrastructure management.'),
       ('IT Operations & Support',
        'it-operations-support',
        'Day-to-day IT operations, troubleshooting, and support tips for both on-premises and cloud systems.'),
       ('Climbing',
        'climbing',
        'Personal experiences, climbing techniques, training tips, and gear recommendations for bouldering and climbing.'),
       ('Running',
        'running',
        'Articles covering running routines, training plans, race experiences, and gear reviews.'),
       ('Fitness',
        'fitness',
        'General fitness tips, strength training routines, flexibility exercises, and maintaining overall health.');


insert into public.skill_categories (name, "order") values
                                                        ('Programming Languages', 1),
                                                        ('Frameworks and Libraries', 2),
                                                        ('Front-End Technologies', 3),
                                                        ('Databases', 4),
                                                        ('Other', 5)
on conflict (name) do nothing;


insert into public.skills (name, icon, proficiency, category_id)
values

('Django', 'simple-icons:django', 'expert', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('HTML', 'simple-icons:html5', 'expert', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Python', 'simple-icons:python', 'expert', (select id from public.skill_categories where name = 'Programming Languages')),
('Windows', 'simple-icons:windows', 'expert', (select id from public.skill_categories where name = 'Other')),
('Bootstrap', 'simple-icons:bootstrap', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('CSS', 'simple-icons:css3', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Figma', 'simple-icons:figma', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('HTMX', 'simple-icons:htmx', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('MSSQL', 'simple-icons:microsoftsqlserver', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('MySQL', 'simple-icons:mysql', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('SQLite', 'simple-icons:sqlite', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('VUE', 'simple-icons:vuedotjs', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('AWS', 'simple-icons:amazonaws', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('C#', 'simple-icons:csharp', 'intermediate', (select id from public.skill_categories where name = 'Programming Languages')),
('Digital Ocean', 'simple-icons:digitalocean', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Github', 'simple-icons:github', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Linux', 'simple-icons:linux', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Nuxt3', 'simple-icons:nuxtdotjs', 'intermediate', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('PHP', 'simple-icons:php', 'intermediate', (select id from public.skill_categories where name = 'Programming Languages')),
('Postgres', 'simple-icons:postgresql', 'intermediate', (select id from public.skill_categories where name = 'Databases')),
('REST', 'mdi:api', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Tailwind', 'simple-icons:tailwindcss', 'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Vuetify', 'simple-icons:vuetify', 'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Flask', 'simple-icons:flask', 'beginner', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('GraphQL', 'simple-icons:graphql', 'beginner', (select id from public.skill_categories where name = 'Databases')),
('JS', 'simple-icons:javascript', 'beginner', (select id from public.skill_categories where name = 'Programming Languages'))
on conflict (name) do nothing;


--
-- -- Companies
insert into public.companies (name, "url")
values
    ('MMPC', 'https://www.mandmpestcontrol.com');

insert into public.projects (name, description, company_id, year, image_url)
values
    (
        'Customer Quoting Application',
        'Internal application for generating and managing customer quotes.',

        (select id from public.companies where name = 'MMPC'),
        2024,
        null
    ),
    (
        'Lead Analyzer Reporting Platform',
        'Reporting and analytics platform for inbound leads.',
        (select id from public.companies where name = 'MMPC'),
        2023,
        null
    ),
    (
        'Vehicle GPS Alerting System for Field Service Workers',
        'GPS-based alerting system for tracking and monitoring field technicians.',
        (select id from public.companies where name = 'MMPC'),
        2022,
        null
    ),
    (
        'Field Service Management API',
        'API services supporting field service operations.',
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Visual Lead Inspection Job Tracking System',
        'Job tracking system with visual inspection workflows.',
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Field Service Management System Extension',
        'Extensions and customizations for the field service management platform.',
        (select id from public.companies where name = 'MMPC'),
        2017,
        null
    ),
    (
        'Automated User Lookup and Reporting System',
        'Automated reporting and user lookup tools.',
        (select id from public.companies where name = 'MMPC'),
        2009,
        null
    )
;


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
