# ADR 0019 — No Inline DataTable Editing

**Status:** Accepted

## Context

PrimeVue DataTable supports inline row editing (`edit-mode="row"`), which was used for the Companies admin page on the premise that 3-field entities don't warrant a dedicated editor page.

In practice, inline row editing in a DataTable produces a broken UX:
- Rows expand unexpectedly when entering edit mode, which is jarring in a compact admin table.
- File inputs (e.g. logo upload) inside editor slots are awkward — the row must grow to accommodate them, and staged file state has to be managed separately alongside the editing row lifecycle.
- The pattern diverges from every other admin list page, creating two different interaction models for the same admin user.

The Companies page also crossed the stated threshold for inline editing (≤ 3 plain-text/select fields) by including an image upload, making the choice technically incorrect even under the old rule.

## Decision

Inline DataTable row editing (`edit-mode="row"`) is not used anywhere in the admin. Every editable entity has a dedicated editor page (`[id].vue` + `new.vue`), regardless of how few fields it has.

The uniform navigation pattern across all admin list pages:
- Clicking the entity name navigates to the edit page.
- An eye button in the actions column opens the public page in a new tab (only for entities with a public URL defined in the Admin Section Registry).
- A delete button in the actions column triggers a confirm dialog.

## Alternatives Considered

**Keep inline editing for simple entities (≤ 3 plain-text fields, no uploads)** — rejected. Even a 3-field plain-text form is cleaner on its own page than as an expanding table row. The consistency benefit of a single interaction model across all admin pages outweighs the overhead of a minimal editor page. A simple editor page is not complex to build.

**Fix the inline UX (better row transition, staged file input handling)** — rejected. The effort to make inline editing feel polished is greater than building a simple editor page, and it still produces a divergent pattern.
