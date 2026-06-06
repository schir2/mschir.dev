# Handoff: Deploy Pipeline Setup

**Date:** 2026-06-06
**Branch:** `main`
**Picking up from:** Session that ran the `grill-with-docs` spike for issue #115, broke it into issues #116–#121, and implemented most of the infrastructure.

---

## What was accomplished this session

### Completed
- **ADR written:** `docs/adr/0022-deployment-strategy.md` — full rationale for chosen approach
- **Issues created:** #116–#121 on schir2/mschir.dev covering the full deploy pipeline
- **#116 closed:** PM2 installed on VPS, `arcus.service` migrated to PM2, `pm2-root.service` handles reboots
- **#117 partial:** nginx config for mschir.dev written to `/etc/nginx/sites-available/mschir.dev` and symlinked into `sites-enabled`. Config tested (`nginx -t` passes) but **nginx has NOT been reloaded yet** — Django/Gunicorn is still serving mschir.dev. Reload happens after Nuxt is confirmed running on port 3002.
- **#118 done:** `.env.example` committed to repo root
- **#119 done:** All 13 GitHub Actions secrets set on schir2/mschir.dev (some as real values, Turnstile/Resend left as PLACEHOLDER — not needed to unblock deploy)
- **#120 done:** `.github/workflows/deploy.yml` committed and pushed

### VPS state
| App | Port | Manager | Status |
|---|---|---|---|
| getarcus.com (arcus) | 3001 | PM2 | Running |
| calcura.org | 3000 | PM2 (config only) | Down — see #121 |
| mschir.dev Django | 8000 | gunicorn.service (systemd) | Still live |
| mschir.dev Nuxt | 3002 | PM2 (config only) | Not yet started |

PM2 ecosystem config: `/apps/ecosystem.config.js`
App directory on VPS: `/apps/mschir.dev`

---

## Immediate blockers

### 1. Workflow failing: `supabase db push --linked` — project ref not found

**Run:** https://github.com/schir2/mschir.dev/actions/runs/27050094080

**Error:** `Cannot find project ref. Have you run supabase link?`

**Cause:** `supabase/config.toml` has `project_id = "mschir.dev"` (local name), not the actual Supabase project ref. The `--linked` flag needs either a prior `supabase link` step or an explicit `--project-ref`.

**Fix needed in `.github/workflows/deploy.yml`** — change the migrations step from:
```yaml
- name: Apply migrations
  run: npx supabase db push --linked
  env:
    SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
```
to:
```yaml
- name: Apply migrations
  run: npx supabase db push --project-ref nunhhchnxyreoflgxxdd
  env:
    SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
```

### 2. Supabase remote DB may have drifted from migrations

The user suspects the remote DB schema may not match the migration files in `supabase/migrations/`. This needs to be diagnosed with:
```bash
npx supabase link --project-ref nunhhchnxyreoflgxxdd
npx supabase db diff
```

**Requires Docker** — the user needs to restart their machine to get Docker running, then run these commands locally. If there's drift, a reconciliation migration may be needed before the deploy pipeline can push migrations safely.

---

## Remaining work to complete the deploy pipeline

1. **Fix workflow** — update `supabase db push` to use `--project-ref nunhhchnxyreoflgxxdd` (see above)
2. **Resolve DB drift** — run `supabase db diff` after Docker is up, reconcile if needed
3. **Get a green CI run** — first successful deploy will place the artifact at `/apps/mschir.dev/.output/` and PM2 will start mschir on port 3002
4. **Complete #117 cutover** — once Nuxt is confirmed on port 3002:
   - Run `certbot --nginx -d mschir.dev -d www.mschir.dev` to get SSL (Certbot will modify the nginx config automatically)
   - Run `systemctl reload nginx`
   - Run `systemctl stop gunicorn && systemctl disable gunicorn`
   - Verify mschir.dev loads the Nuxt app over HTTPS
5. **Close #117, #119, #120** once the above is verified
6. **Close #115** (the spike) once everything is live

---

## Key files changed this session

- `.github/workflows/deploy.yml` — CI/CD pipeline
- `.env.example` — production env var documentation
- `docs/adr/0022-deployment-strategy.md` — deployment strategy decision record
- `nuxt.config.ts` — removed unused `runtimeConfig.public.port`

## Suggested skills

- `/supabase` — for diagnosing and resolving the DB drift issue
- `/triage` — to update issue statuses as steps complete
