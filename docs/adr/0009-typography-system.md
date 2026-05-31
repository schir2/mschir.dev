# ADR 0009 — Typography System

## Status

Accepted

## Context

The site launched with no custom font configured — all text rendered in the OS system font stack. The homepage hero and article reading experience both felt flat as a result. Issue #57 tracked resolving this.

Three questions needed answering before implementation:

1. **One font or two?** A single font keeps things simple; a display/body split can create stronger visual hierarchy but requires more coordination across layers.
2. **Which fonts?** Font choice affects brand personality and readability, especially on a dark background.
3. **Where does the display font apply?** Too narrow (h1 only) and the serif feels disconnected from the rest of the site. Too broad (all headings) and it creates visual noise inside technical articles.

The site uses three CSS systems simultaneously (PrimeVue, Tailwind, md-editor-v3), so any font decision must be applied consistently across all three layers to avoid inconsistency between PrimeVue components, Tailwind-styled elements, and article content rendered by the markdown editor.

## Decision

### Two-font system

A display/body split rather than a single font. The serif/sans-serif contrast creates clear visual hierarchy and lets the display font carry weight on the hero and article titles without being overused.

- **Display font**: Fraunces (variable serif) — chosen for its expressive character at large sizes (the optical-size axis makes it more decorative at `text-6xl` and cleaner at smaller sizes), its strong presence on the dark hero gradient, and good editorial feel for article titles.
- **Body font**: Inter (sans-serif) — chosen for its screen readability across all sizes, from small UI labels to long-form article prose. Pairs cleanly with Fraunces without competing.

Fonts load via Google Fonts `<link>` tags in `nuxt.config.ts`. The `@nuxt/fonts` module was considered but rejected — the optimization gains do not justify the added dependency for a two-font portfolio site.

### Display font scope: h1 and h2 only

Fraunces applies to `h1` and `h2` elements across the site. `h3` and below use Inter.

**Why not all headings**: Serif `h3`/`h4`/`h5` inside technical articles (with code blocks, CLI output, diagrams) creates visual noise and competes with the content. The serif is most effective when used sparingly for structural moments.

**Why h2 and not h1 only**: Major section breaks inside articles (`h2`) benefit from the same visual weight as the article title, making the document structure scannable. Dropping to Inter at `h2` would make long articles feel disconnected from their titles.

### Three-layer implementation

| Layer | File | Change |
|---|---|---|
| PrimeVue | `primevue-theme.ts` | `semantic.fontFamily: "'Inter', sans-serif"` — PrimeVue components inherit Inter automatically |
| Tailwind | `tailwind.config.ts` | `fontFamily.sans: ['Inter', 'sans-serif']`, `fontFamily.display: ['Fraunces', 'serif']` |
| Global CSS | `app/assets/css/main.css` | `h1, h2 { font-family: 'Fraunces', serif; }` — covers all components without per-component changes |
| md-editor-v3 | `app/assets/css/overrides/md-editor.css` | Explicit `h1, h2` override inside `#article-detail .md-editor-preview` to win over library-internal styles |

The Tailwind key is named `display` (class: `font-display`) rather than `fraunces`. This decouples the utility class from the specific typeface — if the display font changes, only `tailwind.config.ts` needs updating, not every template that uses the class.

### Hero type scale

| Element | Class |
|---|---|
| Name "Marek Schir" (h1) | `text-6xl` |
| Subtitle | `text-2xl` |
| Headline copy | `text-xl` |

The previous scale (`text-6xl` / `text-lg` / `text-xl`) had almost no differentiation between the subtitle and headline. The subtitle bump to `text-2xl` creates a clear three-level hierarchy.

## Consequences

- All heading typography flows from two places: `main.css` (global `h1, h2` rule) and `tailwind.config.ts` (font family definitions). Changing either font requires only those two files plus the Google Fonts URL in `nuxt.config.ts`.
- PrimeVue components inherit Inter automatically via the `semantic.fontFamily` token — no per-component overrides needed.
- The `font-display` Tailwind class is available when a component needs to explicitly force the display font outside of `h1`/`h2` (e.g. a large pull-quote or section label).
- md-editor-v3 article content is covered by both the global CSS rule and an explicit override in `app/assets/css/overrides/md-editor.css` — the explicit override ensures Fraunces wins over any library-internal heading styles.
