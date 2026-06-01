# ADR 0008 — CSS Layering Strategy

## Status

Accepted

## Context

The site uses three CSS systems simultaneously:

1. **PrimeVue Aura** — a component library with a semantic design token system (`--p-primary-*`, `--p-surface-*`, etc.) customised in `primevue-theme.ts`. Dark mode is always active (`htmlAttrs.class: 'dark-mode'`).
2. **Tailwind CSS** — utility classes for layout, spacing, and typography.
3. **md-editor-v3** — a markdown editor/preview library that ships its own global CSS, imported once in `app/plugins/md-editor-v3.client.ts`.

Without a documented layering strategy, color values from different systems end up mixed in templates (e.g. raw `text-red-600` alongside PrimeVue tokens), overrides for third-party libraries accumulate ad-hoc in individual page `<style>` blocks, and there is no single place to look for customisations.

## Decision

### Three-layer rule

| Layer | Responsibility | How to use |
|---|---|---|
| **PrimeVue tokens** | Colors, spacing scale, border-radius, shadows | `var(--p-primary-500)`, `var(--p-surface-card)`, `text-primary`, etc. Single source of truth for the visual language. |
| **Tailwind utilities** | Layout, positioning, flex/grid, responsive breakpoints, spacing | `flex`, `gap-4`, `max-w-4xl`, `hidden lg:block`, etc. No semantic color class names. |
| **Third-party overrides** | Adapting external library CSS to the site's design tokens | One file per library in `app/assets/css/overrides/`. Override selectors use `var(--p-*)` tokens so dark mode stays consistent. |

Custom component styles that don't fit either layer use `<style scoped>` with `var(--p-*)` for any color values.

### No raw color values in templates

Raw Tailwind color names (`text-red-600`, `bg-yellow-500`, `from-indigo-500`) are **not** used for brand colors. All color references go through PrimeVue tokens so the theme file remains the single source of truth. Layout-neutral utilities like `text-white` on a known dark background are acceptable exceptions.

### Inline style exception — per-row dynamic hex colors

`:style` bindings are permitted **only** when a color value is a dynamic, per-entity hex string that cannot be expressed as a PrimeVue token. The documented case is the `ArticleCard` category chip: `article_categories.color` is an arbitrary hex value set per category in the database. There is no PrimeVue token that can represent it, and a CSS class cannot be generated at runtime for each possible value.

All other inline styles remain prohibited. This exception does not extend to static colors, spacing, or any value that could be expressed through the token system.

### Global CSS entry point

`app/assets/css/main.css` is registered in `nuxt.config.ts` as the sole custom CSS entry point. It contains only `@import` statements — no styles directly. Adding overrides for a new library means: create `app/assets/css/overrides/<lib>.css` and add one `@import` line to `main.css`.

### Brand palette

Defined in `primevue-theme.ts` as `definePreset(Aura, { semantic: { ... } })`:

- **`primary`** — indigo scale. Structural UI color: buttons, links, active states.
- **`accent`** — amber scale. Highlights, CTAs, personal touches.
- **`success`** — emerald scale. Positive feedback states.

## Consequences

- All color decisions flow through `primevue-theme.ts`. Changing the brand color requires one file edit.
- Third-party library overrides are findable and bounded — one file per library under `app/assets/css/overrides/`.
- Tailwind's color palette is still available but its use for brand colors is a code smell to flag in review.
- New developers can apply the three-layer rule mechanically without needing to know PrimeVue internals.