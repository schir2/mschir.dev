-- New tags for the training articles
insert into public.article_tags (name, slug)
values ('Supabase', 'supabase'),
       ('PostgreSQL', 'postgresql'),
       ('Claude Code', 'claude-code'),
       ('AI Tools', 'ai-tools'),
       ('LSP', 'lsp'),
       ('md-editor-v3', 'md-editor-v3')
on conflict (slug) do nothing;

-- Supabase learning series
insert into public.article_series (id, title, slug, description, author)
values ('a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'Learning Supabase',
        'learning-supabase',
        'A practical guide to building with Supabase — from local development to production-ready Row Level Security.',
        '3a455a9e-9a96-4fa1-aef9-8591690084e6');

-- Article 1: Getting Started with Supabase
insert into public.articles (id, title, slug, content, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000001',
    'Getting Started with Supabase',
    'getting-started-with-supabase',
    $article$# Getting Started with Supabase

Supabase is an open-source Firebase alternative that gives you a PostgreSQL database, authentication, real-time subscriptions, storage, and edge functions — all through a clean REST and GraphQL API.

## What Supabase Gives You

- **PostgreSQL database** — a real relational database, not a document store
- **Auth** — email/password, magic link, OAuth providers (Google, GitHub, etc.)
- **Row Level Security (RLS)** — database-level access control
- **Storage** — S3-compatible file storage with access policies
- **Edge Functions** — Deno-based serverless functions
- **Realtime** — WebSocket subscriptions to database changes

## Setting Up a Project

1. Create an account at supabase.com
2. Click "New project" and fill in the name, database password, and region
3. Wait ~2 minutes for provisioning
4. Your project dashboard gives you:
   - **Project URL** — `https://<ref>.supabase.co`
   - **anon key** — safe to expose in the browser; enforced by RLS
   - **service_role key** — server-only; bypasses RLS entirely

## Installing the Client

```bash
pnpm add @supabase/supabase-js
```

Create a client instance:

```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!
)
```

## Basic Queries

Supabase wraps PostgREST, so queries look like this:

```typescript
// Select all published articles
const { data, error } = await supabase
    .from('articles')
    .select('id, title, slug, created_at')
    .not('published_at', 'is', null)
    .order('published_at', { ascending: false })

// Insert a row
const { data, error } = await supabase
    .from('articles')
    .insert({ title: 'Hello World', slug: 'hello-world', content: '...' })
    .select()
    .single()

// Update
const { error } = await supabase
    .from('articles')
    .update({ title: 'Updated Title' })
    .eq('id', articleId)

// Delete
const { error } = await supabase
    .from('articles')
    .delete()
    .eq('id', articleId)
```

## Authentication

Sign up and sign in with email:

```typescript
// Sign up
const { data, error } = await supabase.auth.signUp({
    email: 'user@example.com',
    password: 'secure-password'
})

// Sign in
const { data, error } = await supabase.auth.signInWithPassword({
    email: 'user@example.com',
    password: 'secure-password'
})

// Get current user
const { data: { user } } = await supabase.auth.getUser()

// Sign out
await supabase.auth.signOut()
```

## Generating TypeScript Types

Supabase can generate types directly from your schema:

```bash
npx supabase gen types typescript --project-id <ref> > types/database.types.ts
```

Then use them for type-safe queries:

```typescript
import type { Database } from './types/database.types'

const supabase = createClient<Database>(url, key)

// Now .from('articles') is fully typed
const { data } = await supabase.from('articles').select('*')
// data is typed as Database['public']['Tables']['articles']['Row'][]
```

## Next Steps

Once you have basic queries working, the most important thing to learn is **Row Level Security** — without it, anyone with your anon key can read and write all your data. That is covered in the next article in this series.
$article$,
    (select id from public.article_categories where slug = 'software-development'),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    1,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-01 09:00:00+00',
    '2026-05-01 09:00:00+00',
    '2026-05-01 09:00:00+00'
);

