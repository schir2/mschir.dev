# Domain Context

## Portfolio Domain

### Portfolio Page
The `/portfolio` route. A curated companion to a PDF resume — visitors arrive already having the resume and use this page to go deeper. Not a cold-entry pitch. Three sections in order: Skills Snapshot, Featured Projects, Featured Articles.

### Skills Snapshot
The top section of the Portfolio Page. Displays only Highlighted Skills as an icon + name label grid. Intended to let a recruiter immediately verify relevant tech without reading prose.

### Highlighted Skill
A skill marked `is_highlighted = true` on the `skills` table. Controls which skills appear in the Skills Snapshot. Distinct from `proficiency`, which measures expertise level — a skill can be `expert` but not highlighted (e.g. outdated tech), or `advanced` but highlighted because it is currently in demand. The `is_highlighted` flag is a portfolio presentation decision; `proficiency` is a factual self-assessment.

### Featured Project
A project selected for portfolio showcase. Stored in the `featured_projects` table (separate from `projects`). Carries a portfolio-specific `tagline` — a quick identity label ("what IS this thing", e.g. *"Job scheduling app for field service companies"*), written for the portfolio context where visitors need instant recognition. Distinct from `projects.summary`, which is a descriptive blurb covering what the project does. Also carries `display_order` to control sequence on the page. Follows the same pattern as `featured_articles`.

**Decided:** `tagline` lives only on `featured_projects`, not on `projects` itself. `projects.summary` (a short plain-text blurb for cards and SEO) covers the general short-description use case. Adding a `tagline` to `projects` would blur the distinction and is not needed outside the portfolio context.

### Project Card
A reusable component (`ProjectCard`) that renders a single project preview from a `ProjectCardItem` prop. Does no data fetching. Used on the Portfolio Page (featured projects) and the Projects Page.

**Layout (left to right):**
- Amber left bar (`w-1.5`, `bg-amber-500`) — present only when `featured: true`. Same amber = featured rule as the Article Card.
- Text block (flex-col, fills remaining width):
  - *Metadata row*: `Company Name · Year` (plain text, no logo). Year only when no company.
  - *Title*: Fraunces display font, `line-clamp-2`.
  - *Body text*: when featured and `tagline` is set, the tagline fills this slot; otherwise `summary` is shown (`line-clamp-3`). Nothing shown when both are null.
  - *Skills footer*: `border-t border-surface-800` divider, then flat icon+name chip pills. Max 5 chips, `+N` badge for overflow. No category grouping.
- Thumbnail (96×96 square, right): real image resolved from Supabase storage (`images` bucket) when `image_url` is set; otherwise a deterministic diagonal gradient from `--p-primary-*` / `--p-surface-*` tokens, derived by hashing the project name (six variants, always the same gradient for the same project name).

**Hover/click**: same pattern as Article Card — `opacity-85` default → `opacity-100` on hover with shadow and border lighten. No translate-y. See ADR 0016.

### Projects Page
The `/projects` route. A single-column vertical list of all projects, ordered by year descending. Uses `ProjectCard` for each row. Queries `projects` joined with `companies(name)` and `project_skills(skills(id, name, icon))`. Each card links to the Project Detail Page.

### Project Detail Page
The `/projects/[slug]` route. Public read-only view of a single project. Layout is responsive:
- **Mobile**: hero image fills a tall block with the project title overlaid at the bottom behind a dark gradient scrim. Company · year and skills appear below.
- **Desktop (md+)**: hero image renders as a shorter banner; title, company · year, and skills render below it as a structured header.
- **No image**: title always renders in the header (no hero block).

Content sections in order: breadcrumb → hero image (if set) → title + admin edit button → company · year → skills chips → markdown description via `<md-preview>`.

Fetches via `useAsyncData` with `lazy: true`, filtering by `slug`. Returns 404 for unknown slugs. Description rendered via `MdPreview` (md-editor-v3) wrapped in `<div class="md-content-preview">` inside `<client-only>`. Admin edit button links to `/admin/projects/[id]`, shown only when `app_metadata.role === 'admin'`.

### Featured Article
An article selected for editorial showcase. Stored in the `featured_articles` table (one-to-one with `articles`, `isOneToOne: true`). Fields: `article_id`, `featured_reason` (nullable string — e.g. "Staff pick", "Most shared"), `author`, timestamps. An article is considered featured if a `featured_articles` record exists for it — there is no boolean flag on the `articles` table; featured status is derived from the join. Appears on the Article Landing Page and signals "editor's pick" with an amber bar on the Article Card.

## Storage Domain

### Image
A file stored in Supabase Storage and referenced by a DB column containing the storage path (not the full URL). The public URL is derived at runtime via `supabase.storage.from(bucket).getPublicUrl(path)`.

