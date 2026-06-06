# mschir.dev

Personal portfolio site for Marek Schir. Built with Nuxt 4, Supabase (PostgreSQL + auth), and PrimeVue.

## Stack

- **Frontend**: Nuxt 4, Vue 3, PrimeVue 4, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Row-Level Security, Storage, Auth)
- **Testing**: Vitest (components/composables), pgTAP (DB layer), Deno (edge functions)
- **Markdown**: md-editor-v3 (editor + public rendering, with Mermaid and KaTeX)

## Development

```bash
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

```bash
pnpm run build            # Build for production
pnpm run preview          # Preview production build
pnpm run supabase:types   # Regenerate types/database.types.ts from schema
pnpm run db:migrate       # Apply pending migrations without a full reset
pnpm test                 # Run Vitest component/composable tests
pnpm run test:db          # Run pgTAP database tests (requires supabase:start)
pnpm run test:edge        # Run Deno edge function tests
```

## Dev Environment Setup (WSL Ubuntu)

### 1. Node.js (via nvm)
81C3-3539

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
rm -rf ~/.nvm  # if install fails due to broken existing install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
```

### 2. pnpm

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
source ~/.bashrc
pnpm --version
```

### 3. Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

### 4. WebStorm — pnpm integration

Run `which pnpm` to get the pnpm binary path, then:

**Settings → Languages & Frameworks → Node.js** → set package manager to pnpm and paste the path.

## Deployment

Deploys automatically on push to `main` via GitHub Actions (`.github/workflows/deploy.yml`). The workflow:

1. Tests the SSH connection to the VPS (fails fast before the build if the key or host is wrong)
2. Builds the Nuxt app
3. Copies the `.output/` artifact to the VPS via `rsync`
4. Reloads the app with `pm2`

**Required GitHub secrets:**

| Secret | Description |
|---|---|
| `VPS_HOST` | Public IP or hostname of the VPS |
| `VPS_USER` | SSH username on the VPS |
| `VPS_SSH_KEY` | Private SSH key — matching public key must be in `~/.ssh/authorized_keys` on the VPS |
| `SITE_URL` | Public site URL (e.g. `https://mschir.dev`) |
| `NUXT_PUBLIC_TURNSTILE_SITE_KEY` | Cloudflare Turnstile site key |
| `NUXT_TURNSTILE_SECRET_KEY` | Cloudflare Turnstile secret key |
| `NUXT_RESEND_API_KEY` | Resend API key for contact form emails |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key |

> **Migrations are not run by the pipeline.** Apply migrations manually with `npx supabase db push --linked` before or after deploying.

## Documentation

- [`CLAUDE.md`](./CLAUDE.md) — development environment, conventions, and architecture guide for Claude Code
- [`CONTEXT.md`](./CONTEXT.md) — domain glossary (canonical terms for all domain concepts)
- [`docs/adr/`](./docs/adr/) — architecture decision records