# Marek Schir

New York City Metropolitan Area | [fill: email] | [fill: phone] | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Software Engineer, AI Integration | LLM pipelines (Claude, Pydantic AI), systems integration (HubSpot, 3CX, Stripe, legacy MSSQL), Python/Django**

AI integration engineer with 13 years wiring software into the systems a 100-person field-service company actually runs on, most recently a production LLM pipeline that turns phone calls into structured CRM records with per-run cost tracking, versioned prompts, and human-in-the-loop review. Integrates with anything, from HubSpot webhooks and a 3CX phone system to no-API vendor apps and a 2007-era SQL Server reached through a hand-built wire-protocol proxy; gathers requirements from owners, ships, and trains the staff who use it.

## Skills

**LLM and agents:** Anthropic Claude API (Sonnet 4.6), OpenAI API, Pydantic AI, tool calling, structured outputs (Pydantic), prompt versioning, confidence-threshold gating with human review, token and cost tracking, prompt tuning for smaller models, faster-whisper transcription, Claude Code

**Integrations and APIs:** REST, webhooks (dedup, idempotency, retries), HubSpot (webhooks, custom properties, workflows), 3CX, Stripe, TSheets, FieldWorks, Google Chat, Gmail, TomTom, Dograh voice agents, Zapier, n8n, Python cron automation, Selenium

**Languages and backend:** Python, Django, Django REST Framework (DRF), Flask, Django Q, asyncio, TypeScript, Vue, Nuxt, HTMX

**Data:** PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, schema design and migrations, TDS protocol

**Infrastructure:** Docker, Linux, Nginx, Gunicorn, DigitalOcean, Amazon Web Services (AWS), Supabase, networking (Cisco CCNA), Active Directory

## Experience

**M&M Environmental**, Queens, NY | May 2012 – Present

Pest control and environmental services company that grew from 30 to 100+ employees. Progressed from part-time Software Developer to Director of IT while remaining the only engineer for all internal software, integrations, and infrastructure.

**Director of IT (Lead Software Engineer)** | May 2021 – Present

*AI and integration work*

- Designed and shipped a production LLM pipeline (Django Q, faster-whisper, Pydantic AI, Claude) that transcribes every inbound 3CX call, classifies it with a tool-calling agent, and writes 45 structured properties plus contacts, deals, and tickets to HubSpot, where workflows route each item to the right team; results under a confidence threshold go to human review instead of auto-filing
- Gave the agent five Django-backed tools (contact search, deal lookup, owner resolution, HubSpot enum lookup, fill-if-blank contact write) and validated every output against a Pydantic schema before any CRM write
- Built the LLMOps layer: per-run token, model, and prompt-version records; prompts versioned in YAML frontmatter; a re-enrichment command that reprocesses older calls under a new version so review and escalation rates can be compared across prompts; one query answers "total LLM spend this month"
- Made the pipeline idempotent and self-healing: webhook events deduplicated by number, start time, and agent; a HubSpot property as the idempotency sentinel; bounded retries ending in a dead state; low-quality transcripts re-transcribed once, then flagged as untranscribable in HubSpot so operators know to listen to the recording
- Tuned prompts and model selection so smaller, cheaper models held output quality [fill: cost per call before/after, or % saved]; ran the same extraction over ServiceCEO job and invoice notes [fill: calls or notes processed per month]
- Built data enrichment pipelines against OpenAI, Claude, and transcription APIs, and implemented tools and API endpoints for a Dograh voice/call agent [fill: what the agent handles and its volume]
- Integrated HubSpot (webhooks, custom properties, workflows), 3CX, Stripe, TSheets, FieldWorks, Google Chat, Gmail, and TomTom into internal systems; automated back-office workflows with n8n, Zapier, and Python cron jobs [fill: workflow count or staff hours saved per week]
- Reverse-engineered SQL Server's TDS wire protocol to build a transparent TCP/UDP proxy (Python asyncio, Docker, ipvlan) that rewrites queries in flight, keeping a vendor-abandoned field-service system in production since 2024 with no client changes

*Platform, delivery, and infrastructure*

- Built the Django backend and API for a customer-facing quoting portal (Nuxt frontend built by two teammates): server-side pricing rules, magic-link draft resume, pdfkit proposals signed with pyHanko, HubSpot contact and ticket creation on submit; property managers now get a signed proposal with no sales-rep involvement
- Built a Django platform for Green Orchard Group's $5M NYCHA lead-inspection contract: XRF instrument CSV parsing with per-firmware parsers, validation against NYCHA component rules, 20-30 page PDF and Excel compliance packages; report generation fell from about 3 hours to under 3 minutes per inspection
- Gathered requirements from owners and department heads, prototyped in Figma and InVision, diagrammed workflows in draw.io and Mermaid, ran rollouts, trained staff, and wrote SOPs; every internal tool went from request to daily use without a product manager
- Ran network, Active Directory, Windows and Linux servers, backups, and vendor contracts for a company that grew from 30 to 100+ employees

**IT Manager** | 2019 – 2021

- Added a TomTom and Google Maps routing tool to MM Portal that maps technician locations, scores route efficiency, and shows coverage gaps for the scheduling team
- Wrote a Selenium scraper that logs into ServiceBridge, a vendor field app with no API, to pull work orders and service-agreement PDFs into MM Portal
- Built Flask REST APIs over MSSQL for field service operations and a Django/PostgreSQL job tracker for visual lead inspections

**Programming Analyst (Full-Stack Developer)** | 2015 – 2019

- Designed and built MM Portal from scratch (Django, Bootstrap, MySQL) with a live MSSQL connection to ServiceCEO, a 2007-era desktop system with 3-5 minute page loads; role-gated dashboards gave scheduling, sales, accounting, and customer service fast web access to the same data, now used daily by 50+ staff

**Software Developer (part-time)** | May 2012 – 2015

- Built internal reporting and user-lookup tools on SQL Server while completing a degree in Computer Engineering

## Projects

**Arcus** | Nuxt, Vue, TypeScript, Pinia, Supabase | 2025 | getarcus.com | github.com/schir2/arcus

- Project and task management app with real-time multi-user editing: Supabase Realtime streams Postgres changes into a layered store/action architecture; Vue Flow renders task dependency graphs

**Calcura** | Nuxt, TypeScript, Chart.js, Django REST Framework | 2024 | calcura.org | github.com/schir2/calcura

- Retirement simulator that projects 401(k), IRA, Roth, brokerage, debt, and income year by year through a user-reorderable command sequence; Vitest coverage across every account manager

## Education and Certifications

**Bachelor's, Computer Engineering** [fill: confirm exact degree name], New York City College of Technology (City Tech), CUNY

Cisco CCNA and Cisco Certified Specialist, Enterprise Advanced Infrastructure Implementation (both expired)

Coursera: Machine Learning; Mathematics for Machine Learning specialization; Python for Data Science and AI
