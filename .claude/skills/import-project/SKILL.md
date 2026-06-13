# import-project

Import a GitHub repository as a project entry in the portfolio. Inspects the repo, asks targeted questions to fill in what code can't answer, creates a markdown preview for approval, then writes the seed SQL and invokes `/copy-style` to enforce voice rules before committing any prose.

## When to Use

- You have a GitHub repo URL and want to add it as a project entry
- You are batch-importing past work into the portfolio

## Input

A GitHub repo URL, e.g. `https://github.com/org/repo-name`.

## Processing Steps

### Step 1 — Research the repo

Use the `gh` CLI (not WebFetch) to inspect:

- Repo metadata: `gh api repos/{owner}/{repo}` — description, language, topics, created_at, updated_at, private/public, org vs. personal
- File tree: `gh api repos/{owner}/{repo}/git/trees/HEAD?recursive=1`
- README: `gh api repos/{owner}/{repo}/contents/README.md`
- Dependency manifest (whichever applies): `requirements.txt`, `pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, `Gemfile`
- Key source files to confirm the actual stack in use
- Documentation directories if present: `docs/flows/`, `docs/adr/`, `docs/`, `ADR/`, or similar — always fetch these as source material for diagrams and engineering decisions regardless of project complexity

Derive from this research:
- **Language(s)** and **frameworks/libraries** in use
- **Year** — use the repo's `created_at` year
- **Company** — check whether the org name matches an existing company in `supabase/seeds/02_content.sql`; if so, note the match
- **Existing skills match** — compare derived tech against `supabase/seeds/02_content.sql`; flag any that are missing
- **Complexity signals** — note any of the following (each triggers multi-section description in Step 6):
  - 3 or more external system integrations
  - AI/ML pipeline present
  - 3+ years of active commits (check `updated_at` vs `created_at`)
  - `docs/flows/`, `docs/adr/`, or equivalent present in the repo
  - Private repo under a company org (description must do more work since code won't be visible)
- **Privacy flag** — if the repo is private and under a company org, note it; business domain taxonomies and internal process models will need a privacy check before diagramming

### Step 2 — Present pre-filled values and confirm

Before asking any open-ended questions, show the user what was derived and get confirmation:

```
Derived from the repo:
- Language: Python
- Stack: Django, HTMX, HubSpot API, Pydantic AI
- Year: 2019
- Company: MMPC (matched existing)
- Skills matched: Django, Python, HTMX
- Skills missing: HubSpot, Pydantic AI
- Complexity signals: 4 external integrations, AI pipeline, 7 years active, docs/adr/ present, private company org
- Privacy flag: private company repo — will ask before exposing domain details

Does this look right?
```

### Step 3 — Propose a project name

Offer 2-3 name candidates following the existing naming register in `supabase/seeds/03_projects.sql` (functional descriptor noun phrases, e.g. "EPA Pesticide Registry Scraper"). Include a recommendation. Wait for the user to confirm or provide their own.

### Step 4 — Ask targeted questions one at a time

Ask only what code cannot answer. Wait for a response before moving to the next question. Provide a recommended answer for each.

**Required questions:**

1. **Problem / use case** — What was this built to solve? What workflow did it replace or support?
2. **Outcome** — Did it ship and get used, or was it a proof of concept / prototype? What happened to it?
3. **`is_public` flag** — Should the GitHub repo link appear publicly on the Project Detail Page? Default recommendation: `false` if the repo is under a company org; `true` if it's under the user's personal GitHub.

**Optional questions** (skip if already answered through research or prior context):

4. **Target audience** — Who was this built for? (internal tool, public users, specific team)
5. **Featured project** — Ask only if the project signals significance: long-running (3+ years), daily users mentioned, or the user describes it as a flagship or major project. If yes, ask for:
   - Tagline (one sentence; copy-style rules apply; no em dashes)
   - Display order (check current max in `supabase/seeds/06_portfolio.sql`)

### Step 5 — Handle missing skills

For each skill identified in Step 1 that is not in `supabase/seeds/02_content.sql`, ask:

```
"HubSpot" isn't in your skills table. Should I add it?
- Category: Other (or suggest based on the skill)
- Proficiency: advanced (recommended) — but this is your call
```

Wait for confirmation of name, category, and proficiency before proceeding.

Judgment on which skills to surface: exclude table-stakes skills (HTML, CSS, generic JS unless it's the only frontend tool). Focus on named frameworks, platforms, and tools that differentiate the project.

### Step 6 — Create markdown preview and wait for approval

Create `docs/project-drafts/<slug>.md` with the full content that will be written to seeds. **Always create this file — do not write to any seed file before the user approves the preview.**

**Preview file structure:**

```markdown
# <Project Name> — Project Draft

> Preview file. Approve this, then I'll write to the seed files.

## Name / Slug / Year / Company / Repo

## Summary

## Description (Markdown)

[full description — see depth guidance below]

## Skills

[confirmed list]

## New Skills to Add to DB

[table: name, icon, proficiency, category]

## Featured Project (if applicable)

