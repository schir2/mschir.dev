# ADR-0024: Article Browse Page article list refactored to PrimeVue DataView

## Status
Accepted

## Context

The Article Browse Page had a manual layout toggle: a `listColumns: ref<1|2>` drove a `:class` binding that switched between `flex flex-col` and `grid grid-cols-2`. This required the page to own the list/grid DOM structure directly. The `icon` prop on `<p-button>` silently ignores Iconify names (only PrimeIcons work), so the toggle icons were also rendering nothing.

## Decision

Replace the manual div toggle with `<p-data-view :value="filteredArticles" :layout="layout">`. DataView accepts a `layout` prop (`'list'` or `'grid'`) and exposes `#list` and `#grid` named slots for the respective layouts, plus an `#empty` slot for the zero-results case.

The layout toggle buttons remain outside DataView (not in its `#header` slot) so they stay visible during the article loading skeleton phase. Toggle buttons use the `#icon` named slot with `class="text-lg"` on the icon, which is the required pattern for Iconify icons inside PrimeVue buttons.

## Alternatives considered

- **Keep manual div toggle** — simpler, no DataView dependency, but the icon bug would persist and the empty-state handling stays ad-hoc.
- **DataView with `#header` slot for toggle** — hides the toggle during loading; removed in favour of keeping the toggle always visible.

## Consequences

- DataView handles list/grid slot routing declaratively; the page no longer owns layout DOM structure.
- `#empty` slot replaces the `v-else-if filteredArticles.length === 0` guard.
- Future pagination can be added via DataView's built-in `paginator` prop without restructuring the template.
