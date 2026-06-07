---
name: copy-style
description: Enforces the project's canonical voice and style rules on any prose draft. Reads rules live from REFERENCE.md so new rules are picked up automatically. Use when writing or rewriting project descriptions, taglines, summaries, article body content, email templates, or page copy — especially when stripping AI-generated patterns to match the site owner's voice.
---

# Copy Style

Grill any prose draft against the project's canonical style rules. Rules are read live from [REFERENCE.md](./REFERENCE.md) — do not rely on memory.

## Step 1 — Load the rules

Read [REFERENCE.md](./REFERENCE.md) before doing anything else. This is the authoritative source for all style rules. Do not rely on memory or hard-code rules.

## Step 2 — Identify content type

Inspect the draft and infer:

| Type | Signal |
|---|---|
| **Short copy** | 1–3 sentences: description, tagline, or summary |
| **Technical article** | How-to, setup guide, implementation walkthrough |
| **Financial article** | Investing, retirement, financial planning topics |
| **Personal/opinion article** | Experience piece, reflection, opinion |
| **Other copy** | Email template, page hero, CTA blurb |

Confirm with the user before proceeding: "This looks like a [type] — is that right?"

For **from-scratch** requests (no draft pasted): write a clean first draft, self-grill it against all four categories, then present the result with any remaining judgment calls flagged.

## Step 3 — Grill one category at a time

Work through these in order. For each category:
- Quote the specific offending passage from the draft
- Name the rule it breaks
- Suggest the fix
- Wait for the user to confirm or adjust before moving to the next category
- If no violations: say "No issues in [category]" and move on

**Order** (categories are defined in [REFERENCE.md](./REFERENCE.md)):
1. **Mechanics**
2. **Voice**
3. **Article Structure**
4. **AI Tells**

Short copy skips Article Structure entirely.

## Step 4 — Output the clean version

Once all categories pass, output the complete rewritten prose in a fenced block.

## Article Type Overlays

After confirming the content type, apply the relevant overlay below in addition to the universal rules. Overlays are stubs for now — fill them in as the style guide matures.

### Technical Articles

_To be defined. Expected: opener conventions (direct context-setter), how much prior knowledge to assume, code block and command formatting rules, "Common Mistakes" section guidance._

### Financial Articles

_To be defined. Expected: tone adjustments for non-specialist audience, how to handle jargon (define inline vs link out), disclaimer conventions, how to frame projections and estimates without sounding prescriptive._

### Personal / Opinion Articles

_To be defined. Expected: opener conventions (personal anecdote or moment of confusion), how to signal opinion vs fact, when first-person narrative is appropriate throughout vs just for framing._
