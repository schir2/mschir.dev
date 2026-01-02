create type interaction_type as enum ('like', 'dislike');



create table public.article_topics
(
    id          uuid primary key default gen_random_uuid(),
    name        varchar(100) not null,
    slug        varchar(100) not null unique,
    description text
);

create table public.article_tags
(
    id   uuid primary key default gen_random_uuid(),
    name varchar(100) not null unique,
    slug varchar(100) not null unique
);

create table public.article_series
(
    id          uuid primary key      default gen_random_uuid(),
    title       varchar(200) not null,
    slug        varchar(200) not null unique,
    description text         not null default '',


    author      uuid         not null default auth.uid() references auth.users (id),
    created_at  timestamptz  not null default now(),
    updated_at  timestamptz  not null default now()
);

create table public.articles
(
    id                     uuid primary key      default gen_random_uuid(),
    title                  varchar(200) not null,
    slug                   varchar(200) not null unique,
    content                text         not null,

    topic_id               uuid         references public.article_topics (id) on delete set null,
    image_url              text,

    is_published           boolean      not null default true,
    view_count             integer      not null default 0,

    series_id              uuid         references public.article_series (id) on delete set null,
    series_sequence_number integer,


    author                 uuid         not null default auth.uid() references auth.users (id),
    created_at             timestamptz  not null default now(),
    updated_at             timestamptz  not null default now(),

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
    id          uuid primary key     default gen_random_uuid(),
    article_id  uuid        not null references public.articles (id) on delete cascade,
    content     text        not null,
    is_approved boolean     not null default true,


    author      uuid        not null default auth.uid() references auth.users (id),
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
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

create index idx_articles_author on public.articles (author);
create index idx_articles_topic on public.articles (topic_id);
create index idx_articles_series on public.articles (series_id);

create index idx_comments_article on public.comments (article_id);
create index idx_interactions_article on public.article_interactions (article_id);
