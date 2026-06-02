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
('Django', 'logos:django-icon', 'expert', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('HTML', 'logos:html-5', 'expert', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Python', 'logos:python', 'expert', (select id from public.skill_categories where name = 'Programming Languages')),
('Windows', 'logos:microsoft-windows-icon', 'expert', (select id from public.skill_categories where name = 'Other')),

-- Advanced
('TypeScript', 'logos:typescript-icon', 'advanced', (select id from public.skill_categories where name = 'Programming Languages')),
('Bootstrap', 'logos:bootstrap', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('CSS', 'logos:css-3', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Figma', 'logos:figma', 'advanced', (select id from public.skill_categories where name = 'Front-End Technologies')),
('HTMX', 'simple-icons:htmx', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('MSSQL', 'simple-icons:microsoftsqlserver', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('MySQL', 'logos:mysql', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('SQLite', 'logos:sqlite', 'advanced', (select id from public.skill_categories where name = 'Databases')),
('VUE', 'logos:vue', 'advanced', (select id from public.skill_categories where name = 'Frameworks and Libraries')),

-- Intermediate
('AWS', 'logos:aws', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('C#', 'logos:c-sharp', 'intermediate', (select id from public.skill_categories where name = 'Programming Languages')),
('Digital Ocean', 'logos:digital-ocean', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Docker', 'logos:docker-icon', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Github', 'simple-icons:github', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Linux', 'logos:linux-tux', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Nuxt', 'simple-icons:nuxtdotjs', 'intermediate', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('PHP', 'logos:php', 'intermediate', (select id from public.skill_categories where name = 'Programming Languages')),
('Postgres', 'logos:postgresql', 'intermediate', (select id from public.skill_categories where name = 'Databases')),
('REST', 'mdi:api', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Supabase', 'logos:supabase-icon', 'intermediate', (select id from public.skill_categories where name = 'Other')),
('Tailwind', 'logos:tailwindcss-icon', 'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies')),
('Vuetify', 'simple-icons:vuetify', 'intermediate', (select id from public.skill_categories where name = 'Front-End Technologies')),

-- Beginner
('Flask', 'logos:flask', 'beginner', (select id from public.skill_categories where name = 'Frameworks and Libraries')),
('GraphQL', 'logos:graphql', 'beginner', (select id from public.skill_categories where name = 'Databases')),
('JS', 'logos:javascript', 'beginner', (select id from public.skill_categories where name = 'Programming Languages'))
on conflict (name) do nothing;


-- Companies
insert into public.companies (name, "url") values
    ('MMPC', 'https://www.mandmpestcontrol.com')
on conflict (name) do nothing;

