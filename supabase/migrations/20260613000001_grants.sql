-- Grant SELECT on all public tables to anon (RLS policies restrict which rows)
grant select on all tables in schema public to anon;

-- anon can submit contact forms
grant insert on public.contact_messages to anon;

-- Grant full DML to authenticated (RLS policies restrict access by role)
grant select, insert, update, delete on all tables in schema public to authenticated;

-- Ensure future tables get the same grants automatically
alter default privileges in schema public grant select on tables to anon;
alter default privileges in schema public grant select, insert, update, delete on tables to authenticated;
