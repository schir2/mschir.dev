# ADR-0020: Spacing Scale and Padding Layer Model

## Status
Accepted

## Context

The codebase accumulated scattered spacing values — `p-5`, `p-7`, `mb-3`, `gap-5` — with no enforced scale. Admin pages double-padded by adding `pt-6` on their wrapper on top of `AdminPageHeader`'s own `pt-6`. Components set `mb-6` to push siblings away, leaking margin outside their own box. The combination made spacing unpredictable and visually uneven.

## Decision

**Spacing scale: 8-point grid** (multiples of 8px). Valid Tailwind values: `p-2` (8), `p-4` (16), `p-6` (24), `p-8` (32), `p-10` (40), `p-12` (48), `p-16` (64). Same rule applies to `gap-*`, `m-*`, `pb-*`, `pt-*`, etc. Off-grid values (`p-3`, `p-5`, `p-7`, `gap-3`, `gap-5`) are not permitted.

We chose the 8-point grid over strict powers-of-2 (4, 8, 16, 32, 64) because powers-of-2 has no step between 16px and 32px, making normal card padding awkward. The 8-point grid is the standard in Material Design, Tailwind's own defaults, and most major design systems.

**No external margin on components**: components must not set `mb-*` or `mt-*`. External spacing is the parent's job via `gap` on a flex container.

**Admin page layer model**:

| Layer | Responsibility |
|---|---|
| `admin-list` layout | `px-6` horizontal padding |
| `AdminPageHeader` | `pt-6 pb-4` internal padding only — no `mb-*` |
| List page wrapper | `flex flex-col gap-8 pb-8` |
| Detail page wrapper | `flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8` |

## Consequences

- Any new admin page follows the wrapper patterns above without thinking about spacing.
- `AdminPageHeader` never sets external margin; its gap is always provided by the parent.
- Off-grid values in code reviews are an immediate red flag.
- Public pages are not covered by this ADR — they use the `page` layout's `p-6` wrapper and are a separate audit.
