-- Draft article: Testing Nuxt pages with real Supabase

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000011',
    'Testing Nuxt Pages with Real Supabase',
    'testing-nuxt-pages-with-real-supabase',
    $article$# Testing Nuxt Pages with Real Supabase

For a long time, this site had no page-level tests. The rule in the test documentation was blunt: *"Not tested at page level — extract logic into composables or utils instead."* It was a placeholder, not a philosophy. Issue #47 sat open while every page got exercised manually and hoped for the best.

Setting up the infrastructure turned out to be more interesting than I expected, because the obvious approach — mocking `useSupabaseClient` — is actually the wrong one. This is what I built instead and why.

## What "page test" means here

There are two things people mean when they say "test a page":

1. **Page-mount tests**: Mount the page component in a Nuxt runtime sandbox, control the route, assert on rendered output and function calls. Fast, no browser, no running dev server.
2. **E2e tests**: Open a real browser, navigate to the URL, click things, assert the URL changed. Slow, requires a running server, catches a different class of bugs.

This article is about the first kind. The second kind is a separate project.

## The pieces

### `mountSuspended`

Vue Test Utils gives you `mount()` for mounting a component in a test environment. But Nuxt pages use composables like `useRoute()`, `useSupabaseClient()`, and `useAsyncData()` that only work when the Nuxt runtime is present. Plain `mount()` doesn't set that up — calls to those composables either throw or return undefined.

`mountSuspended()` from `@nuxt/test-utils` does two things differently:

1. It initialises the full Nuxt context before mounting — auto-imports, plugins, modules, the mock Vue Router — so composables work correctly.
2. It wraps the component in a `<Suspense>` boundary and awaits it, so any async component setup (like `await useAsyncData(...)` without `lazy: true`) completes before the function returns.

```typescript
import { mountSuspended } from '@nuxt/test-utils/runtime'

const wrapper = await mountSuspended(MyPage, {
  route: '/articles/browse?category=web-development'
})
```

The `route` option tells the mock Vue Router which URL to simulate, so `useRoute()` inside the page returns the right path and query params.

### What a wrapper is

`mountSuspended` returns a **wrapper** — a Vue Test Utils `VueWrapper` object that wraps the mounted component instance. It gives you methods to query what was rendered:

```typescript
wrapper.text()                        // all visible text as a string
wrapper.find('button')                // first matching DOM element
wrapper.findAll('.chip')              // all matching elements
wrapper.findComponent(MyComponent)    // find a child component by definition
wrapper.findComponent(MyComponent).props('modelValue')  // read a prop
```

The wrapper is your handle on the rendered output. You don't interact with the DOM directly — you go through the wrapper. This matters because Vue's reactivity system needs to be in the loop when you trigger interactions.

### `mockNuxtImport`

Nuxt auto-imports composables — `useRoute`, `useRouter`, `useSupabaseClient`, etc. — so you never write `import` statements for them in your components. In tests, this creates a problem: how do you replace them with a controlled version?

The answer is `mockNuxtImport` from `@nuxt/test-utils/runtime`. It works like `vi.mock` but understands Nuxt's auto-import system:

```typescript
import { mockNuxtImport } from '@nuxt/test-utils/runtime'
import { vi } from 'vitest'

const { mockSignOut } = vi.hoisted(() => ({
  mockSignOut: vi.fn().mockResolvedValue({})
}))

mockNuxtImport('useSupabaseClient', () => () => ({
  auth: { signOut: mockSignOut }
}))
```

Two things to notice:

- The factory function returns *another* function — `() => () => ({...})`. That's because `useSupabaseClient` is a composable (a function you call), so the mock needs to return a function that, when called, returns the fake client.
- `vi.hoisted()` is required for any variables you want to reference inside `mockNuxtImport`. Vitest hoists mock declarations to the top of the file at compile time, before regular variable declarations run. `vi.hoisted()` runs at the same early stage, making the variable available.

### Why real Supabase over mocks

When I first sketched the page test infrastructure, the obvious move was to mock `useSupabaseClient` with a fake that returns hardcoded data. It keeps tests offline, fast, and deterministic. It's what most tutorials show.

The problem is what mocks hide. Consider a page that queries:

```typescript
const { data } = await supabase
  .from('article_categories')
  .select('id, name, slug')
  .order('name')
```

A mock returns whatever you tell it to, regardless of whether that query is correct. Rename the column from `slug` to `category_slug` in a migration and forget to update the query — the mock still passes. Add a Row Level Security policy that accidentally blocks anonymous reads — the mock still passes. Query the wrong table entirely — the mock still passes.

The composable tests on this site already hit the real local Supabase for exactly this reason. Page tests follow the same principle: the test environment runs against the seeded local instance, so RLS policy correctness and query shape are verified on every run.