-- Article 2: Row Level Security in Supabase
insert into public.articles (id, title, slug, content, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000002',
    'Row Level Security in Supabase',
    'row-level-security-in-supabase',
    $article$# Row Level Security in Supabase

Row Level Security (RLS) is PostgreSQL's built-in mechanism for enforcing access control at the row level. When enabled on a table, every query — SELECT, INSERT, UPDATE, DELETE — is filtered through your policies. No policy match means no access.

## Why RLS Matters

Supabase exposes your database directly to the browser via PostgREST. Your `anon` key is intentionally public. Without RLS, any user can query any table with any filter. With RLS, the database itself enforces who can see what.

**The rule**: enable RLS on every table. Write policies to grant access. Default is deny-all.

## Enabling RLS

```sql
alter table public.articles enable row level security;
```

Do this in a migration, not the dashboard. Once enabled, even authenticated users get nothing until a policy grants access.

## Policy Structure

```sql
create policy "policy name"
    on public.table_name
    for select  -- or insert, update, delete, all
    to public   -- or authenticated, anon, a specific role
    using (/* boolean expression that must be true */);
```

For INSERT and UPDATE, there is also `with check`:
- `using` — filters which rows are visible/affected
- `with check` — validates rows being written

## Common Patterns

### Public read of published content

```sql
create policy "Public can read published articles"
    on public.articles
    for select
    to public
    using (published_at is not null);
```

`to public` means everyone — anonymous visitors and authenticated users.

### Owner-only writes

```sql
create policy "Authors can insert their own articles"
    on public.articles
    for insert
    to authenticated
    with check (author = auth.uid());

create policy "Authors can update their own articles"
    on public.articles
    for update
    to authenticated
    using (author = auth.uid())
    with check (author = auth.uid());
```

`auth.uid()` returns the UUID of the currently authenticated user. This is a PostgreSQL function injected by Supabase.

### Admin bypass

```sql
create policy "Admins can do everything"
    on public.articles
    for all
    to authenticated
    using (
        exists (
            select 1
            from auth.users
            where id = auth.uid()
              and raw_app_meta_data->>'role' = 'admin'
        )
    );
```

Setting `role: admin` in `raw_app_meta_data` requires the service role key — users cannot set this themselves, making it safe for privilege checks.

## Testing RLS Policies

The most reliable way to test RLS is with pgTAP. Set the role and test what each user can see:

```sql
-- Test that anonymous users only see published articles
select lives_ok(
    $$select * from public.articles where published_at is null$$,
    'anon gets no rows for unpublished articles'
);
```

You can also test from the Supabase dashboard SQL editor by running `set role anon;` before your query.

## Common Mistakes

1. **Forgetting `with check` on INSERT** — `using` only filters reads; without `with check`, inserts are unrestricted even with a `using` clause on the same policy.
2. **`to public` vs `to authenticated`** — `public` includes anonymous users; `authenticated` only applies to signed-in users.
3. **Service role bypasses all RLS** — never use your service role key in the browser.
4. **RLS on junction tables** — if you have `article_tags_links`, you need RLS there too, not just on `articles`.

## Debugging

If a query returns nothing unexpectedly:

```sql
-- Check what policies exist
select * from pg_policies where tablename = 'articles';

-- Temporarily disable RLS to confirm it is a policy issue
alter table public.articles disable row level security;
-- run your query, then re-enable
alter table public.articles enable row level security;
```
$article$,
    (select id from public.article_categories where slug = 'software-development'),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    2,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-08 09:00:00+00',
    '2026-05-08 09:00:00+00',
    '2026-05-08 09:00:00+00'
);

