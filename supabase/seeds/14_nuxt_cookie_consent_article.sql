-- Draft article: Cookie Consent in Nuxt with nuxt-cookie-control

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000014',
    'Cookie Consent in Nuxt with nuxt-cookie-control',
    'cookie-consent-in-nuxt-with-nuxt-cookie-control',
    $article$# Cookie Consent in Nuxt with nuxt-cookie-control

After sorting out which services on this site needed consent, I needed a way to collect it,
store it, and wire it to Google Analytics without building all of that from scratch.
`nuxt-cookie-control` handles the consent state and storage. Connecting it to Google's
consent signals takes one small composable on top.

## Installing the Module

```bash
pnpm add @dargmuesli/nuxt-cookie-control
```

Add it to modules in `nuxt.config.ts`:

```ts
modules: [
  'nuxt-gtag',
  '@dargmuesli/nuxt-cookie-control',
  // other modules
]
```

Order matters: `nuxt-gtag` should come before `nuxt-cookie-control` so the Consent Mode
defaults are registered before the cookie module initializes.

## Configuring Your Cookies

The module needs to know which cookies your site sets and what category they belong to.
For a site running only Google Analytics, the configuration is minimal:

```ts
cookieControl: {
  cookies: {
    necessary: [],
    optional: [
      {
        id: 'ga',
        name: 'Google Analytics',
        description: 'Tracks page views to help understand how content is being used. No advertising data is collected.',
        targetCookieIds: ['_ga', '_ga_TBFLGWRP7Y'],
      }
    ]
  }
}
```

`targetCookieIds` lists the actual cookie names that get deleted if the user withdraws
consent. The `_ga_TBFLGWRP7Y` entry is the measurement-ID-specific GA4 cookie.

## Wiring Google Consent Mode

The module does not integrate with Google Consent Mode directly, but it exposes a
`cookiesEnabledIds` ref you can watch. The Consent Mode defaults in `nuxt.config.ts`
already set `analytics_storage` to `denied` with `wait_for_update: 500`, so the browser
waits up to 500ms for this composable to run before GA decides whether to fire:

```ts
// composables/useAnalyticsConsent.ts
export function useAnalyticsConsent() {
  const { cookiesEnabledIds } = useCookieControl()
  const { gtag } = useGtag()

  watch(
    cookiesEnabledIds,
    (enabledIds) => {
      const analyticsGranted = enabledIds?.includes('ga') ? 'granted' : 'denied'
      gtag('consent', 'update', {
        analytics_storage: analyticsGranted,
      })
    },
    { immediate: true }
  )
}
```

Call it in `app.vue` so it runs on every page:

```ts
// app.vue
useAnalyticsConsent()
```

## Replacing the Default UI with PrimeVue

The module ships with its own component styles. Setting `colors: false` strips all of them,
leaving only the logic and the component shell:

```ts
cookieControl: {
  colors: false,
  // ...
}
```

The `<cookie-control>` component accepts named slots for the banner and the preferences
modal. A minimal banner using PrimeVue components:

```vue
<cookie-control>
  <template #bar="{ acceptAll, denyAll }">
    <div class="flex items-center justify-between gap-8 p-6 bg-surface-900 border-t border-surface-700">
      <p class="text-sm text-muted-color">
        This site uses Google Analytics to understand how content is being used.
        No advertising cookies are set.
      </p>
      <div class="flex gap-4 flex-shrink-0">
        <p-button label="Accept" severity="success" @click="acceptAll()" />
        <p-button label="Decline" severity="secondary" outlined @click="denyAll()" />
      </div>
    </div>
  </template>
</cookie-control>
```

The `acceptAll` and `denyAll` functions are passed directly as slot props, so no
`useCookieControl()` import is needed in the template.

For a preferences modal where users can toggle individual categories, use the `#modal` slot
in the same way: the module handles showing and hiding it; you control the markup.
$article$,
    'How to add a GDPR-compliant cookie consent banner to a Nuxt site using nuxt-cookie-control, wired to Google Consent Mode v2 and styled with PrimeVue slot overrides.',
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    '2026-06-09 10:00:00+00',
    '2026-06-09 10:00:00+00'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000014', id
from public.article_tags
where slug in ('privacy', 'gdpr', 'nuxt');
