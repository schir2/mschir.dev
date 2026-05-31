create table public.article_audit_log
(
    id         uuid        primary key default gen_random_uuid(),
    operation  text        not null check (operation in ('INSERT', 'UPDATE', 'DELETE')),
    old_data   jsonb,
    new_data   jsonb,
    changed_at timestamptz not null    default now()
);

alter table public.article_audit_log enable row level security;

create policy "Admin can read audit log"
    on public.article_audit_log
    for select
    to authenticated
    using (
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

create or replace function public.articles_audit_trigger_fn()
    returns trigger
    language plpgsql
    security definer
    set search_path = public
as
$$
begin
    if (TG_OP = 'DELETE') then
        insert into public.article_audit_log (operation, old_data, new_data)
        values ('DELETE', row_to_json(OLD)::jsonb, null);
    elsif (TG_OP = 'UPDATE') then
        insert into public.article_audit_log (operation, old_data, new_data)
        values ('UPDATE', row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);
    elsif (TG_OP = 'INSERT') then
        insert into public.article_audit_log (operation, old_data, new_data)
        values ('INSERT', null, row_to_json(NEW)::jsonb);
    end if;
    return null;
end;
$$;

create trigger articles_audit_trigger
    after insert or update or delete
    on public.articles
    for each row
execute function public.articles_audit_trigger_fn();