-- Article 3: Supabase Local Development
insert into public.articles (id, title, slug, content, category_id, series_id, series_sequence_number, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000003',
    'Supabase Local Development',
    'supabase-local-development',
    $article$# Supabase Local Development

Running Supabase locally lets you develop offline, iterate on migrations without touching production, and run automated tests against a real PostgreSQL instance. The Supabase CLI handles all of this.

## Prerequisites

- Docker Desktop running
- Supabase CLI: `pnpm add -D supabase` or install globally with `npm install -g supabase`

## Project Setup

Initialize Supabase in your project (if not already done):

```bash
supabase init
```

This creates a `supabase/` directory with:
- `config.toml` — local stack configuration
- `migrations/` — ordered SQL migration files
- `seed.sql` — runs after migrations on `db reset`

Link to your remote project (needed for `gen types` and `db push`):

```bash
supabase link --project-ref <your-project-ref>
```

## Starting the Local Stack

```bash
supabase start
```

This pulls Docker images (first run is slow) and starts:
- PostgreSQL on port 54322
- PostgREST API on port 54321
- GoTrue (Auth) on port 54321/auth
- Studio (dashboard) on port 54323
- Inbucket (email testing) on port 54324

The CLI prints your local URL and keys when it starts.

## Migrations

Migrations are numbered SQL files in `supabase/migrations/`. They run in filename order, so always prefix with a timestamp:

```
20260101211111_create_article_tables.sql
20260530160000_article_writing_stage.sql
```

Create a new migration:

```bash
supabase migration new add_featured_column
```

Apply pending migrations without a full reset:

```bash
supabase db push     # applies to linked remote
supabase db reset    # drops and recreates local DB, runs all migrations + seed
```

## Seed Files

`supabase/seed.sql` runs automatically after `db reset`. For large seed datasets, split into numbered files and call them from `seed.sql`:

```sql
-- supabase/seed.sql
\i seeds/01_blog.sql
\i seeds/02_content.sql
\i seeds/03_projects.sql
```

Seeds run in a transaction, so a failure rolls everything back. Keep seeds idempotent with `ON CONFLICT DO NOTHING`.

## Generating Types

After any schema change, regenerate your TypeScript types:

```bash
supabase gen types typescript --local > shared/types/database.types.ts
```

Or target the linked remote:

```bash
supabase gen types typescript --linked > shared/types/database.types.ts
```

## Running Tests

pgTAP tests live in `supabase/tests/database/`. Run them against the local stack:

```bash
supabase test db
```

pgTAP gives you TAP-formatted output. Write tests like this:

```sql
begin;
select plan(3);

select has_table('public', 'articles', 'articles table exists');
select col_not_null('public', 'articles', 'title', 'title is not null');
select policies_are('public', 'articles', array['Public can read published articles']);

select * from finish();
rollback;
```

## Workflow Summary

1. Edit migration files in `supabase/migrations/`
2. `supabase db reset` — applies all migrations + seeds locally
3. Write and run pgTAP tests: `supabase test db`
4. Generate types: `supabase gen types typescript --local > shared/types/database.types.ts`
5. When satisfied: `supabase db push` to apply to the linked remote
6. `supabase gen types typescript --linked > shared/types/database.types.ts` for remote types

## Useful Commands

```bash
supabase status          # show local service URLs and keys
supabase stop            # stop local services
supabase db diff         # show diff between local and remote schemas
supabase logs api        # tail PostgREST logs
supabase logs db         # tail PostgreSQL logs
```
$article$,
    (select id from public.article_categories where slug = 'devops-automation'),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    3,
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-15 09:00:00+00',
    '2026-05-15 09:00:00+00',
    '2026-05-15 09:00:00+00'
);

-- Article 4: Using md-editor-v3
insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000004',
    'Using md-editor-v3 in Vue',
    'using-md-editor-v3-in-vue',
    $article$# Using md-editor-v3 in Vue

`md-editor-v3` is a markdown editor component for Vue 3. It renders a split-pane editing experience: markdown source on the left, live preview on the right. It is built on CodeMirror for editing and uses markdown-it for rendering.

## Installation

```bash
pnpm add md-editor-v3
```

Import the component and styles:

```typescript
// main.ts or a plugin
import MdEditor from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'
```

In Nuxt, use a client-side plugin since the editor requires `window`:

```typescript
// plugins/md-editor.client.ts
import { defineNuxtPlugin } from '#app'
import MdEditor from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.vueApp.use(MdEditor)
})
```

## Basic Usage

