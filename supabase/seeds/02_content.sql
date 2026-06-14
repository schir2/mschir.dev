insert into public.skill_categories (name, "order") values
                                                        ('Programming Languages', 1),
                                                        ('Frameworks and Libraries', 2),
                                                        ('Front-End Technologies', 3),
                                                        ('Databases', 4),
                                                        ('Other', 5)
on conflict (name) do nothing;


insert into public.skills (name, icon, proficiency, category_id, is_highlighted)
values
-- Expert
('Django',   'logos:django-icon',            'expert',       (select id from public.skill_categories where name = 'Frameworks and Libraries'), true),
('HTML',     'logos:html-5',                 'expert',       (select id from public.skill_categories where name = 'Front-End Technologies'),   true),
('Python',   'logos:python',                 'expert',       (select id from public.skill_categories where name = 'Programming Languages'),    true),
('Windows',  'logos:microsoft-windows-icon', 'expert',       (select id from public.skill_categories where name = 'Other'),                   false),

-- Advanced
('TypeScript', 'logos:typescript-icon',        'advanced', (select id from public.skill_categories where name = 'Programming Languages'),    true),
('VUE',        'logos:vue',                    'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries'), true),
('HubSpot',    'simple-icons:hubspot',         'advanced', (select id from public.skill_categories where name = 'Other'),                   true),
('Pinia',      'logos:pinia',                  'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries'), false),
('Bootstrap',  'logos:bootstrap',              'advanced', (select id from public.skill_categories where name = 'Front-End Technologies'),   false),
('CSS',        'logos:css-3',                  'advanced', (select id from public.skill_categories where name = 'Front-End Technologies'),   false),
('Figma',      'logos:figma',                  'advanced', (select id from public.skill_categories where name = 'Front-End Technologies'),   false),
('HTMX',       'simple-icons:htmx',           'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries'), false),
('MSSQL',      'simple-icons:microsoftsqlserver', 'advanced', (select id from public.skill_categories where name = 'Databases'),            false),
('MySQL',      'logos:mysql',                  'advanced', (select id from public.skill_categories where name = 'Databases'),               false),
('SQLite',     'logos:sqlite',                 'advanced', (select id from public.skill_categories where name = 'Databases'),               false),

-- Intermediate
('Nuxt',        'simple-icons:nuxtdotjs',  'intermediate', (select id from public.skill_categories where name = 'Frameworks and Libraries'), true),
('Postgres',    'logos:postgresql',        'intermediate', (select id from public.skill_categories where name = 'Databases'),               true),
('AWS',         'logos:aws',               'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('C#',          'logos:c-sharp',           'intermediate', (select id from public.skill_categories where name = 'Programming Languages'),    false),
('Digital Ocean','logos:digital-ocean',    'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Docker',      'logos:docker-icon',       'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Github',      'simple-icons:github',     'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Linux',       'logos:linux-tux',         'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('PHP',         'logos:php',               'intermediate', (select id from public.skill_categories where name = 'Programming Languages'),    false),
('REST',        'mdi:api',                 'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Supabase',    'logos:supabase-icon',     'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Web Scraping','mdi:spider-web',          'intermediate', (select id from public.skill_categories where name = 'Other'),                   false),
('Tailwind',    'logos:tailwindcss-icon',  'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies'),  false),
('Vuetify',     'simple-icons:vuetify',    'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies'),  false),
('Pydantic AI', 'simple-icons:pydantic',   'intermediate', (select id from public.skill_categories where name = 'Frameworks and Libraries'), false),
('PrimeVue',    'simple-icons:primevue',   'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies'),  false),
('Zod',         'mdi:shield-check',        'intermediate', (select id from public.skill_categories where name = 'Frameworks and Libraries'), false),
('Naive UI',    'logos:naive-ui',          'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies'),  false),

-- Beginner
('Flask',   'logos:flask',      'beginner', (select id from public.skill_categories where name = 'Frameworks and Libraries'), false),
('GraphQL', 'logos:graphql',    'beginner', (select id from public.skill_categories where name = 'Databases'),               false),
('JS',      'logos:javascript', 'beginner', (select id from public.skill_categories where name = 'Programming Languages'),    false),
('Chart.js','logos:chartjs',    'beginner', (select id from public.skill_categories where name = 'Front-End Technologies'),  false)
on conflict (name) do update set is_highlighted = excluded.is_highlighted;


-- Companies
insert into public.companies (name, "url") values
    ('MMPC', 'https://www.mandmpestcontrol.com')
on conflict (name) do nothing;

insert into public.companies (name, "url") values
    ('Green Orchard Group', null)
on conflict (name) do nothing;
