# Target Roles

Which job titles to apply for, ranked by fit against the profile in `resume-skills.md` and `linkedin-profile-audit.md`, with 2025-2026 market data. Built from a research pass across Indeed Hiring Lab, Levels.fyi, Glassdoor, Wellfound, Built In NYC postings with pay bands, Pragmatic Engineer, and Federal Reserve notes. Salary figures were cross-checked across at least two sources; where sources disagree the spread is shown rather than averaged.

Citation tags: `[P]` primary data (posting counts, pay bands in actual postings, large-n salary aggregators, Fed/Indeed research). `[D]` directional (staffing-firm guides, newsletters, blog analyses).

Data caveats: Glassdoor pages block direct fetches, so those figures come from search-result summaries and carry URLs for verification. Job-board counts are keyword matches, not exact titles; read them as relative demand.

## Bottom Line

Apply for these, in this order:

1. **Forward Deployed Engineer (FDE) / Forward Deployed AI Engineer.** The closest description of the last 13 years of work: integrate purchased AI into messy real-world systems, with a customer at the table. Steepest demand curve in the market right now. Posting median base around $190K. The single-employer and "IT title" objections matter least here.
2. **AI Engineer / Applied AI Engineer (LLM-application flavor)** at enterprises and vertical SaaS, not AI labs. Fastest-growing title in the US. The MM Portal call-enrichment pipeline maps one-to-one onto the posting vocabulary. Skip any posting that requires PyTorch or model training.
3. **Solutions Engineer / Integrations Engineer at field-service vertical SaaS** (WorkWave, ServiceTitan/FieldRoutes, Jobber) and at AI vendors. The only path that monetizes 13 years inside a pest-control company directly, and it sidesteps LeetCode loops.

Run a fourth, volume-based track in parallel: **Senior Software Engineer (backend, Python)** at mid-market and vertical SaaS companies. Never label yourself "Django developer"; that title carries a $100K discount for the same work.

Avoid or deprioritize: Platform Engineer (Kubernetes/Terraform gate), Implementation Engineer (low ceiling), "Automation Engineer" and "AI Integration Engineer" as titles (pay like IT, conflated with QA/PLC/contract work), Engineering Manager at tech startups (they want evidence of managing engineers, which the profile does not have).

## Shortlist

| # | Title | Fit | NYC senior band | Demand signal |
|---|---|---|---|---|
| 1 | Forward Deployed Engineer | Strong | Base $160K-$220K in postings; Palantir FDSE median TC $211K; AI-lab roles $280K+ | 378 NYC postings (Glassdoor, Aug 2026); AWS $1B and Microsoft $2.5B FDE orgs launched Jun/Jul 2026 |
| 2 | AI Engineer / Applied AI Engineer | Strong to partial | Levels.fyi NYC median TC $165K (75th $215K); mid-market postings $180K-$230K; enterprise lead $230K-$286K | #1 fastest-growing US job (LinkedIn); 897 NYC postings (Glassdoor, Aug 2026) |
| 3 | Solutions Engineer / Solutions Architect | Partial to strong | Glassdoor NYC avg $184K (25th-75th $149K-$231K); Anthropic NYC SA $240K-$270K | 230 NYC postings (Glassdoor, Jul 2026) |
| 4 | Integration Engineer | Strong technically, moderate comp | Indeed NYC avg $158K | High volume, noisy title |
| 5 | Senior Backend Engineer (Python) | Partial to strong | Glassdoor NYC avg $214K; Wellfound NYC startups avg $167K | Largest volume; hardest screens without pedigree |
| 6 | Software Engineer, Internal Tools / Business Systems / GTM Systems | Strong | Glassdoor US avg $157K; Block NYC Staff GTM Systems & AI $264K-$395K | Moderate, scattered titles |
| 7 | Founding Engineer | Strong on profile, risk-dependent | Base $160K-$230K plus 0.8%-2% equity | Moderate |
| 8 | Engineering Manager (player-coach) | Partial | Wellfound NYC avg $204K | Moderate |
| 9 | Implementation Engineer | Overqualified | Glassdoor US avg $122K | High volume, low ceiling |
| 10 | Automation Engineer | Skills match, title is a trap | Glassdoor NYC $126K; n8n/Zapier work $40-$65/hr contract | Conflated with QA and industrial |
| 11 | Platform Engineer | Stretch | NYC median base $189K | Kubernetes/Terraform gate |
| 12 | AI Solutions Architect | Stretch by title | Glassdoor US avg $212K; ZipRecruiter $146K | Reach it through #3 |

