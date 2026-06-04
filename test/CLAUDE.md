# Testing

This file covers Vitest tests for the Nuxt application layer only. For database-layer tests (tables, functions, RLS policies) and edge function tests, see `supabase/tests/CLAUDE.md`.

## Running tests

Use `npx vitest run [path]` to run specific test files:

```bash
npx vitest run test/unit/utils/articleFilterUtils.test.ts   # single file
npx vitest run test/nuxt/components/article/               # whole folder
npx vitest run                                              # all tests
```

Do **not** use `pnpm test -- [path]` for targeted runs. In non-interactive shells (e.g. Claude Code's Bash tool), pnpm may try to run `pnpm install` first and abort with `ERR_PNPM_ABORTED_REMOVE_MODULES_DIR_NO_TTY`. `npx vitest run` bypasses this entirely.

Unit tests (`test/unit/`) are fully offline — no Supabase needed. Composable tests under `test/nuxt/composables/` that call `useSupabaseClient()` hit the real local Supabase instance and require `pnpm run supabase:start` first.

## Test folder placement

Every agent must follow these rules:

| What you're testing | Folder | Framework |
| --- | --- | --- |
| Pure functions, utils, helpers | `test/unit/` | Vitest (no Nuxt runtime) |
| Components, composables, store-dependent code | `test/nuxt/` | `@nuxt/test-utils` + Vitest |
| Shared mocks and test setup | `test/helpers/` | — |
| Pages | `test/nuxt/pages/` | `@nuxt/test-utils` + Vitest — same `nuxt` environment as components |

## Naming conventions

- All test files: `*.test.ts`
- Mirror the source path under the matching test folder — e.g. `app/components/field/InplaceText.vue` → `test/nuxt/components/field/InplaceText.test.ts`
- Composable tests: `test/nuxt/composables/useXyz.test.ts`
- Util tests: `test/unit/utils/xyzUtils.test.ts`

## Component test requirements

- Store-aware components require Pinia context — use `@pinia/testing` (`createTestingPinia()`)
- Mount with `@nuxt/test-utils` `mountSuspended()` for components that use Nuxt composables
- Test props, emits, and user interactions — not implementation details
- Follow TDD: write failing tests before implementing the component

## Page test pattern

Page tests live under `test/nuxt/pages/`, mirroring the source path (e.g. `app/pages/articles/browse.vue` → `test/nuxt/pages/articles/browse.test.ts`).

Use the `mountPage` helper from `test/helpers/page.ts` — it wraps `mountSuspended`, injects the route, waits for lazy async data via `flushPromises()`, and returns `{ wrapper, router }`:

```typescript
import { vi } from 'vitest'
import { mountPage } from '#tests/helpers/page'
import BrowsePage from '../../../../app/pages/articles/browse.vue'

it('renders categories from Supabase', async () => {
  const { wrapper } = await mountPage(BrowsePage)
  // Real Supabase calls resolve after mountPage returns — use vi.waitFor for data assertions
  await vi.waitFor(() => expect(wrapper.text()).toContain('Web Development'))
})

it('seeds active category from query param', async () => {
  const { wrapper } = await mountPage(BrowsePage, { query: { category: 'web-development' } })
  await vi.waitFor(() =>
    expect(wrapper.findComponent(CategoryTagFilter).props('modelCategory')).toBe('web-development'),
  )
})

it('calls router.replace when a filter is updated', async () => {
  const { wrapper, router } = await mountPage(BrowsePage)
  await vi.waitFor(() => wrapper.findComponent(CategoryTagFilter).exists())
  await wrapper.findComponent(CategoryTagFilter).vm.$emit('update:modelCategory', 'web-development')
  expect(router.replace).toHaveBeenCalledWith({ query: { category: 'web-development' } })
})
```

**`vi.waitFor` is required for assertions on Supabase data.** Pages use `useAsyncData({ lazy: true })`, which defers the fetch past the initial render. `mountPage` calls `flushPromises()` to drain the microtask queue, but the real HTTP response arrives later in the I/O phase — `flushPromises()` exits before it lands. Wrap any assertion that depends on loaded data in `vi.waitFor(() => ...)`. Assertions on route state (e.g. `router.replace` call args after a user interaction) do not need `vi.waitFor` once you've confirmed the data-dependent component is rendered.

**Auth:** `mountPage` is auth-agnostic. Wrap the suite in `describeAuthenticated` for pages that query RLS-protected data (e.g. admin pages). Leave it as plain `describe` for public pages — this explicitly tests that anonymous RLS reads work.

**Do not mock `useSupabaseClient` in page tests.** Mocks hide RLS bugs and wrong queries. Real Supabase is what catches these. See [ADR-0020](../docs/adr/0020-page-test-infrastructure.md).

**Prerequisites** (same as composable tests):
1. `pnpm run supabase:start`
2. `pnpm run db:reset`

## Integration tests against local Supabase

Tests in `test/nuxt/composables/` that call `useSupabaseClient()` or `useSupabaseUser()` hit the **real local Supabase instance** — they are not mocked.

Prerequisites before running `pnpm test`:
1. `pnpm run supabase:start` — local Supabase stack must be running
2. `pnpm run db:reset` — seeds the test user from `supabase/seeds/05_test_users.sql`
3. `.env.test` must contain `TEST_USER_EMAIL` and `TEST_USER_PASSWORD` matching the seeded credentials

Composables (`useSupabaseClient`, `useSupabaseUser`, etc.) are **auto-imported** in the `nuxt` test environment — no import statement needed in test files under `test/nuxt/`.

## Shared auth helper

The shared auth helper lives in `test/helpers/auth.ts`.

**`describeAuthenticated(label, fn)`** is the standard wrapper for any composable test suite that requires an authenticated Supabase session. It is a drop-in replacement for `describe(...)` that bakes in `beforeAll(signIn)` and `afterAll(signOut)` automatically — no copy-pasted lifecycle hooks in test files.

Use plain `describe(...)` when the test deliberately exercises unauthenticated behaviour.

The helper must be explicitly imported in test files (it is not auto-imported). Use the `#tests` alias rather than a relative path:

```typescript
import { describeAuthenticated } from '#tests/helpers/auth'

describeAuthenticated('useMyComposable', () => {
    it('does something as an authenticated user', async () => {
        // useSupabaseClient() and useSupabaseUser() are auto-imported
    })
})
```

`signIn` and `signOut` are also exported for tests that need manual lifecycle control.

### Reactive state after sign-in

`signIn` does not explicitly flush Vue's reactivity queue after `signInWithPassword` resolves — the Supabase JS client appears to update the session synchronously before returning, and `useSupabaseUser()` reflects it immediately. If a future test finds `useSupabaseUser().value` is `null` right after `beforeAll`, add `await nextTick()` inside `signIn` after the auth call as the first fix to try.

## What to test

- All props render correctly
- All emitted events fire with the correct payload
- User interactions (click, input, keyboard) trigger the right emits or store calls
- Edge cases: empty values, null, loading states