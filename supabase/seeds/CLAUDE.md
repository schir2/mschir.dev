# supabase/seeds/CLAUDE.md

Seed files run in numeric order during `db:reset`. Each file is prefixed with a two-digit number. Use the next available number when adding a new seed file.

## Seed file conventions

- `00_setup.sql` — pgTAP extension, run before all others
- `01_blog.sql` — article tags and categories
- `02_content.sql` — skills, skill categories, companies
- `03_projects.sql` — projects
- `04_project_skills.sql` — project↔skill links
- `05_test_users.sql` — test user credentials for integration tests
- `06_portfolio.sql` — featured projects and featured articles
- `07_articles.sql` / `08_migrated_articles.sql` — bulk article content
- `09+` — individual article seed files, one per article

## Adding a new article

Each article gets its own numbered seed file (e.g. `11_my_topic_article.sql`). Use this template:

```sql
-- Draft article: <short description>

-- Optional: add new tags if needed (skip if all tags already exist in 01_blog.sql)
insert into public.article_tags (name, slug, icon)
values ('My Tag', 'my-tag', 'mdi:some-icon')
on conflict (slug) do nothing;

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-0000000000XX',  -- increment XX
    'Article Title Here',
    'article-slug-here',
    $article$# Article Title Here

Article content in Markdown...
$article$,
    'One-sentence summary shown on article cards and in SEO meta.',
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',  -- author UUID (Marek)
    'draft',      -- writing_stage: 'idea' | 'outline' | 'draft' | 'ready'
    null,         -- published_at: null = unpublished; set to a timestamp to publish
    now(),
    now()
);

-- Link tags (use slugs from 01_blog.sql)
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-0000000000XX', id
from public.article_tags
where slug in ('nuxt', 'supabase', 'typescript');

-- Optional: feature the article on the homepage
insert into public.featured_articles (article_id, featured_reason, author)
values (
    'b1000000-0000-0000-0000-0000000000XX',
    'Short reason shown as the featured caption.',
    '3a455a9e-9a96-4fa1-aef9-8591690084e6'
);
```

## Article ID pattern

Seeded article IDs use a deterministic UUID pattern:
`b1000000-0000-0000-0000-00000000000X` where `X` increments with each new article seed file. Check the last seed file to find the current highest number.

## `writing_stage` values

| Stage | Meaning |
|---|---|
| `idea` | Just a title/topic, no content yet |
| `outline` | Rough structure exists |
| `draft` | Content written, not ready to publish |
| `ready` | Polished and ready — set `published_at` to publish |

Setting `published_at` to a timestamp makes the article visible to public visitors. Setting `writing_stage = 'ready'` does not automatically publish — both must be set.

## Category slugs (from `01_blog.sql`)

`software-development`, `web-development`, `data-science-analytics`, `devops-automation`, `it-infrastructure`, `it-operations-support`, `climbing`, `running`, `fitness`

## Adding a portfolio project

Projects go in `03_projects.sql`. Featured entries (tagline + display order) go in `06_portfolio.sql`.

### Tone and voice

This is a personal portfolio, not a product landing page. Write as a developer talking about work they're proud of — warm, direct, and factual. Avoid sales language.

**Do:**
- Write descriptions in first person where it feels natural ("I built", "a tool I made")
- Reference what the project is inspired by or comparable to (e.g. "Asana and Linear-inspired")
- Mention the tech stack and any notable implementation details (real-time, WebSockets, etc.)
- Keep taglines short and grounded — describe what it is, not what it promises

**Don't:**
- Use marketing framing ("built for people who want to...", "without the bloat", "at a fraction of the cost")
- Reference pricing, competitors' prices, or subscription tiers
- Over-sell with superlatives ("powerful", "seamless", "world-class")

### Field guidance

| Field | Required | Guidance |
|---|---|---|
| `description` | No (nullable) | Markdown. Full write-up: what the problem was, what was built, key decisions, outcome. Omit for minor/legacy projects that belong in the "Other Work" tier on the Projects Page — those get no detail page. |
| `summary` | No | One sentence for card previews. Factual, no fluff. |
| `repo_url` | No | GitHub URL. Always stored even for private repos — admin reference only when `is_public = false`. |
| `project_url` | No | Live site or demo URL. Only set when the project is publicly accessible. |
| `is_public` | Yes | Default `false`. Set `true` to render repo and project URL link buttons on the public detail page. |
| `tagline` (featured) | Yes (if featured) | One sentence. What it is and how it was built. Not a slogan. Lives on `featured_projects`, not `projects`. |

**Projects without a `description` do not get a detail page** (`/projects/[slug]` returns 404) and render as compact "Other Work" rows on the Projects Page instead of full cards.

**Skills:** do not list `HTML`, `CSS`, or `JS` unless JS is the only frontend tool (no framework). These are table-stakes and add noise to the skills chips.

### Adding a project: use `/import-project`

For any GitHub repo, run `/import-project <repo-url>`. The skill researches the repo, asks targeted questions, and writes all seed files. Manual seed edits are only needed for projects with no public repo.

### Manual seed example

```sql
insert into public.projects (name, slug, description, summary, company_id, year, repo_url, project_url, is_public, image_url)
values (
    'Arcus',
    'arcus',
    'An Asana and Linear-inspired task management app I built from scratch...',
    'Personal take on task management, inspired by Asana and Linear, with real-time updates and a clean interface.',
    null,
    2025,
    'https://github.com/schir2/arcus',
    'https://getarcus.com',
    true,
    null
)
on conflict (name) do nothing;
```

`image_url` is always `null` in seeds — set via the admin UI after upload.

## After adding a seed file

Run `npx supabase db reset` to apply all seeds to the local DB (non-TTY safe, use `npx` not `pnpm`).
