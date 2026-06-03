# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

- **OS**: WSL2 (Ubuntu/Linux) on Windows 10 Pro
- **Shell**: bash — all commands use standard bash syntax
- **Path separators**: Use forward slashes (`/`) in paths.
- **Environment variables**: Read with `$VAR_NAME`, set with `export VAR_NAME=value`.
- **Chaining commands**: Use `&&` to chain. Use `;` when you don't care if the prior step fails.

## Commands

```bash
pnpm install          # Install dependencies
pnpm run dev          # Start dev server at http://localhost:3000
pnpm run build        # Build for production
pnpm run preview      # Preview production build

pnpm run supabase:start  # Start local Supabase stack (required before test:db and local dev against DB)
pnpm run supabase:types  # Regenerate types/database.types.ts from remote Supabase schema — fails in non-TTY (see note below)
pnpm run db:reset        # Reset local Supabase DB and re-run migrations + seeds
pnpm run db:migrate      # Apply pending migrations to the local DB without a full reset
pnpm run test:db         # Run pgTAP database tests (requires supabase:start)
pnpm run test:edge       # Run Deno edge function tests
pnpm run seed:assets     # Upload cover images to Supabase Storage and set image_url on articles/projects (see supabase/seed-assets/)
nuxi typecheck            # TypeScript type check — requires pnpm approve-builds to have been run once interactively first (see note below)
```

> **IDE diagnostics**: When running inside WebStorm, the `mcp__ide__getDiagnostics` tool is available and returns live TypeScript errors from the IDE without spawning a type-check process. Prefer it over `nuxi typecheck` for quick diagnostic checks during development. Call it with no arguments to get diagnostics for all open files, or pass a `uri` to check a specific file.

> **pnpm non-TTY note**: Claude Code runs without a TTY, so any pnpm command that triggers interactive prompts will fail with `ERR_PNPM_ABORTED_REMOVE_MODULES_DIR_NO_TTY` or `ERR_PNPM_IGNORED_BUILDS`. If `nuxi typecheck` or other pnpm commands fail with those errors, the user must run `pnpm approve-builds` once in their own terminal to approve build scripts for `@parcel/watcher` and `esbuild`. The `.npmrc` setting `confirm-module-purge=false` suppresses the purge prompt; the builds approval is a one-time manual step.

> **supabase:types non-TTY workaround**: `pnpm run supabase:types` also fails in non-TTY environments. Use this command instead to regenerate `shared/types/database.types.ts`:
> ```bash
> npx supabase gen types typescript --local > shared/types/database.types.ts
> ```
> Similarly, `pnpm run db:reset` fails via pnpm in non-TTY but succeeds with `npx supabase db reset` directly.

## Architecture

This is a **Nuxt 4** personal portfolio site (mschir.dev) backed by **Supabase** (PostgreSQL + auth).

### Directory layout

- `app/` — Nuxt application root (pages, components, layouts, plugins); see `app/components/CLAUDE.md` for component folder organization
- `app/types/` — frontend-only exported types (composable interfaces, UI shapes with no server consumers); see `app/types/CLAUDE.md`
- `shared/types/` — TypeScript types shared across the app; `database.types.ts` is auto-generated from Supabase; domain types (e.g. `Projects.ts`) re-export from it
- `supabase/migrations/` — ordered SQL migration files that define the schema
- `supabase/seeds/` — numbered seed SQL files run in order: `01_blog.sql`, `02_content.sql`, `03_projects.sql`, `04_project_skills.sql`, `05_test_users.sql` (test user for integration tests)
- `supabase/seed.sql` — runs before numbered seeds; enables the pgTAP extension for local dev
- `supabase/seed-assets/covers/` — cover images for articles and projects, one subfolder per slug (e.g. `articles/getting-started-with-supabase/cover.png`); uploaded via `pnpm run seed:assets`; image files are gitignored, folder structure is tracked
- `scripts/` — one-off dev utility scripts (not part of the Nuxt app)
- `supabase/tests/` — pgTAP database tests and Deno edge function tests; see `supabase/tests/CLAUDE.md`
- `primevue-theme.ts` — custom PrimeVue theme imported by `nuxt.config.ts`

### Key patterns

**Data fetching** — pages call `useSupabaseClient()` directly inside `useAsyncData()` with `lazy: true`. There is no intermediate service/store layer for reads.

**Type flow** — Supabase generates `shared/types/database.types.ts`. Domain type files in `shared/types/` create named aliases (e.g. `export type Project = Database['public']['Tables']['projects']['Row']`). Components import from those aliases, not from `database.types.ts` directly. Three tiers: `shared/types/` (DB-derived, server+client), `app/types/` (frontend-only exported), local (unexported, single-file). See `shared/types/CLAUDE.md` and `app/types/CLAUDE.md`.

**Auth** — Supabase auth via `@nuxtjs/supabase`. All routes are excluded from redirect (`exclude: ['/**']`), so auth is opt-in per page. `useSupabaseUser()` is available everywhere; login/logout live in the navbar.

**UI** — PrimeVue 4 components are auto-imported with the `p` prefix (e.g. `<p-card>`, `<p-button>`). Dark mode is always active (`htmlAttrs.class: 'dark-mode'`). PrimeVue `DialogService` and `ToastService` are registered as Nuxt plugins.

