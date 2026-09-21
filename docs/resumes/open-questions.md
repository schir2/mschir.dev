# Open Questions

Everything still needed from you before the resumes in this folder and the LinkedIn drafts in `../research/` are safe to send. Answers get recorded here as they come in; the resumes get updated from this file.

Status key: `OPEN` needs an answer; `ANSWERED` recorded below; `RESOLVED` applied to the resumes.

## A. Accuracy-Critical

These can get a resume rejected or a background check flagged. Nothing ships until every one is closed.

| # | Question | Where it matters | Status |
|---|---|---|---|
| A1 | The resumes say "only engineer for all internal software." The quoting-portal write-up says two other developers built the Nuxt frontend. Who were they (employees, contractors, agency), and were they your reports? Either the claim changes or the bullet explains it. | Every resume, company progression line; also decides whether Engineering Manager roles are honest to pursue | ANSWERED: employees who reported to him. "Only engineer" comes out; management bullet goes in. Team size and dates in A1b. |
| A1b | How many engineers reported to you in total, over what period, and are any still on the team? Did you hire them? | Management bullet wording; Engineering Manager track in target-roles.md | ANSWERED: software engineer / Android developer 2021-present; UI/UX designer in 2023; front-end engineer 2025-present. Team of two today, three at peak. Bullet: "Hired and led a team of up to three (software/Android engineer, front-end engineer, UI/UX designer) since 2021 while remaining the primary backend engineer." Follow-up B12: what does the Android developer build? |
| A2 | IT Manager end date. LinkedIn says 2019-2022, overlapping Director of IT from May 2021. Resumes use 2019-2021. Which is right? | All resumes, LinkedIn draft | ANSWERED: 2019 to May 2021, then Director. Resumes stay as written; LinkedIn IT Manager end date changes to May 2021. |
| A3 | Exact degree as printed on the diploma (B.S. vs B.Tech; Computer Engineering vs Computer Engineering Technology) and graduation year. | Education section | ANSWERED: B.Tech, Computer Engineering Technology. Year omitted on purpose (standard for experienced candidates). |
| A4 | NYCHA platform attribution. Seed data credits Green Orchard Group's $5M contract; the repo lives under the MMPC GitHub org. What is the relationship, and how do you describe it in an interview? | Director of IT bullet, backend "Selected Projects" | ANSWERED: sister company under the same owners. Bullet wording: "for an affiliated environmental contractor's $5M NYCHA contract." Stays under M&M. |
| A5 | Title clarifiers: "Director of IT (Lead Software Engineer)" and "Programming Analyst (Full-Stack Developer)." Would your employer confirm that scope without hesitating? | Every resume, LinkedIn headline plan | ANSWERED: yes, both. Keep as written. |
| A6 | CCNP. "CCNP Certified" is a self-added LinkedIn skill, but Licenses lists only the Cisco Specialist cert (CCNP Enterprise track). Was a full CCNP earned? | Certifications line, LinkedIn skills | ANSWERED: full CCNP earned. CCNA Security also earned (confirmed 2026-09-09). Certifications line is "Cisco CCNA, CCNA Security, and CCNP (all expired)"; add CCNP and CCNA Security under LinkedIn Licenses. FastAPI and GraphQL were added to the full-stack skills block at the user's request on 2026-09-09. |
| A7 | Company name on the resume: "M&M Environmental" (LinkedIn), "MMPC," or "M&M Pest Control"? And the 30 to 100+ employee growth: over what years? | Company header | ANSWERED: "M&M Environmental (M&M Pest Control / MMPC)" once in the company header. Growth span not stated; resumes say "grew from 30 to 100+ employees" without years, which matches the MM Portal write-up. |
| A8 | Software Developer, part-time, May 2012-2015: what did you actually build? The only seed project from that era is a 2009 reporting tool, which predates the role. Did work start before 2012? | Oldest experience entry | CORRECTED: the first answer confirmed an inferred bullet, which the user then flagged as made up. Real answer, in the user's words: mostly scripting; a Yelp scraper that pulled data and sent alerts; PHP pages; website maintenance; SQL report scripts. Bullet rewritten from that. The "while completing a degree" clause was also inferred and is gone. Lesson for the log: do not offer an inferred bullet as the recommended option; ask open-ended for early roles. |
| A9 | Which model runs the call pipeline today (seed diagram says claude-sonnet-4-6), and where do OpenAI and non-Whisper transcription services fit? The AI resume names "Claude Sonnet 4.6" and "OpenAI API." | AI resume skills and bullets | ANSWERED: Claude Sonnet 4.6 for enrichment, faster-whisper for transcription, OpenAI used elsewhere. Where OpenAI runs still unstated; captured under B2/B3. |

