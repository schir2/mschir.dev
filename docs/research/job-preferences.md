# Job Preferences Rubric

Machine-readable preference rules for the job-tracker enrichment workflow. The agent
scores the **Want** column against this file and cites which rule fired. Fit is scored
against the resumes in `docs/resumes/`; Want is scored against this file. They are
independent: a role can be a strong skills match and still be a job worth declining.

Decided 2026-09-20. Supersedes nothing; complements `target-roles.md`, which holds the
market research and comp data behind these rules.

## Dealbreakers (auto-Skip, no further analysis)

A posting tripping any of these gets `Fit = Skip`, a one-line reason, and no Want score.
Do not spend enrichment budget scoring them.

1. **Not remote and not NYC metro.** Anything requiring relocation or on-site presence
   outside the New York City metropolitan area. NYC hybrid is in scope. Travel-heavy
   roles based in NYC (FDE work) are in scope.
2. **Requires ML training, PyTorch, or research pedigree.** Model training, inference
   infrastructure, MLOps platform, and quant research roles. Shipping LLM applications
   is in scope; training models is not.
3. **Pure IT, helpdesk, or non-engineering title.** Director of IT, Service Specialist,
   Technical Writer, Technical Trainer, Administrative. These re-lock the IT read the
   resumes exist to break. This rule fires on the title regardless of how good the work
   sounds.

Compensation is deliberately **not** a dealbreaker. Posted band feeds ranking, not gating.

## Strong Want

Rules that push Want toward Strong. More rules firing means a stronger Want.

- **Track 1 or 2 role:** Forward Deployed Engineer, Applied AI Engineer, AI Engineer
  (LLM-application flavor, not MLE). These are the top of `target-roles.md`.
- **Ships to users.** The work reaches customers or internal users. Internal-tools and
  business-systems roles count. Platform and infrastructure roles simply do not fire this
  rule; that is neutral, not a penalty.
- **Integration-heavy.** The posting describes connecting systems, messy real-world data,
  vendor APIs, or customer environments. This is the 14-year throughline.
- **Vertical SaaS in field service or operations.** ServiceTitan, WorkWave, Jobber and
  similar. Thirteen years as a customer of this category is a differentiator nowhere else.
- **Python or TypeScript primary.** Both are on the resume and defensible in interview.
- **Small enough that one engineer owns outcomes.** Series B and later startups,
  mid-market, or a small team inside a large company.

## Weak Want

Rules that push Want toward Weak. These are not dealbreakers; they are reasons to rank a
role below an otherwise equal one. A Weak Want role is still worth applying to when the
Fit is good.

- **Management track.** Roles where the primary deliverable is people leadership rather
  than shipping. Player-coach and lead-engineer roles at small companies are fine and
  score neutral, not weak.

### Removed 2026-09-20, do not reintroduce

- **Infrastructure-only or platform-only.** Cut. Infrastructure and platform work is
  fine; it was never a stated preference. This rule alone produced 8 of 12 Weak scores
  on the first Bloomberg run and made that whole run misleading.
- **Deep single-vendor domain lock.** Cut. Not considered a negative.
- **C++ primary.** Cut from Want. It is a skills gap, so it belongs in Fit, where it
  already appears in the Gaps column. Scoring it here penalized the same fact twice.
- **Kubernetes, Terraform, or Kafka as a hard requirement.** Cut from Want for the same
  reason: a missing skill is a Fit problem, not a preference.

The distinction to hold onto: **Fit measures what is missing, Want measures what is
wanted.** A gap never belongs in Want.

## Neutral

Explicitly not signals either way, recorded so the agent stops treating them as such:

- Company prestige or brand name.
- Whether the title says Senior. Down-level and up-level titles both stay in scope;
  LeetCode-heavy preparation is done, so hard algorithmic screens are not a filter.
- Remote versus NYC hybrid. Both are fully acceptable; neither is preferred.

## Resume Variant Selection

The agent picks one of three bases from `docs/resumes/` by matching posting vocabulary:

| Variant | Pick it when the posting emphasizes |
|---|---|
| `ai-integration-engineer.md` | LLM applications, agents, RAG, evals, customer deployment, integrations, solutions work |
| `senior-software-engineer-backend.md` | Python and Django depth, data modeling, protocol or systems work, query performance |
| `senior-software-engineer-fullstack.md` | Full-stack product work, internal tools, business systems, Vue or TypeScript frontends |

Default to `ai-integration-engineer.md` when two fit equally. The role research ranks it
the strongest overall fit.
