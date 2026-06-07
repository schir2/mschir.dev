# Copy and Writing Style Reference

Universal rules for all user-facing copy and article prose. Article-type overlays (technical, financial, personal) live as stubs in SKILL.md and will be filled in as the style guide matures.

## Mechanics

- **No em dashes** — never use the em dash character (—), anywhere, in any copy. Use a comma, semicolon, colon, or restructure the sentence. Applies to article body prose, not just short copy.
- **No version numbers in tech stack copy** — write "Nuxt" not "Nuxt 3", "Vue" not "Vue 3". Version numbers date the copy and are meaningless to most readers.
- **Title Case for headings** — all article headings (h1–h3) use Title Case. Chicago style: lowercase articles (*a, an, the*), coordinating conjunctions (*and, but, or, nor*), and prepositions under five letters (*in, of, at, by, for, as*) — unless the word is first or last in the heading.

## Voice

- **Audience** — write for past-you plus a less experienced reader. Explain the WHY so beginners can build a mental model, not just follow steps. Assume less context than you have, not more.
- **Measured and conversational** — not terse, not commanding. Clear and concise: say it once, move on.
- **Show, don't prescribe** — share the experience, let the reader draw the conclusion. "I ran into this exact error when..." not "You should always make sure to..."
- **First person for reasoning and context** — "I prefer this approach because...", "I ran into this when..."
- **Imperative for steps** — in instructional sections, steps are imperative: "Run this command. Open the file." No pronoun needed.
- **Personal voice in project descriptions** — first person where natural ("I built", "a tool I made"). Warm and direct, not a product pitch.
- **Taglines describe identity, not state** — answer "what IS this thing", not its migration status or roadmap.

## Article Structure

- **Opener depends on article type** — how-to articles open with a direct context-setter. Experience and opinion pieces open with a personal anecdote or moment of confusion. Never open with a definition ("X is a tool that...") unless the article is pure reference material.
- **No restatement at any level** — do not restate the heading in the opening sentence of the section. Do not summarize what you just wrote at the end of a section.
- **No restatement conclusions** — articles end when the content ends. Exception: if there is a logical next step, the next article in a series, or a concrete action to take, add a brief "what now" pointer. The test is "does this lead somewhere?" If it does not, stop.

## AI Tells to Strip

These patterns signal AI-generated prose and must not appear.

**Throat clearing** (delete entirely):
- "Furthermore", "Moreover", "Additionally", "In conclusion", "It's worth noting that"
- "Before we dive in", "In this article we will cover", "Let's explore"
- "Keep in mind that", "It's important to understand", "As you can see"

**Prescriptive moralizing** (rewrite as show/experience):
- "You should always", "Make sure you", "Don't forget to"
- "It's best practice to", "It's important that you", "As a developer, you'll want to"

**Hollow intensifiers** (delete or replace with a specific claim):
- "powerful", "robust", "seamless", "comprehensive", "elegant", "intuitive"

**Structural tells** (restructure):
- Passive where active works: "It should be noted" → "Note that"; "This can be seen" → cut it
- "We" with no we — there is just a writer and a reader; use "I" or "you"
- Symmetric bullet lists — AI produces exactly 3–5 items of identical length. Real lists have as many items as the content warrants, varied in length
- Over-bold — only bold what genuinely needs to stand out; bolding for decoration is noise

**Specificity** — AI describes vaguely; write specifically. Name the exact error message, exact command, exact file path. "You may see an error" is not acceptable when you know the error is "`Unable to exchange external code`".
