# Handoff — Service Pages (Issue #102)

**Session date:** 2026-06-08  
**Branch:** main  
**Picking up from:** design + initial implementation complete; design refinement and series nav still needed

---

## What was done this session

### Issues created
- #140 — Remove infrastructure pillar (homepage + contact) — **closed/done**
- #141 — Design service page layout — **closed/done** (design decisions captured)
- #142 — `/services` index page
- #143 — `/services/integrations-apis`
- #144 — `/services/application-development`
- #145 — `/services/ai-automation`
- #148 — Series nav redesign (new, no blockers)

### Files created / modified
| File | Status |
|---|---|
| `app/pages/services/index.vue` | Created — needs design refinement |
| `app/pages/services/integrations-apis.vue` | Created — needs design refinement |
| `app/pages/services/application-development.vue` | Created — needs design refinement |
| `app/pages/services/ai-automation.vue` | Created — needs design refinement |
| `app/components/service/ServiceSiblingNav.vue` | Created — light/dark mode working |
| `app/components/layout/navbar.vue` | Services added (position 2, after Portfolio) |
| `app/components/layout/footer.vue` | Services added (position 2, after Portfolio) |
| `app/pages/index.vue` | Pillar cards now link to service pages; infrastructure pillar removed |
| `app/pages/contact.vue` | Infrastructure pillar removed from left panel |
| `docs/adr/0025-service-pages-separate-routes.md` | Created |
| `CONTEXT.md` | Services Domain section added; Service Pillars updated to 3 |
| `nuxt.config.ts` | `TabMenu` added to PrimeVue include list |
| `temp/` | 4 co-written copy files — source of truth for page copy |

### Prototype pages (throwaway — delete after issues close)
- `/prototype/service-nav` — service sibling nav variants (Variant C chosen: icon cards above h1)
- `/prototype/series-nav` — series nav variants (Variant B chosen: p-select + prev/next)

---

## What still needs work

### 1. Design refinement on service pages (#142–145)

The user was **not happy** with the current state. Specific complaints:
- **Typography**: h2 headings inside service detail pages use Fraunces (applied globally via `h1, h2` CSS rule). At section-heading scale this may be too heavy — needs a visual check and possible override
- **Services index cards**: pillar cards on `/services` use the same `pillar-card` scoped style as the homepage (copied inline). The 2-column grid with 3 items produces a 2+1 layout — consider whether `sm:grid-cols-3` or a single-column stack reads better
- **Overall rhythm**: sections on detail pages feel "a bit chaotic" — spacing and hierarchy need a pass

**Recommended approach:** Open the pages in the browser, identify the specific friction points, and do targeted fixes. Do NOT do a full rewrite before looking.

### 2. Series nav redesign (#148)

Fully designed and prototyped, not yet implemented. See issue #148 for full spec.

- Component to update: `app/components/article/ArticleSeriesPanel.vue`
- Page to update: `app/pages/articles/[slug].vue`
- Prototype reference: `/prototype/series-nav?variant=B`

---

## Key design decisions (don't re-litigate these)

All locked in `CONTEXT.md` (Services Domain section) and `docs/adr/0025-service-pages-separate-routes.md`.

| Decision | Choice |
|---|---|
| Separate routes vs tabs | Separate routes |
| Service sibling nav style | Icon card strip (Variant C) |
| Service sibling nav position | Above h1, with "Services" eyebrow linking to `/services` |
| Series nav | `<p-select>` dropdown + prev/next strip; "Series · [Title]" eyebrow above h1 |
| Project refs on app-dev page | Lightweight link list, not full ProjectCard |
| Nav order | Portfolio → Services → Articles → About → Contact |

---

## Suggested skills

- `/verify` — run the dev server and check each service page in both light and dark mode before making changes
- `/code-review` — after any design refinement, check for spacing rule violations (8-point grid, no `mb-*`/`mt-*`)
- `/copy-style` — if any copy on the service pages gets rewritten
