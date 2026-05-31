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

### Article Editor
The admin UI for creating and editing articles, at `/admin/articles/[id]`. Layout: a metadata bar across the top (series, topic, tags, slug, hero image, publish toggle) and a split markdown editor + live preview below. Access is restricted to admin users via global Nuxt middleware.

### Article List (Admin)
The `/admin/articles` page. A PrimeVue DataTable showing all articles including drafts, with metadata columns: title, topic, series, status, created date, and edit/delete actions. Modelled after Django's changelist — every relevant property visible at a glance without opening the record.

### Draft
An article with `is_published = false`. Visible in the Article List (Admin) but excluded from the public `/articles` page.

### Article Slug
Auto-generated from the article title on creation (e.g. "My First Article" → "my-first-article"). Manually overridable before first publish. Locked after first publish to prevent breaking external links.

### Hero Image
The banner/thumbnail image representing an article. Stored at `article-heroes/{uuid}.ext` in the `images` bucket. Uploaded via an inline file picker in the metadata bar. Distinct from Inline Content Images.

### Inline Content Image
An image embedded within article markdown body (e.g. a diagram or callout screenshot). Uploaded via the editor's drag-drop or paste handler and stored at `article-content/{uuid}.ext` in the `images` bucket. The editor inserts the markdown `![alt](url)` syntax automatically.

### Article Audit Log
A Postgres table recording every INSERT, UPDATE, and DELETE event on `articles` via a trigger. Not exposed in the UI. Serves as a reconstruction ladder — past article states can be rebuilt by walking the log backward. Restore as a first-class feature is deferred.

### Inline Metadata Creation
Topics, tags, and series can be created on the fly from within the Article Editor without leaving the page. The series sequence number auto-assigns to `max + 1` for the chosen series, with manual override available.

### Admin Route Protection
All `/admin/**` routes are guarded by a global Nuxt route middleware (`middleware/admin.global.ts`) that checks both authentication and `app_metadata.role === 'admin'`. The DB-level RLS is the authoritative security boundary; the middleware prevents non-admin users from seeing a broken UI.

## Contact Domain

### ContactReason
A lookup record that classifies why someone is reaching out. Stored in the `contact_reasons` table (`id`, `label`, `order`). Currently three values: Employer Inquiry, Contracting, Article Question. Publicly readable; new reasons can be added without a schema migration.

### ContactMessage
A submission from the contact form. Stored in `contact_messages`. Fields: `name`, `email`, `reason_id` (FK → `contact_reasons`), `message`, `created_at`. Written server-side (Nuxt API route) after Cloudflare Turnstile verification. On success, also triggers an email notification to the site owner via Resend.