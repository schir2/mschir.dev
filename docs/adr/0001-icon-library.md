# ADR-0001: Use @nuxt/icon (Iconify) for icons, not PrimeIcons

## Status
Accepted

## Context
Two icon systems are present in the project: `primeicons` (loaded via CSS in `nuxt.config.ts`) and `@nuxt/icon` (the Nuxt module wrapping Iconify). PrimeIcons covers only PrimeVue's own icon set. Iconify via `@nuxt/icon` covers thousands of icon sets including Material Symbols, Heroicons, and MDI.

## Decision
Use `<Icon name="..." />` from `@nuxt/icon` for all application icons. The chosen set is **Material Symbols** (`material-symbols:*`) as it is Google's current icon standard (successor to Material Design Icons).

PrimeIcons remain in the CSS bundle only to support PrimeVue's internal component icons (e.g. dropdown chevrons, close buttons). Do not use `pi pi-*` classes in application code.

## Consequences
- Icon usage is consistent and not locked to PrimeVue's limited set.
- Any Iconify icon is available with no additional setup.
- `primeicons` CSS is kept but treated as an internal PrimeVue dependency, not a source for application icons.