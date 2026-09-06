# Marek Schir

New York City Metropolitan Area | [fill: email] | [fill: phone] | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Senior Software Engineer | Python, Django, TypeScript, Vue/Nuxt, PostgreSQL**

Full-stack engineer with 13 years designing, building, and operating the internal platforms, customer portals, and integrations a 100-person company runs on. Progressed from Software Developer to Director of IT while remaining the only hands-on engineer; recent work includes a production LLM pipeline that turns phone calls into CRM records and a transparent SQL Server proxy that decodes the TDS wire protocol.

## Skills

**Languages:** Python, TypeScript, JavaScript, SQL, PHP, C#

**Backend and data:** Django, Django REST Framework (DRF), Flask, PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, Django Q, asyncio, REST APIs, webhooks, Selenium

**Frontend:** Vue, Nuxt, Pinia, HTMX, Tailwind CSS, PrimeVue, Vuetify, Bootstrap, Zod, Chart.js, Vitest

**LLM integration:** Anthropic Claude API, OpenAI API, Pydantic AI, tool calling, structured outputs, faster-whisper, Claude Code

**Infrastructure and tooling:** Docker, Linux, Nginx, Gunicorn, Supabase, Amazon Web Services (AWS), DigitalOcean, GitHub

## Experience

**M&M Environmental**, Queens, NY | May 2012 – Present

Pest control and environmental services company that grew from 30 to 100+ employees. Progressed from part-time Software Developer to Director of IT while remaining the only engineer for all internal software.

**Director of IT (Lead Software Engineer)** | May 2021 – Present

- Extended MM Portal, the Django/HTMX/MySQL platform used daily by 50+ staff in scheduling, sales, accounting, and customer service, with a live MSSQL link to the legacy field-service system, HubSpot webhook sync, and GPS alerting for field vehicles
- Shipped a production LLM pipeline (Django Q, faster-whisper, Pydantic AI, Claude) that transcribes every inbound 3CX call, classifies it with a five-tool agent, and writes 45 structured properties plus contacts, deals, and tickets to HubSpot; results under a confidence threshold route to human review
- Instrumented every enrichment run with token counts, model, and prompt version; versioned prompts in YAML frontmatter and built a re-enrichment command so review and escalation rates can be compared across prompt versions
- Reverse-engineered SQL Server's TDS wire protocol to build a transparent TCP/UDP proxy (Python asyncio, Docker, ipvlan) that rewrites queries in flight, keeping a vendor-abandoned system in production since 2024 with no client changes
- Built the Django backend and API for a customer-facing quoting portal (Nuxt frontend built by two teammates): strategy-pattern pricing, magic-link draft resume, pdfkit proposals signed with pyHanko, HubSpot ticket creation, Docker/Nginx/Gunicorn deployment; property managers now get a signed proposal with no sales-rep involvement
- Built a Django platform for Green Orchard Group's $5M NYCHA lead-inspection contract that parses XRF instrument CSVs with per-firmware parsers, validates readings against NYCHA rules, and generates 20-30 page PDF and Excel compliance packages, cutting report generation from about 3 hours to under 3 minutes per inspection
- Ran network, Active Directory, Windows and Linux servers, backups, and vendor contracts; trained staff and wrote SOPs for every rollout

**IT Manager** | 2019 – 2021

- Added a TomTom and Google Maps routing tool to MM Portal that maps technician locations, scores route efficiency, and shows coverage gaps for the scheduling team
- Wrote a Selenium scraper that logs into ServiceBridge, a vendor field app with no API, to pull work orders and service-agreement PDFs into MM Portal
- Built Flask REST APIs over MSSQL for field service operations and a Django/PostgreSQL job tracker for visual lead inspections on DigitalOcean

**Programming Analyst (Full-Stack Developer)** | 2015 – 2019

- Designed and built MM Portal from scratch (Django, Bootstrap, MySQL) with a live MSSQL connection to ServiceCEO, a 2007-era desktop system with 3-5 minute page loads that no longer issued user licenses; role-gated job, customer, invoice, and service dashboards gave every department fast web access to the same data
- Worked directly with owners and department heads to turn workflow pain points into features; trained staff and wrote SOPs for each rollout

**Software Developer (part-time)** | May 2012 – 2015

- Built internal reporting and user-lookup tools on SQL Server while completing a degree in Computer Engineering

## Projects

**Arcus** | Nuxt, Vue, TypeScript, Pinia, Supabase | 2025 | getarcus.com | github.com/schir2/arcus

- Project and task management app with real-time multi-user editing: Supabase Realtime streams Postgres changes into a layered store/action architecture; Vue Flow renders task dependency graphs

**Calcura** | Nuxt, TypeScript, Chart.js, Django REST Framework | 2024 | calcura.org | github.com/schir2/calcura

- Retirement simulator that projects 401(k), IRA, Roth, brokerage, debt, and income year by year through a user-reorderable command sequence; Vitest coverage across every account manager

## Education

**Bachelor's, Computer Engineering** [fill: confirm exact degree name], New York City College of Technology (City Tech), CUNY

Cisco CCNA and Cisco Certified Specialist, Enterprise Advanced Infrastructure Implementation (both expired)
