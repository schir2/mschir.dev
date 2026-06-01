# ADR 0012 — Article Breadcrumb Trail Hierarchy

## Status

Accepted

## Context

The Article Detail Page (`/articles/[slug]`) had no upward navigation. A reader who arrived via the Portfolio Page, the Home Page recent articles list, or a direct link had no visible way to get back into the article section. Breadcrumbs were chosen to solve the "where am I in the hierarchy?" problem; the browser back button was left to handle "where did I come from?" — a history-dependent problem breadcrumbs cannot solve reliably.

## Decision

Breadcrumbs are scoped to the article section only. Top-level pages (Home, Portfolio, About, Contact) are reachable from the sticky navbar and have no meaningful parent — they get no breadcrumb. Project detail pages will follow the same pattern when built.

**Trail hierarchy for `/articles/[slug]`:**
- With series: `Articles > Category Name > Series Title > Article Title`
- Without series: `Articles > Category Name > Article Title`

Both category and series are included when present. Category was chosen over a bare `Articles > Title` trail because the Article Detail Page already fetches category and series data, and surfacing category in the breadcrumb gives readers a direct path into the filtered browse view — a navigation shortcut not available elsewhere on the page. Series is included when present because the Series Page (`/articles/series/[slug]`) is a real destination (ordered reading list) and the breadcrumb makes it discoverable to readers who did not arrive via the series.

**Other routes:**
- `/articles/browse` → `Articles > Browse`
- `/articles/series/[slug]` → `Articles > Series Title`

**Placement:** Inside the page's content container (`max-w-4xl`), at the very top of the content area, above the hero image and archived banner. Hidden on mobile (`hidden md:flex`) — the sticky navbar and browser back button are sufficient on small screens.

## Alternatives Considered

- **`Articles > Article Title` only** — simpler but wastes the category link and leaves series undiscoverable via breadcrumb.
- **`Articles > Series Title > Article Title` (series replaces category)** — loses the category path for non-series readers and for articles that are in a series but where the reader navigated directly via category.
- **Full-width breadcrumb bar** — spans the viewport rather than the content container. Rejected because on wide screens the trail would be far from the content column, making it hard to find.
- **Collapsed breadcrumbs on mobile** — shows `Articles > … > Title`. Rejected in favour of hiding entirely; the collapsed pattern adds complexity with little benefit given the sticky navbar.
