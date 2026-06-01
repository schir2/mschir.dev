# ADR 0011 — Article Card Row Design

## Status

Accepted

## Context

The Article Card needed a full visual redesign to move from a legacy card-grid layout to a horizontal list row. Key design questions were resolved through iterative browser prototyping before any component code was written. Three decisions produced non-obvious outcomes worth recording.

## Decisions

### 1. Featured signal: amber bar, not category color

**Options considered:**
- Thin left bar using the **category color** — visually cohesive (bar and dot share the same color), works well in a dedicated featured section where all cards are featured and the category distinction matters
- Thin left bar in a **fixed amber accent** — consistent site-wide signal; any amber bar means "this article is editorially picked, regardless of category"

**Decision:** Fixed amber (`bg-amber-500`).

**Rationale:** The primary context for the card is a general article feed, not a dedicated featured section. In a general feed, "featured" is the stronger signal — readers need to learn one rule ("amber = featured") rather than scan for which category color happened to also be featured. If a dedicated featured section is added later, the category dot already carries category identity and the amber bar can remain a "featured" overlay without redundancy.

### 2. Series position: content zone, not metadata zone

A structural divider (`border-t border-surface-800`) always separates the card into two zones:
- **Content zone** (above the divider): title, featured reason pill, summary, series membership
- **Metadata zone** (below the divider): tags with +N overflow badge

**Options considered:** series below the divider alongside tags; series as subtitle directly below the title.

**Decision:** Series lives **above** the divider, as `"Part N of · [Series Title]"` text immediately before the divider. Tags live below it.

**Rationale:** Series is narrative context — it tells the reader where the article sits in a reading journey. Tags are discovery metadata used for filtering. Grouping them in the same row created a space-sharing conflict with long series titles. The divider makes the distinction structural and resolves overflow cleanly. The always-present divider (even when no series exists) provides visual consistency: the eye learns that metadata starts below the line.

### 3. No translate-y lift on hover for tightly-packed list items

**Problem observed:** A `hover:-translate-y-0.5` lift (2px) on list cards caused a visual jitter. When the mouse approached a card edge, the card would momentarily lift into the space of the card above, causing the hover target to shift and triggering a rapid hover/unhover cycle.

**Decision:** Remove `translate-y` entirely. Shadow (`hover:shadow-xl hover:shadow-black/40`), border lightening (`hover:border-surface-700`), and opacity change (`opacity-85` → `opacity-100`) communicate the hover state without affecting layout geometry.

## Interaction pattern

The full hover/click pattern for the approved design:

- **Default**: `opacity-85` — cards recede slightly in a long list, reducing visual noise
- **Hover**: `opacity-100`, `shadow-xl shadow-black/40`, `border-surface-700`, thumbnail `scale-110` (contained within `overflow-hidden`)
- **Click**: ripple — JavaScript-placed expanding `bg-white/15` circle from the click coordinate, 0.65s animation via `@keyframes ripple-expand`
- **No translate-y** — shadow does the lifting work without layout impact
