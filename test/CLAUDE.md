# Testing

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

## What to test

- All props render correctly
- All emitted events fire with the correct payload
- User interactions (click, input, keyboard) trigger the right emits or store calls
- Edge cases: empty values, null, loading states