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

## Naming

Use PascalCase for file names (Nuxt auto-import convention). In templates, always use the kebab-case equivalent — see the project-level `CLAUDE.md` for the component naming rule.