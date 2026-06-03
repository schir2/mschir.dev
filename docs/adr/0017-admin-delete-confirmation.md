# ADR-0017 — Use ConfirmDialog for all admin destructive actions

## Status

Accepted

## Context

List pages originally used `<p-confirm-popup>` for row-level deletes — a lightweight popover anchored to the clicked button. The intent was to keep the interaction lightweight for a routine action.

The problem: a deleted record is gone permanently. `ConfirmPopup`'s visual weight (small, dismissible popover) understates that severity and is inconsistent with how the rest of the admin UI handles significant consequences. ADR-0015 already established `<p-confirm-dialog>` (full modal) for publish and unpublish actions on the grounds that their consequences warrant stopping the user completely. Deletes have the same irreversibility.

Having two confirmation patterns also creates a learning cost: developers building new pages need to know which situations warrant which component.

## Decision

Standardize on `<p-confirm-dialog>` for **all** admin destructive actions:

- Row-level record deletion
- State changes with significant consequences (publish, unpublish, archive)

`<p-confirm-popup>` is retired from admin use entirely.

Canonical pattern:

```ts
function confirmDelete(id: string) {
  confirm.require({
    header: 'Delete <Resource>',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteResource(id),
  })
}
```

## Consequences

- Row deletes require one extra click compared to the previous `ConfirmPopup`. Acceptable: deletions are infrequent, irreversible, and warrant the friction.
- One confirmation component to know and test across the entire admin section.
- Existing list pages (`admin/articles/index.vue`, `admin/projects/index.vue`, `admin/companies/index.vue`) still use `ConfirmPopup` — migrating them is tracked as a cleanup issue.
- `<p-confirm-popup>` imports and template registrations can be removed from list pages as part of that migration.
