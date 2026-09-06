# LinkedIn Draft Content

Draft copy for the gaps identified in `linkedin-profile-audit.md`. This is a starting point to edit, not a final version — review for accuracy before pasting anything into LinkedIn.

**How this was built:** experience bullets are grounded in the real project write-ups already on the portfolio site (`supabase/seeds/03_projects.sql`), matched to your 4 job titles by the years each project's description mentions. That mapping is my inference, not something you told me directly — check that each bullet actually landed under the right title before publishing. Some early MMPC work (e.g. a 2009 reporting tool) predates the earliest listed title (Software Developer, 2012) and isn't included below for that reason; mention it yourself if it belongs somewhere.

---

## Headline options

Pick one, or mix pieces. LinkedIn allows up to 220 characters.

1. **IT Director | Full-Stack Developer (Python/Django, Vue/Nuxt) | AI & Agent Engineering | Network Infrastructure (CCNA/CCNP)**
2. **IT Director building the systems a 100+ person company runs on — Django/Python backend, Vue/Nuxt frontend, AI-driven HubSpot automation, and the network/infra underneath it all**
3. **Software Engineer & IT Director — Python/Django, Vue/Nuxt, LLM-powered automation (Claude, HubSpot), and the infrastructure that keeps it running**

Option 1 is the safest, most keyword-dense choice for recruiter search. Option 2 reads more like a real sentence and signals scope/ownership, at the cost of some keyword density.

---

## About section (draft)

> I'm the IT Director at M&M Environmental, where I've spent over a decade building the software that runs the company and the infrastructure it runs on.
>
> What started as writing internal reporting tools grew into MM Portal, a Django platform I built and still maintain that gives 50+ employees fast web access to a 2007-era field service system that would otherwise take minutes to load a single page. Over the years it's grown to include GPS-based technician routing, a web scraper that pulls data out of a third-party system with no API, and — most recently — an AI pipeline that transcribes every incoming call, extracts service requests and sales opportunities using a Claude-backed agent, and writes them straight into HubSpot so nothing falls through the cracks.
>
> I work across the stack: Python/Django and TypeScript/Vue/Nuxt on the software side, MSSQL/MySQL/PostgreSQL on the data side, and networking, Active Directory, and Windows/Linux server administration on the infrastructure side (CCNA and CCNP-track certified). More recently that's expanded into AI and agent engineering — integrating LLM APIs (OpenAI, Anthropic/Claude), building tool-calling agents, and designing pipelines that turn unstructured data (calls, notes, PDFs) into structured, actionable records.
>
> I also build outside of work: [Arcus](https://getarcus.com), a real-time project management app, and [Calcura](https://calcura.org), a retirement planning simulator — both live, both open-source. My full portfolio, with detailed write-ups of the architecture and decisions behind each project, is at [mschir.dev](https://mschir.dev).
>
> Open to conversations about software engineering, IT leadership, or AI/agent engineering roles.

Trim the last line if you don't want the open-to-work signal this visible in the About section (it's already set separately in your "Open to Work" preferences).

---

## Experience bullets (draft)

### Director of IT — M&M Environmental (May 2021 - Present)

- Lead IT strategy and infrastructure for a company that grew from ~30 to 100+ employees, spanning network administration, Active Directory, Windows/Linux server management, and backups
- Designed and built an AI-driven call enrichment pipeline: every inbound call is transcribed (faster-whisper) and analyzed by a Claude-backed agent that classifies service requests and sales opportunities, then writes structured records into HubSpot across 45 custom properties — closing gaps where follow-ups previously fell through
- Extended a customer quoting portal (Django/Nuxt) that replaced manual sales-rep pricing with a real-time, rules-driven intake flow producing signed PDF proposals
- Reverse-engineered the SQL Server TDS wire protocol to build a transparent proxy, keeping a vendor-abandoned production system running without a forced migration
- Own the technical decision-making for all internal platforms, balancing new development against 15+ years of legacy system dependencies

### IT Manager — M&M Environmental (2019 - 2022)

- Built a GPS-based alerting and routing system (TomTom-powered) for field technicians, scoring route efficiency and visualizing coverage gaps
- Built internal APIs supporting field service operations, integrating with the company's legacy field service management system
- Extended MM Portal with a web scraper that recovers work orders and service agreement PDFs from a third-party mobile field app with no public API
- Managed the transition of scheduling, sales, and customer service workflows off a decade-old desktop application onto fast, role-gated web tools

### Programming Analyst — M&M Environmental (2015 - 2019)

- Designed and built the original version of MM Portal, a Django platform giving non-technical staff fast web access to data locked inside a legacy 2005-era SQL Server system
- Built role-gated dashboards for jobs, customers, invoices, and service records, replacing a multi-minute-per-page legacy desktop UI
- Worked directly with scheduling, sales, and accounting teams to translate day-to-day workflow pain points into features

### Software Developer — M&M Environmental (May 2012 - 2015, Part-Time)

- Wrote early internal reporting and data lookup tools while completing my degree, laying the groundwork for what became MM Portal
- Gained hands-on experience with SQL Server and legacy field-service system data structures that later informed larger platform decisions

---

## Featured section (suggested links)

Add these under a new "Featured" section on your profile:

1. **mschir.dev** — your portfolio homepage, as the umbrella link
2. **MM Portal project write-up** (if you make a public-facing summary version — the full write-up references an internal/private repo, so consider a lighter public version)
3. **getarcus.com** — Arcus, live and public
4. **calcura.org** — Calcura, live and public

Public, live projects with real URLs (Arcus, Calcura) are the strongest Featured candidates since anyone can click through immediately — prioritize those over write-ups of internal/private systems.

---

## Skills to add (pull from `docs/research/resume-skills.md`)

At minimum, add these to close the gap the audit identified — none of them currently appear on your LinkedIn Skills page:

- Networking, Active Directory (you hold CCNA/CCNP-track certs but list zero networking skills currently)
- HubSpot, Stripe, Zapier, n8n (Integrations)
- Claude, OpenAI, Prompt Engineering, Pydantic AI (AI & Agent Engineering)
- Docker, AWS (Tools & Platforms — Docker already shows up in your project work but isn't a listed skill)

---

## Open questions for you to resolve before publishing

- Confirm the role-by-role project mapping above is actually accurate — I inferred it from project years, not from you directly.
- Decide whether to keep the "Open to conversations about..." line in the About section, given "Open to Work" is already set separately.
- Resolve the CCNP naming inconsistency (flagged in the audit) before or alongside this — it affects both the headline and the About section, both of which now reference CCNP.