[tagline and display order]
```

**Description depth — simple vs. multi-section:**

If **no complexity signals** fired in Step 1: write a simple 2-3 paragraph description (what it is, what it does, the stack, outcome).

If **any complexity signal** fired: write a multi-section description. Adapt the structure to what the project actually has — not every section is required for every project:

| Section | When to include |
|---|---|
| Intro prose (always) | 2-3 paragraphs: problem, core features, outcome |
| **How It Grew** + timeline diagram | Project active 3+ years with distinct phases |
| **Architecture** + `flowchart TD` | 3+ external system integrations |
| Feature-specific pipeline diagram | AI/ML pipeline, async task queue, or complex multi-step flow |
| State machine diagram | Non-trivial failure handling with terminal states |
| **Key Engineering Decisions** | Significant tradeoffs documented in ADRs or evident from code |

**Mermaid diagram types:**

| Diagram type | Use for |
|---|---|
| `flowchart TD` / `flowchart LR` | System architecture, data flow, async pipelines |
| `timeline` | Project history with distinct named phases |
| `stateDiagram-v2` | Task/job lifecycle, retry/failure state machines |

**Privacy check (private repos under company orgs):**

Before including a business domain taxonomy (call types, deal stages, service classifications, internal process models) in a diagram: ask whether those details should be public. Default: describe the concept in prose without the specifics (e.g., "domain-specific classification hierarchy with confidence thresholds" rather than enumerating the actual types).

### Step 7 — Write description and summary

Draft the description and summary per the approved preview. Then **invoke `/copy-style`** on the prose before finalizing. Rules: no em dashes, first person where natural, no AI tells, specific and concrete.

Do not write seed entries until copy-style has signed off.

### Step 8 — Write seed files

Write to these files in order:

1. **`supabase/seeds/02_content.sql`** — add any new skills confirmed in Step 5, following the existing insert pattern. Add after the last entry in the same proficiency tier.

2. **`supabase/seeds/03_projects.sql`** — add the project entry. Use PostgreSQL dollar-quoting (`$desc$...$desc$`) for descriptions that contain markdown code blocks or apostrophes:
   ```sql
   insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
   values (
       'Project Name',
       'project-slug',
       $desc$[full markdown description]$desc$,
       'Single sentence summary — escape apostrophes as '' in the outer single-quoted string.',
       (select id from public.companies where name = 'MMPC'),
       2019,
       'https://github.com/org/repo',
       false,
       null
   )
   on conflict (name) do nothing;
   ```
   Slug is auto-derived from the name (lowercase, hyphens). `image_url` is always `null` — set later via the admin UI.

3. **`supabase/seeds/04_project_skills.sql`** — add a `union all` block before the final `on conflict do nothing;`:
   ```sql
   union all
   select p.id, s.id
   from public.projects p
            join public.skills s on s.name in ('Python', 'HubSpot', 'Pydantic AI')
   where p.name = 'Project Name'
   ```

4. **`supabase/seeds/06_portfolio.sql`** — if the project is featured, add an entry before `on conflict (project_id) do nothing;`:
   ```sql
   ,
   (
       (select id from public.projects where name = 'Project Name'),
       'Tagline goes here — one sentence, no em dashes.',
       6
   )
   ```
   Check the current highest `display_order` in the file before assigning.

### Step 9 — Article idea prompt

Once all seed files are written, ask once:

> "Did anything in this project surface a potential article idea?"

If yes: ask for a title direction (offer 2-3 candidates if there's a natural angle). Then create the next numbered seed file (`supabase/seeds/NN_<slug>_article.sql`) using the template in `supabase/seeds/CLAUDE.md`, with `writing_stage = 'idea'`, `published_at = null`, and empty content.

If no: skip silently.

### Step 10 — Done

Seed files are written. Stop here.

## Key Constraints

- **Research-first** — derive everything you can from the repo before asking questions. Never ask something the code already answers.
- **Always read docs/** — fetch `docs/flows/`, `docs/adr/`, and equivalent directories during Step 1 if present, regardless of project complexity. They are the best source for diagrams and key decisions.
- **Preview before seeds** — always create `docs/project-drafts/<slug>.md` and wait for approval before writing to any seed file.
- **One question at a time** — wait for a response before moving to the next question.
- **Always ask for new skills** — proficiency is a self-assessment the user must make; never assume it.
- **Privacy check** — for private repos under company orgs, ask before diagramming business domain taxonomies or internal process models.
- **No db:reset** — write files and stop. The user decides when to apply.
- **No `image_url`** — always null; images are uploaded via the admin UI.
- **`is_public` defaults to false** — only set true when explicitly confirmed.
- **Dollar-quote multi-section descriptions** — use `$desc$...$desc$` whenever the description contains markdown code blocks (triple backticks). Single-quote the summary separately; escape apostrophes as `''`.
- **Slug generation** — derive from the confirmed project name: lowercase, spaces to hyphens, strip special characters. Match the pattern in `supabase/seeds/03_projects.sql`.
- **Seed file numbering** — check the highest existing number in `supabase/seeds/` before creating a new article seed file.

## Output

- Created: `docs/project-drafts/<slug>.md` (preview — always)
- Modified: `supabase/seeds/02_content.sql` (if new skills added)
- Modified: `supabase/seeds/03_projects.sql`
- Modified: `supabase/seeds/04_project_skills.sql`
- Modified: `supabase/seeds/06_portfolio.sql` (if featured)
- Created (optional): `supabase/seeds/NN_<slug>_article.sql`
