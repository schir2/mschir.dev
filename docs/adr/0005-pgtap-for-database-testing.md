# ADR-0005: pgTAP for database-layer testing

Database tests (table constraints, SQL functions, RLS policies) are written as pgTAP `.sql` files and run via `supabase test db`. Edge function tests are written as Deno `.ts` files and run via `deno test`.

The alternative was writing integration tests in Vitest that connect to a live Supabase instance over the network — the same runner already used for Vue components and composables. This was rejected because it would require managing DB connections, test isolation, and seed state manually inside TypeScript, and would conflate two unrelated concerns (application logic and DB correctness) in a single runner. pgTAP tests are SQL-native: they express DB-layer invariants in the same language as the schema, run inside the database engine, and get transaction-scoped rollback for free from the `begin/rollback` wrapper.

The structure under `supabase/tests/database/` is split into three subdirectories: `tables/` for structural assertions, `functions/` for SQL/PL/pgSQL function behavior, and `rls/` for row-level security policy allow/deny cases. Edge function tests co-locate with function source under `supabase/functions/tests/` following the Supabase CLI convention.

pgTAP is enabled via `supabase/seed.sql` (not a migration) so it is available in local dev for IDE introspection without being deployed to production.

## Considered Options

**Vitest integration tests connecting to a live DB** — rejected. Would need explicit connection management, seed teardown, and role simulation in TypeScript. Adds friction without benefit for tests that are fundamentally about SQL behavior. Conflates the application test suite with DB correctness checks.

**pgTAP via `supabase test db`** — accepted. SQL-native, transaction-isolated, first-class support in the Supabase CLI. Role switching and JWT claim simulation are handled with `SET LOCAL ROLE` and `set_config()` directly in SQL, matching how Supabase's auth layer actually works.
