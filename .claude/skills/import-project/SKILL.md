# import-project

Import a GitHub repository as a project entry in the portfolio. Inspects the repo, asks targeted questions to fill in what code can't answer, writes the seed SQL, and invokes `/copy-style` to enforce voice rules before committing any prose.

## When to Use

- You have a GitHub repo URL and want to add it as a project entry
- You are batch-importing past work into the portfolio

## Input

A GitHub repo URL, e.g. `https://github.com/org/repo-name`.

## Processing Steps

### Step 1 — Research the repo

Use the `gh` CLI (not WebFetch) to inspect:

- Repo metadata: `gh api repos/{owner}/{repo}` — description, language, topics, created_at, updated_at
- File tree: `gh api repos/{owner}/{repo}/git/trees/HEAD?recursive=1`
- README: `gh api repos/{owner}/{repo}/contents/README.md`
- Dependency manifest (whichever applies): `requirements.txt`, `pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, `Gemfile`
- Key source files to confirm the actual stack in use

Derive from this research:
- **Language(s)** and **frameworks/libraries** in use
- **Year** — use the repo's `created_at` year
- **Company** — check whether the org name matches an existing company in `supabase/seeds/02_content.sql`; if so, note the match
- **Existing skills match** — compare derived tech against `supabase/seeds/02_content.sql`; flag any that are missing

### Step 2 — Present pre-filled values and confirm

Before asking any open-ended questions, show the user what was derived and get confirmation:

```
Derived from the repo:
- Language: Python
- Stack: Selenium, Trio
- Year: 2023
- Company: MMPC (matched existing)
- Skills matched: Python
- Skills missing: Web Scraping (not in DB)

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
5. **Learnings** — Offer 2-3 candidate learnings derived from the code and context. Let the user confirm, reject, or add. If the project is small or unfinished, don't force this — it's fine to note "not much to learn from here."

### Step 5 — Handle missing skills

For each skill identified in Step 1 that is not in `supabase/seeds/02_content.sql`, ask:

```
"Web Scraping" isn't in your skills table. Should I add it?
- Category: Other (or suggest based on the skill)
- Proficiency: [your recommendation] — but this is your call
```

Wait for confirmation of name, category, and proficiency before proceeding.

### Step 6 — Write description and summary

Draft the project description (2-3 sentences) and summary (1 sentence) following the guidance in `supabase/seeds/CLAUDE.md`:
- Description: what it is, what it does, the stack. Personal voice, first person where natural.
- Summary: one sentence for card previews. Factual, no fluff.

Then **invoke `/copy-style`** on the draft before finalizing. Do not write the seed entries until copy-style has signed off on the prose.

### Step 7 — Write seed files

Write to these files in order:

1. **`supabase/seeds/02_content.sql`** — add any new skills confirmed in Step 5, following the existing insert pattern. Add after the last entry in the same proficiency tier.

2. **`supabase/seeds/03_projects.sql`** — add the project entry with all fields:
   ```sql
   insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
   values (...)
   on conflict (name) do nothing;
   ```
   Slug is auto-derived from the name (lowercase, hyphens). `image_url` is always `null` — set later via the admin UI.

3. **`supabase/seeds/04_project_skills.sql`** — add a `union all` block before the final `on conflict do nothing;`:
   ```sql
   union all
   select p.id, s.id
   from public.projects p
            join public.skills s on s.name in ('Python', 'Web Scraping')
   where p.name = 'EPA Pesticide Registry Scraper'
   ```

### Step 8 — Article idea prompt

Once all seed files are written, ask once:

> "Did anything in this project surface a potential article idea?"

If yes: ask for a title direction (offer 2-3 candidates if there's a natural angle). Then create the next numbered seed file (`supabase/seeds/NN_<slug>_article.sql`) using the template in `supabase/seeds/CLAUDE.md`, with `writing_stage = 'idea'`, `published_at = null`, and empty content.

If no: skip silently.

### Step 9 — Done

Remind the user:

> "Run `npx supabase db reset` when you're ready to apply."

Do not run the reset yourself.

## Key Constraints

- **Research-first** — derive everything you can from the repo before asking questions. Never ask something the code already answers.
- **One question at a time** — wait for a response before moving to the next question.
- **Always ask for new skills** — proficiency is a self-assessment the user must make; never assume it.
- **No db:reset** — write files and stop. The user decides when to apply.
- **No `image_url`** — always null; images are uploaded via the admin UI.
- **`is_public` defaults to false** — only set true when explicitly confirmed.
- **Slug generation** — derive from the confirmed project name: lowercase, spaces to hyphens, strip special characters. Match the pattern in `supabase/seeds/03_projects.sql`.
- **Seed file numbering** — check the highest existing number in `supabase/seeds/` before creating a new article seed file.

## Output

- Modified: `supabase/seeds/02_content.sql` (if new skills added)
- Modified: `supabase/seeds/03_projects.sql`
- Modified: `supabase/seeds/04_project_skills.sql`
- Created (optional): `supabase/seeds/NN_<slug>_article.sql`
