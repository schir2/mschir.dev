# Handoff: mschir.dev — Issue #86 Google Analytics Integration

**Project:** `/apps/mschir.dev`
**Issue:** https://github.com/schir2/mschir.dev/issues/86
**Status:** Implementation done, verification in progress — user restarted computer to clear stuck port 3000

---

## What's done

### Decisions (all finalised via grill-with-docs session)
- **GA4 direct via `nuxt-gtag`** — no GTM middleman
- **Measurement ID:** `G-TBFLGWRP7Y` (hardcoded in `nuxt.config.ts` — public value, not sensitive)
- **Production-only** loading — silent in dev unless debug flag set
- **Consent Mode v2** defaults: all signals `denied` (cookieless/modeled mode); consent banner deferred to follow-up issue
- **Pageviews only** for this issue — custom events (article read depth, CTA clicks, etc.) deferred to a separate issue
- **`view_count` DB sync from GA4** — deferred entirely; too complex for now

### Files changed
- `nuxt.config.ts` — `nuxt-gtag` added to modules, `gtag` config block added
- `docs/adr/0014-analytics-ga4-nuxt-gtag.md` — ADR written and saved

### Package installed
```bash
pnpm add nuxt-gtag  # installed as nuxt-gtag@^4.1.0
```

---

## Current state of `nuxt.config.ts` gtag block

```typescript
gtag: {
    id: 'G-TBFLGWRP7Y',
    enabled: true,                    // ⚠️ TEMPORARY — hardcoded for testing
    config: { debug_mode: true },     // ⚠️ TEMPORARY — hardcoded for testing
    initCommands: [
        ['consent', 'default', {
            analytics_storage: 'denied',
            ad_storage: 'denied',
            ad_user_data: 'denied',
            ad_personalization: 'denied',
            wait_for_update: 500,
        }],
    ],
},
```

**After verification, restore to the env-var-driven version:**

```typescript
gtag: {
    id: 'G-TBFLGWRP7Y',
    enabled: process.env.NODE_ENV === 'production' || process.env.DEBUG === 'true',
    config: { debug_mode: process.env.DEBUG === 'true' },
    initCommands: [
        ['consent', 'default', {
            analytics_storage: 'denied',
            ad_storage: 'denied',
            ad_user_data: 'denied',
            ad_personalization: 'denied',
            wait_for_update: 500,
        }],
    ],
},
```

And create `.env` (gitignored) with:
```
DEBUG=true
```

---

## What's left (in order)

1. **Verify gtag loads after clean restart**
   - Start dev server: `pnpm run dev`
   - Open `http://localhost:3000` in browser
   - Open DevTools → Console → type `typeof gtag` → should return `"function"`
   - Open DevTools → Network → filter `gtag` → should see request to `googletagmanager.com/gtag/js?id=G-TBFLGWRP7Y`

2. **Verify events in GA4 DebugView**
   - Go to `analytics.google.com` → select the mschir.dev property → Admin → DebugView
   - Browse a few pages locally
   - Confirm `page_view` events appear in the timeline within ~10 seconds

3. **Restore env-var config** (see above)
   - Replace hardcoded `enabled: true` and `debug_mode: true` with env-var expressions
   - Create `.env` with `DEBUG=true`
   - Restart dev server and confirm DebugView still works

4. **Close issue #86**
   - All acceptance criteria will be met once DebugView confirms events firing

---

## Known pre-existing warnings (unrelated — ignore)
- "Plugin has already been applied" from `confirm-service.ts` and `toast-service.ts`
- "Missing required prop: breadcrumbs" on article `[slug]` page
- `/_nuxt/builds/meta/dev.json 404` — stale `.nuxt` cache; fix with `rm -rf .nuxt` before `pnpm run dev`

---

## Suggested skills

- `/conversation-residue` — capture decisions from this session once the issue is closed
- `/to-issues` — create the follow-up issues for: (1) custom event taxonomy, (2) consent banner via `nuxt-cookie-control`
