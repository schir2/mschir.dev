# ADR-0002: Supabase Storage bucket architecture for images

## Status
Accepted

## Context
Projects, articles, and companies need image storage (hero images and logos). Skills and skill categories need icons but those are covered by ADR-0001 (Iconify names stored in DB columns — no file storage needed for skills).

Several design questions had to be resolved together:
- How many buckets, and how to divide content across them
- Public bucket vs. signed/time-limited URLs
- Whether to store the full public URL or just the storage path in DB columns
- How to name files to avoid collisions and stale cache after replacement
- What happens to old files when an image is replaced
- Who is permitted to upload

## Decision

**Two public buckets:**
- `icons` — small branding images (company logos). Allows SVG, PNG, JPEG.
- `images` — large high-res hero images (project and article banners). Allows PNG, JPEG, WebP.

Separating by bucket enforces different MIME type and file size limits at the infrastructure level rather than in application code. One bucket was rejected because a company logo (SVG, a few KB) and an article hero image (JPEG, potentially several MB) have meaningfully different constraints.

**Public buckets, no signed URLs.** All content is portfolio material intended for public viewing. Signed URLs would add server-side latency and complexity with no security benefit.

**Store storage paths in DB columns, not full public URLs.** The public URL is derived at runtime:
```ts
supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl
```
Storing the full URL embeds the Supabase project reference in every row, which breaks on project migration. The path is portable.

**File naming: `{prefix}/{uuid}.{ext}`**, where the UUID is generated client-side via `crypto.randomUUID()` at upload time. Prefixes by entity type:
- `icons` bucket: `company-logos/`
- `images` bucket: `project-images/`, `article-images/`

Entity-ID-based naming (e.g. `project-images/{project_id}.jpg`) was rejected because the file extension can change on replacement, which would leave orphaned files and require awkward path reconstruction.

**Replacement strategy: delete old, upload new.** When an image is replaced, the flow is: (1) upload new file to a new UUID path, (2) update the DB column, (3) delete the old file using the previously stored path. No version history is retained. This keeps storage lean; a failed mid-flight replacement is an acceptable risk for a low-frequency admin operation on a personal portfolio.

**Write RLS:**
```sql
(auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
```
Applied to INSERT, UPDATE, and DELETE on both buckets. The site has authenticated users beyond the owner (commenters), so `TO authenticated` alone would grant upload rights to any signed-in visitor. `app_metadata` is server-controlled (unlike `user_metadata`, which is user-editable) and is the Supabase-recommended approach for role-based authorization. Note: upsert operations require INSERT + SELECT + UPDATE in the policy.

**Upload flow: direct from browser** via `useSupabaseClient().storage`. The admin session token is sufficient given the RLS policy; proxying uploads through a Nuxt API route would add complexity with no meaningful security gain.

## Consequences
- Any URL is publicly accessible to anyone who knows it — acceptable for a public portfolio site.
- Path-only storage requires a one-line derivation when rendering images, but survives Supabase project migration.
- UUID naming means the URL always changes on replacement, so no stale CDN cache issues.
- Delete-on-replace keeps storage lean but provides no rollback path after a bad upload.
- The `app_metadata` guard requires the owner's user account to have `role: "admin"` set in `app_metadata` via the Supabase dashboard.