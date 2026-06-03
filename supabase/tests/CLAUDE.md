# Supabase Tests

Automated tests for the database layer and edge functions.

## Structure

```
supabase/tests/
├── CLAUDE.md                           ← this file
└── database/                           ← pgTAP tests (pnpm run test:db)
    ├── _helpers.sql                    ← JWT helpers; runs first (underscore sorts before letters)
    ├── tables/
    │   └── {table_name}.test.sql       ← columns, constraints, indexes
    ├── functions/
    │   └── {function_name}.test.sql    ← SQL/PL/pgSQL function behavior
    └── rls/
        └── {table_name}.test.sql       ← allow and deny cases for each policy

supabase/functions/tests/               ← Deno edge function tests (pnpm run test:edge)
    └── {function-name}-test.ts
```

## Running tests

The local Supabase stack must be running first:

```bash
pnpm run supabase:start
pnpm run test:db      # all pgTAP database tests
pnpm run test:edge    # all Deno edge function tests
```

## pgTAP test format

Every file in `database/` must use this structure — no exceptions:

```sql
begin;

select plan(N);  -- N must exactly match the number of assertions below

-- ... pgTAP assertions ...

select * from finish();

rollback;
```

The `begin`/`rollback` pair keeps test data isolated. If `plan(N)` does not match the actual assertion count, the suite reports a failure even if all assertions pass.

## File naming

| Location | Pattern |
|---|---|
| `database/tables/` | `{table_name}.test.sql` |
| `database/functions/` | `{function_name}.test.sql` |
| `database/rls/` | `{table_name}.test.sql` |
| `functions/tests/` | `{function-name}-test.ts` |

One file per entity per category. Split only when a file becomes unmanageable.

## Role switching in RLS tests

Use `SET LOCAL ROLE` as a bare statement in the test file. Do NOT wrap it in a helper function — PL/pgSQL functions restore GUC values on exit, which silently undoes the role change before assertions run.

```sql
-- Insert test data first, while still running as postgres (bypasses RLS)
insert into public.some_table (col) values ('test value');

-- Then switch role for policy assertions
set local role anon;

-- Use JWT helpers from _helpers.sql for auth-based policies
set local role authenticated;
select tests.jwt_authenticated('00000000-0000-0000-0000-000000000001');

set local role authenticated;
select tests.jwt_admin('00000000-0000-0000-0000-000000000002');
```

## What to test in each category

**tables/** — structural: `has_table`, `has_column`, `col_not_null`, `col_is_unique`, `col_type`. Not data.

**functions/** — behavior: return values for valid inputs, errors for invalid inputs, edge cases. One test per meaningful input variant.

**rls/** — always test BOTH directions for each role:
- A permitted operation succeeds (`lives_ok` or `isnt_empty`)
- A denied operation raises `42501` (`throws_ok(..., '42501', NULL, 'description')`)

**functions/tests/** (edge) — HTTP responses, error handling, invocations via `supabase.functions.invoke`. See the Supabase edge function testing docs for the Deno test pattern.

## Common pgTAP functions

```sql
has_table('schema', 'table', 'description')
has_column('schema', 'table', 'column', 'description')
col_not_null('schema', 'table', 'column', 'description')
col_is_unique('schema', 'table', 'column', 'description')
col_type_is('schema', 'table', 'column', 'type', 'description')
isnt_empty('select ...', 'description')       -- query returns >= 1 row
is_empty('select ...', 'description')         -- query returns 0 rows
lives_ok('statement', 'description')          -- statement does not throw
throws_ok('statement', 'errcode', NULL, 'description')  -- statement throws errcode
ok(boolean_expression, 'description')
```

Full reference: https://pgtap.org/documentation.html
