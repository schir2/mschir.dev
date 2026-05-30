# ADR-0004: skills.is_highlighted is a separate flag from proficiency

The portfolio Skills Snapshot needs to show a hand-picked subset of skills. Two options were considered: filter by proficiency threshold (show `advanced` and `expert` only), or an explicit `is_highlighted boolean` on the `skills` table.

An explicit flag was chosen because proficiency and "should appear on the portfolio snapshot" are different concerns. A skill can be `expert` but outdated or irrelevant to current work (and should be suppressed). A skill can be `advanced` but exactly what contracting clients are currently hiring for (and should be surfaced). Filtering by proficiency threshold would force the owner to either misrepresent their proficiency level to control visibility, or accept that the snapshot includes skills they do not want to advertise. `is_highlighted` defaults to `false` so new skills are never accidentally surfaced before the owner reviews them.

## Considered Options

**Filter by proficiency threshold** — rejected. Conflates expertise level with portfolio presentation intent. Would require proficiency ratings to serve double duty and break down as the skill list grows.

**`is_highlighted` boolean (default false)** — accepted. Decouples the factual self-assessment (`proficiency`) from the portfolio presentation decision (`is_highlighted`). The owner controls the snapshot independently of how skills are rated.