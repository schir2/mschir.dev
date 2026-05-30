# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

- **OS**: Windows 10 Pro
- **Shell**: PowerShell 7 (`pwsh`) — all commands use PowerShell syntax
- **Path separators**: Use backslashes (`\`) in paths. In Python string literals passed to `shell -c`, backslashes must be doubled (e.g., `"C:\\Users\\schir\\..."`).
- **Environment variables**: Read with `$env:VAR_NAME`, set with `$env:VAR_NAME = "value"` — not bash `export` syntax.
- **Chaining commands**: Use `&&` to chain (PowerShell 7 supports this). Use `;` when you don't care if the prior step fails.
- **No Unix-only tools**: `grep` → `Select-String`, `find` → `Get-ChildItem -Recurse`, `touch` → `New-Item`, `which` → `(Get-Command name).Source`.

## Commands

```powershell
pnpm install          # Install dependencies
pnpm run dev          # Start dev server at http://localhost:3000
pnpm run build        # Build for production
pnpm run preview      # Preview production build

pnpm run supabase:start  # Start local Supabase stack (required before test:db and local dev against DB)
pnpm run supabase:types  # Regenerate types/database.types.ts from remote Supabase schema
pnpm run db:reset        # Reset local Supabase DB and re-run migrations + seeds
pnpm run db:migrate      # Apply pending migrations to the local DB without a full reset
pnpm run test:db         # Run pgTAP database tests (requires supabase:start)
pnpm run test:edge       # Run Deno edge function tests
```

## Architecture

This is a **Nuxt 4** personal portfolio site (mschir.dev) backed by **Supabase** (PostgreSQL + auth).

### Directory layout

- `app/` — Nuxt application root (pages, components, layouts, plugins)
- `shared/types/` — TypeScript types shared across the app; `database.types.ts` is auto-generated from Supabase; domain types (e.g. `Projects.ts`) re-export from it
- `supabase/migrations/` — ordered SQL migration files that define the schema
- `supabase/seeds/` — numbered seed SQL files run in order: `01_blog.sql`, `02_content.sql`, `03_projects.sql`, `04_project_skills.sql`, `05_test_users.sql` (test user for integration tests)
- `supabase/seed.sql` — runs before numbered seeds; enables the pgTAP extension for local dev
- `supabase/tests/` — pgTAP database tests and Deno edge function tests; see `supabase/tests/CLAUDE.md`
- `primevue-theme.ts` — custom PrimeVue theme imported by `nuxt.config.ts`

### Key patterns

**Data fetching** — pages call `useSupabaseClient()` directly inside `useAsyncData()` with `lazy: true`. There is no intermediate service/store layer for reads.

**Type flow** — Supabase generates `shared/types/database.types.ts`. Domain type files in `shared/types/` create named aliases (e.g. `export type Project = Database['public']['Tables']['projects']['Row']`). Components import from those aliases, not from `database.types.ts` directly.

**Auth** — Supabase auth via `@nuxtjs/supabase`. All routes are excluded from redirect (`exclude: ['/**']`), so auth is opt-in per page. `useSupabaseUser()` is available everywhere; login/logout live in the navbar.

**UI** — PrimeVue 4 components are auto-imported with the `p` prefix (e.g. `<p-card>`, `<p-button>`). Dark mode is always active (`htmlAttrs.class: 'dark-mode'`). PrimeVue `DialogService` and `ToastService` are registered as Nuxt plugins.

**Forms** — Zod schemas validated with `@primevue/forms/resolvers/zod` inside PrimeVue `<p-form>`.

### Database schema (high level)

See `CONTEXT.md` for the domain model.

### After schema changes

1. Add a migration file in `supabase/migrations/` with a timestamp prefix
2. Run `pnpm run db:reset` to apply it to the linked remote
3. Run `pnpm run supabase:types` to regenerate `shared/types/database.types.ts`
4. Update or add domain type aliases in `shared/types/` if new tables were added

### Testing

Two separate test suites — do not mix them:

| Layer | Location | Runner | Command |
|---|---|---|---|
| Vue components, composables, utils | `test/` | Vitest | `pnpm test` |
| DB tables, functions, RLS policies | `supabase/tests/database/` | pgTAP | `pnpm run test:db` |
| Edge functions | `supabase/functions/tests/` | Deno | `pnpm run test:edge` |

See `test/CLAUDE.md` for Vitest rules. See `supabase/tests/CLAUDE.md` for pgTAP and edge function rules.

## Agent skills

### Issue tracker

Issues live in GitHub Issues on `schir2/mschir.dev`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default canonical label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context repo — one `CONTEXT.md` + `docs/adr/` at the root. See `docs/agents/domain.md`.

## Code Style

### Component naming in templates

Always use kebab-case for component names in templates, not PascalCase. This applies to all components:

- PrimeVue (already kebab-case by design): `<p-button>`, `<p-form>`, `<p-input-text>`
- Custom components: `<turnstile-placeholder>`, not `<TurnstilePlaceholder>`
- `@nuxt/icon`: `<icon name="...">`, not `<Icon name="...">`

### Variable naming

Always use full, descriptive variable names. Never use single-letter variables or opaque abbreviations. Code must be readable at a glance.