```vue
<template>
    <md-editor v-model="articleContent" />
</template>

<script setup lang="ts">
const articleContent = ref('')
</script>
```

`v-model` binds to the raw markdown string. The editor handles the rendering.

## Viewer-Only Mode

To render markdown without the editor toolbar (for article display pages):

```vue
<template>
    <md-preview :model-value="articleContent" />
</template>
```

`md-preview` is a read-only component that renders the markdown. Import it from the same package.

## Configuration

The editor accepts a `toolbars` prop to control which toolbar items appear:

```vue
<md-editor
    v-model="content"
    :toolbars="['bold', 'italic', 'strikethrough', '-', 'title', 'quote', 'code', '-', 'link', 'image', '-', 'preview']"
/>
```

Common props:

| Prop | Type | Description |
|---|---|---|
| `v-model` | `string` | The markdown content |
| `language` | `string` | UI language (`'en-US'`, `'zh-CN'`) |
| `theme` | `string` | `'light'` or `'dark'` |
| `preview` | `boolean` | Show/hide the preview pane |
| `toolbars` | `array` | Which toolbar buttons to show |
| `placeholder` | `string` | Placeholder text |

## Dark Mode

Pass `theme="dark"` to match a dark UI:

```vue
<md-editor v-model="content" theme="dark" />
```

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+B` | Bold |
| `Ctrl+I` | Italic |
| `Ctrl+K` | Link |
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo |
| `Ctrl+Shift+P` | Toggle preview |

## Image Upload

Handle uploads via the `onUploadImg` callback:

```vue
<md-editor
    v-model="content"
    :on-upload-img="handleImageUpload"
/>
```

```typescript
async function handleImageUpload(files: File[], callback: (urls: string[]) => void) {
    const urls = await Promise.all(
        files.map(async (file) => {
            const { data } = await supabase.storage
                .from('article-images')
                .upload(`${Date.now()}-${file.name}`, file)
            return supabase.storage
                .from('article-images')
                .getPublicUrl(data!.path).data.publicUrl
        })
    )
    callback(urls)
}
```

## Getting the HTML Output

If you need the rendered HTML (for SEO meta tags or email previews), the editor emits `onHtmlChanged`:

```vue
<md-editor
    v-model="content"
    @on-html-changed="renderedHtml = $event"
