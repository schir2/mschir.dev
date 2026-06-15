# ADR 0026 — GDPR Cookie Consent

## Status

Superseded — 2026-06-14

Google Analytics and the cookie consent module were removed together. The consent banner was intrusive for a personal portfolio site and GA4 provided little value that justified it. Both `nuxt-gtag` and `@dargmuesli/nuxt-cookie-control` were uninstalled; `useAnalyticsConsent()` and the `<cookie-control />` component were deleted. No analytics is collected and no GDPR consent UI is needed.

The self-hosted fonts decision (section 1 below) remains in effect via `@nuxt/fonts`.

---

## Original Context (archived)

mschir.dev loads Google Analytics (GA4) and previously loaded fonts from the Google Fonts CDN. Both create GDPR obligations: sending visitor IP addresses to Google servers without explicit consent. The site targets EU visitors and must comply with GDPR as a baseline (which also satisfies CCPA, PIPEDA, and LGPD by extension).

Consent Mode v2 was configured with all signals defaulting to `denied` as an interim measure (ADR 0014), but no visible consent UI existed.

## Decisions

### 1. Self-host fonts via `@nuxt/fonts`

Google Fonts CDN `<link>` tags were removed from `nuxt.config.ts`. `@nuxt/fonts` downloads Fraunces and Inter at build time and serves them from the site's own origin. This eliminates the Google Fonts GDPR surface entirely — no third-party requests are made for fonts.

### 2. Consent scope: Google Analytics only

One optional cookie category: GA4 (`id: 'ga'`, targeting `_ga` and `_ga_TBFLGWRP7Y`). All other cookies and storage are strictly necessary:

| Cookie / storage | Category | Reason |
|---|---|---|
| Supabase auth session | Necessary | Authentication — no alternative |
| Cloudflare Turnstile | Necessary | Bot protection — functional requirement |
| `color-mode` preference | Necessary | User preference, no PII |
| GA4 (`_ga`, `_ga_*`) | Optional | Analytics — not required for site function |

### 3. `@dargmuesli/nuxt-cookie-control` for consent management

The library handles: consent cookie storage, the consent bar UI, the preferences modal, and the `cookiesEnabledIds` reactive ref that downstream code watches.

`colors: false` was evaluated (strip library CSS and override with custom PrimeVue-themed components) but abandoned — fighting the library's slot/button structure produced unstable, layered UI. The library is used with its own built-in UI.

`barPosition: 'bottom-full'` — standard pattern for full-width bottom bars; matches what most users expect from cookie consent.

### 4. `useAnalyticsConsent()` composable

Watches `cookiesEnabledIds` from `useCookieControl()` and calls:

```typescript
gtag('consent', 'update', {
  analytics_storage: enabledIds?.includes('ga') ? 'granted' : 'denied',
})
```

Called with `immediate: true` so the signal fires on every page load — not just on the moment of user interaction. This ensures GA4 always operates with the correct consent state even after the user has already made a decision in a previous session.

The consent payload logic is extracted as `analyticsConsentPayload()` — a pure function testable without mocking the Nuxt auto-import system. The composable wiring (watch + gtag call) is integration-level and not unit-tested.

**Why not mock `useGtag` in tests**: `nuxt-gtag` disables itself in non-production environments by aliasing `useGtagMock as useGtag` in the auto-import layer. `mockNuxtImport('useGtag', ...)` generates code that sets `module['useGtag']` in the mocked module, but `#imports` reads `module['useGtagMock']` — the key never lands. This is a structural limitation of the alias mechanism, not a fixable mock strategy.

### 5. "Cookie Preferences" re-entry via footer

A "Cookie Preferences" button in the footer copyright row sets `isModalActive = true` via `useCookieControl()`, which opens the library's built-in preferences modal. No custom re-entry UI is needed.

## Alternatives Considered

- **Custom consent banner (Variant C `p-card` design)** — prototyped and approved visually, but the integration was discarded because fighting `@dargmuesli/nuxt-cookie-control`'s bar/button slot structure produced two overlapping modals and unstyled library elements. The library's built-in UI is simpler and correct.
- **Custom consent solution without a library** — evaluated during the grilling session. Library wins on: automatic cookie deletion on withdrawal, future-proof locale strings, maintained cookie expiry logic.
- **CCPA/PIPEDA/LGPD as separate baselines** — GDPR is the strictest; complying with it covers the others without additional UI or logic.