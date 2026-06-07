-- Playwright for Nuxt Developers: A Complete Field Guide (5-part series)

-- New tags
insert into public.article_tags (name, slug, icon)
values
    ('Playwright', 'playwright', 'simple-icons:playwright'),
    ('E2E Testing', 'e2e-testing', 'mdi:test-tube-outline'),
    ('Testing', 'testing', 'mdi:test-tube'),
    ('Vitest', 'vitest', 'logos:vitest')
on conflict (slug) do nothing;

-- Series
insert into public.article_series (id, title, slug, description, author)
values (
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    'Playwright for Nuxt Developers',
    'playwright-for-nuxt-developers',
    'A complete field guide to browser-level end-to-end testing with Playwright, tailored for Nuxt 4 and Supabase projects. Covers architecture, locators, writing stable tests, and practical patterns for a real production stack.',
    '3a455a9e-9a96-4fa1-aef9-8591690084e6'
)
on conflict (slug) do nothing;


-- ============================================================
-- Part 1: What Playwright Is and Where It Fits
-- ============================================================

insert into public.articles (id, title, slug, content, summary, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000012',
    'What Playwright Is and Where It Fits in the Testing Stack',
    'what-playwright-is-and-where-it-fits',
    $article$# What Playwright Is and Where It Fits in the Testing Stack

Before you write a single Playwright test, it helps to understand what layer of the testing stack it occupies and why that distinction matters. Skipping this step is how teams end up with hundreds of slow, fragile e2e tests covering things a unit test would handle in milliseconds.

## The testing pyramid

Think of automated tests as a pyramid with three layers:

```
         /\
        /  \
       / e2e \         <- Playwright lives here
      /--------\
     / integration \   <- mountSuspended + real database
    /--------------\
   /   unit tests   \  <- Vitest, composables, utilities
  /------------------\
```

Each layer has a different cost/confidence tradeoff:

| Layer | Speed | Confidence | Fragility | Cost |
|---|---|---|---|---|
| Unit | Milliseconds | Low (one thing at a time) | Low | Cheap |
| Integration | Seconds | Medium (real DB, real component) | Medium | Moderate |
| E2e (Playwright) | 5 to 30 seconds per test | High (real browser, real app) | High | Expensive |

E2e tests are the most expensive and most fragile, but they provide the highest confidence because they test the whole system exactly as a user would experience it. This is why you have very few of them and make each one count.

## What Playwright actually is

Playwright is a library that controls real web browsers programmatically. When a test runs:

1. Playwright launches a real browser process (Chromium, Firefox, or WebKit)
2. It opens a tab and navigates to your URL
3. It finds elements on the page and interacts with them (click, type, scroll)
4. It asserts that the page is in the expected state
5. The browser closes

There is no simulation, no virtual DOM, no jsdom. It is a real browser rendering your real app. This is both its power and its cost.

## What Playwright is NOT

**Not a replacement for unit tests.** Do not test a `formatDate()` utility with Playwright. Test it with Vitest in 1ms.

**Not a replacement for component tests.** Do not test "does this component render its props correctly" with Playwright. `mountSuspended` from `@nuxt/test-utils` does that faster, cheaper, and with less setup.

**Not a visual regression tool** (without additional plugins like Argos or Percy). Playwright's built-in screenshot diffing is fragile across environments and should not be your primary verification strategy.

## What SHOULD be tested with Playwright

These are the scenarios that genuinely require a real browser.

### Full navigation flows

Does clicking "Read More" navigate to `/articles/my-slug`? Does the browser URL update? Does the page title change? These questions are difficult to answer without a real browser navigating real routes.

### URL-driven state

If filter chips write query params to the URL (like `?category=typescript`), you need a real browser to verify that the URL actually updates when you click. Nuxt's router does not run in jsdom.

### Multi-step user journeys

Login, navigate to a protected page, view content, log out, get redirected. This flow involves cookies, redirects, and real auth state. It is impossible to test reliably without a browser.

### Forms with real submission

A contact form that makes a real HTTP request, shows a toast notification, and clears the fields. You want to confirm the whole flow works end-to-end, not just that the button is clickable.

### JavaScript that depends on the real browser environment

`IntersectionObserver` for lazy loading, `window.scroll` behavior, clipboard APIs, and anything else that jsdom does not implement correctly.

### Smoke tests

"Does the site even load?" A handful of e2e tests that navigate to the main public pages and confirm they do not crash is worth more than dozens of unit tests for catching deployment disasters.

## What should NOT be tested with Playwright

**Component rendering logic.** "Does the article card show the title and author?" Use `mountSuspended` with Vitest.

**Pure functions and composables.** "Does `usePageSeo` set the right meta tags?" Use Vitest.

**Database and RLS correctness.** "Does an unauthenticated user see only published articles?" Use pgTAP for schema-level tests, and `mountSuspended` for component-level.

**Every edge case of a feature.** Playwright tests should cover the happy path and one or two critical error paths, not every branch condition. Leave branch coverage to unit tests.

**Things that require mocking the network.** If you need to mock Supabase responses to test something, that something belongs in an integration test, not e2e.

## The rule of thumb

If you can test it without a real browser, you should. Use Playwright only when a real browser is the only way to be confident the feature works.

The goal is a fast, reliable suite where each layer does its job. Unit tests run in milliseconds and catch logic errors. Integration tests run in seconds and catch wiring errors. E2e tests run in minutes and catch the whole-system failures that nothing else would find.

## Further reading

- [Playwright official documentation](https://playwright.dev/docs/intro)
- [Google Testing Blog: Just Say No to More End-to-End Tests](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)
- [Testing Trophy and Testing Classifications (Kent C. Dodds)](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications)
- [Nuxt Testing overview](https://nuxt.com/docs/getting-started/testing)
$article$,
    'An introduction to Playwright and where it belongs in the testing stack. Covers the testing pyramid, what e2e tests are actually good for, and what they should not be used for.',
    (select id from public.article_categories where slug = 'web-development'),
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    1,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000012', id
from public.article_tags
where slug in ('playwright', 'e2e-testing', 'testing', 'nuxt', 'typescript');


-- ============================================================
-- Part 2: How Playwright Works: Architecture, Core Concepts, and the Selector Engine
-- ============================================================

insert into public.articles (id, title, slug, content, summary, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000013',
    'How Playwright Works: Architecture, Core Concepts, and the Selector Engine',
    'how-playwright-works-architecture-and-core-concepts',
    $article$# How Playwright Works: Architecture, Core Concepts, and the Selector Engine

Once you understand why Playwright exists and where it belongs, the next step is understanding how it actually works. This article covers the internal architecture, the locator system, actions, assertions, and the config file.

## Browser, Context, and Page

Playwright has a three-level hierarchy:

```
Browser (1 per test worker)
  └── BrowserContext (1 per test, fresh by default)
        └── Page (1 or more tabs)
```

**Browser** is the actual browser process. It is expensive to start but cheap to reuse. Playwright starts one per worker and keeps it alive across tests.

**BrowserContext** is an isolated browser session with its own cookies, localStorage, and cache. By default, each test gets a fresh context, so tests cannot share state. Think of it as a fresh incognito window per test. This is why login state from test A never leaks into test B.

**Page** is a single tab inside a context. Most tests work with a single page. You can open multiple pages in one context to test things like "open link in new tab."

## Locators: the core of Playwright

A locator is a lazy query that describes how to find an element. Unlike a DOM query that runs immediately, a locator re-queries the DOM every time you interact with it. This is what makes Playwright tests resilient to re-renders and loading states.

```typescript
// Locator: lazy, re-queries on every action
const button = page.getByRole('button', { name: 'Submit' })
await button.click()
```

Compare this to the old Playwright API (and avoid it):

```typescript
// Avoid: this is a snapshot, does not auto-retry
const element = await page.$('button')
await element.click()
```

### Locator priority: best to worst

**1. `getByRole`** queries by ARIA role and accessible name. This is the best locator because it tests what a screen reader sees, not implementation details.

```typescript
page.getByRole('button', { name: 'Submit' })
page.getByRole('heading', { name: /articles/i })
page.getByRole('list', { name: 'Category filters' })
```

**2. `getByLabel`** finds form inputs by their associated label text.

```typescript
page.getByLabel('Email address')
```

**3. `getByPlaceholder`** finds inputs by placeholder text, useful when there is no visible label.

```typescript
page.getByPlaceholder('Enter your email')
```

**4. `getByText`** finds elements by their visible text content.

```typescript
page.getByText('Hello, World')
```

**5. `getByTestId`** uses `data-testid` attributes added specifically for testing. Use this when nothing else works cleanly.

```typescript
page.getByTestId('submit-button')
// element: <button data-testid="submit-button">
```

**6. CSS selectors via `page.locator()`** are a last resort. They break when styling changes.

```typescript
page.locator('.filter-chip')  // fragile: breaks on rename
page.locator('#submit')       // also fragile
```

Never use XPath unless forced. It is brittle and unreadable.

## Actions

Actions interact with located elements. Every action automatically waits for the element to be visible, enabled, and stable before proceeding. You do not need to add manual sleeps.

```typescript
// Navigation
await page.goto('/articles/browse')
await page.goBack()

// Clicking
await page.getByRole('button', { name: 'Filter' }).click()

// Typing: clears the field first, then types
await page.getByLabel('Email').fill('test@example.com')

// Keyboard
await page.keyboard.press('Enter')
await page.keyboard.press('Tab')

// Hover
await page.getByRole('navigation').hover()

// Select dropdown
await page.getByLabel('Category').selectOption('typescript')
```

## Assertions

Playwright ships web-first assertions via `expect()`. The key feature: they automatically retry until the condition is met or the timeout expires. You almost never need to manually wait for something before asserting.

```typescript
import { expect } from '@playwright/test'

// Wait for a URL change (retries for up to the configured timeout)
await expect(page).toHaveURL('/articles/browse?category=typescript')
await expect(page).toHaveURL(/category=typescript/)  // regex works too

// Wait for an element to be visible
await expect(page.getByRole('heading', { name: 'Articles' })).toBeVisible()

// Wait for text to appear
await expect(page.getByRole('status')).toHaveText('Message sent!')

// Wait for an element to disappear
await expect(page.getByRole('progressbar')).not.toBeVisible()

// Check element count
await expect(page.getByRole('article')).toHaveCount(5)

// Check an attribute
await expect(page.getByRole('link', { name: 'Home' })).toHaveAttribute('href', '/')
```

The retry loop is what separates Playwright assertions from plain JavaScript assertions. When you write `await expect(locator).toBeVisible()`, Playwright keeps re-checking every 100ms until it passes or times out. This is why you rarely need `waitForSelector` or `waitForTimeout`.

## Test structure

Tests use a `test()` function from `@playwright/test`. The built-in `page` fixture is injected automatically.

```typescript
import { test, expect } from '@playwright/test'

test('articles browse page loads', async ({ page }) => {
  await page.goto('/articles/browse')
  await expect(page.getByRole('heading', { name: 'Articles' })).toBeVisible()
})
```

You can group related tests with `test.describe()`:

```typescript
test.describe('article filtering', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/articles/browse')
  })

  test('clicking a category chip updates the URL', async ({ page }) => {
    await page.getByRole('button', { name: 'TypeScript' }).click()
    await expect(page).toHaveURL(/category=typescript/)
  })
})
```

## The config file

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './test/e2e',
  timeout: 30_000,
  retries: process.env.CI ? 2 : 0,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
})
```

**`baseURL`** is the most important setting. Once set, `page.goto('/articles')` resolves against it so you never hardcode the full URL in a test.

**`trace: 'on-first-retry'`** records a full timeline of every action, screenshot, and network request on the first retry. Open it with `npx playwright show-trace trace.zip` to scrub through exactly what happened.

**`retries`** lets flaky tests pass on CI by trying again. This is a safety net, not a solution to flakiness. If a test retries consistently, fix the root cause.

## Further reading

- [Playwright: Locators](https://playwright.dev/docs/locators)
- [Playwright: Actionability](https://playwright.dev/docs/actionability)
- [Playwright: Assertions](https://playwright.dev/docs/test-assertions)
- [Playwright: Configuration](https://playwright.dev/docs/test-configuration)
- [Playwright: Fixtures](https://playwright.dev/docs/test-fixtures)
$article$,
    'A deep dive into how Playwright works internally: the Browser/Context/Page hierarchy, the locator engine, actions, web-first assertions, and how to configure the test runner.',
    (select id from public.article_categories where slug = 'web-development'),
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    2,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000013', id
from public.article_tags
where slug in ('playwright', 'e2e-testing', 'testing', 'typescript');


-- ============================================================
-- Part 3: Playwright in the Nuxt Ecosystem
-- ============================================================

insert into public.articles (id, title, slug, content, summary, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000014',
    'Playwright in the Nuxt Ecosystem',
    'playwright-in-the-nuxt-ecosystem',
    $article$# Playwright in the Nuxt Ecosystem

Using Playwright in a Nuxt project is not quite the same as using it in a plain Node app. Nuxt has its own test utilities layer that wraps Playwright and handles server lifecycle for you. This article explains both approaches and makes a case for which one to use.

## Two approaches

### Option A: Standalone Playwright

You run `pnpm run dev` yourself in a terminal, then point Playwright at `localhost:3000` via `baseURL` in `playwright.config.ts`. Simple, works with any Nuxt version, no extra dependencies beyond `@playwright/test`.

```typescript
// playwright.config.ts
export default defineConfig({
  use: { baseURL: 'http://localhost:3000' },
})
```

```typescript
// test/e2e/smoke.spec.ts
import { test, expect } from '@playwright/test'

test('home page loads', async ({ page }) => {
  await page.goto('/')
  await expect(page.getByRole('main')).toBeVisible()
})
```

You run `npx playwright test` separately from your Vitest suite. The dev server must already be running.

### Option B: `@nuxt/test-utils` e2e helpers

The `@nuxt/test-utils` package wraps Playwright and manages the Nuxt server lifecycle automatically. Tests live inside your Vitest config as a separate project. The package provides `setup()`, `createPage()`, and `url()` helpers.

```typescript
// test/e2e/smoke.spec.ts
import { setup, createPage, url } from '@nuxt/test-utils/e2e'
import { describe, it, expect } from 'vitest'
import { fileURLToPath } from 'node:url'

await setup({
  rootDir: fileURLToPath(new URL('../../', import.meta.url)),
  browser: true,
})

describe('smoke', () => {
  it('home page loads', async () => {
    const page = await createPage(url('/'))
    await expect(page.getByRole('main')).toBeVisible()
    await page.close()
  })
})
```

Under the hood, `setup()` calls `nuxi build` and starts a server before any test in the file runs. `createPage()` opens a browser page pointed at that server. `url('/path')` resolves the path against the test server's base URL.

## Choosing between the two

| | `@nuxt/test-utils` + Vitest | Standalone Playwright |
|---|---|---|
| Server management | Automatic | Manual (run dev server first) |
| Runner | Vitest | Playwright's own runner |
| Config | `vitest.config.ts` | `playwright.config.ts` |
| HTML reports and traces | Not built-in | Full Playwright reporter |
| Maturity | Good for Nuxt 3/4 | Battle-tested everywhere |
| One command to run all tests | Yes (`vitest run`) | No (separate commands) |

For a Nuxt 4 project that already uses Vitest for unit and integration tests, `@nuxt/test-utils` is the right choice. It keeps everything in one test runner, manages the server for you, and integrates naturally with the existing project structure.

## Installation

```bash
pnpm add -D @nuxt/test-utils @playwright/test
npx playwright install chromium
```

`@nuxt/test-utils` depends on `@playwright/test` for the browser layer but does not re-export its runner. You need both.

`npx playwright install chromium` downloads the browser binary. This is a one-time step per machine, and needs to be repeated in CI.

## Configuring Vitest for e2e

The e2e project in `vitest.config.ts` needs `environment: 'node'`, not `environment: 'nuxt'`. E2e tests do not use jsdom or the Nuxt test environment; they drive a real browser.

```typescript
// vitest.config.ts (simplified)
export default defineConfig({
  test: {
    projects: [
      {
        test: {
          name: 'unit',
          include: ['test/**/*.spec.ts'],
          exclude: ['test/e2e/**'],
          environment: 'nuxt',
        },
      },
      {
        test: {
          name: 'e2e',
          include: ['test/e2e/**/*.spec.ts'],
          environment: 'node',
          testTimeout: 60_000,
          hookTimeout: 120_000, // setup() needs time to build Nuxt
        },
      },
    ],
  },
})
```

The `hookTimeout` is important. `setup()` builds your Nuxt app before running any tests. On a first run or after a cache miss, this can take 30-60 seconds. Without a generous `hookTimeout`, the test suite fails before it even starts.

## The `setup()` call

`setup()` is called at the top level of a test file (outside any `describe` or `it` block). It runs once per file, building the Nuxt app and starting the server.

```typescript
await setup({
  rootDir: fileURLToPath(new URL('../../', import.meta.url)),
  browser: true,
})
```

`rootDir` points to the Nuxt project root. The relative path `../../` navigates up from `test/e2e/` to the project root.

`browser: true` tells `@nuxt/test-utils` to spin up a Playwright browser. Without this, `createPage()` is unavailable.

## The `createPage()` and `url()` helpers

`createPage()` opens a new browser tab. Pass a URL to navigate immediately:

```typescript
const page = await createPage(url('/articles/browse'))
```

`url()` converts a path to the full test server URL. Always use `url()` rather than hardcoding `http://localhost:3000` directly, because `@nuxt/test-utils` picks a random available port when starting the server.

Always call `await page.close()` at the end of each test. This is the equivalent of closing the browser tab and cleaning up resources.

## Using the raw Playwright `expect`

`@nuxt/test-utils` does not re-export `expect`. Import it directly from `@playwright/test`:

```typescript
import { expect } from '@playwright/test'
import { createPage, url } from '@nuxt/test-utils/e2e'
```

## Supabase: you still manage it yourself

`@nuxt/test-utils` manages the Nuxt server. It does not manage Supabase. Before running e2e tests, the local Supabase stack must be running and the database must be seeded.

```bash
pnpm run supabase:start   # start local Supabase (run once per session)
npx vitest run --project e2e
```

On CI, add a step to start Supabase before running tests. The `supabase/cli` GitHub Action is the standard approach for this.

## Further reading

- [Nuxt: Testing (official guide)](https://nuxt.com/docs/getting-started/testing#e2e-testing)
- [@nuxt/test-utils source and docs](https://github.com/nuxt/test-utils)
- [Playwright: Vitest integration note](https://playwright.dev/docs/intro)
- [Supabase GitHub Action for CI](https://supabase.com/docs/guides/cli/github-actions)
$article$,
    'How to use Playwright inside a Nuxt project, covering both the standalone approach and the @nuxt/test-utils integration with Vitest. Includes setup, configuration, and Supabase prerequisites.',
    (select id from public.article_categories where slug = 'web-development'),
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    3,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000014', id
from public.article_tags
where slug in ('playwright', 'e2e-testing', 'testing', 'nuxt', 'typescript', 'vitest');


-- ============================================================
-- Part 4: Writing Stable Tests
-- ============================================================

insert into public.articles (id, title, slug, content, summary, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000015',
    'Writing Stable Playwright Tests: Patterns, Anti-Patterns, and Waiting Correctly',
    'writing-stable-playwright-tests',
    $article$# Writing Stable Playwright Tests: Patterns, Anti-Patterns, and Waiting Correctly

Playwright makes it easy to write tests that work on your machine today and break in CI next week. Most of that fragility comes from two sources: testing implementation details instead of behavior, and waiting incorrectly. This article covers both, along with the patterns that make tests reliable over time.

## The golden rule: test behavior, not implementation

A test should describe what the user does and what they see. It should not describe which CSS class is present or which function was called.

```typescript
// Test user-visible behavior
await page.getByRole('button', { name: 'TypeScript' }).click()
await expect(page).toHaveURL(/category=typescript/)

// Avoid: tests implementation detail
await page.locator('.filter-chip--active').click()
await expect(page.locator('#article-grid')).toHaveClass(/filtered/)
```

The second version breaks the moment you rename a CSS class or restructure the DOM. The first version is still correct even if you rewrite the component from scratch, as long as the user-visible behavior stays the same.

## Waiting correctly: the biggest source of flakiness

The most common cause of flaky Playwright tests is incorrect waiting. The wrong pattern:

```typescript
// Never do this
await page.waitForTimeout(2000)
await page.click('.submit-button')
```

Arbitrary sleeps are fragile: too short on a slow machine, wasteful on a fast one. They are the number one source of flaky tests and should never appear in a test file.

The right approach is to let Playwright's built-in waiting do the work. Every action waits for the element to be visible and stable before proceeding. Every `expect()` assertion retries automatically.

### Waiting strategies by scenario

| Scenario | How to wait |
|---|---|
| Page navigation | `page.goto()` resolves when loaded; `page.waitForURL()` for URL changes |
| Data loading after click | `await expect(spinner).not.toBeVisible()` then assert the data |
| Network request completes | `page.waitForResponse(pattern)` in parallel with the trigger |
| Animation or transition | `await expect(element).toBeVisible()` waits for stable position |
| Toast or notification appears | `await expect(page.getByRole('status')).toHaveText('...')` |

Parallel wait for a network request:

```typescript
await Promise.all([
  page.waitForResponse('**/rest/v1/articles**'),
  page.getByRole('button', { name: 'Apply Filter' }).click(),
])
await expect(page.getByRole('article')).not.toHaveCount(0)
```

This pattern clicks the button and simultaneously waits for the network response. Without the parallel wrapper, the click might complete before the wait is registered, and the response could be missed.

## The Arrange-Act-Assert pattern

Every test should have three clear phases:

```typescript
test('clicking the TypeScript filter updates the URL', async ({ page }) => {
  // Arrange: set up the preconditions
  await page.goto('/articles/browse')
  await expect(page.getByRole('main')).toBeVisible()

  // Act: do the thing being tested
  await page.getByRole('button', { name: 'TypeScript' }).click()

  // Assert: verify the outcome
  await expect(page).toHaveURL(/category=typescript/)
})
```

Each test should cover exactly one behavior. If a test does eight things, split it into smaller tests. A failing test with a clear scope tells you exactly what broke. A failing test that covers eight scenarios tells you almost nothing.

## Page Object Model

For pages with complex interactions, create a Page Object class that encapsulates locators and actions. This keeps test files clean and makes locators reusable.

```typescript
// test/e2e/pages/ArticlesBrowsePage.ts
import type { Page } from '@playwright/test'

export class ArticlesBrowsePage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/articles/browse')
  }

  get heading() {
    return this.page.getByRole('heading', { name: 'Articles' })
  }

  get filterList() {
    return this.page.getByRole('list', { name: /filters/i })
  }

  async filterByCategory(name: string) {
    await this.filterList.getByRole('button', { name }).click()
  }
}
```

```typescript
// test/e2e/articles-filter.spec.ts
it('filter chip updates the URL', async ({ page }) => {
  const browsePage = new ArticlesBrowsePage(page)
  await browsePage.goto()
  await browsePage.filterByCategory('TypeScript')
  await expect(page).toHaveURL(/category=typescript/)
})
```

Use Page Objects when a page has three or more interactions across multiple tests. For simple smoke tests, inline locators are fine.

## Isolating tests from each other

Each test must be fully independent. It cannot rely on state left by a previous test, and tests should not need to run in a specific order.

Playwright handles cookie and localStorage isolation automatically through fresh browser contexts per test.

What it does not handle: database state. Your e2e tests run against a real local Supabase. To keep tests independent:

**For read-only tests** (navigate, filter, read data): rely on a consistent seed that runs once before the suite. Read-only tests do not need teardown.

**For write tests** (form submission, creating records): clean up after the test, or use a separate seed that resets to a known state before each test.

The best strategy for most portfolio-style sites is to make the majority of e2e tests read-only and keep write-path tests minimal.

## Fixtures for reusable setup

When multiple tests need the same precondition (like being logged in), create a custom fixture instead of repeating the login flow in each test.

```typescript
import { test as base } from '@playwright/test'
import type { Page } from '@playwright/test'

const test = base.extend<{ authedPage: Page }>({
  authedPage: async ({ page }, use) => {
    await page.goto('/auth/login')
    await page.getByLabel('Email').fill('admin@test.com')
    await page.getByLabel('Password').fill('password')
    await page.getByRole('button', { name: 'Sign in' }).click()
    await page.waitForURL('/admin')
    await use(page)
    // context is destroyed after the test; no explicit logout needed
  },
})

test('admin sees the articles list', async ({ authedPage }) => {
  await authedPage.goto('/admin/articles')
  await expect(authedPage.getByRole('heading')).toBeVisible()
})
```

The `use(page)` call is where the test body runs. Everything before it is setup; nothing after it is needed for a browser test since the context is discarded.

## Network interception

Use `page.route()` to intercept requests for truly external third-party services you cannot control in a test environment.

```typescript
// Block analytics from loading during tests
await page.route('**/plausible.io/**', route => route.abort())

// Simulate a Turnstile success without the widget
await page.route('**/turnstile/**', route => {
  route.fulfill({ status: 200, body: 'ok' })
})
```

Do not mock your own API or Supabase in e2e tests. If you mock Supabase, you are no longer testing end-to-end. Reserve interception for third-party services that would fail, flicker, or require real credentials in a local environment.

## Debugging a failing test

**Headed mode** runs the browser visibly so you can watch what happens:

```bash
npx playwright test --headed
```

**Playwright Inspector** pauses before each action and shows the locator being used:

```bash
PWDEBUG=1 npx playwright test
```

**Trace viewer** replays a recorded trace after a failure:

```bash
npx playwright show-trace test-results/my-test/trace.zip
```

**`page.pause()`** drops a breakpoint in your test code:

```typescript
await page.goto('/articles/browse')
await page.pause()  // browser pauses here, Inspector opens
```

When a test is failing for unclear reasons, `--headed` and `page.pause()` together are usually enough to see what is actually happening.

## Further reading

- [Playwright: Best Practices](https://playwright.dev/docs/best-practices)
- [Playwright: Page Object Models](https://playwright.dev/docs/pom)
- [Playwright: Debugging](https://playwright.dev/docs/debug)
- [Playwright: Trace Viewer](https://playwright.dev/docs/trace-viewer-intro)
- [Playwright: Network](https://playwright.dev/docs/network)
$article$,
    'How to write Playwright tests that stay reliable over time. Covers testing behavior over implementation, the correct waiting strategies, Arrange-Act-Assert, Page Object Model, test isolation, and debugging tools.',
    (select id from public.article_categories where slug = 'web-development'),
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    4,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000015', id
from public.article_tags
where slug in ('playwright', 'e2e-testing', 'testing', 'typescript');


-- ============================================================
-- Part 5: Practical Playwright for Nuxt 4 + Supabase
-- ============================================================

insert into public.articles (id, title, slug, content, summary, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000016',
    'Practical Playwright for Nuxt 4 and Supabase',
    'practical-playwright-for-nuxt-4-and-supabase',
    $article$# Practical Playwright for Nuxt 4 and Supabase

The previous articles covered concepts and patterns in the abstract. This one applies them directly to a Nuxt 4 project backed by Supabase and PrimeVue. It covers how to structure the test suite, the prerequisites for running e2e tests, the first smoke tests, and the specific patterns for the kinds of features this stack tends to produce.

## How to think about the test pyramid for this stack

Given the tools available (pgTAP, `mountSuspended` + real Supabase, Playwright), each layer has a clear job:

| What to test | Where |
|---|---|
| Database schema, RLS policies, SQL functions | pgTAP in `supabase/tests/database/` |
| Component rendering, composables, RLS visible through the UI | `mountSuspended` + Vitest in `test/` |
| Navigation flows, URL-driven state, whole-app smoke | Playwright in `test/e2e/` |

The number of tests should follow the pyramid shape: many pgTAP and unit tests, fewer component integration tests, a small number of e2e tests covering the flows that nothing else can verify.

## Prerequisites before running e2e tests

Every Playwright run against this stack requires:

1. **Local Supabase running**: `pnpm run supabase:start`
2. **Database seeded**: `pnpm run db:reset` (or Supabase auto-seeds on start if configured)
3. **Browser binaries installed**: `npx playwright install chromium` (one-time per machine)
4. **`@nuxt/test-utils` and `@playwright/test` installed**: `pnpm add -D @nuxt/test-utils @playwright/test`

`@nuxt/test-utils` manages the Nuxt server build and startup. You do not need to run the dev server separately. Supabase is your responsibility to start before the tests run.

## Installation

```bash
pnpm add -D @nuxt/test-utils @playwright/test
npx playwright install chromium
```

## Vitest config for the e2e project

Add or confirm the e2e project in `vitest.config.ts`:

```typescript
{
  test: {
    name: 'e2e',
    include: ['test/e2e/**/*.spec.ts'],
    environment: 'node',
    testTimeout: 60_000,
    hookTimeout: 120_000,
  },
}
```

`environment: 'node'` is required. E2e tests do not use the Nuxt test environment; they drive a real browser.

## Running e2e tests

```bash
# Run only e2e tests
npx vitest run --project e2e

# Run all tests (unit + e2e)
npx vitest run
```

## The first test: a smoke suite

The highest-value test you can write is a smoke suite. It takes one minute to write and catches deployment disasters before anyone else does.

```typescript
// test/e2e/smoke.spec.ts
import { setup, createPage, url } from '@nuxt/test-utils/e2e'
import { expect } from '@playwright/test'
import { describe, it, beforeAll } from 'vitest'
import { fileURLToPath } from 'node:url'

await setup({
  rootDir: fileURLToPath(new URL('../../', import.meta.url)),
  browser: true,
})

describe('smoke', () => {
  it('home page loads', async () => {
    const page = await createPage(url('/'))
    await expect(page.getByRole('main')).toBeVisible()
    await page.close()
  })

  it('articles browse page loads', async () => {
    const page = await createPage(url('/articles/browse'))
    await expect(page.getByRole('heading', { name: /articles/i })).toBeVisible()
    await page.close()
  })

  it('projects page loads', async () => {
    const page = await createPage(url('/projects'))
    await expect(page.getByRole('heading', { name: /projects/i })).toBeVisible()
    await page.close()
  })
})
```

These three tests cover the main public pages. If any of them fail, the site is down or broken in a fundamental way.

## The category filter test

This is the test that motivated setting up Playwright in the first place: click a category chip on the articles browse page and assert the URL updates.

```typescript
// test/e2e/articles-filter.spec.ts
import { setup, createPage, url } from '@nuxt/test-utils/e2e'
import { expect } from '@playwright/test'
import { describe, it } from 'vitest'
import { fileURLToPath } from 'node:url'

await setup({
  rootDir: fileURLToPath(new URL('../../', import.meta.url)),
  browser: true,
})

describe('articles browse: category filter', () => {
  it('clicking a filter chip adds the category to the URL', async () => {
    const page = await createPage(url('/articles/browse'))
    await expect(page.getByRole('main')).toBeVisible()

    const chip = page.getByRole('list', { name: /filters/i })
      .getByRole('button')
      .first()
    await chip.click()

    await expect(page).toHaveURL(/category=/)
    await page.close()
  })

  it('clicking the active chip again removes the filter', async () => {
    const page = await createPage(url('/articles/browse'))
    await expect(page.getByRole('main')).toBeVisible()

    const chip = page.getByRole('list', { name: /filters/i })
      .getByRole('button')
      .first()

    await chip.click()
    await expect(page).toHaveURL(/category=/)

    await chip.click()
    await expect(page).not.toHaveURL(/category=/)
    await page.close()
  })
})
```

If the filter list does not have an ARIA name, add `aria-label="Category filters"` to the `<ul>` or `<ol>` element in the component. This makes the locator explicit and improves accessibility at the same time.

## Testing navigation to a detail page

```typescript
it('clicking an article card navigates to the article detail page', async () => {
  const page = await createPage(url('/articles/browse'))
  await expect(page.getByRole('main')).toBeVisible()

  const firstArticleLink = page.getByRole('article').first()
    .getByRole('link')
    .first()

  await firstArticleLink.click()
  await expect(page).toHaveURL(/\/articles\/[a-z0-9-]+$/)
  await expect(page.getByRole('main')).toBeVisible()
  await page.close()
})
```

The URL regex `/\/articles\/[a-z0-9-]+$/` matches any article slug without hardcoding a specific one. This keeps the test valid even after the seed data changes.

## Testing the contact form

```typescript
it('contact form shows a confirmation after submit', async () => {
  const page = await createPage(url('/contact'))
  await expect(page.getByRole('main')).toBeVisible()

  await page.getByLabel('Name').fill('Test User')
  await page.getByLabel('Email').fill('test@example.com')
  await page.getByLabel('Message').fill('This is a test message from Playwright.')
  await page.getByRole('button', { name: 'Send' }).click()

  await expect(page.getByRole('status')).toContainText(/sent|thank you/i)
  await page.close()
})
```

If the form uses Cloudflare Turnstile, intercept it before filling the form:

```typescript
await page.route('**/challenges.cloudflare.com/**', route => route.abort())
```

## What NOT to add Playwright tests for in this project

Given you already have `mountSuspended` + real Supabase from the integration test setup:

**Do not** write a Playwright test to verify RLS blocks unauthenticated reads. pgTAP covers the schema level, and `mountSuspended` covers the component level.

**Do not** write a Playwright test for every admin form field. That is component testing territory.

**Do not** write a Playwright test for SEO meta tags. `mountSuspended` can read the document head.

**Do not** write a Playwright test for every article card variant. Prototype pages and component tests handle visual layout verification.

**Do** write Playwright tests for navigation flows, URL state changes, form submissions, auth redirects, and smoke tests.

## Adding ARIA labels to support clean locators

When writing Playwright tests, you will sometimes find that `getByRole` needs an accessible name to be precise. Rather than falling back to CSS selectors, add the ARIA label to the element in your component.

This is a good practice regardless of testing. It makes your app more accessible and your locators more meaningful.

```html
<!-- Before: hard to target precisely -->
<ul class="filter-chips">...</ul>

<!-- After: targetable and accessible -->
<ul class="filter-chips" aria-label="Category filters">...</ul>
```

Now `page.getByRole('list', { name: 'Category filters' })` works cleanly.

## Quick reference

```bash
# Install
pnpm add -D @nuxt/test-utils @playwright/test
npx playwright install chromium

# Prerequisites before running
pnpm run supabase:start

# Run
npx vitest run --project e2e

# Debug
npx playwright test --headed
PWDEBUG=1 npx playwright test
npx playwright show-trace test-results/*/trace.zip
```

Core imports:

```typescript
import { setup, createPage, url } from '@nuxt/test-utils/e2e'
import { expect } from '@playwright/test'
import { describe, it } from 'vitest'
import { fileURLToPath } from 'node:url'
```

Locators used 90% of the time:

```typescript
page.getByRole('button', { name: 'Submit' })
page.getByRole('heading', { name: /articles/i })
page.getByRole('list', { name: 'Category filters' }).getByRole('button').first()
```

Assertions used 90% of the time:

```typescript
await expect(page).toHaveURL(/category=typescript/)
await expect(page.getByRole('article')).toBeVisible()
await expect(page.getByRole('main')).toBeVisible()
```

## Further reading

- [Playwright official documentation](https://playwright.dev/docs/intro)
- [Nuxt: Testing (official guide)](https://nuxt.com/docs/getting-started/testing)
- [@nuxt/test-utils GitHub repository](https://github.com/nuxt/test-utils)
- [Playwright: Best Practices](https://playwright.dev/docs/best-practices)
- [Playwright: Page Object Models](https://playwright.dev/docs/pom)
- [Supabase: Testing with pgTAP](https://supabase.com/docs/guides/database/extensions/pgtap)
- [ARIA roles reference (MDN)](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)
$article$,
    'A hands-on guide to writing Playwright e2e tests for a Nuxt 4 and Supabase project. Covers test structure, prerequisites, smoke tests, filter interactions, navigation flows, and what not to test at this layer.',
    (select id from public.article_categories where slug = 'web-development'),
    'f1e2d3c4-b5a6-7890-cdef-012345678901',
    5,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z',
    '2026-06-07T12:00:00Z'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000016', id
from public.article_tags
where slug in ('playwright', 'e2e-testing', 'testing', 'nuxt', 'typescript', 'vitest', 'supabase');
