# ADR-0020: Spacing Scale and Padding Layer Model

## Status
Accepted

## Context

The codebase accumulated scattered spacing values — `p-5`, `p-7`, `mb-3`, `gap-5` — with no enforced scale. Admin pages double-padded by adding `pt-6` on their wrapper on top of `AdminPageHeader`'s own `pt-6`. Components set `mb-6` to push siblings away, leaking margin outside their own box. The combination made spacing unpredictable and visually uneven.

## Decision

**Spacing scale: 8-point grid** (multiples of 8px). Valid Tailwind values: `p-2` (8), `p-4` (16), `p-6` (24), `p-8` (32), `p-10` (40), `p-12` (48), `p-16` (64). Same rule applies to `gap-*`, `m-*`, `pb-*`, `pt-*`, etc. Off-grid values (`p-3`, `p-5`, `p-7`, `gap-3`, `gap-5`) are not permitted.

We chose the 8-point grid over strict powers-of-2 (4, 8, 16, 32, 64) because powers-of-2 has no step between 16px and 32px, making normal card padding awkward. The 8-point grid is the standard in Material Design, Tailwind's own defaults, and most major design systems.

**No external margin on components or page templates**: `mb-*` and `mt-*` must not appear in page templates or component roots. External spacing is the parent's job via `gap` on a flex container.

**Two-tier spacing scale**: The 8-point rule applies to layout spacing — gaps between components, sections, and content blocks. Inside a single atomic UI element (a chip, badge, or icon+label pair that renders as one visual unit), the 4-point Tailwind grid is acceptable (`py-1`, `px-2`, `gap-1`, `gap-1.5`). The boundary is: spacing *between* elements → 8-point; spacing *inside* one atomic element → 4-point.

**Admin page layer model**:

| Layer | Responsibility |
|---|---|
| `admin-list` layout | `px-6` horizontal padding |
| `AdminPageHeader` | `pt-6 pb-4` internal padding only — no `mb-*` |
| List page wrapper | `flex flex-col gap-8 pb-8` |
| Detail page wrapper | `flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8` |

**Public page layer model**:

| Layer | Responsibility |
|---|---|
| `page` layout | `px-6 pt-6 pb-8` — all outer shell padding |
| Page root | `flex flex-col gap-*` — controls gaps between top-level sections |
| Section blocks | `flex flex-col gap-*` on their own — no `mb-*`/`mt-*` on children |

```vue
<!-- ✅ public page pattern -->
<template>
  <section class="flex flex-col gap-16">
    <div class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Section Title</h2>
      <some-content-component />
    </div>
  </section>
</template>
```

## Consequences

- Any new admin page follows the wrapper patterns above without thinking about spacing.
- Any new public page uses `flex flex-col gap-*` at every level; no `mb-*` or `mt-*` anywhere in templates.
- `AdminPageHeader` never sets external margin; its gap is always provided by the parent.
- Off-grid values in code reviews are an immediate red flag — except inside chip/badge elements (4-point exception).
- Conditional elements inside a `flex` parent are safe: the gap only appears when the element renders, avoiding double-spacing bugs.
- **Footer exception**: `layout/footer.vue` retains `mt-16` on its root element. It is a global layout component shared across all 5 layouts; owning its own top gap prevents the same spacing from being duplicated in every layout file. This is the only accepted case of a component owning external top margin.
