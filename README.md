# mschir.dev

Personal portfolio site for Marek Schir. Built with Nuxt 4, Supabase (PostgreSQL + auth), and PrimeVue.

## Stack

- **Frontend**: Nuxt 4, Vue 3, PrimeVue 4, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Row-Level Security, Storage, Auth)
- **Testing**: Vitest (components/composables), pgTAP (DB layer), Deno (edge functions)
- **Markdown**: md-editor-v3 (editor + public rendering, with Mermaid and KaTeX)

## Development

```powershell
pnpm install              # Install dependencies
pnpm run supabase:start   # Start local Supabase stack (required for local dev)
pnpm run db:reset         # Reset local DB and re-run migrations + seeds
pnpm run dev              # Start dev server at http://localhost:3000
```

### Google OAuth (local dev)

Google OAuth requires a one-time setup in Google Cloud Console and a local environment variable:

1. In [Google Cloud Console](https://console.cloud.google.com/) go to **APIs & Services > Credentials** and open your OAuth 2.0 client.
2. Under **Authorized JavaScript origins** add `http://localhost:3000`.
3. Under **Authorized redirect URIs** add `http://localhost:54321/auth/v1/callback`.
4. Copy the client secret and add it to a `.env` file in the project root:
   ```
   SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_SECRET=your-client-secret
   ```
5. Confirm `supabase/config.toml` has the matching client ID and `redirect_uri`:
   ```toml
   [auth.external.google]
   enabled = true
   client_id = "your-client-id.apps.googleusercontent.com"
   secret = "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_SECRET)"
   skip_nonce_check = false
   redirect_uri = "http://localhost:54321/auth/v1/callback"
   ```
6. Restart the local Supabase stack to pick up the env variable: `pnpm run supabase:start`.

The redirect URI in Google Console and the `redirect_uri` in `config.toml` must be identical. Mixing `localhost` and `127.0.0.1` will cause a silent `Unable to exchange external code` error.

## Commands

```powershell
pnpm run build            # Build for production
pnpm run preview          # Preview production build
pnpm run supabase:types   # Regenerate types/database.types.ts from schema
pnpm run db:migrate       # Apply pending migrations without a full reset
pnpm test                 # Run Vitest component/composable tests
pnpm run test:db          # Run pgTAP database tests (requires supabase:start)
pnpm run test:edge        # Run Deno edge function tests
```

## Documentation

- [`CLAUDE.md`](./CLAUDE.md) — development environment, conventions, and architecture guide for Claude Code
- [`CONTEXT.md`](./CONTEXT.md) — domain glossary (canonical terms for all domain concepts)
- [`docs/adr/`](./docs/adr/) — architecture decision records