# app/components/CLAUDE.md

## Folder structure

Components are organized by domain subfolder. Every component belongs in the folder that matches its domain:

- `admin/` — admin shell components: `AdminPageHeader`, future admin sidebar
- `article/` — article display, editing, navigation
- `auth/` — login, register, Turnstile, auth-related UI
- `layout/` — navbar, header, footer, page shell
- `portfolio/` — skills snapshot, featured projects
- `project/` — project cards, timelines

**Root-level** (`app/components/`) is reserved for cross-cutting UI primitives with no single domain owner (e.g. a generic `LoadingSpinner.vue` used by multiple unrelated domains). If you can name a domain it belongs to, put it in that folder.

When in doubt, pick the closest domain folder rather than leaving a component at root.

## PrimeVue slot overrides

If a component overrides the *entire* item slot of a PrimeVue wrapper (e.g. `#item` on `<p-breadcrumb>`), drop the PrimeVue wrapper and render a plain HTML element directly. Keeping the wrapper only to override its full output adds slot-scoped type noise (PrimeVue's `MenuItem` types are intentionally broad) without any benefit. Render directly over your own typed props instead.

## CTA buttons

Primary calls-to-action (buttons the user should act on) use the global `btn-accent` class, not the default primary fill:

```html
<p-button label="Get in Touch" class="btn-accent"/>
<p-button label="Send Message" class="btn-accent" type="submit"/>
```

Default `<p-button>` (no extra class) uses the primary color and is appropriate for secondary actions and admin UI. Reserve `btn-accent` for the one button on a page that most needs attention.

## Icons inside `<p-button>`

The `icon` prop on `<p-button>` only works with PrimeIcons class names (`pi pi-*`). This project avoids PrimeIcons in admin pages (see ADR-0001). To use a `material-symbols:*` or any Iconify icon inside a button, use the `#icon` named slot instead.

Always add `class="text-lg"` to the `<icon>` inside the slot — without it the icon inherits the button's font size and renders too small, especially with `size="small"` buttons.

```vue
<!-- icon-only button (e.g. table action) — no size="small", it overrides font-size and shrinks the icon -->
<p-button text severity="danger" aria-label="Delete">
  <template #icon>
    <icon name="material-symbols:delete-outline" class="text-lg" />
  </template>
</p-button>

<!-- icon + label (e.g. save button) -->
<p-button label="Save" severity="success">
  <template #icon>
    <icon name="material-symbols:save" class="text-lg" />
  </template>
</p-button>
```

Never pass an Iconify name to the `icon` prop — it will silently render nothing.

## Naming

Use PascalCase for file names (Nuxt auto-import convention). In templates, always use the kebab-case equivalent — see the project-level `CLAUDE.md` for the component naming rule.