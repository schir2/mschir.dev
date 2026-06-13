-- Draft article: nuxt-link vs router-link vs plain anchors

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000019',
    'nuxt-link vs router-link: What Nuxt Adds to Internal Navigation',
    'nuxt-link-vs-router-link',
    $article$# nuxt-link vs router-link: What Nuxt Adds to Internal Navigation

I swapped a `router-link` to `nuxt-link` in a breadcrumb today. They render the same anchor tag, look identical in the template, and the Nuxt docs say to prefer `nuxt-link` without explaining why. So I dug in.

## The Short Version

Three types of link, three different behaviors:

- `<a href>`: full browser navigation, reloads the page. For external URLs and file downloads.
- `<router-link>`: Vue Router's client-side navigation. No page reload, JS routing. Nothing Nuxt-specific.
- `<nuxt-link>`: wraps `RouterLink` and adds Nuxt's prefetch layer. The right choice for all internal links in a Nuxt app.

## What Prefetching Actually Does

When a `nuxt-link` enters the viewport, Nuxt uses an `IntersectionObserver` to detect it and starts fetching the JavaScript chunks for that route in the background, before the user clicks.

By the time they click, the code is already loaded. Navigation feels instant.

This only kicks in for routes that haven't been loaded yet. Already-visited routes are cached by the router, so prefetching there is a no-op.

## Controlling Prefetch Behavior

The default is viewport-based: links prefetch their route once they become visible. You can override this per-link:

```html
<!-- Disable prefetch entirely -->
<nuxt-link to="/heavy-page" :prefetch="false">Heavy Page</nuxt-link>

<!-- Prefetch on hover or focus, not on viewport entry -->
<nuxt-link to="/about" prefetch-on="interaction">About</nuxt-link>
```

`prefetch-on` accepts `"visibility"` (default) or `"interaction"`. For links that are always on screen (like nav items), I use `"interaction"` to avoid prefetching every route on every page load. For links to rarely-visited pages with large route chunks, I disable prefetch entirely and let the user's click trigger the load.

## The prefetchedClass Prop

Add a class to a link once its route has been prefetched:

```html
<nuxt-link to="/about" prefetched-class="is-ready">About</nuxt-link>
```

I use this during development to confirm that nav links are prefetching correctly. You can also use it for progressive enhancement: style or animate the link differently once the destination is loaded in the background.

## External Links

`nuxt-link` detects external URLs and renders them as plain anchor tags with `target="_blank" rel="noopener noreferrer"`. But a plain `<a>` is clearer in the template about what it is. The rule I follow:

```html
<!-- Internal -->
<nuxt-link to="/articles">Articles</nuxt-link>

<!-- External -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Example</a>

<!-- Download -->
<a href="/files/resume.pdf" download>Resume</a>
```

## What router-link Gets You

The same client-side navigation as `nuxt-link`, minus prefetching. In a Nuxt app there's no reason to reach for it. `nuxt-link` is a strict superset. The only case where `router-link` makes sense is a pure Vue Router context without Nuxt's layer, which doesn't come up in practice.

## Active State Classes

Both components apply `router-link-active` on partial route matches and `router-link-exact-active` on exact matches. Remap them with the `active-class` and `exact-active-class` props if you want custom names.

In PrimeVue projects I leave the router classes alone and style nav active states with `:deep(.router-link-exact-active)` on the nav component.
$article$,
    'How nuxt-link differs from router-link and plain anchor tags, and how Nuxt''s viewport-based prefetching works.',
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    now(),
    now()
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000019', id
from public.article_tags
where slug in ('nuxt', 'vue.js');
