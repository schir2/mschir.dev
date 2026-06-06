-- =============================================================
-- Article audit trigger
-- =============================================================

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
