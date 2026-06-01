# app/components/CLAUDE.md

## Folder structure

Components are organized by domain subfolder. Every component belongs in the folder that matches its domain:

- `article/` — article display, editing, navigation
- `auth/` — login, register, Turnstile, auth-related UI
- `layout/` — navbar, header, footer, page shell
- `portfolio/` — skills snapshot, featured projects
- `project/` — project cards, timelines

**Root-level** (`app/components/`) is reserved for cross-cutting UI primitives with no single domain owner (e.g. a generic `LoadingSpinner.vue` used by multiple unrelated domains). If you can name a domain it belongs to, put it in that folder.

When in doubt, pick the closest domain folder rather than leaving a component at root.

## PrimeVue slot overrides

If a component overrides the *entire* item slot of a PrimeVue wrapper (e.g. `#item` on `<p-breadcrumb>`), drop the PrimeVue wrapper and render a plain HTML element directly. Keeping the wrapper only to override its full output adds slot-scoped type noise (PrimeVue's `MenuItem` types are intentionally broad) without any benefit. Render directly over your own typed props instead.

## Naming

Use PascalCase for file names (Nuxt auto-import convention). In templates, always use the kebab-case equivalent — see the project-level `CLAUDE.md` for the component naming rule.