/>
```
$article$,
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-18 09:00:00+00',
    '2026-05-18 09:00:00+00',
    '2026-05-18 09:00:00+00'
);

-- Article 5: Tailwind CSS Fundamentals
insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000005',
    'Tailwind CSS Fundamentals',
    'tailwind-css-fundamentals',
    $article$# Tailwind CSS Fundamentals

Tailwind CSS is a utility-first CSS framework. Instead of writing custom CSS classes, you compose layouts and styles by applying small, single-purpose utility classes directly in your HTML. The result is that you rarely need to leave your template to style a component.

## The Utility-First Mental Model

Traditional CSS: write a class, write the styles.

```css
.card {
    background: white;
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
```

Tailwind: apply utilities directly.

```html
<div class="bg-white rounded-lg p-4 shadow">
    ...
</div>
```

The trade-off: HTML gets more verbose, but you stop context-switching between files, and you stop naming things that do not need names.

## Core Concepts

### Spacing

Tailwind uses a spacing scale based on multiples of 4px (`1 unit = 4px`):

- `p-4` — padding: 16px all sides
- `px-4` — padding: 16px left and right
- `py-2` — padding: 8px top and bottom
- `mt-8` — margin-top: 32px
- `gap-4` — gap: 16px (for flex/grid)

### Colors

Colors follow a `{color}-{shade}` pattern, shades 50–950:

```html
<p class="text-gray-700 dark:text-gray-200">
    <span class="bg-blue-500 text-white px-2 py-1 rounded">Badge</span>
</p>
```

### Typography

```html
<h1 class="text-3xl font-bold tracking-tight">Heading</h1>
<p class="text-base text-gray-600 leading-relaxed">Body text</p>
<code class="font-mono text-sm bg-gray-100 px-1 rounded">inline code</code>
```

### Flexbox

```html
<div class="flex items-center justify-between gap-4">
    <span>Left</span>
    <span>Right</span>
</div>
```

Common flex utilities:
- `flex` — display: flex
- `items-center` — align-items: center
- `justify-between` — justify-content: space-between
- `flex-col` — flex-direction: column
- `flex-1` — flex: 1 1 0%
- `flex-wrap` — flex-wrap: wrap

### Grid

```html
<div class="grid grid-cols-3 gap-6">
    <div>...</div>
    <div>...</div>
    <div>...</div>
</div>
```

## Responsive Design

Tailwind uses mobile-first breakpoints with prefixes:

| Prefix | Min-width |
|---|---|
| (none) | 0px |
| `sm:` | 640px |
| `md:` | 768px |
| `lg:` | 1024px |
| `xl:` | 1280px |

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
    ...
</div>
```

## Dark Mode

With `darkMode: 'class'` in your config:

```html
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
    ...
</div>
```

The `dark:` prefix applies styles when a `dark` class is on the `<html>` element.

## State Variants

```html
<button class="bg-blue-600 hover:bg-blue-700 active:bg-blue-800 disabled:opacity-50">
    Submit
</button>

<input class="border border-gray-300 focus:border-blue-500 focus:ring-2 focus:ring-blue-200">
```

Common state prefixes: `hover:`, `focus:`, `active:`, `disabled:`, `group-hover:`.

## Extracting Components with `@apply`

When a pattern repeats often, extract it:

```css
/* In your CSS file */
.btn-primary {
    @apply bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 py-2 rounded-lg transition-colors;
}
```

Use sparingly — the whole point of Tailwind is avoiding custom class names. Only extract when you have real repetition across many instances of the same combination.

## Configuration

`tailwind.config.ts` lets you extend the default theme:

```typescript
export default {
    content: ['./app/**/*.{vue,ts}'],
    theme: {
        extend: {
            colors: {
                brand: {
                    50: '#eff6ff',
                    500: '#3b82f6',
                    900: '#1e3a5f',
                }
            },
            fontFamily: {
                sans: ['Inter', 'sans-serif'],
            }
        }
    }
}
```

The `content` array is critical — Tailwind scans these files to determine which utilities to include in the build.

## Common Pitfalls

1. **Dynamic class names do not work** — Tailwind scans for static strings. `text-${color}-500` will be purged. Use full class names or safelist them.
2. **Order matters with conflicting utilities** — `p-4 px-8` applies `p-4` first, then `px-8` overrides it. Tailwind Merge solves this if you are building a component library.
3. **Do not concatenate class strings** — `'text-' + size` will be purged. Always write full class names.
$article$,
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-20 09:00:00+00',
    '2026-05-20 09:00:00+00',
    '2026-05-20 09:00:00+00'
);

-- Article 6: Claude Code Workflows
insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000006',
    'Claude Code Workflows: Automation in the Cloud',
    'claude-code-workflows-automation-in-the-cloud',
    $article$# Claude Code Workflows: Automation in the Cloud

Claude Code now supports **cloud-based workflows** that run your configured slash commands on a schedule or in response to triggers — without you being at your keyboard. This is distinct from a regular Claude Code session: the agent runs remotely, accesses your repo, and can open PRs, post comments, or run tests.

## What Are Cloud Workflows?

A cloud workflow is a Claude Code agent run that executes remotely on Anthropic infrastructure. It has access to:
- Your GitHub repository (via the GitHub integration)
- The slash commands and skills defined in your project
- MCP servers configured in your project settings

You trigger them from the Claude Code web app at `claude.ai/code`, or schedule them via `/schedule`.

## Setting Up

Prerequisites:
1. Your project must be a GitHub repository
2. Install the Claude Code GitHub app on your repo (Settings → Integrations in the web app)
3. The repo must have a `CLAUDE.md` with enough context for the agent to work autonomously

## Triggering a Workflow Manually

