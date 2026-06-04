# ADR 0021 — SEO strategy

## Status

Accepted

## Context

mschir.dev had no SEO beyond a static `<title>` tag. The goal was to add full SEO coverage (meta descriptions, Open Graph, canonical URLs, sitemap, robots.txt) without per-page boilerplate and without compromising the `lazy: true` data-fetching pattern on non-SEO-critical pages.

Three questions drove the decision: which module to use, where SEO logic lives, and how to handle dynamic pages that fetch content from Supabase.

## Decision

### Module: `@nuxtjs/seo` suite (cherry-picked sub-modules)

Install the `@nuxtjs/seo` meta-module. Use `@nuxtjs/sitemap` and `nuxt-robots` from the suite for their genuine complexity (XML generation, robots.txt serving, `lastmod` headers, `X-Robots-Tag` injection). Use manual `useServerSeoMeta` calls (via `usePageSeo`) for all meta tag work rather than `nuxt-schema-org` auto-inference. JSON-LD deferred to a follow-up (#109).

`@nuxtjs/og-image` (dynamic server-side OG image generation) is not used — Supabase Storage hero images are passed directly as `ogImage`. A static fallback at `/seo/og-default.png` covers pages with no hero image.

### Global defaults in `nuxt.config.ts`

- `titleTemplate`: `(title) => title ? \`${title} | Marek Schir\` : 'Marek Schir'` — function form handles the no-title case
- `site.name`: `'Marek Schir'`
- `site.url`: from `SITE_URL` env var
- Default `og:image`: `/seo/og-default.png`
- `twitter:card`: `summary_large_image`

### Per-page SEO via `usePageSeo` composable

A single `usePageSeo(options: PageSeoOptions)` composable in `app/composables/usePageSeo.ts` wraps `useServerSeoMeta` + canonical `useHead`. It accepts `MaybeRefOrGetter` values so the same composable serves both static pages (plain strings) and dynamic pages (getter functions over a reactive data ref). Required fields: `title`, `description`. Optional: `image`, `type`, `publishedAt`.

Every public page calls `usePageSeo`. Admin, auth, and prototype pages do not — they are covered by `nuxt-robots` disallow rules instead.

### `lazy: true` removed from detail pages

`/articles/[slug]` and `/projects/[slug]` remove `lazy: true` from their primary `useAsyncData` call. With `lazy: true`, SSR renders with null data and crawlers see empty meta tags. These pages need their content to render meaningfully anyway, so blocking SSR on the Supabase fetch is the correct trade.

All other pages may continue using `lazy: true`.

### Sitemap sources

`@nuxtjs/sitemap` discovers static routes automatically. Dynamic routes (`/articles/[slug]`, `/projects/[slug]`, `/articles/series/[slug]`) are sourced via a server API handler at `server/api/__sitemap__/urls.ts` that queries Supabase for:

- Published, non-archived articles (`published_at IS NOT NULL AND archived_at IS NULL`)
- All projects
- Series with at least one published article

Archived articles are excluded from the sitemap — they remain publicly accessible via direct URL but are not actively submitted for crawling.

### robots.txt

`nuxt-robots` replaces the static `/public/robots.txt`. Disallowed paths:

```
/admin
/login
/register
/callback
/prototype
```

Draft and unpublished articles are not disallowed explicitly — the article detail page already returns 404 for any article where `published_at IS NULL`, so crawlers cannot index them regardless.

## Alternatives considered

**`@nuxtjs/seo` full suite with auto-inference** — rejected because `nuxt-schema-org` auto-inference and `@nuxtjs/og-image` add complexity and runtime overhead not justified for a portfolio site with ~10 public pages. Manual `usePageSeo` is simpler to audit and debug.

**Manual sitemap (server route returning XML)** — rejected because `@nuxtjs/sitemap` handles caching, `lastmod`, XML formatting, and sitemap index splitting without boilerplate. The only custom code needed is the `sources` endpoint.

**Layout-level SEO via extended `route.meta`** — rejected because `route.meta` typing is awkward for arbitrary fields and the pattern breaks for dynamic pages where values come from async data, not static `definePageMeta` calls.