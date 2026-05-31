# ADR-0007: Global page transition — fade + scale

## Status
Accepted

## Context
No page transitions were configured. All route changes were instant cuts, which felt abrupt on a portfolio site.

## Decision
Use Nuxt's built-in `pageTransition` with a **fade + scale** animation: incoming pages fade in (opacity 0 → 1) while scaling up from 98% to 100%. The outgoing page fades out only (no transform on leave). Duration: 300ms enter, 200ms leave, `ease` timing, `out-in` mode so pages never overlap.

CSS lives in `app/layouts/default.vue` as a non-scoped `<style>` block under the `.page-*` transition class names. Configured in `nuxt.config.ts` via `app.pageTransition: { name: 'page', mode: 'out-in' }`.

`prefers-reduced-motion` is respected: the scale transform is suppressed and duration reduced to 150ms for users who have requested reduced motion.

Alternatives considered:
- **Pure crossfade** — clean but felt flat, especially on a dark background.
- **Fade + upward drift** (translateY 8px) — also considered; scale was preferred as it felt more cohesive with the dark theme.

## Consequences
- All page navigations use the same transition automatically — no per-page configuration needed.
- To override a specific page, use `definePageMeta({ pageTransition: { name: 'my-name' } })` and add the matching `.my-name-*` CSS to `default.vue` or a global CSS file.
- The transition name `page` is the authoritative hook. Do not rename it without updating both `nuxt.config.ts` and the CSS.