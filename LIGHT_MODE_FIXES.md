# Light Mode Style Pass — Issue #114

Pick this up fresh. The dark/light mode toggle is already live and working. This task is purely fixing components that hardcode dark-end palette tokens so they look correct in both modes.

## Background

- `@nuxtjs/color-mode` is installed. It adds/removes `.dark-mode` on `<html>`.
- PrimeVue `darkModeSelector: '.dark-mode'` — PrimeVue tokens adapt automatically.
- Tailwind `darkMode: ['selector', '.dark-mode']` — `dark:` utilities respond to the class.
- `useMdEditorTheme()` already watches `.dark-mode` via MutationObserver — no changes needed there.

## Token strategy (resolved in grilling session)

Two mechanisms — pick the right one per use case:

| Need | Use |
|---|---|
| Card / panel background | scoped CSS: `background: var(--p-content-background)` |
| Card / panel border | scoped CSS: `border-color: var(--p-content-border-color)` |
| Chip / pill background | Tailwind utility: `bg-emphasis` (maps to `var(--p-content-hover-background)`) |
| Chip hover background | scoped CSS: `background: var(--p-content-border-color)` on hover rule |
| Body / chip text | Tailwind utility: `text-color` |
| Muted / secondary text | Tailwind utility: `text-muted-color` |
| Emphasis text (e.g. company name) | Tailwind utility: `text-color-emphasis` |

**Never** use `dark:` pairs like `bg-surface-100 dark:bg-surface-900` — semantic tokens cover all cases here and are cleaner.

**Footer stays always-dark** — intentional design decision. Do NOT change the footer background. Only fix one bug there (see below).

---

## File-by-file changes

### 1. `app/components/article/ArticleCard.vue`

Card wrapper (~line 54):
- Remove `bg-surface-900` and `border-surface-800` and `hover:border-surface-700` from the class string
- In `<style scoped>`, the card already has a `.group` selector — extend it (or add a new `.article-card` class):
  ```css
  .article-card {
    background: var(--p-content-background);
    border-color: var(--p-content-border-color);
  }
  .article-card:hover {
    border-color: color-mix(in srgb, var(--p-primary-color) 60%, transparent);
  }
  ```
  Add `article-card` to the wrapper element's class.

Text colors:
- ~line 86: `text-surface-300` → `text-color`
- ~line 88: `text-surface-400` → `text-muted-color`
- ~line 109: `text-surface-400` → `text-muted-color`
- ~line 116: `text-surface-500` → `text-muted-color`

Divider (~line 124): remove `border-surface-800`; add a scoped class:
```css
.tag-divider { border-color: var(--p-content-border-color); }
```

Tag chips (~line 129): replace `bg-surface-800 text-surface-300 hover:bg-surface-700 transition-colors` with `bg-emphasis text-color tag-chip transition-colors`
```css
.tag-chip:hover { background: var(--p-content-border-color); }
```

Hidden tag badge (~line 137): `bg-surface-800 text-surface-500` → `bg-emphasis text-muted-color`

---

### 2. `app/components/project/ProjectCard.vue`

Same pattern as ArticleCard:

Card wrapper (~line 50): remove `bg-surface-900 border-surface-800 hover:border-surface-700`; add `.project-card` scoped class:
```css
.project-card {
  background: var(--p-content-background);
  border-color: var(--p-content-border-color);
}
.project-card:hover {
  border-color: color-mix(in srgb, var(--p-primary-color) 60%, transparent);
}
```

Text colors:
- ~line 62: `text-surface-300` → `text-color`
- ~line 70: `text-surface-400` → `text-muted-color`

Divider (~line 74): remove `border-surface-800`; add `.skill-divider { border-color: var(--p-content-border-color); }`

Skill chips (~line 78): `bg-surface-800 text-surface-300` → `bg-emphasis text-color`

Overflow badge (~line 85): `bg-surface-800 text-surface-500` → `bg-emphasis text-muted-color`

---

### 3. `app/pages/index.vue` — service pillar cards

Pillar card (~line 89): remove `bg-surface-900 border-surface-700` from the class string.

The card already has `.pillar-card` in `<style scoped>`. Add to it:
```css
.pillar-card {
  background: var(--p-content-background);
  border-color: var(--p-content-border-color);
  /* keep all existing hover/glow/transition rules */
}
```

**Leave alone:**
- ~line 63: `text-white` on hero h1 — hero gradient is permanently dark, this is correct
- ~line 175: `color: #fff !important` in scoped CSS — same reason

---

### 4. `app/pages/contact.vue`

Pure text-color swaps, no structural changes:
- ~line 61: `text-surface-400` → `text-muted-color`
- ~line 73: `text-surface-300` → `text-muted-color`
- ~line 81, 85, 89, 93: `text-surface-300` → `text-muted-color`

---

### 5. `app/pages/articles/[slug].vue`

Tag chips (~line 140):
Replace `bg-surface-800 text-surface-300 hover:bg-surface-700 hover:text-surface-100 transition-colors`
with `bg-emphasis text-color transition-colors`

If the page has no `<style scoped>` block yet, just drop the hover color change — it's a minor UX detail not worth adding a style block for.

---

### 6. `app/pages/projects/[slug].vue`

**Leave alone:**
- ~line 78: `text-white` — inside `bg-gradient-to-t from-black/80` hero overlay, always dark

Text swaps:
- ~line 99: `text-surface-200` → `text-color-emphasis`
- ~line 100: `text-surface-600` → `text-muted-color`
- ~line 101: `text-surface-400` → `text-muted-color`

Skill chips (~line 109): `bg-surface-800 text-surface-300` → `bg-emphasis text-color`

---

### 7. `app/components/layout/footer.vue` — one-line fix only

The footer background (`var(--p-surface-900)`) and all its scoped CSS text colors are palette values — they're stable and do NOT need changing.

The only bug: the "Marek Schir" name span (~line 21) has no explicit color class, so it inherits `--p-text-color` which flips to dark in light mode against the dark footer background.

Fix: add `text-surface-100` to the span:
```html
<span class="font-semibold text-lg text-surface-100">Marek Schir</span>
```

---

## Verification checklist

After making changes, start the dev server (`pnpm run dev`) and toggle between dark and light mode using the sun/moon button in the navbar. Check each page:

- [ ] `/` — service pillar cards adapt; article cards adapt; hero stays white-text
- [ ] `/portfolio` — project cards adapt; skills section text readable
- [ ] `/articles` — article card list adapts
- [ ] `/articles/[any-slug]` — tag chips readable in both modes
- [ ] `/projects/[any-slug]` — skill chips and metadata text readable
- [ ] `/contact` — body text readable in light mode
- [ ] Footer — "Marek Schir" name visible in both modes; footer stays dark

## Related issues

- #112 — `@nuxtjs/color-mode` setup (done)
- #113 — navbar toggle button (done)
- #114 — this task
