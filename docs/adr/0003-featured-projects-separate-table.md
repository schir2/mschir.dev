# ADR-0003: featured_projects as a separate table, not a boolean on projects

The portfolio page needs a curated subset of projects displayed with portfolio-specific copy. Two options were considered: an `is_featured` boolean (plus `featured_order`) on the `projects` table, or a separate `featured_projects` table.

A separate table was chosen because a featured project carries a `tagline` — a short punchy hook written specifically for the portfolio context — that is distinct from the canonical `description` on `projects`. Conflating the two would either force portfolio copy into the canonical record or require null-able columns that only make sense in the portfolio context. The separate table also keeps `projects` as a clean data record; featured status is a presentation concern. This mirrors the existing `featured_articles` pattern already in the schema.

## Considered Options

**Boolean on `projects`** — simpler schema; rejected because there is no clean place for the portfolio-specific `tagline`. The canonical `description` serves a different purpose and should not be overloaded with showcase copy.

**Separate `featured_projects` table** — accepted. Follows `featured_articles` precedent. Keeps project canonical data clean. `tagline`, `display_order`, and any future portfolio-only fields live here without polluting the source record.