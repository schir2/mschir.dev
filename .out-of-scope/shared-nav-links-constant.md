# Shared navLinks constant (#61)

**Decision:** Closed as wontfix.

**Reason:** Footer and navbar are intentionally independent. The footer already omits links that appear in the navbar (e.g. Projects), and the two may diverge further by design. Coupling them to a shared constant would make intentional differences harder to maintain.
