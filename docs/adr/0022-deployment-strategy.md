# ADR 0022 — Deployment strategy

## Status

Accepted

## Context

mschir.dev (Nuxt 4 SSR + Supabase) needs a deployment strategy for a VPS hosted on Hostinger running Ubuntu, with nginx already handling TLS termination. The previous tenant on the VPS is a Django/Gunicorn app that will be replaced.

Key constraints driving the decision:

- Commits were previously pushed directly to `main` including small incremental changes — always-on auto-deploy to `main` would have shipped half-finished work
- Must not silently break the live site — any automation needs a visible failure mode
- VPS has no built-in rollback — must be designed in explicitly
- Supabase schema migrations must be coordinated with app code deploys to avoid the live site hitting a schema it wasn't built against

## Decision

### Branching workflow

`main` = production. Feature work happens on branches; direct WIP commits to `main` are no longer the norm. A merge to `main` is the explicit signal that something is ready to go live.

### Trigger: GitHub Actions on merge to `main`

Every merge to `main` fires a GitHub Actions workflow automatically — no manual approval gate. The branch discipline (feature branches + PR merge) is the human checkpoint; a second approval click inside CI adds friction without meaningful safety.

### Build in CI, ship artifact to VPS

The GitHub Actions runner runs `pnpm install` and `pnpm build`. The resulting `.output/` directory is rsynced to the VPS over SSH. The VPS is never asked to build — it only runs the pre-built artifact. This keeps build spikes off the production server and means a failed build never touches the live site.

### Migrations before code

The workflow runs `npx supabase db push` (using a Supabase service role key stored as a GitHub Actions secret) before rsyncing the artifact. Schema is always updated before the new code lands. The old code (still serving during the rsync + PM2 reload window) sees the new schema, which must remain backwards-compatible — destructive schema changes (dropping columns the old code reads) require a two-phase deploy.

### Previous artifact retained for rollback

Before rsyncing the new build, the workflow moves the current `.output/` to `.output.bak/` on the VPS. Rolling back app code is one SSH command:

```bash
mv /root/.output.bak /root/.output && pm2 reload mschir
```

Schema changes cannot be rolled back this way — rollback is only safe when the previous code is compatible with the already-applied migrations.

### PM2 for process management

PM2 manages the Node process: auto-restart on crash, startup on reboot (`pm2 startup`), zero-downtime reload on deploy (`pm2 reload`). nginx proxies port 80/443 → 3000 (the Nuxt app).

### Secrets: GitHub Actions → VPS `.env` on each deploy

All production secrets (`NUXT_TURNSTILE_SECRET_KEY`, `NUXT_RESEND_API_KEY`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `NUXT_PUBLIC_TURNSTILE_SITE_KEY`, `SITE_URL`) are stored as GitHub Actions secrets. The workflow writes them to `/root/.output/server/.env` on the VPS during each deploy. GitHub is the single source of truth — adding a new secret means adding it to GitHub secrets and merging any PR that uses it; the next deploy propagates it automatically.

## Consequences

- Direct commits to `main` for in-progress work must stop — this is a workflow change
- Schema changes that are backwards-incompatible require two PRs (schema-only first, then code)
- Rollback restores app code only; database state is not rolled back
- The Supabase service role key must be stored as a GitHub Actions secret — treat it with the same care as a production DB password
- A `.env.example` documenting all required env vars should be added to the repo so the GitHub secrets list stays auditable

## Alternatives considered

- **Manual SSH pull-and-run** — rejected: no automation, relies entirely on human discipline for every deploy
- **Build on the VPS** — rejected: build spikes risk destabilising the live server; a mid-build failure leaves the site in an unknown state
- **GitHub Actions with manual approval gate** — rejected: redundant once branch discipline is established; adds a click with no safety benefit
- **Env vars in VPS `.env` only (no CI involvement)** — rejected: requires SSH access to add or rotate secrets; GitHub secrets are more auditable and discoverable
