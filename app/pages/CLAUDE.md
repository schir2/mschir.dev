# app/pages/CLAUDE.md

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