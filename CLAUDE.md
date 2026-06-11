# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

- **OS**: WSL2 (Ubuntu/Linux) on Windows 10 Pro
- **Shell**: bash — all commands use standard bash syntax
- **Path separators**: Use forward slashes (`/`) in paths.
- **Environment variables**: Read with `$VAR_NAME`, set with `export VAR_NAME=value`.
- **Chaining commands**: Use `&&` to chain. Use `;` when you don't care if the prior step fails.

## Commands

> **Never run the dev server.** Do not run `pnpm run dev` or `pnpm run preview`. The user manages the dev server themselves.

> **Never remove modules or dependencies without explicit confirmation.** If a module appears unused, always ask before removing it — it may be planned for upcoming work. This applies to `nuxt.config.ts` modules, `package.json` dependencies, and any registered plugins.

> **Permission prompts for "never do X" rules.** When the user says "never do X" and it relates to a tool permission (e.g. "never run the dev server", "never push without asking"), ask whether it should be added as a permission rule in `.claude/settings.json` (project-scoped) or `~/.claude/settings.json` (user-scoped, applies across all projects). Some rules belong only here; others are better enforced by the harness. Ask before adding to settings — scope matters.

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
- `packages/portfolio-mcp/` — (planned) Portfolio MCP server; pnpm workspace package published as `@mschir/portfolio-mcp`; see #170 and ADR-0026

### Key patterns

**Data fetching** — pages call `useSupabaseClient()` directly inside `useAsyncData()` with `lazy: true`. There is no intermediate service/store layer for reads. Exception: article and project detail pages omit `lazy: true` so SSR can await the data and populate meta tags before sending HTML to crawlers.

**SEO** — every public page calls `usePageSeo({ title, description, image?, type?, publishedAt? })` from `~/composables/usePageSeo`. It sets the `<title>` (with `titleTemplate`), all `og:*` and `twitter:*` meta tags, and the canonical link. Admin, auth, and prototype routes are noindexed via `nuxt-robots` and must not call `usePageSeo`. See `app/pages/CLAUDE.md` for the full pattern and `docs/adr/0021-seo-strategy.md` for the decision record.

**Type flow** — Supabase generates `shared/types/database.types.ts`. Domain type files in `shared/types/` create named aliases (e.g. `export type Project = Database['public']['Tables']['projects']['Row']`). Components import from those aliases, not from `database.types.ts` directly. Three tiers: `shared/types/` (DB-derived, server+client), `app/types/` (frontend-only exported), local (unexported, single-file). See `shared/types/CLAUDE.md` and `app/types/CLAUDE.md`.

**Auth** — Supabase auth via `@nuxtjs/supabase`. All routes are excluded from redirect (`exclude: ['/**']`), so auth is opt-in per page. `useSupabaseUser()` is available everywhere; login/logout live in the navbar.

**UI** — PrimeVue 4 components are auto-imported with the `p` prefix (e.g. `<p-card>`, `<p-button>`). All PrimeVue components are available — `nuxt.config.ts` uses `include: '*'` so no registration step is needed when adding a new component. Color mode follows the user's system preference (`preference: 'system'`, `fallback: 'dark'`); the active mode is applied as a class on `<html>` with `-mode` suffix (e.g. `dark-mode`, `light-mode`). PrimeVue's `darkModeSelector` is set to `.dark-mode`. PrimeVue `DialogService` and `ToastService` are registered as Nuxt plugins.

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

### After adding environment variables

Whenever a new environment variable is introduced (in `nuxt.config.ts`, an edge function, a script, or anywhere else):

1. Add it to `.env.example` with a blank or placeholder value and a short comment describing what it's for.
2. If it is a production secret used by the deploy pipeline, add a row for it in the **Required GitHub secrets** table in `README.md`.

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

### Prose and copy style

Voice, tone, AI-tell patterns, heading style, and article structure rules for all written copy on this site. See `.claude/skills/copy-style/REFERENCE.md`. Use `/copy-style` when writing or rewriting any user-facing prose.

## UI and Visual Work

### PrimeVue-first for admin pages

Admin pages must use PrimeVue components whenever one fits the need. Do not build custom components for admin UI unless no PrimeVue component can satisfy the requirement. Consistency matters more than aesthetics here — admin is a tool, not a showcase.

For public-facing pages (homepage, services, article pages), custom components are appropriate when visual design calls for it. The dividing line: if you're building something a visitor sees and you're optimizing for visual impact, custom is fine. If you're building something the site owner uses to manage data, reach for PrimeVue first.

