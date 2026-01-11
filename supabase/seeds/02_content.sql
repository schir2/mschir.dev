insert into public.skill_categories (name, "order") values
                                                        ('Programming Languages', 1),
                                                        ('Frameworks and Libraries', 2),
                                                        ('Front-End Technologies', 3),
                                                        ('Databases', 4),
                                                        ('Other', 5)
on conflict (name) do nothing;


insert into public.skills (name, icon, proficiency, category_id)
values
-- Expert
('Django', 'simple-icons:django', 'expert', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('HTML', 'simple-icons:html5', 'expert', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Python', 'simple-icons:python', 'expert', (select id from public.skill_categories where name = 'Programming Languages')),
('Windows', 'simple-icons:windows', 'expert', (select id from public.skill_categories where name = 'Other')),

-- Advanced
('Bootstrap', 'simple-icons:bootstrap', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('CSS', 'simple-icons:css3', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Figma', 'simple-icons:figma', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('HTMX', 'simple-icons:htmx', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('MSSQL', 'simple-icons:microsoftsqlserver', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('MySQL', 'simple-icons:mysql', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('SQLite', 'simple-icons:sqlite', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('VUE', 'simple-icons:vuedotjs', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),

-- Intermediate
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

-- Beginner
('Flask', 'simple-icons:flask', 'beginner', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('GraphQL', 'simple-icons:graphql', 'beginner', (select id from public.skill_categories where name = 'Databases')),
('JS', 'simple-icons:javascript', 'beginner', (select id from public.skill_categories where name = 'Programming Languages'))
on conflict (name) do nothing;


-- Companies
insert into public.companies (name, "url") values
    ('MMPC', 'https://www.mandmpestcontrol.com')
on conflict (name) do nothing;

