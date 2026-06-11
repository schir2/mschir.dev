# Copy and Writing Style Reference

Universal rules for all user-facing copy and prose on this site. Article-specific rules (structure, audience context, article-type voice overlays) live in [references/article.md](./references/article.md).

## Mechanics

- **No em dashes** — never use the em dash character (—), anywhere, in any copy. Use a comma, semicolon, colon, or restructure the sentence.
- **No version numbers in tech stack copy** — write "Nuxt" not "Nuxt 3", "Vue" not "Vue 3". Version numbers date the copy and are meaningless to most readers.
- **Title Case for all headings** — all headings (h1–h3) across the site use Title Case. Chicago style: lowercase articles (*a, an, the*), coordinating conjunctions (*and, but, or, nor*), and prepositions under five letters (*in, of, at, by, for, as*) — unless the word is first or last in the heading.

## Voice

- **Audience** — write for a smart, capable reader who knows their own domain. Don't explain what they already know. Earn their attention with specificity and directness. For articles, where the reader may lack specific domain context, see [references/article.md](./references/article.md).
- **Brevity** — fewest words that carry the full meaning. Cut everything that restates, hedges, or decorates. If a word can be removed without losing meaning, remove it.
- **Conversational but direct** — clear and concise: say it once, move on.
- **First person** — "I prefer this approach because...", "I built this when...". Warm and direct.
- **Taglines describe identity, not state** — answer "what IS this thing", not its migration status or roadmap.

## AI Tells to Strip

**Throat clearing** (delete entirely):
- "Furthermore", "Moreover", "Additionally", "In conclusion", "It's worth noting that"
- "Before we dive in", "In this article we will cover", "Let's explore"
- "Keep in mind that", "It's important to understand", "As you can see"

**Prescriptive moralizing** (rewrite):
- "You should always", "Make sure you", "Don't forget to"
- "It's best practice to", "It's important that you"

**Hollow intensifiers** (delete or replace with a specific claim):
- "powerful", "robust", "seamless", "comprehensive", "elegant", "intuitive"

**Structural tells** (restructure):
- Passive where active works: "It should be noted" → cut it; "This can be seen" → cut it
- "We" with no we — use "I" or "you"
- Symmetric bullet lists — AI produces exactly 3–5 items of identical length. Real lists have as many items as the content warrants, varied in length
- Over-bold — only bold what genuinely needs to stand out

**Setup-problem openers** (rewrite):
- Leading with a problem statement before saying what you do: "Most businesses reach a point where...", "Most people think of X as..." — lead with what you do, not a problem setup

**"Who this is for" sections** (delete):
- Sections that filter the audience by describing who should or shouldn't read on. They read as AI scaffolding and self-filter people who might otherwise be interested

**Vague outcome phrases** (make concrete):
- Phrases that describe results abstractly: "routing it to the right place", "making things better", "improving efficiency" — name the concrete result: "putting it in front of the people who need to act on it"

**Specificity** — name the exact thing. "You may see an error" is not acceptable when you know what the error is.