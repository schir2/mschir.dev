# ADR-0023: Browse page tag filter scoped to tags with published articles

## Status
Accepted

## Context

The `article_tags` table can accumulate tags over time — created during admin editing, imported from seed data, or added speculatively. On the Article Browse Page, the tag filter previously fetched all rows from `article_tags` regardless of whether any published article used them. In the seed data this was ~97 tags, most never linked to a published article. Showing all of them made the filter panel visually overwhelming and offered dead-end selections (clicking a tag would show zero results).

## Decision

The tag query on the browse page uses a Supabase `!inner` join on `article_tags_links`:

```typescript
supabase
  .from('article_tags')
  .select('id, name, slug, icon, article_tags_links!inner(article_id)')
  .order('name')
```

`!inner` causes Supabase to return only rows in `article_tags` that have at least one matching row in `article_tags_links`. Tags with no linked articles are excluded from the result. The joined `article_tags_links` data is discarded after the query via type cast (`as unknown as ArticleTag[]`).

## Alternatives considered

- **Postgres view** — a `used_article_tags` view that pre-filters the table. More portable across query sites but adds schema overhead for a single consumer.
- **Server-side filter with published check** — also exclude tags where all linked articles are unpublished. Not implemented because unpublished articles are invisible to the public anyway; the tag still represents a valid topic the author intends to publish about.

## Consequences

- Tag filter chips reflect only topics that have published content, keeping the list actionable.
- Tags added but never linked to a published article are invisible on the browse page without any schema change.
- If a tag's last published article is deleted or archived, the tag disappears from the filter automatically on next page load.