## B. Numbers That Strengthen Bullets

**Decision: no numbers.** The user does not plan to supply volumes, costs, rates, or hours saved. Every numeric `[fill: ...]` placeholder gets removed and the bullet describes scope qualitatively. Only the wording questions in this section (B3, B6, B10, B12) remain open.

Trade-off, recorded so it is a choice and not an oversight: the resume-format research ranks quantified results as the single biggest bullet-quality lever, and AI-role screeners specifically flag "no numbers" as a red flag. The existing concrete figures that came from the project write-ups stay (50+ daily users, 45 HubSpot properties, five agent tools, 3 hours to 3 minutes, $5M contract, 30 to 100+ employees, in production since 2024).

| # | Question | Bullet it feeds | Status |
|---|---|---|---|
| B1 | Calls per month through the 3CX pipeline, and the share flagged for human review. | AI pipeline bullets (all three resumes) | ANSWERED: skip; describe qualitatively. Placeholder removed. |
| B2 | Cost per call, or monthly LLM spend, before and after prompt tuning and the model change. | "Tuned prompts and model selection" bullet | DECLINED on numbers. Bullet keeps "so smaller, cheaper models held output quality" without a figure. |
| B3 | Dograh: what the voice agent handles and which tools and endpoints you built for it. | Dograh bullet (AI resume) | ANSWERED: inbound call handling for the company; tools read and write company systems during the call. Bullet: "Built the tools and API endpoints behind a Dograh voice agent that handles inbound calls, reading and writing company systems mid-call." |
| B4 | n8n, Zapier, and cron automations: counts and hours saved. | Automation bullet (AI resume) | DECLINED; placeholder removed |
| B5 | Quoting portal: quotes per month. | Quoting portal bullet | DECLINED; "no sales-rep involvement" wording stands |
| B6 | Stripe, TSheets, FieldWorks, Google Chat, Gmail: what each integration does. | Integrations bullet | ANSWERED: keep as a name list, no per-system detail. |
| B7 | MM Portal: further usage or uptime numbers. | MM Portal bullets | ANSWERED 2026-09-09: routine tasks went from 10-15 minutes to under 1 minute. Also added: analyzed the ServiceCEO database ("decrypted" was replaced with "analyzed" at the user's request the same day), rebuilt stored procedures into views and leaner procedures, and added a caching layer. Applied to all three resumes, the LinkedIn draft, and the MM Portal write-up in `03_projects.sql`. "50+ daily users" stays. The old "3-5 minute page loads" framing is gone from the resumes. |
| B8 | TDS proxy client count and incidents. | TDS proxy bullet | DECLINED; "in production since 2024" stands |
| B9 | Enrichment beyond calls: volume. | Enrichment bullet | DECLINED; placeholder removed |
| B10 | Claude Projects: set up for whom and for what. This is also a training and enablement story. | AI-Assisted Development section, possibly a bullet | ANSWERED: both. New Director of IT bullet: "Rolled out Claude Projects to staff with company SOPs and context loaded, and trained teams to use them." Personal-workflow line stays in AI-Assisted Development. |
| B11 | Training and SOPs: counts. | Delivery bullet | DECLINED; existing wording stands |
| B12 | The Android developer on your team: what did they build, and did you architect or review it? | Possible new bullet under Director of IT | DROPPED: not necessary per user. The management line covers them. |

## C. Preferences

These change which resume gets polished first and how the header reads.

| # | Question | Status |
|---|---|---|
| C1 | Which track first: Forward Deployed Engineer, Applied AI Engineer, Solutions/Integrations Engineer at field-service SaaS, or Senior Backend? | ANSWERED: all three in parallel; route by posting. |
| C2 | Work mode and travel: on-site, hybrid, remote; willing to travel for FDE customer work? | ANSWERED: hybrid NYC, some travel OK. FDE roles stay in play. |
| C3 | Header location: "New York City Metropolitan Area" or "New City, NY"? | DEFAULTED: "New York City Metropolitan Area." |
| C4 | Contact line: email and phone to print, or keep placeholders until export. | ANSWERED: Marek Schir, (718) 909-3737, schir2@gmail.com, linkedin.com/in/marek-schir-95229684, github.com/schir2, mschir.dev. Applied to all three headers. |
| C5 | LinkedIn: will you claim a vanity URL and change the headline and titles to match the resumes before applying? | USER ACTION: pending. Listed in README "Before Sending." |
| C6 | Timeline: when do applications start? Decides whether the RAG project and eval harness (see README gaps) happen first. | ANSWERED: as soon as the resumes are final. Gap list is optional. |
| C7 | Compensation floor and target, so the target-roles doc can be filtered. | SKIPPED: user is not supplying numbers. |

## Answers Log

Recorded in the order answered. All answers above were applied to the three resumes, `README.md`, `../research/target-roles.md`, and `../research/linkedin-draft-content.md` on 2026-09-08.

**Embellishment sweep (after the 2012-2015 bullet was flagged as made up):** removed "vendor contracts," "hired," "without a product manager," "loaded with company SOPs and context," the Dograh "mid-call" phrasing, and two invented LinkedIn bullets ("Own the technical decision-making..." and "Managed the transition..."). Everything left traces to a project write-up in `03_projects.sql` or to the user's own words in this file. Two placements are still inferred from project years, not confirmed: the 2021 Flask API and lead-inspection tracker sit under IT Manager (ended May 2021), and the Programming Analyst SOP/training clause assumes that practice started then.

**Google Doc tabs, 2026-09-09:** the Google Doc now has three tabs: Full Stack (the user's final version, headline "Full-Stack Software Engineer"), Enterprise Engineer (headline "Enterprise Software Engineer | Internal tools, systems integration, Python/Django, Vue/Nuxt"; summary names the sales, scheduling, and accounting teams; an Integrations skills line; the stakeholder bullet leads, followed by a new rollouts/training/SOPs bullet), and LLM Integration Engineer (headline "LLM Integration Engineer | Claude and OpenAI APIs, Pydantic AI, tool calling, Python/Django"; summary names Claude, human review, and the Dograh voice agent; LLM skills line expanded and moved first; pipeline bullet leads and names Claude; new bullets for the Django Q queue, prompt versioning and cost tracking, and the Dograh agent; vehicle-tracking bullet and PHP dropped). Prompted by a second screener pass that ranked Enterprise Engineering first, Applied AI second, and Backend third. The repo markdown resumes were not restructured to match the tabs.

**Screener pass, 2026-09-09:** the user ran the full-stack doc through a Meta-style screener and accepted these changes after a grill: keep the official title first (A5 stands) but restore the headline line and lead the summary with "engineer"; reorder so the TDS proxy leads and the Partnered bullet moves near the end; add a testing bullet (pytest for framework-free code, Django's test runner with fixtures for the rest; CI pipelines deploy the NYCHA platform and Arcus; Vitest on Arcus and Calcura); expand the team bullet (up to three engineers since 2021 including an intern, two today, pull-request review and feature-branch merges, the Nuxt quoting-portal frontend as the outcome; the designer is no longer mentioned, which supersedes the A1b wording); cut Coursera from the full-stack resume only and change the Cisco line to "(expired)"; summary says 14 years (May 2012 to now); drop GraphQL, Claude Code, and Call Agents (Dograh) from the full-stack skills; no React, none exists; graduation year stays off. New 2015-2016 project: a real-time PHP, jQuery, and Bootstrap vehicle-tracking dashboard that plotted the GPS fleet against scheduled jobs and alerted schedulers when a technician was out of range; the seed's "Vehicle GPS Alerting System" entry was dated 2022 and is now 2016 (approximate) with a matching description. Early-work bullet now says "WordPress site".

**Bullet pass, 2026-09-09:** the user asked for fewer "Built" verbs (six in a row), past tense on the first bullet, and a wider pipeline scope: the LLM pipeline reads inbound calls, technician job notes, emails, meeting notes, and Google Chat rooms, and its outputs include job routing, equipment needs, and sales opportunities. Also added an n8n bullet. Layering per the user: n8n on DigitalOcean is the outer integration layer taking webhooks from HubSpot, Stripe, Yelp, and other external platforms; the Django REST Framework API is the internal layer with custom Python for the field-service system, Google Maps, and TomTom, plus caching, credential handling, and security. Applied to the Google Doc and all three resumes.

**3CX integration, mentioned by the user 2026-09-09:** a custom 3CX CRM integration written in 3CX's proprietary XML template format that replaces the stock HubSpot connector and redirects call records to the pipeline's webhook. Small piece of work by the user's account; added as a clause in the AI resume's integrations bullet only. Interview talking point, not a bullet.

**Google Chat app, added by the user 2026-09-09:** a Google Chat application connecting chat to HubSpot and the field-service manager. The user designed the REST API endpoints and the Django/DRF backend for the field-service side, then wired chat commands and interactive dialogs so staff can update HubSpot tickets from chat. Added to all three resumes and the Google Doc. Built in early 2026, so it sits under Director of IT in the dated resumes. Follow-up the same day: the Django REST Framework API is its own system that every integration (ServiceBridge scraping, Django Q enrichment, routing, caching, the chat app) runs through, so it got its own bullet ahead of the chat bullet. The MM Portal write-up in `03_projects.sql` now has a paragraph on the API and the chat app, and Google Chat is in the architecture diagram. The chat app is on the timeline as a 2026 entry.

**Pipeline scope, added by the user 2026-09-08:** beyond enrichment, the call pipeline raises and escalates issues, routes complaints, brings items to people's attention, and produces call analytics on sales wins and losses that drive marketing and sales decisions. Bullets rewritten around that in all three resumes and the LinkedIn draft.

Decisions with the widest effect:

1. **Not the only engineer.** Led a team of up to three since 2021 (software/Android engineer 2021-present, UI/UX designer 2023, front-end engineer 2025-present). Every "only engineer" claim was replaced with "primary hands-on engineer" plus a management bullet. This also moves Engineering Manager and Lead Engineer roles from "avoid" to "viable at small companies" in the target-roles doc.
2. **No numbers.** Recorded in section B with the trade-off.
3. **Full CCNP and CCNA Security earned.** Certifications line is now "Cisco CCNA, CCNA Security, and CCNP (all expired)"; LinkedIn Licenses still needs the CCNP and CCNA Security entries added.
4. **Degree:** B.Tech, Computer Engineering Technology, City Tech (CUNY). Year omitted.
5. **NYCHA platform:** built for a sister company under the same owners; worded as "an affiliated environmental contractor's $5M NYCHA contract."
6. **IT Manager ended May 2021**; LinkedIn needs the end date changed from 2022.