In the Claude Code web app:
1. Open your project
2. Click "Run workflow" or use the `/run` skill
3. Select the command or describe what you want the agent to do
4. The agent spins up, clones the repo, executes your command, and reports back

## Scheduled Workflows with `/schedule`

The `/schedule` skill lets you create recurring agents:

```
/schedule daily at 9am: run /code-review ultra and post findings as PR comments
/schedule every monday: check for stale issues and label them needs-triage
/schedule once at 3pm: run the test suite and notify me if anything fails
```

Behind the scenes, this creates a cron-based routine that fires the Claude Code CLI with your specified prompt.

## Writing Prompts for Autonomous Agents

Autonomous agents need more context than interactive ones because there is no one to answer clarifying questions. In your workflow prompt:

- **Be specific about inputs and outputs** — "review all open PRs" is ambiguous; "review PRs opened in the last 24 hours against main" is not
- **Specify what to do on failure** — "if tests fail, open an issue with the log output, do not create a PR"
- **Reference your skills** — `/code-review`, `/triage`, `/tdd` are available to the remote agent

## Using Hooks

Hooks in `.claude/settings.json` fire before or after tool calls:

```json
{
    "hooks": {
        "PreToolUse": [
            {
                "matcher": "Bash",
                "hooks": [
                    {
                        "type": "command",
                        "command": "echo 'running bash'"
                    }
                ]
            }
        ]
    }
}
```

In cloud runs, hooks run inside the sandbox. Use them for logging, validation, or injecting context.

## GitHub Actions vs Claude Workflows

| | GitHub Actions | Claude Workflows |
|---|---|---|
| Trigger | Push, PR, cron | Manual, cron, issue comment |
| Code | YAML workflows | Natural language + skills |
| Context | Static scripts | Full Claude reasoning |
| Best for | Deterministic CI | Intelligent triage, review, generation |

They complement each other. A typical setup: GitHub Actions for CI (lint, test, build), Claude Workflows for code review, triage, and PR summarization.

## Practical Examples

**Daily code review:**
```
/schedule daily at 8am: review all PRs opened yesterday, post inline comments for any obvious bugs, and add a summary comment
```

**Automated triage:**
```
/schedule every 2 hours: check for new GitHub issues, apply appropriate labels, and post a clarifying question if the issue is missing reproduction steps
```

**Test monitoring:**
```
/schedule every 15 minutes: run pnpm test and if anything fails, create a GitHub issue with the test output and assign it to me
```
$article$,
    (select id from public.article_categories where slug = 'devops-automation'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-22 09:00:00+00',
    '2026-05-22 09:00:00+00',
    '2026-05-22 09:00:00+00'
);

-- Article 7: LSPs in Claude Code
insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000007',
    'Using LSP Diagnostics in Claude Code to Save Tokens',
    'using-lsp-diagnostics-in-claude-code-to-save-tokens',
    $article$# Using LSP Diagnostics in Claude Code to Save Tokens

One of the most effective ways to reduce token usage in Claude Code is to stop asking the model to hunt for type errors manually. Instead, let your Language Server Protocol (LSP) do the work it was designed for — and feed those diagnostics directly into Claude.

## The Problem with Manual Type Checking

A common pattern when fixing TypeScript errors:

1. Claude reads `file.ts` — costs tokens
2. Claude reads imports to understand types — more tokens
3. Claude tries to reason about type compatibility — often wrong
4. You paste the error from the terminal — finally, useful signal

You have spent hundreds of tokens doing what `tsc` would tell you in milliseconds.

## The `mcp__ide__getDiagnostics` Tool

Claude Code ships with an MCP server that bridges your editor's LSP to the agent. The `getDiagnostics` tool returns the current list of errors and warnings from your language server — the same list your editor shows in the Problems panel.

In a Claude Code session, the agent can call this directly. You can also invoke it explicitly:

> "Check LSP diagnostics for `app/components/article/ArticleCard.vue`"

Claude calls `getDiagnostics`, gets a structured list of errors with file paths, line numbers, and messages, and targets its fixes precisely.

