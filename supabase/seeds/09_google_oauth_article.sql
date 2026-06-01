-- Draft article: Google OAuth with Supabase local dev

insert into public.article_tags (name, slug)
values
    ('OAuth', 'oauth'),
    ('Authentication', 'authentication'),
    ('Nuxt', 'nuxt')
on conflict (slug) do nothing;

insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000009',
    'Google OAuth with Supabase Local Dev',
    'google-oauth-with-supabase-local-dev',
    $article$# Google OAuth with Supabase Local Dev

Setting up Google OAuth with Supabase is straightforward in production, but local development has a few gotchas that are easy to miss. This article walks through the full setup and the specific configuration decisions that matter.

## Prerequisites

- A Google Cloud project
- Local Supabase stack running (`supabase start`)
- `@nuxtjs/supabase` installed (or the Supabase JS client directly)

## Google Cloud Console Setup

Go to **APIs and Services > Credentials** and create a new OAuth 2.0 Client ID. Choose **Web application** as the application type.

Under **Authorized JavaScript origins**, add your app's local URL:

```
http://localhost:3000
```

Under **Authorized redirect URIs**, add the local Supabase auth callback:

```
http://localhost:54321/auth/v1/callback
```

Save the client ID and client secret. You will need both.

Note: the Supabase docs recommend using `http://127.0.0.1:54321/auth/v1/callback` instead of `localhost`. Either works, but whichever you register in Google Console must match exactly what you configure in `config.toml`. If they do not match, the code exchange will fail with a cryptic `Unable to exchange external code` error.

## Supabase Config

In `supabase/config.toml`, enable the Google provider and set the redirect URI to match what you registered in Google Console:

```toml
[auth.external.google]
enabled = true
client_id = "your-client-id.apps.googleusercontent.com"
secret = "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_SECRET)"
skip_nonce_check = false
redirect_uri = "http://localhost:54321/auth/v1/callback"
```

The `secret` value reads from an environment variable so the actual secret stays out of source control.

Also update `additional_redirect_urls` in the `[auth]` section to include your app's callback route:

```toml
[auth]
site_url = "http://localhost:3000"
additional_redirect_urls = ["http://localhost:3000", "http://localhost:3000/callback"]
```

The `site_url` is where Supabase redirects on failure. The `additional_redirect_urls` list must include any URL you pass as `redirectTo` in `signInWithOAuth` -- Supabase validates this against the allow list.

## Environment Variable

Add the client secret to your local environment. Create a `.env` file in the project root (or add to your existing one):

```
SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_SECRET=your-client-secret
```

Make sure this file is in `.gitignore`. Do not commit client secrets.

After changing `config.toml` or environment variables, restart the local Supabase stack:

```bash
supabase stop && supabase start
```

## App Code

Call `signInWithOAuth` with a `redirectTo` pointing to your callback route:

```typescript
const supabase = useSupabaseClient()
const config = useRuntimeConfig()

await supabase.auth.signInWithOAuth({
  provider: 'google',
  options: {
    redirectTo: `${config.public.siteUrl}/callback`,
  },
})
```

The `redirectTo` URL tells Supabase where to send the user after the OAuth flow completes. It must be in your `additional_redirect_urls` list.

## Callback Route

Create a callback page at the route matching your `redirectTo`. With `@nuxtjs/supabase`, the module handles the PKCE code exchange automatically via middleware -- you just need the page to exist so the middleware fires:

```vue
<!-- app/pages/(auth)/callback.vue -->
<template>
  <div>Signing in...</div>
</template>
```

The module exchanges the code for a session and redirects the user. You can customize where they land by configuring `redirectOptions` in `nuxt.config.ts`:

```typescript
supabase: {
  redirectOptions: {
    login: '/login',
    callback: '/callback',
    exclude: ['/**'],
  }
}
```

## Common Mistakes

**Redirect URI mismatch**: the URI in Google Console, the `redirect_uri` in `config.toml`, and the actual URL the Supabase auth server listens on must all be consistent. Mixing `localhost` and `127.0.0.1` will cause silent failures at the token exchange step. The error message (`Unable to exchange external code`) does not make the mismatch obvious.

**Wrong client secret**: if you have multiple OAuth clients in Google Console (for example, separate clients for web, iOS, and Android), double-check that you are using the secret that matches the client ID configured in `config.toml`. A secret from a different client will cause the same `Unable to exchange external code` error.

**Missing `additional_redirect_urls`**: if the `redirectTo` URL is not in the allow list, Supabase will reject the redirect silently and send the user to `site_url` instead.

**Not restarting Supabase**: `config.toml` changes only take effect after a full restart of the local stack.
$article$,
    (select id from public.article_categories where slug = 'software-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    '2026-06-01 09:00:00+00',
    '2026-06-01 09:00:00+00'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000009', id
from public.article_tags
where slug in ('supabase', 'oauth', 'authentication', 'nuxt');