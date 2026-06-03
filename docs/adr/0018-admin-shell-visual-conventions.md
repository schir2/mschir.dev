# ADR 0018 — Admin Shell Visual Conventions

**Status:** Accepted

## Context

Admin pages serve a single user (the site owner) performing data-management tasks. They need to be dense, readable, and consistent with each other — not with the public-facing portfolio and article pages, which prioritize visual impact for external visitors.

Two questions required explicit decisions:

1. Should admin page headers match the size and style of public page headers?
2. What button style should the `#actions` slot use?

## Decision

### Admin page header

`<admin-page-header>` uses `text-3xl` for the title and a `border-b border-surface-700` separator. This is intentionally smaller and more structured than public page headers (which use `text-4xl`+ and no border). The separator gives the header a Django admin-style boundary between the title/actions row and the table content below.

Rationale: admin pages are data-dense. Smaller headings leave more vertical room for DataTables. The separator replaces the bottom margin that public pages use, creating a crisper section boundary suited to the admin context.

### Action buttons in `#actions` slot

Admin action buttons use `severity="secondary"` and `rounded`. Icons use `material-symbols:add-circle` passed via the `#icon` slot (not the `icon` prop — see `app/components/CLAUDE.md`).

Rationale: the default filled primary button (indigo) is visually heavy next to a large Fraunces heading. Secondary severity uses the surface palette, which recedes appropriately. Rounded matches the established PrimeVue visual language used in other interactive controls on the site.

### Page padding ownership

| Layer | Responsibility |
|---|---|
| `admin-list` layout | Horizontal padding (`px-6`) |
| `<admin-page-header>` | Top padding (`pt-6`) |
| Page wrapper div | Bottom padding only (`pb-8`) |

Pages must not add their own horizontal padding or top padding — those are owned by the layout and the header component respectively. The previous pattern of wrapping page content in `<div class="p-6">` caused double horizontal padding and is not acceptable.

## Alternatives Considered

**Match public page header sizes** — rejected. Public headers (`text-4xl`+, no border) are designed for visitor impact. Applying that to admin pages wastes vertical space in a data-management context and creates no meaningful benefit since the admin is not a visitor.

**Primary severity action buttons** — rejected. The filled indigo button is visually dominant against the Fraunces heading and draws the eye away from the page title. Secondary severity is visible without competing.

**Keep `p-6` wrapper on page content** — rejected. `admin-list` layout already provides `px-6`. Double-padding at `px-12` effective is inconsistent with the `max-w-6xl` container intent and creates misaligned content edges.
