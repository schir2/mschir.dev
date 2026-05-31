# Domain Context

## Portfolio Domain

### Portfolio Page
The `/portfolio` route. A curated companion to a PDF resume — visitors arrive already having the resume and use this page to go deeper. Not a cold-entry pitch. Three sections in order: Skills Snapshot, Featured Projects, Featured Articles.

### Skills Snapshot
The top section of the Portfolio Page. Displays only Highlighted Skills as an icon + name label grid. Intended to let a recruiter immediately verify relevant tech without reading prose.

### Highlighted Skill
A skill marked `is_highlighted = true` on the `skills` table. Controls which skills appear in the Skills Snapshot. Distinct from `proficiency`, which measures expertise level — a skill can be `expert` but not highlighted (e.g. outdated tech), or `advanced` but highlighted because it is currently in demand. The `is_highlighted` flag is a portfolio presentation decision; `proficiency` is a factual self-assessment.

### Featured Project
A project selected for portfolio showcase. Stored in the `featured_projects` table (separate from `projects`). Carries a portfolio-specific `tagline` — a short punchy hook written for the portfolio context, distinct from the canonical `description` on `projects`. Also carries `display_order` to control sequence on the page. Follows the same pattern as `featured_articles`.

### Featured Article
An article selected for portfolio showcase. Stored in the existing `featured_articles` table. Appears as an optional bonus section at the bottom of the Portfolio Page.

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
A first-class browse lane that classifies every article into one of a small, stable set of mutually exclusive buckets (e.g. *Software Development*, *Career*, *Finance*). Each article belongs to exactly one category. Stored in the `article_categories` table (`id`, `name`, `slug`, `description`); articles reference it via `category_id`. Distinct from Article Tags, which are cross-cutting labels that span multiple categories.

### Article Tag
A cross-cutting label attached to an article. An article can have many tags; the same tag can appear on articles across different categories (e.g. *Python* might appear on both a Software Development article and a Finance article). Stored in `article_tags` with a many-to-many join via `article_tags_links`. Tags are used for drill-down filtering, not top-level navigation.

### Article Editor
The admin UI for creating and editing articles. `/admin/articles/new` creates a new article; `/admin/articles/[id]` edits an existing one. Layout: a metadata bar across the top (title, slug, hero image, category, tags, series + sequence number, publish date, archive date) and a full-width split markdown editor + live preview below. Access is restricted to admin users via global Nuxt middleware.

Keyboard shortcuts in the editor: **Ctrl+Alt+1–6** apply heading levels 1–6 (wraps selected text or inserts the prefix at the cursor). Standard shortcuts (Ctrl+B, Ctrl+I, etc.) are handled natively by the editor's CodeMirror layer.

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
Auto-generated from the article title on creation (e.g. "My First Article" → "my-first-article"). Manually overridable before first publish. Locked after first publish to prevent breaking external links.

### Hero Image
The banner/thumbnail image representing an article. Stored at `article-heroes/{uuid}.ext` in the `images` bucket. Uploaded via an inline file picker in the metadata bar. Distinct from Inline Content Images.

### Inline Content Image
An image embedded within article markdown body (e.g. a diagram or callout screenshot). Uploaded via the editor's drag-drop or paste handler and stored at `article-content/{uuid}.ext` in the `images` bucket. The editor inserts the markdown `![alt](url)` syntax automatically.

### Article Audit Log
A Postgres table recording every INSERT, UPDATE, and DELETE event on `articles` via a trigger. Not exposed in the UI. Serves as a reconstruction ladder — past article states can be rebuilt by walking the log backward. Restore as a first-class feature is deferred.

### Inline Metadata Creation
Categories, tags, and series can be created on the fly from within the Article Editor without leaving the page. The series sequence number auto-assigns to `max + 1` for the chosen series, with manual override available.

### Article Card
A reusable card component (`ArticleCard`) that renders a single article preview from an `ArticleCardItem` prop. Does no data fetching. Displays: hero image, title (link to `/articles/[slug]`), category chip (link to `/articles/browse?category=[slug]`), up to three tag badges, publish date, and a series badge when the article belongs to a series. Accepts an optional `size` prop (`'featured' | 'default'`) for layout variation. Visual hierarchy: category uses `<p-chip>` (pill, folder icon), tags use `<p-tag severity="secondary">` (small rectangular), series badge uses `<p-tag severity="info">` (blue, list icon).

### Series Card
A reusable card component (`SeriesCard`) that renders a series preview from an `ArticleSeriesSummary` prop. Does no data fetching. Displays: series title (link to `/articles/series/[slug]`), article count as a `<p-tag severity="secondary">` badge, and series description.

### Category Tag Filter
A reusable filter bar component (`CategoryTagFilter`) used on the Article Browse Page. Accepts `categories`, `tags`, `modelCategory` (single-select slug or null), and `modelTags` (multi-select slug array) as props. Emits `update:modelCategory` and `update:modelTags` on interaction. Clicking an active category chip deselects it (emits null). Tag chips toggle on/off independently (multi-select). Does no data fetching — the parent page owns query and URL state.

### Article Landing Page
The `/articles` route. A visual dashboard that serves as the entry point to the article section. Four sections in order: Featured Articles (from the `featured_articles` table), Recent Articles (latest 5 published, excluding featured), Series (all series with at least one published article, rendered as Series Cards), and Browse by Category (chip links into the Article Browse Page filtered by category). Sections with no content are hidden.

### Article Browse Page
The `/articles/browse` route. A filterable grid of all published articles. Filters by category (single-select) and tags (multi-select) are reflected in the URL query string (`?category=` and `?tag=`) so filtered views are bookmarkable and shareable. Filtering is client-side (computed properties over the full loaded list). Initialises filter state from the URL on mount; updates the URL via `router.replace` on filter change.

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

## Site Navigation Domain

### Site Navbar
A sticky top navbar (`position: sticky; top: 0`) visible at all times as the user scrolls. Adds a drop shadow when the page has scrolled past 10px. Nav items: Portfolio, Articles, About, Contact. Social links (GitHub, LinkedIn) appear on the right and are hidden on mobile. Auth area is on the far right.

### Navbar Auth Area
The right-most section of the Site Navbar that reflects authentication state:
- **Unauthenticated**: icon-only person button linking to `/login`.
- **Authenticated**: a `<p-avatar>` showing the user's email initial (future: profile picture). Clicking it opens a popup menu.

### Navbar User Menu
A `<p-menu popup>` triggered by clicking the Navbar Auth Area avatar. Contains:
- **Admin Articles** → `/admin/articles` (shown only when `app_metadata.role === 'admin'`)
- **Logout**

As the admin section grows, additional admin links are added here. A Profile item is planned when user profile editing is built out.

## Contact Domain

### ContactReason
A lookup record that classifies why someone is reaching out. Stored in the `contact_reasons` table (`id`, `label`, `order`). Currently three values: Employer Inquiry, Contracting, Article Question. Publicly readable; new reasons can be added without a schema migration.

### ContactMessage
A submission from the contact form. Stored in `contact_messages`. Fields: `name`, `email`, `reason_id` (FK → `contact_reasons`), `message`, `created_at`. Written server-side (Nuxt API route) after Cloudflare Turnstile verification. On success, also triggers an email notification to the site owner via Resend.