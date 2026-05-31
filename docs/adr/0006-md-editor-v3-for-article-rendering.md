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
- `<md-editor>` in the admin editor page
- `<md-editor-v3 type="preview">` (read-only) on the public article page

Use md-editor-v3's own built-in CSS for all article content styling. Do not apply Tailwind Typography `prose` classes to article content.

## Reasons
- md-editor-v3 is Vue 3 native and ships official plugins for both Mermaid and KaTeX — the two hard requirements
- Using the same component on both surfaces guarantees the editor preview is pixel-identical to the public view (true WYSIWYG)
- A custom remark/rehype pipeline with Mermaid and KaTeX would require wiring and maintaining the rendering stack manually, with no WYSIWYG guarantee
- md-editor-v3 also provides a built-in `onUploadImg` callback for inline image uploads, covering the inline content image requirement without custom UI

## Consequences
- `prose` classes are not used for article content; md-editor-v3's own styles govern article typography
- Article rendering is coupled to md-editor-v3's release cadence — switching editors later would require migrating the public article page too
- Tailwind Preflight conflicts with the editor container must be handled via CSS scoping if they arise