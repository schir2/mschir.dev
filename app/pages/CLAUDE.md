# app/pages/CLAUDE.md

## Heading hierarchy

Every public content page must have exactly one `<h1>` as its first visible element. Use `text-4xl font-bold` to match the site-wide scale. Sections within a page use `<h2>` (Fraunces applies automatically via the global `h1, h2` CSS rule — no `font-display` class needed on h2s).

| Page | h1 text | Notes |
|---|---|---|
| `/about` | "Marek Schir" | Name is the subject — not "About" |
| `/contact` | "Get in Touch" | Functional label, not the page-nav label |
| `/portfolio` | "Portfolio" | |
| `/articles` | "Articles" | |
| `/projects` | "Projects" | |
| `/articles/[slug]` | article title | Dynamic, from data |
| `/projects/[slug]` | project name | Dynamic, from data |

**Homepage exception**: `/` uses "Marek Schir" as `<h1>` in the hero. Section eyebrow labels ("What I Build", "Recent Articles") are plain `<span class="text-xs uppercase tracking-widest font-medium text-muted-color">` — intentional visual decoration, not semantic headings. Service pillar titles are `<h2>` (the first real document heading after the hero h1).

**Never skip heading levels.** h1 → h3 without an h2 in between is invalid. If a section label is visually styled as an eyebrow/overline rather than a document heading, use a `<span>` — don't force it into an h2 just to satisfy hierarchy.

## SEO

Every **public** page must call `usePageSeo()` from `~/composables/usePageSeo`. Admin, auth, and prototype pages are excluded — they are served with `noindex` via `nuxt-robots` configuration and must not call `usePageSeo`.

### Which pages are public

```
/             /about          /contact        /portfolio
/articles     /articles/browse
/articles/series/[slug]       /articles/[slug]
/projects     /projects/[slug]
```

### Which pages are excluded

```
/admin/**     /login    /register    /callback    /prototype/**
```

### Static pages

Pass plain strings. `title` is the page-specific part only — the site name (`| Marek Schir`) is appended automatically by the global `titleTemplate`.

```ts
usePageSeo({
  title: 'About',
  description: 'Software Developer & Systems Architect with 14 years of experience across networking, infrastructure, software development, and integrations.',
})
```

### Dynamic pages (article / project detail)

Pass getter functions so values stay reactive to the resolved data. Call `usePageSeo` after `useAsyncData` so the ref exists.

```ts
const { data: article } = await useAsyncData(`article-${slug}`, async () => { /* ... */ })

usePageSeo({
  title: () => article.value?.title,
  description: () => article.value?.summary ?? undefined,
  image: () => heroImageUrl.value ?? undefined,   // full public URL, not a storage path
  type: 'article',
  publishedAt: () => article.value?.published_at ?? undefined,
})
```

`image` should be the resolved public URL (via `supabase.storage.from('images').getPublicUrl(path)`), not the raw storage path. When omitted or undefined, `usePageSeo` falls back to `/seo/og-default.png`.

### `usePageSeo` signature

```ts
interface PageSeoOptions {
  title: MaybeRefOrGetter<string | undefined>
  description: MaybeRefOrGetter<string | undefined>
  image?: MaybeRefOrGetter<string | undefined>      // full URL; falls back to /seo/og-default.png
  type?: 'website' | 'article'                      // defaults to 'website'
  publishedAt?: MaybeRefOrGetter<string | undefined> // ISO string; article pages only
}
```

Source: `app/composables/usePageSeo.ts`

### `lazy: true` on detail pages

Article and project detail pages do **not** use `lazy: true` on their primary `useAsyncData` call. SSR must await the data so crawlers receive populated meta tags. All other pages may use `lazy: true` as normal.