-- =============================================================
-- Types (enums)
-- =============================================================

create type interaction_type as enum ('like', 'dislike');

create type skill_proficiency as enum (
    'beginner',
    'intermediate',
    'advanced',
    'expert'
);

create type writing_stage as enum ('idea', 'outline', 'draft', 'ready');


-- =============================================================
-- Articles domain
-- =============================================================

create table public.article_categories
(
    id          uuid primary key      default gen_random_uuid(),
    name        varchar(100) not null,
    slug        varchar(100) not null unique,
    description text,
    color       varchar,
    image_url   text
);

create table public.article_tags
(
    id   uuid primary key      default gen_random_uuid(),
    name varchar(100) not null unique,
    slug varchar(100) not null unique,
    icon text
);

create table public.article_series
(
    id          uuid primary key      default gen_random_uuid(),
    title       varchar(200) not null,
    slug        varchar(200) not null unique,
    description text         not null default '',
    image_url   text,

    author      uuid         not null default auth.uid() references auth.users (id),
    created_at  timestamptz  not null default now(),
    updated_at  timestamptz  not null default now()
);

create table public.articles
(
    id                     uuid primary key       default gen_random_uuid(),
    title                  varchar(200) not null,
    slug                   varchar(200) not null unique,
    content                text         not null,
    summary                text,

    category_id            uuid         references public.article_categories (id) on delete set null,
    image_url              text,

    writing_stage          writing_stage not null default 'idea',
    published_at           timestamptz,
    archived_at            timestamptz,
    view_count             integer      not null  default 0,

    series_id              uuid         references public.article_series (id) on delete set null,
    series_sequence_number integer,

    author                 uuid         not null  default auth.uid() references auth.users (id),
    created_at             timestamptz  not null  default now(),
    updated_at             timestamptz  not null  default now(),

    constraint unique_title_author
        unique (title, author),
    constraint unique_series_sequence_number
        unique (series_id, series_sequence_number)
);

create table public.article_tags_links
(
    article_id uuid not null references public.articles (id) on delete cascade,
    tag_id     uuid not null references public.article_tags (id) on delete cascade,

    primary key (article_id, tag_id)
);

create table public.comments
(
    id         uuid primary key     default gen_random_uuid(),
    article_id uuid        not null references public.articles (id) on delete cascade,
    content    text        not null,
    is_approved boolean    not null default true,

    author     uuid        not null default auth.uid() references auth.users (id),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.article_interactions
(
    id               uuid primary key          default gen_random_uuid(),
    article_id       uuid             not null references public.articles (id) on delete cascade,
    interaction_type interaction_type not null,

    author           uuid             not null default auth.uid() references auth.users (id),
    created_at       timestamptz      not null default now(),
    updated_at       timestamptz      not null default now(),

    constraint unique_article_interaction_per_user
        unique (article_id, author)
);

create table public.featured_articles
(
    id              uuid primary key     default gen_random_uuid(),
    article_id      uuid        not null unique
        references public.articles (id) on delete cascade,
    featured_reason text,

    author          uuid        not null default auth.uid() references auth.users (id),
    created_at      timestamptz not null default now(),
    updated_at      timestamptz not null default now()
);

create table public.article_audit_log
(
    id         uuid        primary key default gen_random_uuid(),
    operation  text        not null check (operation in ('INSERT', 'UPDATE', 'DELETE')),
    old_data   jsonb,
    new_data   jsonb,
    changed_at timestamptz not null    default now()
);

create index idx_articles_author        on public.articles (author);
create index idx_articles_category      on public.articles (category_id);
create index idx_articles_series        on public.articles (series_id);
create index idx_articles_published_at  on public.articles (published_at);
create index idx_comments_article       on public.comments (article_id);
create index idx_interactions_article   on public.article_interactions (article_id);


-- =============================================================
-- Content / Portfolio domain
-- =============================================================

create table public.companies
(
    id       uuid primary key default gen_random_uuid(),
    name     varchar(255) not null,
    url      text,
    logo_url text,
    constraint unique_company_name unique (name)
);

create table public.contact_reasons
(
    id      uuid primary key      default gen_random_uuid(),
    label   varchar(100) not null,
    "order" smallint     not null default 1,
    constraint unique_contact_reason_label unique (label)
);

create index idx_contact_reasons_order on public.contact_reasons ("order");

create table public.contact_messages
(
    id         uuid primary key      default gen_random_uuid(),
    name       varchar(100) not null,
    email      varchar(255) not null,
    reason_id  uuid         references public.contact_reasons (id) on delete set null,
    message    text         not null,
    created_at timestamptz  not null default now()
);

create index idx_contact_messages_created_at on public.contact_messages (created_at desc);

create table public.skill_categories
(
    id      uuid primary key      default gen_random_uuid(),
    name    varchar(100) not null,
    icon    text,
    "order" smallint     not null default 1,
    constraint unique_skill_category_name unique (name)
);

create index idx_skill_categories_order on public.skill_categories ("order");

create table public.skills
(
    id             uuid primary key           default gen_random_uuid(),
    name           varchar(255)      not null,
    icon           text,
    proficiency    skill_proficiency not null  default 'intermediate',
    is_highlighted boolean           not null  default false,
    category_id    uuid references public.skill_categories (id) on delete cascade,
    constraint unique_skill_name unique (name)
);

create index idx_skills_category    on public.skills (category_id);
create index idx_skills_proficiency on public.skills (proficiency);

create table public.projects
(
    id          uuid primary key      default gen_random_uuid(),
    name        varchar(255) not null,
    slug        text         not null unique,
    description text         not null,
    summary     text,
    company_id  uuid         references public.companies (id) on delete set null,
    year        smallint     not null default extract(year from now()),
    image_url   text,
    constraint unique_project_name unique (name)
);

create index idx_projects_year    on public.projects (year);
create index idx_projects_company on public.projects (company_id);

create table public.project_skills
(
    project_id uuid not null references public.projects (id) on delete cascade,
    skill_id   uuid not null references public.skills (id) on delete cascade,

    primary key (project_id, skill_id)
);

create table public.featured_projects
(
    id            uuid primary key     default gen_random_uuid(),
    project_id    uuid        not null unique
        references public.projects (id) on delete cascade,
    tagline       text        not null,
    display_order smallint    not null default 1,
    created_at    timestamptz not null default now(),
    updated_at    timestamptz not null default now()
);