## Token Savings in Practice

Without LSP diagnostics, fixing a TypeScript error in a large component might look like:
- Read the component file (800 tokens)
- Read 3 imported types (600 tokens)
- Make a guess, check if it is right (200 tokens)
- Total: ~1600 tokens for one error

With `getDiagnostics`:
- Call getDiagnostics (50 tokens)
- Read only the relevant 10 lines around the error (100 tokens)
- Apply the fix (100 tokens)
- Total: ~250 tokens for one error

**That is an 85% reduction for a targeted fix.**

## Workflow: Fix All Errors Efficiently

Ask Claude Code to work through all current diagnostics:

> "Run getDiagnostics on the whole project, then fix all TypeScript errors starting with the ones in `app/components/`"

Claude will:
1. Fetch the full diagnostics list
2. Group errors by file
3. Fix them in dependency order (leaf files first)
4. Re-check diagnostics to confirm the fixes took

## When to Use Diagnostics vs Reading Files

| Task | Better approach |
|---|---|
| Fix a TypeScript error | getDiagnostics first, then targeted read |
| Understand how a module works | Read the file |
| Refactor a type | Read the type definition, then diagnostics after |
| Confirm a fix worked | getDiagnostics after applying |
| Review code for logic bugs | Read the file (LSP does not catch logic errors) |

## Setting Up MCP in Your Project

If `getDiagnostics` is not available, check that the IDE MCP server is enabled. In `.claude/settings.json`:

```json
{
    "mcpServers": {
        "ide": {
            "type": "stdio",
            "command": "claude",
            "args": ["mcp", "serve", "ide"]
        }
    }
}
```

The IDE MCP server also provides `getOpenFiles` and other editor-state tools. Run `/fewer-permission-prompts` after enabling it so you are not prompted on every diagnostic call.

## Vue + TypeScript Specifics

Vue single-file components have an extra layer: `vue-tsc` is the type checker, and Volar is the language server. Diagnostics from `getDiagnostics` in a Vue project will include:
- TypeScript errors in `<script setup>` blocks
- Template binding errors (wrong prop types, missing required props)
- Import resolution errors

These are often more useful than raw `tsc` output because they include template-level type mismatches that `tsc` would not catch without `vue-tsc`.

## Combining with `/code-review`

Run a review after a large refactor to catch anything the LSP missed:

```
/code-review low
```

Low-effort review plus getDiagnostics is usually enough for a quick sanity check after mechanical changes. Save `/code-review ultra` for meaningful architectural changes.
$article$,
    (select id from public.article_categories where slug = 'software-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'ready',
    '2026-05-25 09:00:00+00',
    '2026-05-25 09:00:00+00',
    '2026-05-25 09:00:00+00'
);

-- Tag links: Supabase series
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000001', id from public.article_tags where slug in ('supabase', 'postgresql');

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000002', id from public.article_tags where slug in ('supabase', 'postgresql', 'security');

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000003', id from public.article_tags where slug in ('supabase', 'postgresql', 'docker', 'ci-cd');

-- Tag links: md-editor-v3
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000004', id from public.article_tags where slug in ('md-editor-v3', 'vue.js', 'javascript');

-- Tag links: Tailwind
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000005', id from public.article_tags where slug in ('tailwind-css', 'css', 'responsive-design');

-- Tag links: Claude Code workflows
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000006', id from public.article_tags where slug in ('claude-code', 'ai-tools', 'cloud', 'ci-cd');

-- Tag links: LSPs
insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000007', id from public.article_tags where slug in ('claude-code', 'ai-tools', 'lsp', 'scripting');

-- Featured articles
insert into public.featured_articles (article_id, featured_reason, author)
values
    ('b1000000-0000-0000-0000-000000000001',
     'Essential first article in the Supabase series',
     '3a455a9e-9a96-4fa1-aef9-8591690084e6'),
    ('b1000000-0000-0000-0000-000000000007',
     'Practical token-saving technique for Claude Code users',
     '3a455a9e-9a96-4fa1-aef9-8591690084e6');