### PrimeVue container components

Prefer PrimeVue structural components over raw HTML elements with manual CSS for layout containers, separators, and scrollable regions. They carry correct theme-aware surface tokens out of the box — no scoped CSS needed for light/dark mode.

| Need | PrimeVue component | Notes |
|---|---|---|
| Scrollable region with themed background | `<p-scrollpanel>` | Replaces `<div class="overflow-y-auto">` + manual background color; handles custom scrollbar styling too |
| Labeled content group / card | `<p-panel>` | Use `#header` slot for eyebrow-style labels (`text-xs uppercase tracking-widest`) |
| Row separator inside a panel or list | `<p-divider class="my-0">` | Replaces `border-b border-surface-*` on individual rows |

**Why this matters:** Raw Tailwind surface utilities like `bg-surface-900` are fixed palette values — they do not flip between light and dark mode. PrimeVue component backgrounds use semantic CSS custom properties (`var(--p-*)`) that the theme switches automatically via the `.dark-mode` selector. Always prefer a PrimeVue container over a raw element when a themed background is needed.

See `app/pages/admin/CLAUDE.md` for admin-specific examples of `p-panel` and `p-divider`.

### Prototype before implementing

For any task that involves redesigning a visual component's layout — especially one the user described as wanting to "play around with" or "prototype" — **build a visible prototype first and get explicit approval before writing tests or wiring to pages.**

**The rule:**
1. Build a throwaway prototype page (e.g. `/prototype/article-card`) with hardcoded fixture data — no Supabase needed, no real pages touched
2. Show the user multiple layout variants side-by-side if the brief calls for exploration
3. Wait for the user to say the design looks good before proceeding to: writing component tests, hooking into real pages, or dispatching subagents to wire up layouts

**Why this matters:** Skipping the prototype phase and going straight to spec implementation burned significant tokens on a component that was visually broken — tests passed but the layout was wrong. Tests verify behavior, not visual correctness. A 5-minute browser check would have caught the issues that a full test suite missed.

**Signal words that mean "prototype first":** "play around with", "experiment", "try out", "see what it looks like", "not sure if I like", "explore options", any layout redesign where the user has not pre-approved a specific design.

## Code Style

### Spacing & Padding

**Scale — two-tier**:
- **Layout spacing** (between components, sections, content blocks): 8-point grid only. Valid: `p-2` (8px), `p-4` (16px), `p-6` (24px), `p-8` (32px), `p-10` (40px), `p-12` (48px), `p-16` (64px). Off-grid values (`gap-3`, `gap-5`, `p-3`, `p-5`) are not permitted.
- **Micro-spacing** (inside a single atomic UI element — a chip, badge, or icon+label pair that renders as one visual unit): 4-point grid is allowed (`py-1`, `px-2`, `gap-1`, `gap-1.5`). The boundary is: spacing *between* elements → 8-point; spacing *inside* one atomic element → 4-point.

**No external margin anywhere**: Neither components nor page templates may set `mb-*` or `mt-*`. External spacing is always the parent's responsibility via `gap` on a flex container.

**Admin page layer model**:

| Layer | Class responsibility |
|---|---|
| `admin-list` layout | `px-6` — horizontal edges |
| `AdminPageHeader` | `pt-6 pb-4` — internal only, no `mb-*` |
| Page wrapper (list pages) | `flex flex-col gap-8 pb-8` |
| Page wrapper (detail pages) | `flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8` |
| Individual components | Internal padding only — never compensate for outer context |

```vue
<!-- ✅ list page wrapper -->
<template>
  <div class="flex flex-col gap-8 pb-8">
    <admin-page-header>...</admin-page-header>
    <div><!-- page content --></div>
  </div>
</template>

<!-- ✅ detail page wrapper -->
<template>
  <div class="flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8">
    <admin-page-header>...</admin-page-header>
    <p-form class="flex flex-col gap-6" ...><!-- form fields --></p-form>
  </div>
</template>

<!-- ❌ wrong — pt-6 double-pads with header; mb-* leaks outside component box -->
<template>
  <div class="px-6 pt-6 pb-8">
    <admin-page-header class="mb-6">...</admin-page-header>
  </div>
</template>
```

**Public page layer model**:

| Layer | Class responsibility |
|---|---|
| `page` layout | `px-6 pt-6 pb-8` — all outer shell padding; pages add none |
| Page root | `flex flex-col gap-*` — gaps between top-level sections |
| Section blocks | `flex flex-col gap-*` on their own — no `mb-*`/`mt-*` on children |

