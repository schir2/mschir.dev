alter table public.projects enable row level security;

drop policy if exists "Enable read access for all users" on public.projects;

create policy "Enable read access for all users"
    on public.projects
    for select
    to public
    using (true);