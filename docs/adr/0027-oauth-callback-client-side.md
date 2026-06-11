# ADR 0027 — OAuth callback handled client-side, not as a server route

The Google OAuth callback is handled in a client-side Vue page (`app/pages/(auth)/callback.vue`) rather than a Nuxt server route. This is required by the PKCE flow: the code verifier generated when the OAuth flow begins is stored in `localStorage`, which is inaccessible to the server. A server route cannot complete the code exchange without the verifier, so the exchange must happen in the browser.

`@nuxtjs/supabase` v2 handles the exchange automatically via `createBrowserClient` (`detectSessionInUrl: true`) — the client exchanges the code and writes the session to cookies during its initialization, before the page component mounts. The callback page only needs to redirect once the session is confirmed.

## Considered options

**Server route (`server/routes/callback.ts`)** — common in Next.js/Supabase examples that use the implicit grant flow or password flow. Not viable here: PKCE code verifiers live in `localStorage`, not in the HTTP request, so the server has no way to complete the exchange.

**Manual `exchangeCodeForSession` in the page** — explicit but redundant. The `@nuxtjs/supabase` plugin calls `getSession()` during its async setup, which waits for `initializePromise` (the auto-exchange). By the time the page mounts, the exchange is already done or has failed. Calling it again in the page would be a no-op at best.