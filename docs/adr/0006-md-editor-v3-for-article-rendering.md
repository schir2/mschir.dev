# ADR 0006 — md-editor-v3 for Article Editing and Public Rendering

## Status
Accepted

## Context
Articles are stored as markdown text in the `articles.content` column. Two surfaces need to render that content:
1. The admin editor (write + live preview)
2. The public article page (read-only display)

The rendering requirements are non-standard: Mermaid diagram support, KaTeX math/formula support, and consistent appearance between editor preview and the public view.

The project already has `@tailwindcss/typography` installed. The obvious default would be to render markdown to HTML server-side (remark/rehype pipeline) and apply `prose` classes for typography.

## Decision
Use **md-editor-v3** for both surfaces:
- `MdEditor` component in the admin editor page
- `MdPreview` component (read-only, lighter bundle) on the public article page
- `MdCatalog` component for the TOC sidebar on the public article page

All three components are registered globally via `app/plugins/md-editor-v3.client.ts` (Nuxt `.client.ts` convention — runs client-side only). On the public article page, `MdPreview` and `MdCatalog` are wrapped in `<client-only>` because Mermaid rendering requires browser APIs. `md-editor-v3/lib/style.css` (full CSS) is imported once in the plugin and covers all components.

Use md-editor-v3's own built-in CSS for all article content styling. Do not apply Tailwind Typography `prose` classes to article content.

### Configuration requirements (non-obvious)

**Language** — md-editor-v3 defaults to `zh-CN`. Always pass `language="en-US"` to `MdPreview` and `MdEditor` to get English UI strings (copy buttons, fold/expand labels, etc.).

**Theme** — md-editor-v3 has its own theme system independent of PrimeVue. Use the `useMdEditorTheme()` composable (`app/composables/useMdEditorTheme.ts`) which watches the `dark-mode` class on `<html>` via `MutationObserver` and returns `'dark' | 'light'`. Bind this to the `:theme` prop on all md-editor-v3 components. Do not hardcode `theme="dark"`.

**Preview background** — `MdPreview` renders with its own background colour (`#fff` / `#000`). Override by wrapping any `<md-preview>` in `<div class="md-content-preview">`. The CSS in `app/assets/css/overrides/md-editor.css` scopes the fix to `.md-content-preview > .md-editor`, targeting the component's root element via its parent:
```css
.md-content-preview > .md-editor { background: transparent; border: none; box-shadow: none; padding: 0; }
.md-content-preview > .md-editor .md-editor-preview-wrapper { padding: 0; }
.md-content-preview > .md-editor .md-editor-preview { --md-theme-bg-color: transparent; }
```
This works for any `editor-id` value — no per-page CSS rule needed.

**MdCatalog scroll target** — `MdCatalog`'s default `scrollElement` is `#${editorId}-preview-wrapper`, the non-scrollable inner div of the preview. Clicking TOC links will silently do nothing unless you override it. Always pass `scroll-element="html"` to target the page scroll container.

**Icon sizing in rendered content** — skill and tag icon chips use `w-4 h-4` (not `text-sm`) for consistent 16px rendering. `logos:*` icons have variable internal SVG padding; explicit pixel sizing normalises them.

## Reasons
- md-editor-v3 is Vue 3 native and ships official plugins for both Mermaid and KaTeX — the two hard requirements
- Using the same component on both surfaces guarantees the editor preview is pixel-identical to the public view (true WYSIWYG)
- A custom remark/rehype pipeline with Mermaid and KaTeX would require wiring and maintaining the rendering stack manually, with no WYSIWYG guarantee
- md-editor-v3 also provides a built-in `onUploadImg` callback for inline image uploads, covering the inline content image requirement without custom UI

## Consequences
- `prose` classes are not used for article content; md-editor-v3's own styles govern article typography
- Article rendering is coupled to md-editor-v3's release cadence — switching editors later would require migrating the public article page too
- Tailwind Preflight conflicts with the editor container must be handled via CSS scoping if they arise
- Three non-obvious configuration pitfalls exist (language, theme, catalog scroll target) — see Configuration requirements above