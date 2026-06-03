# app/pages/admin/CLAUDE.md

Standards for building admin pages in this project. All `/admin/**` routes must follow these conventions. The global middleware at `app/middleware/admin.global.ts` guards every admin route automatically.

## Layouts

Two admin layouts exist. Every admin page must explicitly declare one:

- **`admin-list`** — list and index pages (`/admin/articles`, `/admin/projects`, etc.)
- **`admin-detail`** — editor, create, and edit pages (`/admin/articles/[id]`, `/admin/articles/new`, etc.)

Always set the page title via `route.meta.title` — the layout reads it automatically. Do not pass the title as a prop or hardcode it elsewhere.

```ts
// list page
definePageMeta({ layout: 'admin-list', title: 'Articles' })

// editor/create/edit wrapper page
definePageMeta({ layout: 'admin-detail', title: 'Edit Article' })
```

## Page header

Every admin page must use `<admin-page-header>` as its first child. It reads the title from `route.meta.title` automatically and exposes a `#actions` slot for right-side buttons.

Action buttons use `severity="secondary"` and `rounded`. Icons must be passed via the `#icon` slot (the `icon` prop only works with PrimeIcons — see `app/components/CLAUDE.md`).

```vue
<template>
  <admin-page-header>
    <template #actions>
      <p-button label="New Article" rounded severity="secondary" @click="navigateTo('/admin/articles/new')">
        <template #icon>
          <icon name="material-symbols:add-circle" />
        </template>
      </p-button>
    </template>
  </admin-page-header>

  <!-- page content -->
</template>
```

Never invent a bespoke page header. Component: `app/components/admin/AdminPageHeader.vue`.

## Page padding

The `admin-list` layout already provides horizontal padding (`px-6`) and the `<admin-page-header>` component provides top padding (`pt-6`). Do not add redundant padding in page wrapper divs.

```vue
<!-- ✅ correct — layout handles px, header handles pt -->
<template>
  <admin-page-header>...</admin-page-header>
  <div class="pb-8">
    <!-- page content -->
  </div>
</template>

<!-- ❌ wrong — p-6 double-pads horizontally and overwrites header top spacing -->
<template>
  <div class="p-6">
    <div class="flex justify-between ...">...</div>
    <!-- page content -->
  </div>
</template>
```

## Admin sections registry

`app/config/adminSections.ts` is the **single source of truth** for all admin pages. Every new admin page must add an entry here — no exceptions.

The registry is consumed by the Navbar User Menu, the `/admin` index page, and the future admin sidebar. A `toMenuItems()` utility exported from the same file converts the registry into PrimeVue `MenuItem[]` for `<p-tiered-menu>`.

```ts
// Shape reference — see app/config/adminSections.ts for the full file
interface AdminSection {
  label: string
  to: string
  icon: string          // Iconify material-symbols:* name
  description: string   // shown on the /admin index page
  getPublicUrl?: (row: Record<string, unknown>) => string  // omit if no public page
}
```

Current groups: **Content** (Articles, Categories, Series) · **Portfolio** (Projects, Companies, Skills) · **Inbox** (Contact Messages).

### Preview links (`getPublicUrl`)

If the entity has a public-facing page, define `getPublicUrl` on its registry entry:

```ts
getPublicUrl: (row) => `/articles/${(row as { slug: string }).slug}`
```

List pages where `getPublicUrl` is defined must render an eye icon button in the DataTable actions column that opens the URL in a new tab. Entities with no public page (companies, skills, contact messages) omit `getPublicUrl` entirely.

## Inline editing vs. separate editor pages

All admin entities use dedicated editor pages — no inline DataTable row editing. This applies even to simple entities with only a few plain-text fields.

| Situation | Pattern |
|---|---|
| Any editable entity | Separate editor page (`[id].vue` + `new.vue`) |
| Read-only with delete | Inline DataTable, no row-edit mode (contact messages pattern) |

Inline row editing (`edit-mode="row"`) is not used anywhere in the admin. It was tried for Companies but produced a broken, jarring UX (rows expand unexpectedly, file inputs inside editor slots are awkward). A simple editor page is cleaner and consistent with the rest of the admin.

## Zod validation

