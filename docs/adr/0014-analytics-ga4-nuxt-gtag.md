# ADR 0014 — Analytics: GA4 Direct via nuxt-gtag

## Status

Accepted

## Context

mschir.dev had no analytics. The goal is to understand site traffic: pageviews by route, session patterns, and which articles attract readers. Two approaches were evaluated: Google Tag Manager (GTM) as a tag delivery container that fires GA4, or GA4 loaded directly without GTM as a middleman.

## Decision

**GA4 direct via the `nuxt-gtag` Nuxt module.** Measurement ID: `G-TBFLGWRP7Y`.

GTM's core value — letting non-developers manage tags via a UI without code deploys — does not apply to a single-author personal site. GTM would add a second network request, a second script, and a second configuration surface (the GTM container UI) with no benefit. GA4 loaded directly is one hop, one script, and all config lives in the codebase.

**Production-only loading.** Analytics is disabled in dev and preview builds (`process.env.NODE_ENV === 'production'`). This prevents local development sessions from polluting production data.

**Consent Mode v2 defaults.** All GA4 consent signals (`analytics_storage`, `ad_storage`, `ad_user_data`, `ad_personalization`) default to `denied`. GA4 runs in cookieless/modeled mode — no cookies are set and no PII is sent until a user grants consent. A visible consent banner is deferred to a follow-up issue; this default satisfies the "no PII without consent" requirement in the interim.

**Pageviews only.** `nuxt-gtag` fires a pageview event automatically on every Nuxt router navigation. No custom events are wired in this issue. Custom event taxonomy (article read depth, CTA clicks, outbound link clicks) is tracked separately.

## Alternatives Considered

- **GTM as the tag container** — rejected. GTM's UI-managed tag deployment is irrelevant for a single developer. Extra complexity, extra network overhead, no benefit.
- **Manual `<script>` tag in `nuxt.config.ts`** — rejected. `nuxt-gtag` handles the Nuxt router integration (pageview on route change) and Consent Mode v2 wiring out of the box. Replicating that manually adds boilerplate with no upside.
- **GA4 enabled in dev for local testing** — not adopted as a permanent setting. DebugView in GA4 can be used temporarily during development by enabling the module conditionally, then reverting before commit.

## GDPR / Consent Debt

Consent Mode v2 with all signals defaulting to `denied` satisfies the letter of the requirement (no PII without consent) but does not give users visible control over their data. A consent banner (likely via `nuxt-cookie-control`) is a known follow-up. Until that banner exists, EU visitors receive modeled analytics data only — no cookies, no identifiers.