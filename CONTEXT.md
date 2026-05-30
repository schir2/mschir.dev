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

## Contact Domain

### ContactReason
A lookup record that classifies why someone is reaching out. Stored in the `contact_reasons` table (`id`, `label`, `order`). Currently three values: Employer Inquiry, Contracting, Article Question. Publicly readable; new reasons can be added without a schema migration.

### ContactMessage
A submission from the contact form. Stored in `contact_messages`. Fields: `name`, `email`, `reason_id` (FK → `contact_reasons`), `message`, `created_at`. Written server-side (Nuxt API route) after Cloudflare Turnstile verification. On success, also triggers an email notification to the site owner via Resend.