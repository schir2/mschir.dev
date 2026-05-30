-- Shared helpers for the pgTAP test suite.
-- This file has no begin/rollback — the functions must persist for the entire test session.
-- The underscore prefix ensures lexicographic sort order places this file first.
--
-- IMPORTANT: Database role switching (set local role anon / authenticated) must be done
-- as bare statements in each test file, NOT via helper functions. PL/pgSQL functions
-- restore GUC values on exit, which undoes SET LOCAL ROLE changes before the test can use them.

create schema if not exists tests;

-- Clears JWT claims. Use alongside: set local role anon;
create or replace function tests.jwt_anon()
returns void
language sql
as $$
  select set_config('request.jwt.claims', '', true);
$$;

-- Sets JWT claims for an authenticated user. Use alongside: set local role authenticated;
create or replace function tests.jwt_authenticated(user_id uuid default gen_random_uuid())
returns void
language sql
as $$
  select set_config(
    'request.jwt.claims',
    json_build_object('sub', user_id, 'role', 'authenticated')::text,
    true
  );
$$;

-- Sets JWT claims for an admin user (app_metadata.role = 'admin'). Use alongside: set local role authenticated;
create or replace function tests.jwt_admin(user_id uuid default gen_random_uuid())
returns void
language sql
as $$
  select set_config(
    'request.jwt.claims',
    json_build_object(
      'sub', user_id,
      'role', 'authenticated',
      'app_metadata', json_build_object('role', 'admin')
    )::text,
    true
  );
$$;