Required for every admin form that writes to the DB. Even a minimal schema marking required fields is enough — relying solely on DB constraints is not acceptable.

- Schema file: `app/schemas/<Entity><Insert|Update>Schema.ts` (see ADR-0010)
- Schema file exports the Zod schema only — no resolver, no inferred types
- `zodResolver(Schema)` is wired in the component's `<script setup>`

```ts
// in the component
import { zodResolver } from '@primevue/forms/resolvers/zod'
import { ArticleCategoryInsertSchema } from '~/schemas/ArticleCategoryInsertSchema'

const resolver = zodResolver(ArticleCategoryInsertSchema)
```

## Image upload

Always use the `useImageUpload()` composable. Never call `supabase.storage` directly for uploads.

```ts
const newPath = await useImageUpload('images', 'category-images', file, existingPath ?? undefined)
```

Reference implementation: `app/components/project/ProjectEditor.vue`.

> Note: `ArticleEditor.vue` still uses inline storage calls — that is a known deviation tracked for cleanup.

## DataTable conventions

### Sorting

All admin DataTables use a fixed server-side default sort (via `.order()` in the Supabase query) **and** enable client-side column sorting on the primary columns. Add `:sortable="true"` on each sortable column; PrimeVue handles the rest client-side without re-fetching.

Default sort by entity:
- Articles: `created_at DESC`
- Projects: `year DESC`
- Companies: `name ASC`

### Size and striped rows

All DataTables declare `size="small"` for a compact admin aesthetic. `striped-rows` is enabled on all tables.

### Global filter

All admin DataTables include a global text filter input rendered above the table (right-aligned, `placeholder="Search…"`). Wire it up with a `v-model:filters` binding and pass `:global-filter-fields` listing the string columns that should be searched.

```vue
<script setup>
import { FilterMatchMode } from '@primevue/core/api'

const filters = ref({ global: { value: null, matchMode: FilterMatchMode.CONTAINS } })
</script>

<template>
  <div class="flex justify-end mb-3">
    <p-input-text v-model="filters['global'].value" placeholder="Search…" size="small" />
  </div>
  <p-data-table v-model:filters="filters" :global-filter-fields="['title', 'status']" ...>
```

### Empty state

All DataTables set an `empty-message` prop: `"No <entities> found."` (e.g. `"No articles found."`).

### Actions column

The actions column is always the last column. Buttons are icon-only, `text` variant, `size="small"`. Use `<icon name="material-symbols:...">` via the `#icon` slot — never the `icon` prop (which only works with PrimeIcons).

- **Preview** (eye): `severity="secondary"` — opens the public page in a new tab. Only rendered when `getPublicUrl` is defined for this entity in the Admin Section Registry.
- **Delete** (trash): `severity="danger"` — opens a `<p-confirm-dialog>`.

There is no edit button in the actions column. Clicking the entity name navigates to the edit page.

## Data fetching

```ts
const { data: items, pending: loading, refresh } = await useAsyncData<Type[]>(
  'admin-<resource>',       // cache key: kebab-case, always prefixed with 'admin-'
  async () => {
    const { data, error } = await supabase
      .from('<table>')
      .select('<fields>')
      .order('<field>', { ascending: true })   // always include an order clause
    if (error) throw error
    return data as Type[]
  },
  { lazy: true }             // always lazy
)
```

Always throw on error — Nuxt catches it and shows the error page. Never silently swallow errors.

## Loading states

List pages must show a `<p-progress-spinner>` overlay while `pending` is true. Never render an empty DataTable while data is loading.

## Delete and state-change confirmation (ADR-0017)

All destructive actions use `<p-confirm-dialog>` (modal). This includes row-level deletes and state changes (publish, archive, unpublish). Never use `<p-confirm-popup>` for admin destructive actions.

```ts
function confirmDelete(id: string) {
  confirm.require({
    header: 'Delete <Resource>',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteResource(id),
  })
}
```

`<p-confirm-dialog>` must be present in the template (or provided by the layout).

## Toast durations

- Success: `life: 3000`
- Error / warning: `life: 4000`

## Icons

Use `<icon name="material-symbols:...">` from `@nuxt/icon`. Never use `pi pi-*` classes in admin pages (see ADR-0001).
