# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
npm run dev          # Start dev server at http://localhost:3000
npm run build        # Build for production
npm run preview      # Preview production build

npm run supabase:types  # Regenerate types/database.types.ts from remote Supabase schema
npm run db:reset        # Reset linked remote Supabase DB and re-run migrations + seeds
```

There is no test suite configured.

## Architecture

This is a **Nuxt 4** personal portfolio site (mschir.dev) backed by **Supabase** (PostgreSQL + auth).

### Directory layout

- `app/` — Nuxt application root (pages, components, layouts, plugins)
- `shared/types/` — TypeScript types shared across the app; `database.types.ts` is auto-generated from Supabase; domain types (e.g. `Projects.ts`) re-export from it
- `supabase/migrations/` — ordered SQL migration files that define the schema
- `supabase/seeds/` — numbered seed SQL files (`01_blog.sql`, `02_content.sql`, `03_projects.sql`, `04_project_skills.sql`)
- `primevue-theme.ts` — custom PrimeVue theme imported by `nuxt.config.ts`

### Key patterns

**Data fetching** — pages call `useSupabaseClient()` directly inside `useAsyncData()` with `lazy: true`. There is no intermediate service/store layer for reads.

**Type flow** — Supabase generates `shared/types/database.types.ts`. Domain type files in `shared/types/` create named aliases (e.g. `export type Project = Database['public']['Tables']['projects']['Row']`). Components import from those aliases, not from `database.types.ts` directly.

**Auth** — Supabase auth via `@nuxtjs/supabase`. All routes are excluded from redirect (`exclude: ['/**']`), so auth is opt-in per page. `useSupabaseUser()` is available everywhere; login/logout live in the navbar.

**UI** — PrimeVue 4 components are auto-imported with the `p` prefix (e.g. `<p-card>`, `<p-button>`). Dark mode is always active (`htmlAttrs.class: 'dark-mode'`). PrimeVue `DialogService` and `ToastService` are registered as Nuxt plugins.

**Forms** — Zod schemas validated with `@primevue/forms/resolvers/zod` inside PrimeVue `<p-form>`.

### Database schema (high level)

- **Blog domain**: `articles`, `article_topics`, `article_tags`, `article_tags_links`, `article_series`, `article_interactions`, `comments`, `featured_articles`
- **Portfolio domain**: `projects`, `companies`, `project_skills` (M2M), `skills`, `skill_categories`
- **Contact**: `contact_messages`
- RLS is enabled on all tables; `projects` has a public read policy; most other tables restrict based on `auth.uid()`

### After schema changes

1. Add a migration file in `supabase/migrations/` with a timestamp prefix
2. Run `npm run db:reset` to apply it to the linked remote
3. Run `npm run supabase:types` to regenerate `shared/types/database.types.ts`
4. Update or add domain type aliases in `shared/types/` if new tables were added

### Testing

**Test folder placement — every agent must follow these rules:**

| What you're testing | Folder | Framework |
|---|---|---|
| Pure functions, utils, helpers | `test/unit/` | Vitest (no Nuxt runtime) |
| Components, composables, store-dependent code | `test/nuxt/` | `@nuxt/test-utils` + Vitest |
| Shared mocks and test setup | `test/helpers/` | — |


**Naming conventions:**
- All test files: `*.test.ts`
- Mirror the source path under the matching test folder — e.g. `app/components/field/InplaceText.vue` → `test/nuxt/components/field/InplaceText.test.ts`
- Composable tests: `test/nuxt/composables/useXyz.test.ts`
- Util tests: `test/unit/utils/xyzUtils.test.ts`