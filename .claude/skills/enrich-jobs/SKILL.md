---
name: enrich-jobs
description: Score job postings in the Job Search tracker against the candidate's resumes and preference rubric. Fans out one subagent per posting, then writes Fit, Want, Carries, Gaps, Resume, Location, Comp Band, and Stack back to the sheet. Use when the user wants to enrich, score, evaluate, or triage rows in the job tracker, or says "run enrichment", "score these jobs", or "/enrich-jobs".
---

# enrich-jobs

Reads job postings from the Job Search tracker, scores each one against the candidate's
resumes and preference rubric, and writes the results back. One subagent reads and scores
each posting in isolation; the orchestrator does all spreadsheet writes.

## When to Use

- New rows were added to the tracker and have `Enrichment = Pending`
- Rows are `Stale` or `Failed` and need a re-run
- The rubric in `docs/research/job-preferences.md` changed and scores need refreshing

## Input

Optional argument controlling scope:

| Argument | Meaning |
|---|---|
| *(none)* | All rows where `Enrichment` is `Pending` |
| `row 7` or `7` | That single row. Use this for testing. |
| `next 5` | The first 5 `Pending` rows |
| `all` | Every row regardless of current Enrichment value |
| `stale` | Rows where `Enrichment` is `Stale` or `Failed` |

## Source Files

Read these before dispatching anything. Do not score from memory.

- `docs/research/job-preferences.md` — the Want rubric, dealbreakers, and resume-variant mapping
- `docs/resumes/ai-integration-engineer.md`
- `docs/resumes/senior-software-engineer-backend.md`
- `docs/resumes/senior-software-engineer-fullstack.md`
- `docs/research/target-roles.md` — background only, when a judgment call needs context

The tracker: `https://docs.google.com/spreadsheets/d/1kbQiXTGOMdU4KPHBnPSjXSC8KXOh_kzKM6PtSG28G70/edit`

## Processing Steps

### Step 1 — Open the sheet and read the queue

Load the Chrome tools in one `ToolSearch` call, open the sheet, and select the
**Submissions** tab. Read columns A (Title, which carries the posting URL inside a
`HYPERLINK` formula), B (Company), and M (Enrichment).

To get the URLs, select the range and read the formulas rather than the rendered text.
Put the cursor on each Title cell and read the formula bar, or read column A's formulas
via a helper column if the run is large.

Build a work list of `{row, title, company, url}`. Report the count to the user before
dispatching. If the count is above 10, say so and confirm before spending the tokens.

### Step 2 — Dispatch one subagent per posting

Send them in a single message with multiple tool uses so they run concurrently. Cap
concurrency at 6; batch the rest.

Each subagent gets the prompt template in `SCORING.md`, with `{{URL}}`, `{{TITLE}}`, and
`{{COMPANY}}` substituted. Use `subagent_type: "general-purpose"`.

The subagent returns strict JSON. It does not touch the spreadsheet. It does not use
browser tools — `WebFetch` only, so the runs stay independent and cheap.

### Step 3 — Validate what came back

Reject and retry once if any of these fail:

- `fit` is not one of `Strong`, `Stretch`, `Skip`
- `fit` is `Stretch` or `Skip` but `gaps` names no specific qualification from the posting
- `fit` is `Skip` without either a named **minimum** qualification or a fired dealbreaker
- `want` is not one of `Strong`, `Medium`, `Weak`, or is non-null when a **dealbreaker**
  fired. A `Skip` that came from an incredible gap rather than a dealbreaker still carries
  a real Want; do not null it.
- `resume` is not one of `ai-integration`, `backend`, `fullstack`
- `location` is not one of `Remote`, `NYC Hybrid`, `NYC On-site`, `Other`
- `carries` or `gaps` is longer than 200 characters
- `fit` is `Skip` but `skip_reason` is empty

If the fetch failed or the posting is gone, set `Enrichment` to `Failed` or `Expired`
and write nothing else for that row.

### Step 4 — Write results back

**Only columns E through N. Never A through D.** Those are the user's.

Follow `SHEET-MECHANICS.md` exactly — Google Sheets automation through the browser has
several non-obvious failure modes and that file documents each one.

Write column-by-column, not row-by-row: jump to `E{first_row}`, type all Fit values
separated by newlines, then `F{first_row}` for all Want values, and so on. This is far
fewer round trips than writing each row.

Set `Enrichment` to `Enriched` and `Enriched On` to today's date for every row that
scored successfully.

### Step 5 — Report

Print a compact table of what was written: row, title, Fit, Want, resume variant. Then
call out anything that needs a human:

- Any row where `fit` is `Strong` but `want` is `Weak`, or the reverse. These are the
  interesting ones and the reason the two scores are separate.
- Any dealbreaker that fired on a row the user had previously said to keep.
- Any posting whose comp band was absent, since NYC law means that is unusual and may
  mean the posting is out of state.

Do not summarize every row in prose. The sheet is the artifact.

## Rules

- The subagent never writes to the sheet. Serialize all writes through the orchestrator;
  there is one browser and concurrent writes will interleave and corrupt rows.
- Never overwrite a non-empty human column (A-D) for any reason.
- If `docs/research/job-preferences.md` is missing, stop and say so. Do not invent a
  rubric; the whole point is that Want is reproducible and arguable.
- Scores are cheap to redo and expensive to trust wrongly. When a subagent is uncertain
  between two Fit values, it must pick the lower one and say why in `gaps`.

## Fetching postings from JS-rendered job boards

Most modern careers pages render the description client-side, so `WebFetch` returns a nav
shell or nothing. Do not mark these `Failed` before trying the board's own API. Nearly
every ATS exposes one:

| Board | What to fetch instead |
|---|---|
| Ashby (OpenAI, Ramp, Sierra, Decagon, Harvey, Hebbia) | `api.ashbyhq.com/posting-api/job-board/<org>?includeCompensation=true`, then match the posting id from the URL |
| Greenhouse (Anthropic, Scale AI, Databricks, Datadog, Block) | the Greenhouse board API for that org, matched on `gh_jid` |
| Lever (Palantir, WorkWave) | the Lever postings API for that org |
| Workday (ServiceTitan) | `<org>.wdN.myworkdayjobs.com/wday/cxs/<org>/<board>/jobs` |
| Stripe | the embedded job index on `stripe.com/jobs/search` |

`openai.com/careers/<id>` returns 403 to non-browser clients; the Ashby page is the same
posting and its API is readable. This is worth an explicit retry: on the first run the
OpenAI rows were all marked `Failed`, and every one of them scored fine once the agent
was pointed at the API.

**Google Careers is the known exception.** The description is client-rendered and no
public API backs it. Those rows need browser automation or a manual read; mark them
`Failed` with a note rather than burning retries.
