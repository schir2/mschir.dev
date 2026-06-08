# ADR 0025 — Service Pages: Separate Routes over Single Tabbed Page

## Status
Accepted

## Context
Three service detail pages needed to be built for the Services Section. The two structural options were:
- A single `/services` page with a `<p-tabs>` component switching between three service panels
- Three separate routes (`/services/integrations-apis`, `/services/application-development`, `/services/ai-automation`) with a `/services` index

Each service page carries 400–600 words of distinct copy, its own project references, and its own audience (a visitor evaluating one specific type of engagement).

## Decision
Three separate routes with a `/services` index.

## Reasons
- **SEO**: Each service gets its own `<title>`, `og:description`, and canonical URL. A tabbed page produces one shared URL for all services — a visitor sharing `/services?tab=ai-automation` with a client gets a URL that may not deep-link correctly and produces one generic og:description for all three services.
- **Shareability**: A `/services/ai-automation` URL can be dropped into a proposal email or a LinkedIn message and land the recipient on exactly the right page.
- **Established pattern**: The site already uses separate detail routes for articles and projects. The tooling (`usePageSeo`, layouts, breadcrumbs, `<p-tab-menu>` for sibling-nav) is already there.
- **Content weight**: Tabs make sense for short comparative content. These are sales pages — not a comparison table.

## Tradeoffs
A single tabbed page would have been simpler to implement and avoids the need for a sibling-nav component. Separate routes add a `<p-tab-menu>` Service Sibling Nav to each detail page so visitors can still jump between services without returning to the index.
