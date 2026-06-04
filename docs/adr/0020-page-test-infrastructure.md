# ADR-0020: Page-level test infrastructure for Nuxt pages

Page tests use `mountSuspended` from `@nuxt/test-utils` in the existing `nuxt` Vitest project, hitting the real local Supabase instance. A shared `mountPage` helper in `test/helpers/page.ts` wraps the setup and returns `{ wrapper, router }`.

## Real Supabase over mocks

Mocking `useSupabaseClient` in page tests was rejected. A mock can return hardcoded data and make tests pass even when the real query is broken — wrong table name, wrong select shape, or an RLS policy that silently blocks anonymous reads. The composable tests already hit the real local Supabase for the same reason. Page tests follow the same principle: the test environment runs against the seeded local instance, so RLS allow/deny behavior and query correctness are exercised on every run.

The cost is that page tests require `pnpm run supabase:start` — the same prerequisite already documented for composable tests.

## `mountPage` helper

Each page test file previously would have needed to: call `mockNuxtImport` for `useRoute` and `useRouter`, construct a route string, call `mountSuspended`, await `flushPromises()` for lazy async data, and set up router spies. The `mountPage` helper in `test/helpers/page.ts` encapsulates all of this. Tests stay small and the intent is readable at a glance.

`mountPage` is auth-agnostic. Protected pages are tested inside `describeAuthenticated` from `test/helpers/auth.ts` — composing two focused helpers is cleaner than a single helper that mixes route setup with auth lifecycle.

## `flushPromises()` for `lazy: true` async data

All `useAsyncData` calls in this project use `{ lazy: true }`, which defers the fetch past the initial render. `mountSuspended` resolves before those fetches complete, so assertions on rendered data would fail without an explicit flush. `mountPage` always calls `flushPromises()` after `mountSuspended`. Tests that need to assert loading state (before data arrives) should use `mountSuspended` directly rather than `mountPage`.

## Considered Options

**Mock `useSupabaseClient` with fixture data** — rejected. See above. Green tests over broken queries are worse than no tests.

**Copy-paste `mockNuxtImport` + `flushPromises` in every test file** — rejected. Produces large, hard-to-read test files and inconsistent setups as the pattern drifts across files.

**E2e Playwright tests** — deferred to a follow-up issue. `playwright-core` is installed and `test/e2e/` is wired into Vitest config, but full browser tests are a separate initiative from the page-mount infrastructure established here.