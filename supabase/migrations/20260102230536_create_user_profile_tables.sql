create table public.user_profiles
(
    id           uuid primary key     default gen_random_uuid(),

    user_id      uuid        not null
        references auth.users (id)
            on delete cascade,

    first_name   varchar(100),
    last_name    varchar(100),
    display_name varchar(150),

    email        varchar(255),

    avatar_url   text,

    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now(),

    constraint unique_user_profile
        unique (user_id)
);


create index idx_user_profiles_user_id
    on public.user_profiles (user_id);

create index idx_user_profiles_email
    on public.user_profiles (email);

alter table public.user_profiles enable row level security;