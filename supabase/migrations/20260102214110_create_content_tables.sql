-- --------------------
-- companies
-- --------------------
create table public.companies
(
    id   uuid primary key default gen_random_uuid(),
    name varchar(255) not null,
    url  text
);

create index idx_companies_name on public.companies (name);

-- --------------------
-- contact_messages
-- --------------------
create table public.contact_messages
(
    id         uuid primary key      default gen_random_uuid(),
    name       varchar(100) not null,
    email      varchar(255) not null,
    subject    varchar(100) not null,
    message    text         not null,

    created_at timestamptz  not null default now()
);

create index idx_contact_messages_created_at
    on public.contact_messages (created_at desc);

-- --------------------
-- skill_categories
-- --------------------
create table public.skill_categories
(
    id      uuid primary key      default gen_random_uuid(),
    name    varchar(100) not null,
    icon    text,
    "order" smallint     not null default 1,
    constraint unique_skill_category_name unique (name)
);

create index idx_skill_categories_order
    on public.skill_categories ("order");


create type skill_proficiency as enum (
    'beginner',
    'intermediate',
    'advanced',
    'expert'
    );

-- --------------------
-- skills
-- --------------------
create table public.skills
(
    id          uuid primary key           default gen_random_uuid(),
    name        varchar(255)      not null,
    icon        text,
    proficiency skill_proficiency not null default 'intermediate',
    category_id uuid references public.skill_categories (id) on delete cascade,
    constraint unique_skill_name unique (name)
);

create index idx_skills_category on public.skills (category_id);
create index idx_skills_proficiency on public.skills (proficiency);

-- --------------------
-- projects
-- --------------------
create table public.projects
(
    id          uuid primary key      default gen_random_uuid(),
    name        varchar(255) not null,
    description text         not null,
    company_id  uuid         references public.companies (id) on delete set null,
    year        smallint     not null default extract(year from now()),
    image_url   text
);

create index idx_projects_year on public.projects (year);
create index idx_projects_company on public.projects (company_id);

-- --------------------
-- project_skills (M2M)
-- --------------------
create table public.project_skills
(
    project_id uuid not null references public.projects (id) on delete cascade,
    skill_id   uuid not null references public.skills (id) on delete cascade,

    primary key (project_id, skill_id)
);

alter table public.contact_messages enable row level security;
alter table public.projects enable row level security;
alter table public.project_skills enable row level security;
alter table public.companies enable row level security;
alter table public.skills enable row level security;
alter table public.skill_categories enable row level security;