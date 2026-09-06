# Resume Format Research

What effective engineer resumes look like in 2025-2026, condensed from a research pass weighted toward practitioner sources: the r/EngineeringResumes wiki, Tech Interview Handbook, Laszlo Bock's XYZ formula, Gergely Orosz's Tech Resume material, an ex-Meta hiring manager and an ex-Meta recruiter, official Greenhouse and Workday documentation, and live Anthropic, OpenAI, and GitLab job descriptions. Vendor resume sites are cited only for concrete examples. Points marked **contested** have credible sources on both sides.

The three resumes in `docs/resumes/` follow these rules; `docs/resumes/README.md` maps each rule to the decisions made.

## Length and Layout

- One page per decade of experience is the rule of thumb; at 13 years, two pages is defensible when page two carries projects with live URLs and earlier-title bullets rather than padding ([r/EngineeringResumes wiki](https://github.com/r-engineeringresumes/subreddit-wiki/blob/main/wiki/index.md), [techinterview.org](https://www.techinterview.org/post/3233474607/engineering-resume-one-page-vs-two/)). **Contested:** Tech Interview Handbook and one ex-Meta hiring manager say one page, always.
- Single column only. A Lever parsing test on a two-column resume captured the work-experience section and dropped skills, contact info, and links ([Jobscan](https://www.jobscan.co/blog/resume-tables-columns-ats/)).
- No tables, text boxes, icons, images, skill bars, or content in headers/footers; Workday's parser skips headers and footers. Standard section names only: Experience, Skills, Education, Projects.
- Fonts: Calibri, Arial, or a serif like XCharter at 10.5-11pt; margins 0.5in; dates as "May 2021 – Present" with an en dash, right-aligned.
- Submit a text-based PDF unless the posting asks for DOCX. If you can select the text in the PDF, parsers can read it.
- Test: paste the resume into a plain text file; if sections scramble, the parser will scramble them too.

## Section Order

For an experienced engineer whose titles do not say "engineer," put a short skills block near the top so the "Python backend engineer" read happens on the recruiter's first pass ([Tech Interview Handbook](https://github.com/yangshun/tech-interview-handbook/blob/main/apps/website/contents/resume.md), r/EngineeringResumes template). Order used here: header, headline and summary, skills, experience, projects, education. **Contested:** the ex-Meta recruiter puts skills at the bottom for experienced candidates.

## Summary

Include one only when senior, changing roles, or explaining something. This candidate qualifies twice (13 years; title mismatch). Two sentences, under 50 words if possible, starting with the target job-title noun, naming what is different, not buzzwords. Do not let a model write it unedited: "vague, buzzword-laden, and interchangeable" is the failure mode ([Austen McDonald](https://newsletter.systemdesign.one/p/software-engineer-resume)).

## Skills Block

- Grouped categories, comma-separated, three to five lines, single column.
- First item is what you interview in. Only list what you can discuss for five minutes.
- Full form plus abbreviation once ("Microsoft SQL Server (MSSQL)") because some ATS searches are literal.
- No proficiency ratings, stars, or percentages.
- No soft skills. Every engineering-specific source excludes "teamwork" and "leadership" from the skills block; demonstrate them in bullets instead.

## Bullets

- Formula: "Accomplished X, measured by Y, by doing Z" ([Bock](https://www.linkedin.com/pulse/20140929001534-24454816-my-personal-formula-for-a-better-resume)). Equivalent: STAR, CAR, "[action] that resulted in [outcome]."
- One to two lines each, one sentence, past-tense verb first, no pronouns, no trailing period, technologies embedded in the achievement rather than listed separately.
- Count: 4-6 for the current or most relevant role, 2-3 for older roles, 1-2 for the oldest. A stacked single-employer entry gets roughly 10-14 bullets total across titles.
- Quantify without revenue: users, records, integrations, latency, time saved, adoption, error rates, uptime, cost avoided. Ranges and defensible estimates are fine; give context so the number means something.
- Weakest verbs by frequency in a 100K-resume dataset: worked, made, took, showed, helped, assisted, "responsible for" ([Rezi](https://www.rezi.ai/posts/weak-action-verbs-resume)). Preferred: built, designed, shipped, reduced, cut, replaced, integrated, automated, migrated, reverse-engineered, instrumented.
- AI-tell vocabulary recruiters flag: spearheaded, leveraged, orchestrated, pivotal, delve, showcasing, passionate, results-driven, cutting-edge, dynamic, synergy, robust, seamless. A May 2025 survey of 600 US hiring managers: a third say they can spot an AI-written resume in under 20 seconds and a fifth would reject it ([TopResume](https://topresume.com/career-advice/ai-in-hiring-survey)).

## AI Engineer Specifics

- Mirror the posting language. Anthropic's Applied AI Engineer posting: "production experience with LLMs including advanced prompt engineering, agent development, evaluation frameworks, and deployment at scale"; "customized pilots, prototypes, and evaluation suites" ([posting](https://jobs.accel.com/companies/anthropic/jobs/69412050-applied-ai-engineer)).
- Hiring managers probe five things, each of which maps to a bullet: evals ("how do you know nothing else got worse?"), cost per request and the levers used, retrieval diagnosis, guardrails (schema validation, retry budgets, deterministic fallbacks, alerts on quality metrics), and tool-calling security (least privilege, untrusted retrieved content). Red flags: "all demos, no operations," "no numbers," "framework vocabulary, no failure vocabulary" ([Conectia](https://conectia.pro/en/blog/how-to-hire-llm-engineers)).
- "Eval literacy is the single biggest signal of 'this person actually built with LLMs'" ([Digital Applied](https://www.digitalapplied.com/blog/ai-developer-hiring-skills-that-matter-2026)).
- "Prompt engineering" alone reads like "writes good SQL." Show iteration and measurement: versioned prompts, review-rate comparisons, fallback-to-human triggers, cost per call before and after.
- Name specific models and providers tied to shipped work. Top-scoring resumes in one 8,600-resume analysis named a specific model version 3.4x more often than bottom-half resumes ([Resume Optimizer Pro](https://resumeoptimizerpro.com/blog/ai-engineer-resume-examples), vendor data). Thin-wrapper stacks (plain Anthropic or OpenAI SDKs with Pydantic for structured outputs) are respected; listing every framework you have imported signals surface exposure.

## Integration and Solutions Engineer Specifics

- GitLab's public Integrations Engineer job family is the clearest primary source: REST-based HTTP APIs, iPaaS (Workato, MuleSoft, Boomi, Tray), enterprise systems (Salesforce, NetSuite, Workday), JSON/XML, ETL to warehouses, "end-to-end project ownership," documentation for executives and engineers ([GitLab handbook](https://handbook.gitlab.com/job-description-library/finance/integrations-engineer/)).
- Reliability vocabulary that signals depth and rarely appears in postings verbatim, so use it inside bullets: idempotency keys, deduplication, dead-letter and replay, correlation IDs, fast acknowledgement then async processing, signature verification, reconciliation jobs.
- Solutions engineer resumes lead with scope and outcome (stakeholders, departments, adoption, cycle time), then the technical proof. Roughly one outcome clause and one technical clause per bullet. AI-lab SA postings want "5+ years in customer-facing technical roles," requirements translation between technical and business stakeholders, and helping customers build evaluation frameworks.

## Stacked Titles at One Employer

- One company header with location and the full date span, a one-line progression note, then each title as its own dated sub-entry with its own bullets. This parses best and shows scope growth ([Resume Worded](https://resumeworded.com/blog/how-to-show-a-promotion-on-a-resume/)).
- Long tenure is fine when paired with progression; the concern hiring managers voice is looking "institutionalised" without role change ([HN thread](https://news.ycombinator.com/item?id=33321428)). Four titles are the counter-evidence. Other levers: a modern stack visible in skills and recent bullets, projects with live URLs, and separate IC and management resumes.

## Title Clarifiers

- "Director of IT (Lead Software Engineer)" is within bounds when the employer would confirm the scope without hesitating. Official title first, clarifier in parentheses, identical form on LinkedIn, official title alone on application and background-check forms ([Hiration](https://www.hiration.com/blog/change-job-title-on-resume/), [JobSparrow](https://jobsparrow.ai/blog/can-you-change-your-job-title-on-a-resume-a-recruiter-s-guide-to-background-checks-ats)). Background checks verify dates and the official title, not daily responsibilities.
- Never promote yourself ("Staff Engineer," "Head of Engineering"). Do the heavy lifting in the summary and bullets.

## Projects and Links

- For an experienced candidate, projects are secondary but do a specific job here: independently verifiable modern engineering outside the single employer.
- Only maintained, polished work with live URLs. Format: name, stack, year, links, then one or two bullets with users or scale.
- Header links: LinkedIn, GitHub, portfolio site, as plain clickable URLs without labels or icons. No more than four links. A stale GitHub hurts more than none; pin the best repositories.

## What ATS Actually Does

- Greenhouse does not rank or auto-reject; it extracts skills, titles, dates, and companies and shows recruiters matched and missing terms ([Greenhouse support](https://support.greenhouse.io/hc/en-us/articles/41131616864283-Talent-Matching-Data-Processing-FAQ)). Workday's HiredScore grades A-D against the posting's qualifications and prioritizes; it does not reject ([Workday datasheet](https://www.workday.com/content/dam/web/en-us/documents/datasheets/hiredscore-ai-recruiting.pdf)). Lever is a keyword-searchable database.
- The "75% of resumes never reach a human" figure traces to a 2012 sales pitch with no methodology. In a 25-recruiter survey, 92% said their ATS does not auto-reject on content or formatting ([Enhancv](https://enhancv.com/blog/does-ats-reject-resumes/)). Rejections come from humans reading against a scorecard, so mirroring the posting's exact nouns in bullets, not only in the skills block, is what moves the needle.
- Match-score tools measure word overlap; recruiters never see them.
- Apply early: tech roles draw 2,000+ applicants and half of recruiters prioritize early applicants.

## Tailoring

- Maintain two or three base versions for different role families and tailor individually only for high-priority companies. Tactics: adjust the summary, reorder bullets within roles, lift the strongest role-specific evidence, match the skills block to the posting's vocabulary.
- Analyze three to five postings in a role family to find the recurring terms; include full and abbreviated forms; no keyword stuffing, no white text, no per-ATS-vendor versions.

## Templates Worth Copying

- Jake's Resume (LaTeX, MIT license): centered name, one contact line, Education / Experience / Projects / Skills with small-caps headers and rules; move Education to the bottom for experienced candidates ([GitHub](https://github.com/jakegut/resume)).
- r/EngineeringResumes template (Google Docs and Overleaf): XCharter 11pt, 0.5in margins, Skills / Experience / Projects / Education, single-line entry headers with right-aligned dates ([repo](https://github.com/r-engineeringresumes/resume-templates)).
- The Pragmatic Engineer template: Contact, Summary, Experience, Technologies, Education, Projects; single column, minimal bolding, no photo, no self-ratings ([blog](https://blog.pragmaticengineer.com/the-pragmatic-engineers-resume-template/)).

Markdown cannot right-align dates. The resumes here use `**Title** | Mon YYYY – Mon YYYY` entry lines and `**Category:** item, item` skills lines, which render cleanly through pandoc into a single-column DOCX or PDF.
