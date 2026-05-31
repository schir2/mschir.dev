# mschir.dev

Personal portfolio site for Matthew Schiraldi. Built with Nuxt 4, Supabase (PostgreSQL + auth), and PrimeVue.

## Stack

- **Frontend**: Nuxt 4, Vue 3, PrimeVue 4, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Row-Level Security, Storage, Auth)
- **Testing**: Vitest (components/composables), pgTAP (DB layer), Deno (edge functions)
- **Markdown**: md-editor-v3 (editor + public rendering, with Mermaid and KaTeX)

## Development

```powershell
pnpm install              # Install dependencies
pnpm run supabase:start   # Start local Supabase stack (required for local dev)
pnpm run db:reset         # Reset local DB and re-run migrations + seeds
pnpm run dev              # Start dev server at http://localhost:3000
```

## Commands

```powershell
pnpm run build            # Build for production
pnpm run preview          # Preview production build
pnpm run supabase:types   # Regenerate types/database.types.ts from schema
pnpm run db:migrate       # Apply pending migrations without a full reset
pnpm test                 # Run Vitest component/composable tests
pnpm run test:db          # Run pgTAP database tests (requires supabase:start)
pnpm run test:edge        # Run Deno edge function tests
```

## Documentation

- [`CLAUDE.md`](./CLAUDE.md) — development environment, conventions, and architecture guide for Claude Code
- [`CONTEXT.md`](./CONTEXT.md) — domain glossary (canonical terms for all domain concepts)
- [`docs/adr/`](./docs/adr/) — architecture decision records