# ADR-0028: Two-tier Projects Page and description-gated detail pages

## Status

Partially implemented. The detail page 404 gate is live (migration + `[slug].vue`). The two-tier Projects Page layout is tracked in #180.

## Context

The `projects` table originally required `description NOT NULL`. All seeded projects had a one-liner description, and every project card linked to a detail page. When the project content research sprint (#105) was planned, it became clear that:

- Some projects are worth a full detail page (portfolio pieces with a rich write-up)
- Others are worth listing only as a career breadth signal ("I was doing this work") without implying they're showcase material
- Empty or one-liner detail pages create a poor UX — a visitor clicks through to find nothing

Three options were considered:

**A. Hide non-showcase projects entirely** — don't show them on `/projects` at all. Visitors only see projects with content. Simple, but loses the career-breadth signal entirely.

**B. Show all as full cards, degrade detail page gracefully** — all cards are clickable, thin pages for projects without rich descriptions. Rejected: a page with just metadata and no description body is "a big page full of empty nonsense" (user's words).

**C. Two-tier layout: full cards for described projects, compact "Other Work" rows for the rest** — Projects with a `description` render as full `ProjectCard` rows with links to the detail page. Projects without render as compact name/company/year/skills rows under an "Other Work" heading — no card chrome, no link.

## Decisions

### 1. `description` is nullable; detail page 404s when null

`description` was changed from `NOT NULL` to nullable. The `/projects/[slug]` route returns 404 when `description IS NULL`. This prevents anyone from landing on an empty page.

**Rationale:** The field is only populated after a research sprint or `/import-project` import. Requiring it at the schema level would block creating project records before the write-up is ready. Gating at the routing level achieves the same UX outcome without blocking DB writes.

### 2. Projects Page renders two tiers (pending #180)

- **Tier 1** (`description IS NOT NULL`): full `ProjectCard` rows, clickable, link to `/projects/[slug]`
- **Tier 2** (`description IS NULL`): compact rows — name, company · year, skills chips. Section heading: "Other Work". No link.

The split is a rendering decision only — one query, filtered in the component.

### 3. Project cards are only clickable when a detail page exists

`ProjectCard` does not render as a link for projects without a description. The compact Other Work rows are never links. This avoids dead navigation and confusing non-interactive cards mixed into the main list.

## Consequences

- New projects created via admin or seed have no detail page until a description is written
- The `/import-project` skill writes `description` as part of its flow, so imported projects get a detail page immediately
- Projects intentionally left in "Other Work" (legacy, minor, or private work) need `description` left null — do not add a placeholder