```vue
<!-- ✅ public page pattern -->
<template>
  <section class="flex flex-col gap-16">
    <div class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Section Title</h2>
      <some-content-component />
    </div>
  </section>
</template>

<!-- ❌ wrong — mb-* on h2 and no flex container -->
<template>
  <section>
    <h2 class="text-2xl font-bold mb-6">Section Title</h2>
    <some-content-component />
  </section>
</template>
```

### Color roles — primary vs accent

Two semantic colors serve distinct purposes. Never swap them:

- **Primary (violet)** — structural UI chrome: nav active states, focus rings, links, default button fills, form control highlights. Anything that says "this is interactive."
- **Accent (amber)** — anything that needs to *stand out*: CTAs the user should act on, featured-content markers (the amber left bar on article/project cards), icon highlights on feature sections (service pillars).

```html
<!-- ✅ CTA that should grab attention -->
<p-button label="Get in Touch" class="btn-accent"/>

<!-- ✅ Featured content marker — amber means featured, site-wide -->
<div class="w-1.5 bg-amber-500 self-stretch"/>

<!-- ❌ Don't use primary for a primary CTA — it reads as chrome, not action -->
<p-button label="Get in Touch"/>
```

**`btn-accent` class** is defined globally in `app/assets/css/main.css`. It sets amber background, amber border, and dark text (`--p-surface-950`) so the label is readable on the warm background. Use it on any `<p-button>` that is a primary call-to-action.

### Feature card hover pattern

Feature sections (service pillars, etc.) use a consistent interactive card style. Key elements:

- **Border**: `border-surface-700` at rest → `color-mix(in srgb, var(--p-accent-500) 50%, transparent)` on hover
- **Glow shadow**: `box-shadow: 0 0 48px -8px color-mix(in srgb, var(--p-accent-500) 30%, transparent)` on hover
- **Top accent bar**: `position: absolute; inset-x: 0; top: 0; height: 2px` with a `linear-gradient(to right, transparent, var(--p-accent-500), transparent)` — opacity 0 at rest, 1 on hover
- **Icon**: `color: var(--p-accent-400)`, scales to 110% on hover

Use scoped CSS with `var(--p-accent-*)` tokens for all hover color values — do not hardcode hex values for the glow.

### Service pillar layout (C3)

The canonical layout for service pillar cards is a horizontal strip:

```html
<div class="pillar-card group relative flex items-center gap-6 p-6 rounded-xl border border-surface-700 bg-surface-900 overflow-hidden">
  <div class="pillar-top-bar absolute inset-x-0 top-0 h-0.5"/>
  <div class="flex flex-col gap-2 flex-1">
    <h3 class="font-display text-2xl font-semibold leading-tight">{{ title }}</h3>
    <p class="text-base leading-relaxed text-muted-color">{{ description }}</p>
  </div>
  <icon :name="icon" class="pillar-icon flex-shrink-0 text-6xl"/>
</div>
```

Icon sits on the **right**, vertically centered with the text block. Title uses `font-display` (Fraunces). Hover effects via the feature card pattern above.

### Confirm dialog severity

All `confirm.require()` calls must set `acceptProps` and `rejectProps` using PrimeVue 4's props API — never `acceptClass`/`rejectClass` (PrimeVue 3 style).

| Dialog type | `acceptProps` severity | `rejectProps` severity |
|---|---|---|
| Destructive (delete, archive, unpublish) | `danger` | `secondary` + `outlined: true` |
| Confirming a save / positive action (publish, submit) | `success` | `secondary` + `outlined: true` |

Cancel/reject buttons are always `secondary` + `outlined: true` — this keeps them visually recessive so the primary action has full attention.

```typescript
// ✅ Destructive action
confirm.require({
  header: 'Delete Project',
  message: 'This cannot be undone.',
  acceptLabel: 'Delete',
  rejectLabel: 'Cancel',
  acceptProps: { severity: 'danger' },
  rejectProps: { severity: 'secondary', outlined: true },
  accept: () => deleteProject(id),
})

// ✅ Positive / save action
confirm.require({
  header: 'Publish article',
  message: 'This will make the article visible to all visitors.',
  acceptLabel: 'Publish',
  rejectLabel: 'Cancel',
  acceptProps: { severity: 'success' },
  rejectProps: { severity: 'secondary', outlined: true },
  accept: () => togglePublished(true),
})

// ❌ Old PrimeVue 3 API — do not use
confirm.require({
  acceptClass: 'p-button-danger',
  ...
})
```