The cost is that page tests require `pnpm run supabase:start` — the same prerequisite the composable tests have. That's an acceptable trade-off.

## The `mountPage` helper

Every page test needs the same setup: inject the route, await mount, set up router spies. Repeating this in every test file produces large, hard-to-read test files that drift apart over time. Instead, a shared helper in `test/helpers/page.ts` encapsulates the whole thing:

```typescript
import { mountSuspended } from '@nuxt/test-utils/runtime'
import { flushPromises } from '@vue/test-utils'
import { vi } from 'vitest'
import type { Component } from 'vue'

interface MountPageOptions {
  query?: Record<string, string | string[]>
  path?: string
}

export async function mountPage(component: Component, options: MountPageOptions = {}) {
  const { query = {}, path = '/' } = options

  const params = new URLSearchParams()
  for (const [key, value] of Object.entries(query)) {
    if (Array.isArray(value)) {
      for (const entry of value) params.append(key, entry)
    } else {
      params.set(key, value)
    }
  }
  const queryString = params.toString()
  const route = queryString ? `${path}?${queryString}` : path

  const wrapper = await mountSuspended(component, { route })
  await flushPromises()

  const router = useRouter()
  vi.spyOn(router, 'replace')
  vi.spyOn(router, 'push')

  return { wrapper, router }
}
```

It returns `{ wrapper, router }` because page tests need both. `wrapper` is how you inspect what was rendered. `router` is how you assert that navigation happened — many pages call `router.replace` when filter state changes, and you want to verify the right query object was passed.

`vi.spyOn(router, 'replace')` wraps the real router method with a spy so calls are recorded. After a user interaction triggers navigation, you can assert:

```typescript
expect(router.replace).toHaveBeenCalledWith({ query: { category: 'web-development' } })
```

Auth is handled separately. `mountPage` is deliberately auth-agnostic. For pages behind RLS that require a signed-in session, wrap the test suite in `describeAuthenticated` from `test/helpers/auth.ts`. This composes two focused helpers rather than merging two concerns into one function. For public pages like the article browser, plain `describe` is the right choice — and it explicitly tests that anonymous RLS reads work.

## `vi.waitFor` and lazy async data

There is one wrinkle. Every `useAsyncData` call on this site uses `{ lazy: true }`:

```typescript
const { data: categories, pending: categoriesPending } = useAsyncData(
  'browse-categories',
  async () => { /* Supabase fetch */ },
  { lazy: true }
)
```

`lazy: true` means the fetch is deferred — it does not block the initial render. `mountSuspended` resolves before the Supabase call completes. `flushPromises()` drains the JavaScript microtask queue, but real HTTP responses land in the I/O phase of the event loop, after `flushPromises()` has already exited.

The result: if you write a test that immediately asserts on rendered Supabase data, the assertion runs against an empty state and fails.

The fix is `vi.waitFor`, which polls the callback using `setInterval` and retries until the assertion stops throwing:

```typescript
it('renders seeded categories', async () => {
  const { wrapper } = await mountPage(BrowsePage)
  await vi.waitFor(() => expect(wrapper.text()).toContain('Web Development'))
})
```

`vi.waitFor` gives the event loop time to process the HTTP response between retries. Without it, you'd be asserting before the data arrives. With it, the test waits patiently until the data is there and then verifies it.

## Putting it together

A page test for the article browser ends up looking like this:

```typescript
describe('articles/browse', () => {
  it('renders seeded categories from Supabase', async () => {
    const { wrapper } = await mountPage(BrowsePage)
    await vi.waitFor(() => expect(wrapper.text()).toContain('Web Development'))
  })

  it('seeds modelCategory from the category query param', async () => {
    const { wrapper } = await mountPage(BrowsePage, { query: { category: 'web-development' } })
    await vi.waitFor(() =>
      expect(wrapper.findComponent(CategoryTagFilter).props('modelCategory')).toBe('web-development'),
    )
  })
})
```

Two tests, each under ten lines. The first proves that Supabase returned data, RLS allowed the anonymous read, and the page rendered it. The second proves that the query param seeded the active category correctly. Running them requires a local Supabase instance, which is the same requirement as the composable tests — nothing new to set up.

The infrastructure that makes this work — `mountPage`, `vi.waitFor`, real Supabase — took longer to design than to implement. The mocking alternative would have been faster to write and slower to trust.
$article$,
    'How this site''s page-level test infrastructure works: mountSuspended, real Supabase over mocks, the mountPage helper, and why vi.waitFor is required for lazy async data.',
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    '2026-06-04 10:00:00+00',
    '2026-06-04 10:00:00+00'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000011', id
from public.article_tags
where slug in ('nuxt', 'supabase', 'vue.js', 'typescript');
