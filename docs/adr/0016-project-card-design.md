# ADR 0016 — Project Card Design

## Status

Accepted

## Context

The project card needed a full design for the `/portfolio` Featured Projects section and the `/projects` list page. The previous `FeaturedProjectCard` was a vertical PrimeVue `p-card` in a 3-column grid — incompatible with the horizontal row pattern established by the Article Card. Design questions were resolved through a multi-variant browser prototype before any real component was written.

## Decisions

### 1. Horizontal row layout matching the Article Card, not a vertical grid card

**Options considered:**
- Vertical `p-card` in a responsive grid — matches the original portfolio layout; each card is tall and narrow; good for image-led content
- Horizontal list row (same mold as `ArticleCard`) — single-column, skimmable top-to-bottom; consistent with the article section's design language

**Decision:** Horizontal list row, single-column.

**Rationale:** Projects are text-led, not image-led. The name, company, year, and summary read left-to-right faster in a row than top-to-bottom in a vertical card. Single-column lists are also trivially mobile-friendly. Consistency with the article section means visitors learn one card grammar for the whole site. A 3-column grid was retained only because the old component was a `p-card` — dropping it removed the constraint.

### 2. Tagline replaces summary in the featured context

Featured projects carry both a `tagline` (a quick portfolio identity label on `featured_projects`, e.g. *"Job scheduling app for field service companies"*) and a `summary` (a plain-text blurb on `projects`).

**Options considered:**
- Tagline as an amber-bordered pill below the title, summary shown beneath — makes both visible; mirrors the article featured-reason pill
- Tagline replaces summary — one text slot, tagline shown when featured (since it is written for that context), summary shown otherwise
- Tagline shown in addition to summary — verbose; card grows tall when both are long

**Decision:** Tagline replaces summary when the card is rendered in a featured context (`featured: true` and `tagline` is set). Summary renders for non-featured cards.

**Rationale:** The tagline is intentionally written for the portfolio pitch — showing it alongside the longer summary is redundant. The pill approach (mirroring article featured-reason) looked cluttered when the tagline was a full sentence rather than a short label like "Staff pick". One text slot per card keeps the layout predictable regardless of context.

### 3. Flat skill chips, "Other" category not shown — no category grouping

**Options considered:**
- Flat icon+name chips, all skills, max 5 + overflow badge
- Skills grouped under tiny category labels (Languages / Frameworks / Databases), with the "Other" category (REST, AWS, GitHub) hidden

**Decision:** Flat chips, max 5 skills displayed, no category grouping, no filtering by category.

**Rationale:** Category grouping made the card footer multi-line and significantly taller. In a list of several projects this added visual noise without proportional benefit — skill categories are most useful in a dedicated skills section (e.g. Skills Snapshot), not in a dense list card. The +N overflow badge handles projects with many skills cleanly.

### 4. Deterministic gradient fallback for thumbnails

**Decision:** When no `image_url` is set, the 96×96 thumbnail slot shows a diagonal gradient (`linear-gradient(135deg, ...)`) derived deterministically from the project name. Six gradient variants cycle through `--p-primary-*` and `--p-surface-*` tokens. The hash is stable — the same project always gets the same gradient.

**Rationale:** A flat `bg-surface-700` (neutral dark) was visually inert and made all image-less cards look identical. A gradient using the existing brand token range adds visual differentiation without introducing off-brand colors or requiring a schema change to store per-project colors.

## Interaction pattern

Inherited from the Article Card (ADR 0011) — no deviations:

- **Default**: `opacity-85`
- **Hover**: `opacity-100`, `shadow-xl shadow-black/40`, `border-surface-700`, thumbnail `scale-110`
- **No translate-y** — see ADR 0011 §3
- Amber left bar (`w-1.5 bg-amber-500`) present only when `featured: true` — consistent with site-wide amber = featured rule
