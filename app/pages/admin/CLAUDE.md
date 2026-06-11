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

The `admin-list` layout provides horizontal padding (`px-6`) and `<admin-page-header>` provides top padding (`pt-6`). Page wrappers use `flex flex-col gap-8` so the header-to-content gap is automatic — `AdminPageHeader` must not set `mb-*`.

**List pages** — the outer wrapper is the gap+bottom container; search + table are grouped inside a nested div:

```vue
<!-- ✅ list page -->
<template>
  <div class="flex flex-col gap-8 pb-8">
    <admin-page-header>...</admin-page-header>
    <p-progress-spinner v-if="loading" />
    <div v-else class="flex flex-col gap-4">
      <div class="flex justify-end">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>
      <p-data-table .../>
    </div>
  </div>
</template>
```

**Detail/create pages** — same principle; add `max-w-2xl mx-auto px-6` since `admin-detail` layout provides no container:

```vue
<!-- ✅ detail page -->
<template>
  <div class="flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8">
    <admin-page-header>...</admin-page-header>
    <p-form class="flex flex-col gap-6" ...>...</p-form>
  </div>
</template>
```

```vue
<!-- ❌ wrong — pt-6 double-pads with header; flat pb-8 without gap loses the header separation -->
<template>
  <div class="px-6 pt-6 pb-8">
    <admin-page-header>...</admin-page-header>
    <div class="pb-8">...</div>
  </div>
</template>
```

## PrimeVue structural components

Use PrimeVue's own structural components for grouping and separation — never raw Tailwind borders or custom divider markup.

### Grouping content: `p-panel`

Use `<p-panel>` whenever a page section has a label/header and a body of rows or form fields. The `header` prop renders the group label with PrimeVue's own chrome (border, background, typography). The panel body provides consistent padding and surface color automatically.

```vue
<!-- ✅ group of related rows on the admin index page -->
<p-panel header="Content">
  <!-- rows inside -->
</p-panel>

<!-- ❌ custom header + manual border -->
<div>
  <span class="text-xs uppercase tracking-widest text-muted-color">Content</span>
  <div class="border border-surface-700 rounded">...</div>
</div>
```

### Separating rows: `p-divider`

Use `<p-divider>` to separate rows inside a `p-panel` or any other content block. It uses PrimeVue's surface tokens for its line color — no `border-b border-surface-*` classes on individual rows.

```vue
<!-- ✅ rows separated by p-divider -->
<template v-for="(item, index) in items" :key="item.id">
  <p-divider v-if="index > 0" class="my-0" />
  <div class="flex items-center gap-4 py-2">...</div>
</template>

<!-- ❌ raw Tailwind border on each row -->
<div class="border-b border-surface-800 last:border-b-0 py-3">...</div>
```

`class="my-0"` on `p-divider` removes the default vertical margin when rows already have their own `py-*` padding.

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

List pages where `getPublicUrl` is defined must render an eye icon button in the DataTable actions column that opens the URL in a new tab. Use `<nuxt-link target="_blank" rel="noopener noreferrer">` wrapping the `<p-button>` — never `window.open()` in a template expression (Vue 3 sandboxes `window` and the call silently does nothing). Entities with no public page (companies, skills, contact messages) omit `getPublicUrl` entirely.

```vue
<nuxt-link :to="`/articles/${row.slug}`" target="_blank" rel="noopener noreferrer">
  <p-button text severity="secondary" aria-label="View article">
    <template #icon>
      <icon name="material-symbols:visibility-outline" class="text-lg" />
    </template>
  </p-button>
</nuxt-link>
```

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

Use `useAdminImageField()` for any admin form that includes an image or file upload. It encapsulates the staged-file state, preview URL, and upload error handling in one composable.

```ts
// new.vue (no existing image)
const { previewUrl, onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')

// [id].vue (with existing image from DB)
const { previewUrl, onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images', entity.image_url)
```

In `onSubmit`, call `uploadAndGet(currentPath)`:
- Returns `currentPath` unchanged when no file was staged (no-op).
- Uploads the staged file and returns the new path when a file was staged.
- Toasts an error and re-throws on upload failure — catch and return early, no additional toast needed.

```ts
let newImagePath: string | null
try {
  newImagePath = await uploadAndGet(entity.image_url ?? null)
} catch {
  return  // composable already toasted the error
}
```

Bind `previewUrl` and `onFilePicked` directly to the image input in the template:

```html
<img v-if="previewUrl" :src="previewUrl" class="w-16 h-16 object-cover rounded" />
<input type="file" accept="image/*" @change="onFilePicked" />
```

**Do not** call `useImageUpload()` directly in page files. `useAdminImageField()` wraps it.

> Note: `ArticleEditor.vue` still uses inline storage calls — that is a known deviation tracked for cleanup.

## Color normalization

Use `normalizeColor()` from `~/utils/normalizeColor` to convert raw color picker values before writing to the DB. It returns `null` for empty strings and prepends `#` if missing.

```ts
import { normalizeColor } from '~/utils/normalizeColor'
// normalizeColor('ff0000') → '#ff0000'
// normalizeColor('#ff0000') → '#ff0000'
// normalizeColor('') → null
```

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
  <div class="flex justify-end">
    <p-input-text v-model="filters['global'].value" placeholder="Search…" size="small" />
  </div>
  <p-data-table v-model:filters="filters" :global-filter-fields="['title', 'status']" ...>
```

### Empty state

All DataTables set an `empty-message` prop: `"No <entities> found."` (e.g. `"No articles found."`).

### Actions column

The actions column is always the last column. Buttons are icon-only, `text` variant, `size="small"`. Use `<icon name="material-symbols:...">` via the `#icon` slot — never the `icon` prop (which only works with PrimeIcons).

- **Preview** (eye): `severity="secondary"` — opens the public page in a new tab via `<nuxt-link target="_blank">` wrapping the button. Only rendered when `getPublicUrl` is defined for this entity in the Admin Section Registry.
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

`<p-confirm-dialog>` is provided by both admin layouts — **do not add it to individual page templates**.

## Toast durations

- Success: `life: 3000`
- Error / warning: `life: 4000`

## Icons

Use `<icon name="material-symbols:...">` from `@nuxt/icon`. Never use `pi pi-*` classes in admin pages (see ADR-0001).
