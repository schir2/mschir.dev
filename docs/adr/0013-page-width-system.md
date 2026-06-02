# ADR 0013 — Page Width System

**Status:** Accepted

## Context

Three different max-width values (`max-w-3xl`, `max-w-4xl`, `max-w-6xl`) existed across 8 public pages, with no documented rationale. Navigation between pages produced jarring layout shifts — most noticeably within the `/articles` section, which used all three widths internally.

## Decision

Standardize on **`max-w-6xl` (1152px)** as the site-wide page container width. One deliberate exception: the article prose body on the Article Detail Page is constrained to **`max-w-4xl` (896px)** for readability (targeting 60–80 characters per line).

### Implementation

- Every page's outermost container uses `max-w-6xl mx-auto px-6`.
- On `/articles/[slug]`, the outer container is `max-w-6xl`. Only the `<md-preview>` block is wrapped in an inner `max-w-4xl mx-auto` div. All other elements (breadcrumb, hero image, metadata bar, series panel, prev/next nav) use the full `max-w-6xl` width.
- No layout-level container — each page owns its own container class directly.

## Rationale

`max-w-6xl` already matched the portfolio and homepage, which the site owner considered the reference point. Narrower values on article and about pages had no documented reason and produced noticeable width jumps during navigation.

The article prose exception is content-type driven: long-form text is significantly more readable at narrower line lengths. Constraining only the prose (not the whole page) allows structural chrome — breadcrumbs, metadata, hero images — to align with the rest of the site.

## Alternatives Considered

**Single width for everything including article detail** — rejected because prose readability degrades noticeably at 1152px; the line length (~145 chars) is about twice the comfortable range.

**Narrower site-wide standard (e.g. `max-w-4xl`)** — rejected because grid-heavy pages (portfolio 3-col project cards, contact 2-col form) felt cramped and lost visual breathing room.

**Layout-level container component** — rejected as over-engineering; the site is small and each page's padding/vertical rhythm varies enough that a shared wrapper would need too many escape hatches.