### Button conventions

Every `<p-button>` should have an intentional severity. The full matrix:

| Use case | Severity / class | Notes |
|---|---|---|
| Primary CTA ("Get in Touch", "Send Message") | `class="btn-accent"` | Amber; defined in `main.css` |
| Save / submit / publish | `severity="success"` | Any button that persists or confirms a positive action |
| Delete / archive / unpublish | `severity="danger"` | Any irreversible or destructive action |
| Cancel / back / reject | `severity="secondary"` + `outlined` | Always recessive — never competes with the primary action |
| Secondary/neutral actions | `severity="secondary"` | No `outlined` when it's a peer action, not a cancel |
| Table icon-only actions | `text` + appropriate severity | No `size="small"` — it shrinks the icon; see below |

**Cancel and back buttons** always use `severity="secondary"` with `outlined`:

```html
<!-- ✅ Cancel in a form toolbar -->
<nuxt-link to="/admin/skills">
  <p-button label="Cancel" severity="secondary" outlined/>
</nuxt-link>

<!-- ✅ Reject in a confirm dialog -->
rejectProps: { severity: 'secondary', outlined: true }
```

**Table action buttons** use `text` variant with no `size="small"` (it reduces font-size and shrinks the icon). Use `text-lg` on the icon inside the `#icon` slot:

```html
<p-button text severity="danger" aria-label="Delete">
  <template #icon>
    <icon name="material-symbols:delete-outline" class="text-lg"/>
  </template>
</p-button>

<p-button text severity="secondary" aria-label="View">
  <template #icon>
    <icon name="material-symbols:visibility-outline" class="text-lg"/>
  </template>
</p-button>
```

### PrimeVue token Tailwind utilities

PrimeVue exposes its design tokens as Tailwind utilities — always use those instead of inline `style` attributes or scoped CSS classes that wrap `var(--p-*)` CSS variables. Both are the same anti-pattern: they duplicate the token system and bypass the Tailwind layer.

```html
<!-- ✅ Tailwind utility -->
<span class="text-muted-color">...</span>
<icon class="text-primary" />

<!-- ❌ inline style — bypasses the theme system and triggers linting errors -->
<span style="color: var(--p-text-muted-color)">...</span>
<icon style="color: var(--p-primary-color)" />

<!-- ❌ scoped CSS wrapper class — same anti-pattern as inline style, just indirected -->
<!-- .my-label { color: var(--p-surface-400); } -->
<span class="my-label">...</span>
```

If a color can be expressed as a PrimeVue Tailwind token utility (`text-muted-color`, `text-color`, `text-primary`, `bg-surface-*`, etc.), use the utility directly on the element. Do not create a named scoped class that only wraps a single token assignment.

Scoped CSS is only appropriate for structural or behavioral rules that cannot be expressed in Tailwind: complex pseudo-selectors, `:deep()` overrides, multi-property hover transitions on a unique element. A one-line color assignment is never a valid reason for a scoped class.

The one accepted exception is dynamic `:style` bindings where a color value comes from data (e.g. a category color from the database), which may use a token as a fallback: `:style="{ backgroundColor: item.color ?? 'var(--p-surface-500)' }"`.

### Component naming in templates

Always use kebab-case for component names in templates, not PascalCase. This applies to all components:

- PrimeVue (already kebab-case by design): `<p-button>`, `<p-form>`, `<p-input-text>`
- Custom components: `<turnstile-placeholder>`, not `<TurnstilePlaceholder>`
- `@nuxt/icon`: `<icon name="...">`, not `<Icon name="...">`

**Internal links: always `<nuxt-link>`, never `<router-link>`.** This is a Nuxt project — `<nuxt-link>` is the correct component and adds Nuxt-specific prefetch behaviour. `<router-link>` works but is a Vue Router primitive that bypasses Nuxt's layer. For external links use a plain `<a>` with `target="_blank" rel="noopener noreferrer"`.

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

## Prose Writing and Copy

**This section is about written language — not CSS, not code formatting.**

The full rule set (voice, tone, AI-tell patterns, heading style) lives in `.claude/skills/copy-style/REFERENCE.md`. Article-specific rules (structure, audience context, type overlays) live in `.claude/skills/copy-style/references/article.md`.

**Always invoke `/copy-style`** before writing or rewriting any user-facing prose on this site: service pages, article body, project descriptions, taglines, summaries, page hero copy, contact page copy, email templates, CTA blurbs — any text a visitor reads. The skill reads the rules at runtime.