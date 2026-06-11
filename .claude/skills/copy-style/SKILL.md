---
name: copy-style
description: >
  Enforces the project's canonical voice and style rules on any prose draft.
  Reads rules live from REFERENCE.md so new rules are picked up automatically.

  TRIGGER — invoke before writing or rewriting any user-facing prose on this site:
  service page copy, article body, project descriptions, taglines, summaries,
  page hero text, contact page copy, email templates, CTA blurbs, or any text
  a visitor reads. Do not wait to be asked.

  SKIP — code comments, commit messages, admin UI labels, internal docs, and
  any copy the user has explicitly marked as approved.
---

# Copy Style

Grill any prose draft against the project's canonical style rules. Rules are read live from [REFERENCE.md](./REFERENCE.md) — do not rely on memory.

## Quick Start

Paste a draft or describe what needs to be written. The skill identifies the content type, loads the right rules, grills the draft category by category, and outputs the clean version.

- **Service pages, short copy, CTAs** → [REFERENCE.md](./REFERENCE.md) only
- **Articles** → [REFERENCE.md](./REFERENCE.md) + [references/article.md](./references/article.md)

## Workflow

### Step 1 — Load the rules

Read [REFERENCE.md](./REFERENCE.md). For article content types, also read [references/article.md](./references/article.md). Do not rely on memory.

### Step 2 — Identify content type

| Type | Signal |
|---|---|
| **Short copy** | 1–3 sentences: tagline, description, summary |
| **Technical article** | How-to, setup guide, implementation walkthrough |
| **Financial article** | Investing, retirement, financial planning |
| **Personal/opinion article** | Experience piece, reflection, opinion |
| **Other copy** | Service page, email template, page hero, CTA |

Confirm with the user: "This looks like [type] — is that right?"

For **from-scratch** requests: write a clean first draft, self-grill against all categories, present with judgment calls flagged.

### Step 3 — Grill one category at a time

Quote the offending passage, name the rule it breaks, suggest the fix. Wait for confirmation before moving on. If no violations: say "No issues in [category]."

**Order:**
1. **Mechanics**
2. **Voice**
3. **Article Structure** _(articles only — skip for all other content types)_
4. **AI Tells**

### Step 4 — Output the clean version

Once all categories pass, output the complete rewritten prose in a fenced block.