# ADR 0015 — Publish/Unpublish confirmation dialog

## Status
Accepted

## Context
Publishing an article has two meaningful consequences that are easy to miss with a bare toggle:
1. The article becomes immediately visible to all visitors.
2. The slug is locked to protect existing external links.

The original implementation used a `<p-toggle-switch>` for published state. A toggle gives no indication of what it will do, and accidental publishes are hard to undo gracefully (the article is already indexed by the time you notice).

Unpublishing is similarly non-obvious: the article disappears from all listings without warning.

## Decision
Replace the published toggle with explicit **Publish** and **Unpublish** buttons that trigger a `<p-confirm-dialog>` before taking effect.

- **Publish dialog**: explains that the article will become visible to all visitors and the slug will be locked.
- **Unpublish dialog**: explains that the article will be hidden from all visitors and listings.

The slug lock is implemented as `const slugLocked = computed(() => publishedAt.value !== null)`, so it activates the moment the dialog is confirmed — not deferred until the next save.

## Consequences
- Publish and unpublish require one extra click. Acceptable: these are significant, infrequent actions.
- The slug lock behaviour is explicitly communicated at the moment it happens, reducing surprise.
- A **View** button appears in the toolbar when the article is published, providing a quick path to the live article without navigating away from the editor.
- The writing stage select-button remains disabled while published (unchanged behaviour).