**CSS layering** — three layers in strict priority order: (1) PrimeVue tokens (`var(--p-primary-*)`, `var(--p-surface-*)`) for all colors; (2) Tailwind utilities for layout/spacing/breakpoints only — no raw color class names for brand colors; (3) third-party overrides in `app/assets/css/overrides/<lib>.css`, imported via `app/assets/css/main.css`. See `docs/adr/0008-css-layering-strategy.md`.

**No inline styles** — never use `style=""` attributes for colors or theming. Component-specific color overrides belong in `<style scoped>` using `var(--p-*)` tokens. Inline styles bypass the theme system and are invisible to scoped overrides.

**Typography** — two-font system: Fraunces (serif, display) + Inter (sans-serif, body). A global `h1, h2` rule in `app/assets/css/main.css` applies Fraunces automatically — no class needed on headings. Use the `font-display` Tailwind utility only when forcing Fraunces outside of `h1`/`h2` (e.g. a large pull-quote). Never hardcode `font-family` strings in component templates or scoped styles. See `docs/adr/0009-typography-system.md`.

**Forms** — Zod schemas validated with `@primevue/forms/resolvers/zod` inside PrimeVue `<p-form>`.

**md-editor-v3** — `MdEditor`, `MdPreview`, and `MdCatalog` are registered globally in `app/plugins/md-editor-v3.client.ts`. Three props are required on every usage:
- `language="en-US"` — the library defaults to `zh-CN`; omitting this produces Chinese UI strings
- `:theme="mdTheme"` — use the `useMdEditorTheme()` composable; do not hardcode `"dark"`
- `scroll-element="html"` on `<md-catalog>` — the default scroll target is the non-scrollable preview wrapper; without this, TOC clicks do nothing

**Removing the default black/white background** — wrap every read-only `<md-preview>` in `<div class="md-content-preview">`. The CSS in `app/assets/css/overrides/md-editor.css` targets `.md-content-preview > .md-editor` and makes the background transparent with correct token-based colors. Do not add per-page `#editor-id` selectors — the wrapper class handles all pages uniformly.

See `docs/adr/0006-md-editor-v3-for-article-rendering.md` for the full rationale and CSS override patterns.

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

## UI and Visual Work

### Prototype before implementing

For any task that involves redesigning a visual component's layout — especially one the user described as wanting to "play around with" or "prototype" — **build a visible prototype first and get explicit approval before writing tests or wiring to pages.**

**The rule:**
1. Build a throwaway prototype page (e.g. `/prototype/article-card`) with hardcoded fixture data — no Supabase needed, no real pages touched
2. Show the user multiple layout variants side-by-side if the brief calls for exploration
3. Wait for the user to say the design looks good before proceeding to: writing component tests, hooking into real pages, or dispatching subagents to wire up layouts

**Why this matters:** Skipping the prototype phase and going straight to spec implementation burned significant tokens on a component that was visually broken — tests passed but the layout was wrong. Tests verify behavior, not visual correctness. A 5-minute browser check would have caught the issues that a full test suite missed.

**Signal words that mean "prototype first":** "play around with", "experiment", "try out", "see what it looks like", "not sure if I like", "explore options", any layout redesign where the user has not pre-approved a specific design.

## Code Style

### PrimeVue token Tailwind utilities

PrimeVue exposes its design tokens as Tailwind utilities — always use those instead of inline `style` attributes with `var(--p-*)` CSS variables:

```html
<!-- ✅ Tailwind utility -->
<span class="text-muted-color">...</span>
<icon class="text-primary" />

<!-- ❌ inline style — bypasses the theme system and triggers linting errors -->
<span style="color: var(--p-text-muted-color)">...</span>
<icon style="color: var(--p-primary-color)" />
```

The one accepted exception is dynamic `:style` bindings where a color value comes from data (e.g. a category color from the database), which may use a token as a fallback: `:style="{ backgroundColor: item.color ?? 'var(--p-surface-500)' }"`.

### Component naming in templates

Always use kebab-case for component names in templates, not PascalCase. This applies to all components:

- PrimeVue (already kebab-case by design): `<p-button>`, `<p-form>`, `<p-input-text>`
- Custom components: `<turnstile-placeholder>`, not `<TurnstilePlaceholder>`
- `@nuxt/icon`: `<icon name="...">`, not `<Icon name="...">`

### Variable naming

Always use full, descriptive variable names. Never use single-letter variables or opaque abbreviations. Code must be readable at a glance.

### TypeScript style

Prefer explicit typing over inference. Annotate `computed<T>()` return types and local arrays with their type rather than relying on inference from the first element:

```typescript
// ✅ explicit
const crumbs: Crumb[] = [{ label: 'Articles', to: '/articles' }]
const breadcrumbs = computed<Crumb[]>(() => { ... })

// ❌ inferred — inference from first element locks in a too-narrow type
const crumbs = [{ label: 'Articles', to: '/articles' }]
```

Avoid the `as` keyword. Cast only where genuinely unavoidable — the one accepted exception is coercing Supabase query return types to domain aliases (`return (data ?? []) as ArticleCardItem[]`), because Supabase's inferred structural type is not directly assignable to hand-crafted domain types.

Use generics with explicit type parameters rather than relying on inference. When a type has optional variants, prefer optional fields over union types where possible.