## Role Detail

### 1. Forward Deployed Engineer

**The job.** Pragmatic Engineer's May 2026 breakdown: roughly 25% coding, 50% integration and plumbing, 25% meetings and customer hand-holding, embedded with a customer to get an AI product working against their real systems and data [D] ([source](https://blog.pragmaticengineer.com/the-pulse-forward-deployed-engineering-heats-up-again/)). AWS's new FDE org runs 45-day cycles with pods of five or six engineers per client [P] ([source](https://www.aboutamazon.com/news/aws/aws-1-billion-forward-deployed-ai-engineers)).

**Requirements in postings.** Analysis of ~1,000 FDE posts: Python and/or TypeScript, SQL, cloud, Docker in 95%+; LLM application development, RAG, prompt/eval workflows, agent orchestration in 80%+; customer discovery and translating ambiguous business problems in 70%+ [D] ([source](https://getperspective.ai/blog/2026-fde-hiring-trends-what-1000-job-posts-reveal)). Median posting asks for 5-8 years [D]. Anthropic's NYC "Applied AI Engineer, Startups" posting asked for 4+ years as a software engineer, FDE, or technical founder, plus production LLM application experience [P] ([source](https://www.builtinnyc.com/job/applied-ai-engineer-startups/8235236)).

**Fit: strong.** The 50% integration slice is the whole career: direct MSSQL integration into a 2007-era field-service system, a scraper for a system with no API, the TDS proxy, HubSpot webhooks, 3CX, Stripe, TSheets. The AI slice matches unusually well for a non-AI-company background: a production Pydantic AI + Claude pipeline with tool calling, structured output into 45 CRM properties, confidence thresholds routing to human review, per-task cost tracking, prompt versioning with re-enrichment, and a retry/dead-letter state machine. That is the exact LLMOps vocabulary FDE postings use.

**Gaps.** No RAG/retrieval project (build one). No Kubernetes (minor at startups; Docker suffices). Customer-facing experience is with internal executives and the external users of the quoting portal, not external paying customers. Frame the owners as the customer; that is literally how an internal builder works.

**Comp.** Posting-derived base: 25th $160K, median $190K, 75th $220K [D, 135 postings] ([source](https://www.recruitingfromscratch.com/blog/forward-deployed-engineer-salary-in-2026-real-data-from-200k-job-postings)). Glassdoor US self-reported avg $156K, 90th $244K [P] ([source](https://www.glassdoor.com/Salaries/forward-deployed-engineer-salary-SRCH_KO0,25.htm)). Palantir FDSE median TC $211K [P] ([source](https://www.levels.fyi/companies/palantir/salaries/software-engineer/title/fdse)). Anthropic NYC Applied AI Engineer band $280K-$320K [P, posting]. Treat the "$300K-$450K" figures circulating in blogs as a tiny equity-heavy cohort, not the market.

**Demand.** 378 NYC postings on Glassdoor, Aug 2026 [P]. AWS committed $1B (Jun 30, 2026) [P] ([source](https://techcrunch.com/2026/06/30/amazon-launches-new-1-billion-fde-org-following-openai-and-anthropic/)); Microsoft Frontier Company, $2.5B and ~6,000 staff (Jul 2, 2026) [P] ([source](https://www.cnbc.com/2026/07/02/microsoft-commits-2point5-billion-6000-employees-ai-implementation-unit.html)); OpenAI and Anthropic launched deployment entities in May 2026 [D]. Employer mix: 59% of FDE-hiring companies are Seed to Series A, 35% Series B+ [D].

**Employers.** AI labs' deployment subsidiaries; cloud FDE orgs (AWS, Google Cloud, Microsoft Frontier); Palantir, Databricks, Scale; vertical AI startups (Harvey, Sierra, Decagon, Cresta, Hebbia); consultancies (Deloitte, Accenture).

**Lead with.** The 3CX to Claude to HubSpot pipeline told as a deployment story (messy input, structured output, confidence gating, cost control, versioned prompts). The TDS proxy and the no-API scraper as proof you can integrate with anything. The NYCHA platform as a business-outcome story ($5M contract, 3 hours to 3 minutes). Thirteen years of requirements gathering with owners as the customer-empathy evidence.

**Risks.** Scope creep, white-glove customer accommodation, weak product feedback loop, stock sometimes issued by a subsidiary rather than the parent lab, travel [D, Pragmatic Engineer]. Not greenfield product engineering.

### 2. AI Engineer / Applied AI Engineer

**The job.** Ships LLM features into products and internal workflows: prompt and context engineering, tool-calling agents, structured outputs, RAG over company data, eval harnesses, cost and latency management, observability. Typical NYC posting language: "RAG, tool/function calling, agentic workflows, validated structured outputs" and "LLMOps: evaluation harnesses, prompt and version management, regression testing, observability" [P, postings] ([example](https://www.dice.com/job-detail/3980def3-092f-4e14-ac92-39917435dfe7)).

**Fit: strong to partial.** Strong on the applied side; the existing pipeline has more production maturity than many applicants' work. Partial on two counts: no retrieval/vector-search project, and no formal eval harness beyond confidence thresholds. Building an eval harness over the existing call-classification data closes both in about two weeks. No formal ML training only matters for the MLE-flavored postings, which should be skipped.

**Comp.** Levels.fyi AI Engineer NYC: median TC $165K, 25th $128K, 75th $215K, 90th $310K [P] ([source](https://www.levels.fyi/en-gb/t/software-engineer/title/ai-engineer/locations/new-york-usa)). Posted NYC bands: Ro Senior Engineer, Applied AI $182K-$220K; Maybern Senior Software Engineer, AI $180K-$230K; Capital One Senior Lead AI Engineer $230K-$286K; New York Life Lead Full-Stack AI Engineer $124K-$177K [P] ([source](https://www.builtinnyc.com/jobs/ai-machine-learning/search/ai-engineer)). Staffing-firm data: NYC base $195K-$225K; US-remote base $155K-$210K [D] ([source](https://www.kore1.com/ai-engineer-salary-guide/)). AI premium over non-AI peers at senior: +14.2% [P via Levels.fyi Q3 2025].

**Demand.** LinkedIn Jobs on the Rise 2026: AI Engineer is the #1 fastest-growing US job; 75,000 postings added 2023-2025 [P] ([source](https://www.forbes.com/sites/juliakorn/2026/01/14/future-proof-your-career-with-linkedins-2026-fastest-growing-jobs-list/)). Indeed Hiring Lab: 37% of the May 2025 to May 2026 increase in software-development postings came from jobs with AI in the title [P] ([source](https://hiringlab.indeed.com/2026/07/08/ai-and-job-postings-from-destruction-to-creation/)). 897 NYC postings on Glassdoor, Aug 2026 [P].

**Employers.** Enterprises building internal AI platforms (Capital One, JPMorgan, New York Life, PwC); mid-market and vertical SaaS adding LLM features (Ro, Maybern, Navan); consultancies. These tiers hire for shipped LLM systems, not research pedigree.

**Lead with.** The pipeline architecture and its numbers: classification accuracy vs human-review rate, cost per call before and after prompt tuning, the cheaper-model-holds-quality story, prompt versioning with re-enrichment. Use the words postings use: structured outputs, tool calling, evals, human-in-the-loop, observability, cost per task.

### 3. Solutions Engineer / Solutions Architect

**The job.** Pre-sales: discovery, demos, proofs of concept, RFP and security-review responses, architecture guidance; post-sales variants shade into implementation. Anthropic's NYC "Solutions Architect, Applied AI": technical advisor to enterprise customers from discovery through deployment, guiding Claude integration architecture, helping customers build evaluation frameworks; 5+ years in customer-facing technical roles required [P] ([source](https://www.builtinnyc.com/job/applied-ai-solutions-architect/3711122)).

**Fit: partial to strong.** Technical half is strong. The gap is the literal "customer-facing role" line item. The differentiator is domain: field-service vertical SaaS (WorkWave in Holmdel NJ serves pest control, lawn care, and cleaning; ServiceTitan owns FieldRoutes/PestRoutes; Jobber) sells to companies exactly like M&M Environmental. A 13-year customer of the category who can also code is a rare SE hire there.

**Comp.** Glassdoor NYC Solutions Engineer avg $184K, 25th $149K, 75th $231K [P] ([source](https://www.glassdoor.com/Salaries/new-york-city-ny-solutions-engineer-salary-SRCH_IL.0,16_IM615_KO17,35.htm)). Indeed NYC avg $164K [P]. Anthropic NYC SA $240K-$270K [P]. Vertical-SaaS SE roles sit near the Indeed/Glassdoor bands.

**Employers.** AI labs and cloud providers (highest pay, hardest screens); iPaaS vendors (Workato, Boomi, Tray); HubSpot itself, not its agencies; field-service vertical SaaS; observability and security vendors.

**Lead with.** Requirements gathering with owners, training staff and writing SOPs, Figma/InVision prototyping, the quoting portal (customer-facing, real-time pricing, signed PDFs), HubSpot depth. For field-service SaaS: "I was your customer for 13 years and built what your product does not."

### 4. Integration Engineer

Builds connectors between business systems: CRM/ERP/field-service/finance sync, REST/webhooks, auth, transformation, retry and monitoring, increasingly on iPaaS (Workato, MuleSoft, Boomi). **Fit: strong technically.** The integration inventory covers the entire posting checklist except named iPaaS tools, which are learnable in days. **Comp:** Indeed NYC avg $158K from 77 posting salaries [P] ([source](https://www.indeed.com/career/integration-engineer/salaries/New-York--NY)); Glassdoor US avg $135K, 90th $215K [P]. **Risk:** a ceiling role at enterprise IT shops. Choose the SaaS/AI-company versions, where an "Integrations Engineer" building connectors into customer systems is near FDE comp.

### 5. Senior Backend Engineer (Python)

**Fit: partial to strong.** Django/Postgres/MSSQL/asyncio depth and 13 years of a production system used daily by 50+ people are real. Gaps: no Kafka/Kubernetes/distributed-systems scale evidence, and this title has the most LeetCode-style loops and the most pedigree competition. **Comp:** Glassdoor NYC avg $214K, 25th $166K [P]; Levels.fyi Senior SWE NYC median TC $250K, big-tech skewed [P] ([source](https://www.levels.fyi/t/software-engineer/levels/senior/locations/new-york-city-area)); Wellfound NYC startups avg $167K [P]. Realistic target at mid-market or vertical SaaS: $170K-$220K base. **Lead with:** the TDS proxy (protocol-level work is the single strongest "real engineer" signal in the profile), asyncio, the 3-hour-to-3-minute report pipeline, data modeling across three database engines, 13 years of operating a system without a platform team. Aim at ops-heavy companies where domain and integration depth beat algorithm drills: WorkWave Senior SWE median $171K [P]; ServiceTitan SWE median TC $275K [P].

### 6. Software Engineer, Internal Tools / Business Systems / GTM Systems

**Fit: strong.** This is the job the candidate has done for 13 years at a company that called it IT. **Comp:** Glassdoor US avg $157K, 75th $195K [P]; Block NYC Staff GTM Systems & AI $264K-$395K [P]. Internal-tools seats run $50K-$80K below product engineering per one staffing guide [D]. Search by skills (HubSpot, NetSuite, Salesforce, internal tools, business systems) rather than title. **Risk:** it can perpetuate the IT label. Prefer the "GTM Systems & AI" flavor.

### 7. Founding Engineer

**Fit: strong on profile.** "Built all of a 100-person company's software, integrations, and AI pipeline, plus ran infra" is the archetype; Arcus and Calcura help. Base $160K-$230K with 0.8%-2% equity [P, small n] ([source](https://topstartups.io/startup-salary-equity-database/?title=Founding+software+engineer)). Lower base, higher variance, and no manager above you to fix the title problem later. Only if runway and risk tolerance allow.

### 8. Engineering Manager (player-coach)

37% of engineering leaders are now "deeply hands-on" [D] ([source](https://leaddev.com/management/engineering-managers-have-a-new-job-description)), but startup EM postings want 1-2 years managing engineers plus IC credibility. The profile has IT management, executive communication, SOPs, and training, but no evidence of managing software engineers. Do not claim it. Revisit after two or three years in an IC role.

### 9-12. Deprioritized

- **Implementation Engineer:** Glassdoor US avg $122K, low ceiling. Only when a vertical AI company uses the title as an FDE label with FDE pay.
- **Automation Engineer / AI Automation Engineer:** the title aggregates QA and PLC roles; the n8n/Zapier segment is a contract market at $15-$65/hr [P, listings] ([source](https://www.ziprecruiter.com/Jobs/N8N-Developer)). Keep the automation stories inside other applications; drop the title. Same for "AI Integration Engineer" (ZipRecruiter US avg $124K, identical to plain Integration Engineer) and HubSpot-partner developer roles (~$99K).
- **Platform Engineer:** Kubernetes, Terraform, and cloud-native observability are the gate; pursuing it dilutes the AI/integration narrative.
- **AI Solutions Architect:** 7+ years, often a master's, enterprise-architecture pedigree. The reachable version is the Anthropic-style "Solutions Architect, Applied AI," which is a senior SE with LLM depth. Approach through role #3.

## Seniority

**Where the profile lands.** By years (13, hands-on throughout) and scope (architecture for an entire company, multi-year horizons, cross-functional influence) the profile meets Staff criteria on paper. What Staff loops actually test is influencing other engineers and teams, and with no peer engineers that evidence does not exist. Companies with formal ladders will place the candidate at Senior.

**Practical mapping.**

- Big tech and scaled companies: Senior (L5-equivalent) is the realistic entry. Do not apply to mid-level roles; senior roles were 69.3% of software-development postings in Q1 2026 vs 4.5% entry-level [P] ([source](https://hiringlab.indeed.com/2026/07/23/the-labor-market-is-tilting-toward-seniority/)).
- Startups and mid-market: Senior, Lead, Staff, and Founding are used loosely. Apply to Senior/Staff/Lead postings and let the loop level you.
- FDE and Solutions roles: leveling is by deployment/customer experience; apply at Senior.

**How to avoid being down-leveled or dismissed as "not a real engineer."**

1. Present as an engineer first, everywhere. Resume header and LinkedIn headline carry "Senior Software Engineer"; "Director of IT" is the official title inside the experience entry, not the identity.
2. Quantify scope in engineering terms: 100% of the company's internal software, 50+ daily users for 13 years, three database engines, a protocol-level proxy, an LLM pipeline with cost and quality controls, a $5M-contract reporting platform with a 60x speedup.
3. Tell stories as architecture decisions with tradeoffs: proxy the TDS protocol vs migrate; confidence thresholds vs full automation; prompt versioning with re-enrichment vs in-place edits.
4. Make the code visible. Technical writeups of the AI pipeline and the TDS proxy; Arcus and Calcura as public repositories.
5. Prepare for the coding round explicitly. It is where career-long internal builders get filtered. Two to four weeks of deliberate practice matters more than any resume wording.
6. Ask for the leveling criteria on the first recruiter call. It signals fluency and prevents a silent down-level.
7. Reframe the single employer: four promotions across three distinct roles, one system kept alive through three technology generations, and a company that kept paying for it.
8. The pendulum argument if anyone questions management to IC: the best technical leaders are never more than 2-3 years from hands-on work [D] ([source](https://charity.wtf/2017/05/11/the-engineer-manager-pendulum/)). The candidate never left hands-on work, which is the stronger version.

## Title Translation

**A clarifying parenthetical is acceptable and recruiter-recommended.** Background checks verify dates and the official title on file, not daily responsibilities [D] ([source](https://jobsparrow.ai/blog/can-you-change-your-job-title-on-a-resume-a-recruiter-s-guide-to-background-checks-ats)). The line: clarify what you did, never fabricate seniority; the resume and LinkedIn must match [D] ([source](https://resumeworded.com/change-job-title-on-resume-key-advice)).

**Resume treatment.**

- Header line: "Senior Software Engineer | Python/Django, Systems Integration, LLM Pipelines." The target title belongs in the resume title and summary, not in the past-title field.
- Experience entry: `Director of IT (Lead Software Engineer; sole developer for all internal platforms)`, with the first bullet stating the reality.
- Show the progression so earlier titles do the work: two of four titles already say developer/programming.
- Never rename the role to "Staff Software Engineer" or "Head of Engineering."
- Consider splitting the Director of IT entry into "Software Engineering" and "IT Infrastructure" sub-headings so engineering bullets are not buried.

**LinkedIn.** Recruiter search filters are exact-match on title and keywords, and the headline is the primary field for a transition [D] ([source](https://www.leonar.app/blog/linkedin-recruiter-search-filters/)). Put target titles and posting vocabulary in the headline and skills; keep the experience title "Director of IT" with the parenthetical in the description's first line. No abbreviations in the headline.

**Application forms.** Where a form asks for the title as it would appear on employment verification, use "Director of IT."

**In conversation.** "My official title was Director of IT, but at a 100-person company that meant I was the entire software team. I designed and built the platform 50 people use every day, the integrations into our CRM and phone system, and the AI pipeline that reads our calls. I also ran the infrastructure." Then move straight into a technical story.

## Market Context

- US software-development postings on Indeed rose almost 15% since late February 2025 while overall postings fell 7%, but remain about 27.5% below pre-pandemic [P] ([source](https://hiringlab.indeed.com/2026/07/08/ai-and-job-postings-from-destruction-to-creation/)).
- The rebound is a senior rebound: senior roles were 71% of the net increase in software-development postings May 2025 to May 2026 [P]. This is the single most favorable structural fact for a 13-year candidate.
- AI's effect on demand is re-sorting, not disappearing: the Dallas Fed finds AI-exposed postings fell about 8% relative to less-exposed ones by Q1 2025 [P] ([source](https://www.dallasfed.org/research/economics/2026/0901)); the Fed Board finds null effects of firm AI adoption on total postings [P] ([source](https://www.federalreserve.gov/econres/notes/feds-notes/ai-adoption-and-firms-job-posting-behavior-20260327.html)); Indeed reads AI-exposed occupations as leading the recovery in 2025 [P].
- Software-development and IT-systems postings mention AI 20%+ of the time; AI skills carry a 28% (~$18K) salary premium [P] ([source](https://lightcast.io/resources/blog/beyond-the-buzz-press-release-2025-07-23)).
- "AI integration at non-AI companies" is a real, growing segment. Enterprises buy models rather than train them (76% of use cases purchased) [D] ([source](https://menlovc.com/perspective/2025-the-state-of-generative-ai-in-the-enterprise/)), and MIT's "GenAI Divide" found 95% of pilots produced no measurable P&L impact because tools "integrate poorly or don't match workflows" [D] ([source](https://www.forbes.com/sites/jasonsnyder/2025/08/26/mit-finds-95-of-genai-pilots-fail-because-companies-avoid-friction/)). The scarce skill is wiring purchased LLM capability into legacy systems with controls, which is why FDE orgs are being funded at billion-dollar scale. The call-transcription-to-CRM pipeline is a textbook instance of what the 5% did.
- Remote: 31.8% of US software-development postings carried remote/hybrid terms on July 31, 2026, down from 33.7% a year earlier [P] ([source](https://github.com/hiring-lab/remote-tracker)). Hybrid two to three days is the default. From New City, NY, Manhattan-hybrid is workable; FDE roles add customer-site travel.
- Growing segments: applied AI, FDE and deployment services, fintech, security/observability, consultancies. Shrinking: mobile and frontend, entry-level, Meta/Oracle/TikTok openings [D] ([source](https://newsletter.pragmaticengineer.com/p/state-of-the-job-market-2026)).
- Daily AI-tool use is now baseline (51% of developers use them daily; 46% distrust accuracy) [P] ([source](https://survey.stackoverflow.co/2025/ai)). Heavy Claude Code use is expected, not a differentiator. Owning correctness is the differentiator, and the pipeline's human-review gating demonstrates it.

## Actions That Raise Every Track

1. Publish technical writeups of the AI call-enrichment pipeline and the TDS proxy (the two artifacts that most convincingly say "engineer"). Both already exist as portfolio project descriptions; they need public-facing versions.
2. Build an eval harness over the existing call-classification data, and a small RAG/retrieval project. Together they close the two visible gaps for AI Engineer and FDE postings.
3. Run a deliberate coding-interview prep block before the first Senior Backend or Applied AI loop.
4. Fix the LinkedIn headline, About, and experience descriptions (see `linkedin-draft-content.md`), since recruiter search is exact-match on those fields.

## Key Primary Sources

- Indeed Hiring Lab, seniority tilt: https://hiringlab.indeed.com/2026/07/23/the-labor-market-is-tilting-toward-seniority/
- Indeed Hiring Lab, AI and job postings: https://hiringlab.indeed.com/2026/07/08/ai-and-job-postings-from-destruction-to-creation/
- Indeed Hiring Lab, remote tracker dataset: https://github.com/hiring-lab/remote-tracker
- Federal Reserve FEDS note, AI adoption and postings: https://www.federalreserve.gov/econres/notes/feds-notes/ai-adoption-and-firms-job-posting-behavior-20260327.html
- Dallas Fed, AI exposure and postings: https://www.dallasfed.org/research/economics/2026/0901
- Lightcast AI skills report: https://lightcast.io/resources/blog/beyond-the-buzz-press-release-2025-07-23
- Levels.fyi AI Engineer NYC: https://www.levels.fyi/en-gb/t/software-engineer/title/ai-engineer/locations/new-york-usa
- Levels.fyi Senior SWE NYC: https://www.levels.fyi/t/software-engineer/levels/senior/locations/new-york-city-area
- Anthropic NYC postings with pay bands: https://www.builtinnyc.com/job/applied-ai-engineer-startups/8235236 and https://www.builtinnyc.com/job/applied-ai-solutions-architect/3711122
- AWS FDE org: https://www.aboutamazon.com/news/aws/aws-1-billion-forward-deployed-ai-engineers
- Microsoft Frontier Company: https://www.cnbc.com/2026/07/02/microsoft-commits-2point5-billion-6000-employees-ai-implementation-unit.html
- Pragmatic Engineer, 2026 job market: https://newsletter.pragmaticengineer.com/p/state-of-the-job-market-2026
- Pragmatic Engineer, FDE Pulse: https://blog.pragmaticengineer.com/the-pulse-forward-deployed-engineering-heats-up-again/
- Wellfound NYC hiring data: https://wellfound.com/hiring-data/l/new-york
