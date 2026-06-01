# app/types/CLAUDE.md

Frontend-only exported types live here. These are types that are reused across multiple frontend files (components, composables, utils, pages) but have no server-side consumers and no direct Supabase table origin.

## What belongs here

- Composable parameter/return shapes that callers need to reference (e.g. the `SeriesArticle` interface accepted by `useSeriesNavigation`)
- UI navigation shapes shared across multiple components (e.g. `Crumb` used by `Breadcrumb.vue`, `PageHeader.vue`, and article pages)
- UI-specific types that are exported and reused across multiple files but are not DB-derived
- Any type that crosses file boundaries within the frontend but does not belong in `shared/types/`

## What does NOT belong here

- Types derived from Supabase table rows → use `shared/types/` instead
- Unexported local types used only once in a single file → keep them local in that file

## File naming

Singular PascalCase matching the primary entity the types relate to (e.g. `Article.ts` for series navigation shapes related to articles). Mirror the naming in `shared/types/` where applicable.