Two buckets exist:
- **`icons`** — small branding images (e.g. company logos). Allows SVG, PNG, JPEG.
- **`images`** — large high-res hero images (e.g. project and article banners). Allows PNG, JPEG, WebP.

Both buckets are **public** (no signed URLs needed — portfolio content is publicly visible).

### StoragePath
The value stored in image columns (e.g. `projects.image_url`, `articles.image_url`, `companies.logo_url`). Format: `{prefix}/{uuid}.{ext}` — e.g. `project-images/3f2a1b.jpg`. The prefix identifies the entity type within the bucket. The UUID is generated client-side at upload time (`crypto.randomUUID()`), making each upload unique regardless of extension.

### Image Replacement
When an entity's image is replaced: (1) upload the new file to a new UUID path, (2) update the DB column to the new path, (3) delete the old file using the previously stored path. Old files are not retained.

### Storage RLS
- **Read**: public (enforced at bucket level — no RLS policy needed for reads on public buckets).
- **Write** (INSERT, UPDATE, DELETE): restricted to users where `(auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'`. Upsert requires all three: INSERT + SELECT + UPDATE.

## Article Domain

### Article Category
A first-class browse lane that classifies every article into one of a small, stable set of mutually exclusive buckets (e.g. *Software Development*, *Career*, *Finance*). Each article belongs to exactly one category. Stored in the `article_categories` table (`id`, `name`, `slug`, `description`, `color`, `image_url`); articles reference it via `category_id`. `color` is a nullable hex string used as the category chip background color and as the final image fallback in the Thumbnail Fallback Chain. `image_url` is a nullable StoragePath in the `images` bucket used as a thumbnail fallback before the color block. Distinct from Article Tags, which are cross-cutting labels that span multiple categories.

### Article Tag
A cross-cutting label attached to an article. An article can have many tags; the same tag can appear on articles across different categories (e.g. *Python* might appear on both a Software Development article and a Finance article). Stored in `article_tags` with a many-to-many join via `article_tags_links`. Tags are used for drill-down filtering, not top-level navigation. The `icon` column (nullable text) holds an Iconify icon name for tech-related tags (e.g. `logos:python`, `logos:docker-icon`); tags without a natural logo leave it null. Tags render as icon+name pill chips on the Article Detail Page, matching the skill chip style.

