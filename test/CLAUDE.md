# Testing

This file covers Vitest tests for the Nuxt application layer only. For database-layer tests (tables, functions, RLS policies) and edge function tests, see `supabase/tests/CLAUDE.md`.

## Test folder placement

Every agent must follow these rules:

| What you're testing | Folder | Framework |
| --- | --- | --- |
| Pure functions, utils, helpers | `test/unit/` | Vitest (no Nuxt runtime) |
| Components, composables, store-dependent code | `test/nuxt/` | `@nuxt/test-utils` + Vitest |
| Shared mocks and test setup | `test/helpers/` | — |

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