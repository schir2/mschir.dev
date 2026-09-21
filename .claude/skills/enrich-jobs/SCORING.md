# Subagent Prompt Template

Substitute `{{URL}}`, `{{TITLE}}`, `{{COMPANY}}` and send as the `prompt` to a
`general-purpose` subagent. One subagent per posting.

---

You are scoring a single job posting for a candidate. Return only JSON. Do not write to
any spreadsheet, and do not use browser tools.

## Read first

1. `docs/research/job-preferences.md` — the Want rubric and the dealbreakers
2. `docs/resumes/ai-integration-engineer.md`
3. `docs/resumes/senior-software-engineer-backend.md`
4. `docs/resumes/senior-software-engineer-fullstack.md`

## Then fetch the posting

`WebFetch` {{URL}} and extract: required and preferred qualifications, the technologies
named, the team's product area, the posted compensation band, and the work location or
remote policy.

If the fetch fails after two attempts, or the posting has been removed, return
`{"status": "failed"}` or `{"status": "expired"}` and nothing else.

## Score it

**Fit** — can the candidate get this job. Judged against the **posting's own stated
qualifications**, using the resumes as the evidence. This is deliberately objective: it
measures whether the candidate clears the bar the employer published, not how impressive
the match feels.

- `Strong` — meets **every** stated minimum qualification. Being short on *preferred*
  qualifications does NOT reduce this. Preferred means optional; treat it as optional.
- `Stretch` — meets every minimum except one, and that one is **arguable or partially
  met** (adjacent experience, a judgment call, a bar that is close but not clearly clear)
- `Skip` — **clearly** misses one or more minimum qualifications, or a dealbreaker fired

The three buckets map to actions: `Strong` means apply, you clear the published bar.
`Stretch` means apply if motivated, one requirement is a judgment call. `Skip` means the
application would be screened out.

Always name the specific qualification you judged against. In `gaps`, when a minimum is
unmet, say so explicitly with the word "minimum" so the row is scannable.

Do not downgrade for vibes. A candidate who meets every stated minimum is `Strong` even
if the company is prestigious, the competition is fierce, or the work sounds a level
above what they have done before. Those are hiring-odds questions, not qualification
questions, and the tracker does not model them.

If a posting states no minimum qualifications section, judge against the requirements as
written, and say in `gaps` that you did so.

Revised twice on 2026-09-20.

The original definition required "directly comparable shipped work" for Strong and told
the agent to pick the lower value when torn. Together those produced 24 Stretch out of
35 rows and hid the difference between missing a hard requirement and merely lacking a
nice-to-have.

The first revision replaced it but was ambiguous: it defined Strong as "meets all
minimums" and Stretch as "meets all minimums, short on preferred", which are not mutually
exclusive. Agents split on it within a single batch, one returning Strong and one Stretch
for postings with identical `minimums_unmet: []`. Strong now depends on minimums alone.

Do not reintroduce any of it. If `minimums_unmet` is empty, Fit is `Strong`.

**Want** — does the candidate want this job, judged against the rubric only. Never infer
preferences that are not written in `job-preferences.md`. If a dealbreaker fired, `fit`
is `Skip` and `want` is `null`. A `Skip` that came from an incredible gap rather than a
dealbreaker still gets a real Want score: the candidate may want a job they cannot get,
and that is worth seeing.

Name every rubric rule that fired in `rules_fired`, using the rule's own wording. List
only Strong Want and Weak Want rules. Do not list Neutral rules; they fire on everything
and say nothing.

**Carries** — the single strongest thing in the candidate's background for this specific
posting. Concrete, not a category. "MM Portal, Django platform 50+ staff use daily" beats
"internal tools experience". Max 200 characters.

**Gaps** — what the posting asks for that the candidate does not have. Be blunt; a gap
list that flatters is useless. Max 200 characters.

When `fit` is `Skip`, `gaps` carries the skip reason instead. Use `Dealbreaker: <rule>`
ONLY when a rubric dealbreaker actually fired. A Skip caused by an incredible skills gap
is written `Not credible: <what is missing>`. Mislabeling a gap as a dealbreaker hides
which rows were rejected by the rubric versus by the resume. A Skip row only needs to answer "why not", so the
mechanical gap list is redundant there. Still populate `skip_reason` in the JSON; the
orchestrator folds it into the Gaps cell and there is no separate column for it.

**Resume** — which variant to apply with, per the mapping table in the rubric.

**Location** — `Remote`, `NYC Hybrid`, `NYC On-site`, or `Other`. Use `Other` for
anything requiring presence outside the NYC metro area, which is a dealbreaker.

**Comp Band** — the posted base range verbatim, e.g. `$185K-$245K`. Empty string if the
posting does not state one.

**Stack** — the languages and infrastructure the posting actually names, comma
separated, most load-bearing first. Max 5 items. This is what tells the candidate
whether a team is C++ before an application is spent on it.

## Return

```json
{
  "status": "ok",
  "fit": "Strong | Stretch | Skip",
  "want": "Strong | Medium | Weak | null",
  "skip_reason": "",
  "carries": "",
  "gaps": "",
  "resume": "ai-integration | backend | fullstack",
  "location": "Remote | NYC Hybrid | NYC On-site | Other",
  "comp_band": "",
  "stack": "",
  "rules_fired": []
}
```

`skip_reason` is required when `fit` is `Skip` and empty otherwise. Return the JSON
object alone, with no surrounding prose.