### Article Series
A named sequence of related articles read in order. Stored in `article_series` (`id`, `title`, `slug`, `description`, `image_url`). `image_url` is a nullable StoragePath in the `images` bucket used as a thumbnail fallback (second in the Thumbnail Fallback Chain, after the article's own image and before the category image). Articles reference a series via `series_id` and `series_sequence_number`.

### Article Summary
A short optional teaser for an article (1–3 sentences). Stored as the nullable `summary` column on `articles`. Displayed below the title in the Article Card row layout. Not derived from content — authored manually (or eventually via AI assist). When null the Article Card row renders without a summary line.

### Article Editor
The admin UI for creating and editing articles. `/admin/articles/new` creates a new article; `/admin/articles/[id]` edits an existing one. Full-height layout: a compact metadata bar across the top and a full-width split Markdown editor + live preview below. Saving stays on the page. Access is restricted to admin users via global Nuxt middleware.

**Metadata bar fields:** title, slug (auto-generated, locks on publish), summary, hero image, category, tags, series + sequence number, writing stage, featured toggle, archived toggle (when published). All fields use stacked `text-xs` labels.

**Publish / Unpublish:** replaced the bare toggle with explicit action buttons that trigger a confirmation dialog explaining the consequences (visibility change, slug lock). Slug is locked (`disabled`) the moment publish is confirmed — derived as a computed from `publishedAt`, not deferred to save. A **View** button appears in the toolbar when the article is published, opening `/articles/[slug]` in a new tab. See ADR 0015.

Keyboard shortcuts in the editor: **Ctrl+Alt+1–6** apply heading levels 1–6 (wraps selected text or inserts the prefix at the cursor). Standard shortcuts (Ctrl+B, Ctrl+I, etc.) are handled natively by the editor's CodeMirror layer.

### Project Slug
Auto-generated from the project name on creation (e.g. "Customer Quoting Application" → "customer-quoting-application"). Manually overridable at any time — no lock policy applies (portfolio site, low traffic, project detail page not yet built). Stored as `slug` (text, NOT NULL UNIQUE) on `projects`. Used for routing to the project detail page once that page is built.

### Project Summary
A short optional plain-text blurb (1–3 sentences) for a project. Stored as the nullable `summary` column on `projects`. Displayed in project list contexts (e.g. Timeline). Not derived from content — authored manually. Distinct from `featured_projects.tagline`, which is a quick identity label written for the portfolio page context.

### Project List (Admin)
The `/admin/projects` page. A PrimeVue DataTable showing all projects with columns: name, company, year, featured (boolean), and edit/delete actions. Entry point to the Project Editor. Includes a "Manage Companies" shortcut link to `/admin/companies`.

### Project Editor
The admin UI for creating and editing projects. `/admin/projects/new` creates a new project; `/admin/projects/[id]` edits an existing one. Full-height split layout matching the Article Editor: a compact metadata bar across the top (name, slug, summary, hero image, company, year, skills) and a full-width split Markdown editor + live preview below. Also includes a **Featured** section: a toggle to mark the project as featured, with tagline and display_order fields shown when toggled on. Managing the featured state writes to/from the `featured_projects` table inline. The description field is rendered via `<md-editor>` (md-editor-v3).

### Company List (Admin)
The `/admin/companies` page. A PrimeVue DataTable listing all companies. Columns: logo (uploaded to the `icons` bucket), name, URL, and actions (edit, delete). Clicking a company name navigates to the Company Editor. No inline row editing — all editing happens on a dedicated editor page, consistent with all other admin list pages.

### Article List (Admin)
The `/admin/articles` page. A PrimeVue DataTable showing all articles including drafts, with metadata columns: title, category, series, status, created date, and edit/delete actions. Modelled after Django's changelist — every relevant property visible at a glance without opening the record.

### Writing Stage
The editorial workflow state of an article. Stored as the `writing_stage` enum column on `articles`. Tracks where the article is in the writing process, independent of whether it is published. Default is `idea`.

| Value | Meaning |
|---|---|
| `idea` | Title or topic captured; no content yet |
| `outline` | Structure exists; no prose written |
| `draft` | Writing in progress |
| `ready` | Writing complete and polished; waiting to be published |

### Article Status
Derived from two nullable timestamp columns on `articles`: `published_at` and `archived_at`. Distinct from Writing Stage — status describes visibility, not editorial progress.

| `published_at` | `archived_at` | Derived status |
|---|---|---|
| NULL | NULL | Unpublished |
| NOT NULL | NULL | Published |
| NOT NULL | NOT NULL | Archived |
| NULL | NOT NULL | (invalid — archive without publish is not meaningful) |

### Published Article
An article where `published_at IS NOT NULL` and `archived_at IS NULL`. Readable on the public article page. `published_at` records when the article was first made public.

### Archived Article
An article where `archived_at IS NOT NULL`. Still publicly readable, but displayed with an "archived" banner indicating the content may be outdated. `archived_at` records when archiving occurred.

### Article Slug
Auto-generated from the article title on creation (e.g. "My First Article" → "my-first-article"). Manually overridable before first publish. Locked immediately when the article is published — the lock is a computed derived from `publishedAt`, so it activates the moment publish is confirmed, not on next save. Prevents breaking external links.

### Hero Image
The banner/thumbnail image representing an article. Stored at `article-heroes/{uuid}.ext` in the `images` bucket. Uploaded via an inline file picker in the metadata bar. Distinct from Inline Content Images.

### Inline Content Image
An image embedded within article markdown body (e.g. a diagram or callout screenshot). Uploaded via the editor's drag-drop or paste handler and stored at `article-content/{uuid}.ext` in the `images` bucket. The editor inserts the markdown `![alt](url)` syntax automatically.

### Article Audit Log
A Postgres table recording every INSERT, UPDATE, and DELETE event on `articles` via a trigger. Not exposed in the UI. Serves as a reconstruction ladder — past article states can be rebuilt by walking the log backward. Restore as a first-class feature is deferred.

### Inline Metadata Creation
Categories, tags, and series can be created on the fly from within the Article Editor without leaving the page. The series sequence number auto-assigns to `max + 1` for the chosen series, with manual override available.

### Article Card
A reusable component (`ArticleCard`) that renders a single article preview from an `ArticleCardItem` prop. Does no data fetching. Single-variant horizontal list row.

**Layout (left to right):**
- Amber left bar (`w-1.5`, `bg-amber-500`) — present only when `featured_articles` is non-null. Site-wide signal: amber always means featured.
- Text block (flex-col, fills remaining width):
  - *Top row*: category dot (colored circle, `w-2.5 h-2.5`, inline style for hex color) + category name, both linking to `/articles/browse?category=[slug]`. Date floated right.
  - *Title*: Fraunces display font, `line-clamp-2`, links to `/articles/[slug]`, shifts to `text-primary-400` on hover.
  - *Featured reason pill* (optional): amber bordered pill (`border-amber-500/50 text-amber-400`) below the title, only when `featured_articles.featured_reason` is set.
  - *Summary* (optional): `line-clamp-2`, hidden when null.
  - *Content/metadata divider*: `border-t border-surface-800`, always present. Separates narrative content above from discovery metadata below.
  - *Series row* (optional, above divider): `"Part N of · [Series Title]"` — series title links to `/articles/series/[slug]`.
  - *Tags row* (below divider): first 3 tags as pill links to `/articles/browse?tag=[slug]`. `+N` muted badge when more than 3 exist.
- Thumbnail (96×96 square, right): `<img>` or colored rectangle via Thumbnail Fallback Chain. Zooms on hover (`group-hover:scale-110`, contained within `overflow-hidden`).

**Hover/click**: `opacity-85` default → `opacity-100` on hover with shadow and border lighten. Click triggers a JavaScript ripple (`bg-white/15` expanding circle from click coordinate). No `translate-y` lift — it causes jitter in tightly-packed lists (see ADR 0011).

Used on the Article Browse Page, Article Landing Page, and Portfolio Page.

### Thumbnail Fallback Chain
The resolution order used by the `useArticleThumbnail` composable to determine the thumbnail for an Article Card. Resolves in order: article `image_url` → series `image_url` → category `image_url` → category `color` block. Returns `{ type: 'image', url: string }` when any image is found, or `{ type: 'color', color: string }` when only a color (or nothing) is available. Ensures the thumbnail slot is never empty regardless of how much metadata has been populated.

### Series Card
A reusable card component (`SeriesCard`) that renders a series preview from an `ArticleSeriesSummary` prop. Does no data fetching. Displays: series title (link to `/articles/series/[slug]`), article count as a `<p-tag severity="secondary">` badge, and series description.

### Category Tag Filter
A reusable filter bar component (`CategoryTagFilter`) used on the Article Browse Page. Wrapped in a `<p-panel toggleable>` that is collapsed by default; the panel header shows "Filters" or "Filters (N active)" when filters are set. Two chip rows inside: one for categories (amber inset ring when active), one for tags (violet inset ring when active). A "Clear filters" button appears below the panel when any filter is active and emits both `update:modelCategory: null` and `update:modelTags: []`. Accepts `categories`, `tags`, `modelCategory` (single-select slug or null), and `modelTags` (multi-select slug array) as props. Emits `update:modelCategory` and `update:modelTags` on interaction. Does no data fetching — the parent page owns query and URL state.

### Article Landing Page
The `/articles` route. A visual dashboard that serves as the entry point to the article section. Four sections in order: Featured Articles (from the `featured_articles` table), Recent Articles (latest 5 published, excluding featured), Series (all series with at least one published article, rendered as Series Cards), and Browse by Category (chip links into the Article Browse Page filtered by category). Sections with no content are hidden.

### Article Browse Page
The `/articles/browse` route. A filterable list of all published articles. Filters are rendered inside a Category Tag Filter panel (collapsed by default). Filters by category (single-select) and tags (multi-select, AND logic) are reflected in the URL query string (`?category=` and `?tag=`) so filtered views are bookmarkable and shareable. Filtering is client-side (computed properties over the full loaded list). Tag data is fetched with an `!inner` join so only tags attached to at least one published article are shown. Initialises filter state from the URL on mount; updates the URL via `router.replace` on filter change. Article list renders via `<p-data-view>` with list and grid layouts; layout toggles between single-column and two-column (state is not persisted across page loads).

### Article Series Page
The `/articles/series/[slug]` route. Displays a series title and description, then lists all published articles in the series ordered by `series_sequence_number` ascending. Used to read a series sequentially from part 1 to the end. Returns 404 if the series slug does not exist.

### Article Detail Page
The `/articles/[slug]` route. The full reading experience for a single published or archived article. Layout and features:

- **Hero image** — constrained banner (within the article container) above the title if `image_url` is set.
- **Metadata bar** — category, tags (as chips linking to `/articles/browse?tag=[slug]`), `published_at` date, `view_count`, and hard-coded author name. Archived articles display a prominent "Archived" banner.
- **Series panel** — shown when the article belongs to a series. Collapsible panel near the top displaying the series title and a numbered list of all articles in the series, with the current article highlighted. Allows jumping to any part directly.
- **Article content** — rendered via `MdPreview` (md-editor-v3) inside `<client-only>`.
- **TOC sidebar** — fixed collapsible right sidebar using `MdCatalog` (md-editor-v3 built-in). Collapsed to a toggle button when the reader wants a distraction-free view. Hidden on mobile.
- **Series prev/next** — at the bottom of the article, links to the previous and next articles in the series by `series_sequence_number`.
- **Admin edit button** — visible only to admin users; links to `/admin/articles/[id]`.

Drafts (`published_at IS NULL`) return 404 for all users on this page — preview happens in the Article Editor. Archived articles (`archived_at IS NOT NULL`) remain publicly readable with an archived banner.

### Article TOC
The collapsible fixed right-sidebar table of contents on the Article Detail Page. Rendered by md-editor-v3's `MdCatalog` component, which auto-generates entries from the headings in the rendered article content. Highlights the active section as the reader scrolls. Collapsible to a toggle button so readers can enter a distraction-free reading mode.

### Series Panel
A collapsible UI block on the Article Detail Page, shown when the article belongs to a series. Displays the series title, a numbered list of all articles in the series (ordered by `series_sequence_number`), and highlights the currently-reading article. Allows the reader to jump to any part. Distinct from the Series Prev/Next nav at the bottom, which only exposes the immediately adjacent articles.

### Admin Route Protection
All `/admin/**` routes are guarded by a global Nuxt route middleware (`middleware/admin.global.ts`) that checks both authentication and `app_metadata.role === 'admin'`. The DB-level RLS is the authoritative security boundary; the middleware prevents non-admin users from seeing a broken UI.

## Homepage Domain

### Homepage
The `/` route. First impression for all visitors. Leads with value — what gets built and who it helps — not personal narrative (that's `/about`). Drives visitors toward `/portfolio` and `/contact`.

**Sections** (in order): (1) Hero — name + subtitle + headline + two CTAs, (2) Service Pillars — 3-card grid (single column on mobile, three columns on lg+), (3) Recent Articles — latest 3 published from DB (borderless link list), (4) Bottom CTA.

**Hero name**: "Marek Schir" (h1, `text-6xl`, Fraunces)
**Hero subtitle**: "Software Developer & Systems Architect" (`text-2xl`)
**Hero headline**: *"Building the software and systems that make businesses run better."* (`text-xl`)
**Hero CTAs**: Two buttons — "See My Work" (outlined) → `/portfolio` and "Get in Touch" (filled) → `/contact`.
**Hero visual**: Full-bleed animated gradient — `--p-primary-950` → `--p-primary-800` → `var(--p-accent-800)`. Entrance animation staggers name, subtitle, headline, buttons in on load.

**Bottom CTA copy**: *"Got a system, workflow, or idea that needs the right technology behind it? Let's talk."* Button: "Get in Touch" → `/contact`.

**Heading structure**: Hero h1 is the only `<h1>`. Section eyebrow labels ("What I Build", "Recent Articles") are plain `<span>` elements — visual decoration only, not semantic headings. Service pillar titles are `<h2>` (Fraunces applied via the global h1/h2 rule). See `app/pages/CLAUDE.md` for the full heading convention. See ADR-0009 for the typography system.

## Services Domain

### Services Section
The `/services` route subtree. A set of public-facing sales pages — one index and three detail pages — that elaborate on each Service Pillar for visitors evaluating whether to hire. Separate routes (not a single tabbed page) so each service has its own SEO surface, canonical URL, and shareable link. See ADR-0022.

### Service Index Page
The `/services` route. Lists all three Service Pillars with a brief description and a link to each Service Detail Page. Entry point for visitors exploring what's on offer. Calls `usePageSeo()`.

### Service Detail Page
One of three routes: `/services/integrations-apis`, `/services/application-development`, `/services/ai-automation`. Each elaborates on one Service Pillar — what it involves, who it's for, relevant past projects, and a CTA to `/contact`.

**Page structure (top to bottom):**
1. `"Services"` eyebrow — `text-xs uppercase tracking-widest text-muted-color`, links to `/services`
2. `<h1>` — service name
3. **Service Sibling Nav** — immediately below the h1
4. Body copy — sections vary per service (authored in `temp/`)
5. Project references — lightweight link list (name + one-line descriptor → `/projects/[slug]`), not full ProjectCard
6. CTA — "Get in touch" → `/contact`

### Service Sibling Nav
An icon card strip placed immediately below the `<h1>` on every Service Detail Page, preceded by a `"Services"` eyebrow label above the h1. Three cards in a `grid-cols-3` grid, one per service. Each card shows the service icon (left) and label (right). Active card: amber border (`border-amber-500/60`), amber background tint (`bg-amber-500/10`), amber icon (`text-amber-400`). Inactive cards: `border-surface-700 bg-surface-900 text-muted-color`, lighten on hover.

Implemented as `<nuxt-link>` cards (not `<p-tab-menu>`) — active state set by comparing the current route to each service's path. Visually consistent with the Service Pillar cards on the Homepage (same icon + label layout).

### Series Nav
The navigation UI on the Article Detail Page for articles that belong to a series. Structure (top to bottom within the article header):

1. `"Series · [Series Title]"` eyebrow — `text-xs uppercase tracking-widest text-muted-color`; "Series" is plain text, the series title links to `/articles/series/[slug]`
2. `<h1>` — article title (the eyebrow sits above it, providing series context before the title)
3. **Jump nav**: a `<p-select>` dropdown immediately below the h1, showing "Part X of Y — [Current Title]" as the selected value. All series articles are options. Scales to any series length (tested with 19 articles). Replaces the current collapsible `<p-panel>` list which is unusable at large series sizes.

At the bottom of the article:
4. **Prev/next strip**: two columns — previous article on the left, next on the right — each showing a direction label (`← Previous` / `Next →`) and the article title. Supports sequential reading flow.

## Site Design Domain

### Brand Palette
Two semantic colors defined in `primevue-theme.ts`:
- **Primary**: indigo — structural UI color (buttons, links, active states)
- **Accent**: yellow/amber — highlights, CTAs, personal touches (to be added in #48)

Raw Tailwind color values (e.g. `text-red-600`, `bg-yellow-500`) are not used for brand colors. All color references go through PrimeVue tokens (`var(--p-primary-*)`, `var(--p-surface-*)`, or the accent token once added).

### Typography System
Two-font system loaded via Google Fonts `<link>` tags in `nuxt.config.ts` (no `@nuxt/fonts` module):

- **Display font**: Fraunces (variable serif) — applied to `h1` and `h2` only. Configured as `fontFamily.display` in `tailwind.config.ts`. Used via `font-display` utility class or targeted CSS.
- **Body font**: Inter (sans-serif) — all other text: prose, UI labels, form inputs, card content. Configured as `fontFamily.sans` in `tailwind.config.ts` and as `fontFamily` in `primevue-theme.ts` semantic tokens so PrimeVue components inherit it automatically.

**Hero type scale**: h1 `text-6xl` (Fraunces) / subtitle `text-2xl` / headline `text-xl`.

**md-editor-v3**: `app/assets/css/overrides/md-editor.css` overrides `h1, h2` inside `.md-content-preview > .md-editor .md-editor-preview` to use Fraunces. Body text inside the preview inherits Inter from the page-level font-family.

### CSS Layering Rule
Three layers, each with a defined responsibility:
1. **PrimeVue tokens** — colors, spacing scale, border-radius, shadows. Single source of truth for the visual language.
2. **Tailwind utilities** — layout, positioning, flex/grid, responsive breakpoints. No semantic color classes.
3. **Third-party CSS overrides** — `app/assets/css/overrides/<lib>.css`, imported via `app/assets/css/main.css`. Each library gets its own override file; overrides use `var(--p-*)` tokens so dark mode stays consistent.

Custom component styles use `<style scoped>` with `var(--p-*)` for any color values. Documented in `docs/adr/0008-css-layering-strategy.md` (tracked in issue #48).

## Site Footer Domain

### Site Footer
The `<layout-footer>` component rendered at the bottom of every page via `app/layouts/default.vue`. Persistent across all routes. Secondary navigation aid — not the primary CTA (those live on individual pages). Has a slightly darker background (`var(--p-surface-900)`) to visually close the page.

**Layout**: Three columns + bottom strip.
- **Left**: logo, site name ("Marek Schir"), Site Tagline
- **Center**: nav links (Portfolio, Articles, About, Contact)
- **Right**: "Connect" section — GitHub, LinkedIn, and mail icon buttons (mail links to `/contact`). All icon-only, same size, not small.
- **Bottom strip**: copyright only (`© {year} Marek Schir`). No CTA in the bottom strip.

Mobile: columns stack; nav links become a 2×2 grid.

### Site Tagline
Short descriptor used in the footer beneath the site name. Resolved copy: *"Software and integrations for growing businesses."*

## Site Navigation Domain

### Breadcrumb
A contextual navigation trail rendered at the top of deep content pages, inside the page's content container, immediately below the navbar. Hidden on mobile (`hidden md:block`). The last item (current page) is plain text — not a link. Used on article pages and the Project Detail Page.

On browse and series pages, rendered via `article-page-header` (which wraps the breadcrumb + h1 + optional description). On the article detail page, rendered directly as `article-breadcrumb` since that page's header has a different structure (metadata bar, tags, admin edit button).

**Trails by route:**
- `/articles/browse` → `Articles > Browse`
- `/articles/series/[slug]` → `Articles > [Series Title]`
- `/articles/[slug]` (with series) → `Articles > [Category Name] > [Series Title] > [Article Title]`
- `/articles/[slug]` (no series) → `Articles > [Category Name] > [Article Title]`

`Articles` always links to `/articles`. Category links to `/articles/browse?category=[slug]`. Series links to `/articles/series/[slug]`. See ADR 0012.

### Site Navbar
A sticky top navbar (`position: sticky; top: 0`) visible at all times as the user scrolls. Adds a drop shadow when the page has scrolled past 10px. Nav items: Portfolio, Articles, About, Contact. Social links (GitHub, LinkedIn) appear on the right and are hidden on mobile. Auth area is on the far right.

### Navbar Auth Area
The right-most section of the Site Navbar that reflects authentication state:
- **Unauthenticated**: icon-only person button linking to `/login`.
- **Authenticated**: a `<p-avatar>` showing the user's email initial (future: profile picture). Clicking it opens a popup menu.

### Navbar User Menu
A `<p-tiered-menu popup>` triggered by clicking the Navbar Auth Area avatar. Contains:
- **Admin** → `/admin` (shown only when `app_metadata.role === 'admin'`) — links directly to the Admin Index Page; no submenu
- **Logout**

A Profile item is planned when user profile editing is built out.

## About Page Domain

### About Page
The `/about` route. A personal introduction page presenting the site owner's background, experience, and approach. Serves two audiences: potential contracting clients evaluating whether to reach out, and employers or recruiters considering an opportunity. Tone is direct and personal — genuine breadth built over 14 years, someone who enjoys building things and helping people — not a polished pitch. Distinct from the Portfolio Page (which showcases specific work for someone who already has a resume) and the Homepage (which carries service positioning and the Service Pillar cards).

**Owner background (for copy reference)**: Computer engineering education. Holds CCNA and CCNP (Cisco). Started as a part-time software developer, grew through IT and network infrastructure, now IT Director + software project manager + application and integration builder at a field service company. 14 years of experience spanning small to medium-sized businesses. Originally drawn to 3D graphics design (3D Studio Max, Photoshop, Figma); that creative drive carries into software architecture and UI work. Core motivation: building things, making people's lives easier and more efficient.

**Layout**: Single-column narrative with photo. Four sections in order: (1) Photo + name + brief identity line, (2) Personal narrative — 2–3 paragraphs covering background/origin, scope of work, and what drives the approach, (3) Recent Articles — latest 3 published from DB, (4) CTA toward Contact.

**Photo**: Stored as a static file at `public/img/profile.jpg` (not Supabase Storage — no admin upload UI needed for a headshot). Referenced as `/img/profile.jpg`. Layout: side-by-side with the intro text — photo on the right (~30%), name + first paragraph on the left (~70%). Mobile: photo stacks below text.

**Articles**: latest 3 published articles fetched from DB (`ORDER BY published_at DESC LIMIT 3`). Displayed as a borderless link list (title + category + date, no card chrome). Signals ongoing intellectual activity. Portfolio = best work; About = active person.

**Personality traits for copy reference**: Methodical and deliberate — prefers to plan thoroughly before acting, front-loads work to accelerate later. Utility over beauty (but beauty matters). Finds genuine satisfaction in making people's work faster and easier. Creative at heart (started in 3D design, still takes design courses, uses Figma) — that creativity shows up in software architecture.

### Service Pillars
The three core capability areas presented on the **Homepage** and elaborated on the **Services Section**. Each is a distinct type of engagement. Infrastructure & Cloud was dropped as a public-facing offering (removed from homepage and contact page as of issue #140).

1. **Integrations & APIs** — connecting disparate platforms, building APIs, and modernizing the data flows between systems. Includes CRM platforms (HubSpot, Zoho, Salesforce) and communication systems (3CX, FreePBX). Detail page: `/services/integrations-apis`.
2. **Application Development** — building net-new applications for specific business needs and rebuilding or extending legacy software. Focused on smaller, well-scoped builds. Detail page: `/services/application-development`.
3. **AI & Automation** — workflow automation and AI-enriched pipelines that reduce manual work and surface actionable information. Detail page: `/services/ai-automation`.

### Consulting Approach
The process that precedes all implementation work. Involves working directly with business owners and domain experts to understand existing workflows, identify inefficiencies, and define a technology strategy before any code is written. Distinguishes the site owner from a pure-execution developer.

### About Page Personal Narrative
The 2–3 paragraph personal section of the About Page. Covers: origin (started in graphics/design, shifted to software and IT via computer engineering education and Cisco certifications, grew into full-lifecycle ownership), scope (14 years spanning networking, infrastructure, software development, integrations, and automation across SMBs and field service companies), and motivation (enjoys building and creating, finds satisfaction in making people's work faster and easier). Copy is conversational and first-person, not resume-style. Tone reflects the site owner's methodical personality — does not oversell or rush.

## Admin Shell Domain

### Admin Section Registry
The single source of truth for all admin pages. Defined as `ADMIN_SECTIONS` in `app/config/adminSections.ts` — a typed `as const` array of `AdminGroup` objects, each containing `AdminSection` entries. Each section carries: `label` (plural display name, e.g. "Articles"), `singular` (singular form, e.g. "Article" — used to construct "New Article" labels), `to` (route path), `icon` (Iconify name), `description` (shown on the admin index page), and an optional `getPublicUrl` function that derives the public-facing URL for a given record. Consumed by the Navbar User Menu, the Admin Index Page, and the Admin Sidebar. Two utilities are exported from the same file: `toMenuItems()` (flat PrimeVue `MenuItem[]` for the Navbar User Menu) and `toSidebarMenuItems()` (grouped `MenuItem[]` with `label`/`items` nesting for the Admin Sidebar). Every new admin page must add an entry — there is no other registration step.

Current groups: **Content** (Articles, Categories, Series) · **Portfolio** (Projects, Companies, Skills) · **Inbox** (Contact Messages).

### Admin Index Page
The `/admin` route. Entry point to the admin section. Displays all admin sections as a Django-style changelist: groups with a header row, then one row per entity. Each row shows: entity icon, entity name as a link to the list page (e.g. `/admin/articles`), and an "Add [Entity]" button linking to the new-record page (e.g. `/admin/articles/new`). Driven entirely by `ADMIN_SECTIONS` — no hardcoded rows. Uses the `admin-list` layout.

### Admin Sidebar
A persistent left-column navigation menu rendered inside both admin layouts (`admin-list` and `admin-detail`). Implemented as `app/components/admin/AdminSidebar.vue` using PrimeVue's `p-menu` component with grouped items (`label` + `items` nesting). Groups and sections are derived from `toSidebarMenuItems()` in `adminSections.ts`. Always visible — not collapsible. Each item carries an icon and links to the section's list page. Both admin layouts are two-column: sidebar (fixed width) on the left, page content (`flex-1`) on the right.

### Admin List Layout
`app/layouts/admin-list.vue`. The shell for all admin list and index pages. Provides navbar, footer, toast, dynamic-dialog, and a two-column flex shell: Admin Sidebar on the left, `max-w-6xl` content area on the right (`px-6` padding). Pages declare `definePageMeta({ layout: 'admin-list', title: '...' })`. The title is consumed by the layout for `<head>` and by `<admin-page-header>` for display.

### Admin Detail Layout
`app/layouts/admin-detail.vue`. The shell for admin editor, create, and edit pages. Provides navbar, footer, toast, and dynamic-dialog in a two-column flex shell: Admin Sidebar on the left, full-width content area on the right. Pages declare `definePageMeta({ layout: 'admin-detail', title: '...' })`.

### Admin Page Header
A component (`app/components/admin/AdminPageHeader.vue`) that every admin page renders as its first child. Reads the page title from `route.meta.title` automatically and renders it on the left. Exposes a `#actions` slot for right-side buttons (e.g. "New Article"). Provides the consistent Django admin-style page header across all admin surfaces.

## Auth Domain

### Zod Schema Location
Form validation schemas live in `app/schemas/`. Each schema file exports **only the Zod schema object** — no resolver, no inferred types.

**File naming** — two patterns:
- **DB-backed CRUD forms**: `<Entity><Operation>Schema.ts` — e.g. `ContactMessageInsertSchema.ts`, `ContactMessageUpdateSchema.ts`. The operation suffix (`Insert` / `Update`) matches the Supabase-generated type being satisfied and signals which form it belongs to. Insert and Update schemas are kept separate because their field sets often differ.
- **Non-DB forms**: `<Domain>Schema.ts` — e.g. `CredentialsSchema.ts`.

**Type sourcing**:
- **DB-backed types**: come from `shared/types/` (generated by Supabase). Schemas use `satisfies { [K in keyof T]: z.ZodTypeAny }` to prove the schema covers the shape.
- **Frontend-only types** (no DB table origin): defined in `app/types/` and referenced the same way.

**Resolver** (`zodResolver(...)`) is PrimeVue-specific wiring and lives in the component's `<script setup>`, not in the schema file.

## Contact Domain

### ContactReason
A lookup record that classifies why someone is reaching out. Stored in the `contact_reasons` table (`id`, `label`, `order`). Five values (in order): Employer Inquiry, Contract Inquiry, Article Question, Project Question, Other. Publicly readable; new reasons can be added without a schema migration.

### ContactMessage
A submission from the contact form. Stored in `contact_messages`. Fields: `name`, `email`, `reason_id` (FK → `contact_reasons`), `message`, `created_at`. Written server-side (Nuxt API route) after Cloudflare Turnstile verification. On success: the visitor is redirected to `/contact/thanks` and the API route invokes the `send-contact-emails` edge function fire-and-forget (no await), which sends two emails via Resend:
1. Owner notification to schir2@gmail.com — includes the reason label, full message, and `Reply-To` set to the submitter's address.
2. Submitter confirmation — short personal copy with the original message quoted below a divider.

Both sends are best-effort inside try/catch blocks. The edge function always returns `{ ok: true }` — email failure never surfaces to the user.

### Contact Thanks Page
The `/contact/thanks` route. Shown after a successful contact form submission. Displays a confirmation message and two fixed CTAs: "See my work" (→ `/portfolio`, accent) and "Read some articles" (→ `/articles`, secondary outlined). CTAs are not conditional on the contact reason — avoids coupling the UI to reason label strings that can change in the DB. Noindexed via nuxt-robots.