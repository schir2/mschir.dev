# ADR-0026: Portfolio MCP repo structure — monorepo vs separate repo

## Status

Proposed — decision pending

## Context

The Portfolio MCP (`@mschir/portfolio-mcp`) is a CLI/MCP server that manages articles in the portfolio's Supabase database. It needs access to the same database types that the Nuxt app uses — specifically `shared/types/database.types.ts`, which is auto-generated from the live Supabase schema.

Two structural options are under consideration:

**Option A — Same repo as a pnpm workspace package** (`packages/portfolio-mcp/` inside the portfolio monorepo, published to npm from within the workspace)

| | |
|---|---|
| Pro | Shared `database.types.ts` — schema changes propagate automatically, no manual sync |
| Pro | No npm publish step just to test a change |
| Pro | One repo, one CI pipeline |
| Pro | Multiple MCP packages could live under `packages/` without structural changes |
| Con | `npx @mschir/portfolio-mcp` still works but requires configuring pnpm workspaces for publishing |
| Con | The portfolio repo gains a second identity — Nuxt app + npm package |

**Option B — Separate repo** (independent repository, standalone npm package)

| | |
|---|---|
| Pro | Clean standalone README — easiest for others to find and install |
| Pro | Fully independent release cycle — no risk of a portfolio deploy touching the MCP |
| Con | Schema drift — when `articles` gains a new field, types must be updated in two places |
| Con | The MCP is tightly coupled to this specific portfolio's DB schema; "standalone" benefit is limited |
| Con | Two repos to context-switch between |

## Decision

Not yet made.

## Notes

The decisive factor is likely the schema coupling: the MCP imports `database.types.ts` for every tool. Same-repo eliminates an entire class of drift bugs. However, if the site owner prefers a clean separation for distribution purposes, a separate repo with a documented type-sync step is viable.