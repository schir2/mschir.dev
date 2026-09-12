# Marek Schir

New York City Metropolitan Area | (718) 909-3737 | schir2@gmail.com | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Full-Stack Software Engineer | Python, Django, TypeScript, Vue/Nuxt, PostgreSQL**

Primary engineer and hands-on Director of IT at a 100-person company for 14 years. Recent work: an LLM pipeline that turns calls, technician notes, and chat into HubSpot records; a Google Chat app for updating tickets in place; and an integration layer for FSM, HubSpot, Stripe, and VoIP.

## Skills

**Languages:** Python, TypeScript, JavaScript, SQL, C#, PHP

**Backend:** Django, Django REST Framework (DRF), Flask, FastAPI, Django Q, asyncio, REST APIs, webhooks

**Data:** PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, schema design and migrations

**Frontend:** Vue, Nuxt, Pinia, HTMX, Tailwind CSS, Bootstrap, Zod, Chart.js

**LLM integration:** Anthropic Claude API, OpenAI API, Pydantic AI, tool calling, structured outputs, faster-whisper

**Infrastructure and tooling:** Docker, Linux, Nginx, Gunicorn, Supabase, Amazon Web Services (AWS), DigitalOcean, GitHub

## Experience

**M&M Environmental (M&M Pest Control / MMPC)**, Queens, NY | May 2012 – Present

Director of IT (Lead Software Engineer), 2021 – present · IT Manager, 2019 – 2021 · Programming Analyst, 2015 – 2019 · Software Developer (part-time), 2012 – 2015

Pest control and environmental services company that grew from 30 to 100+ employees. Primary engineer for all internal software throughout; hired and led a team of up to three engineers since 2021.

- Reverse-engineered SQL Server's TDS wire protocol into a transparent proxy that keeps a vendor-abandoned system in production since 2024 (Python asyncio, Docker)
- Created MM Portal, the internal Django platform 50+ staff use daily; analyzed the legacy field-service database, rebuilt its stored procedures into views, and added a caching layer, cutting routine tasks from 10-15 minutes to under 1 minute
- Designed the Django REST Framework API behind the internal tooling: custom endpoints over the field-service system, HubSpot (CRM), 3CX (VoIP), Google Maps, and TomTom, with caching, scraping scripts, and the Django Q enrichment pipeline behind them
- Shipped an LLM pipeline (Claude, Pydantic AI, faster-whisper) that reads inbound calls, technician job notes, emails, meeting notes, and Google Chat rooms and acts on what it finds: escalates issues, routes jobs and complaints, flags equipment needs and sales opportunities, and writes the HubSpot records behind them; the same data gives the owners call analytics on where sales are won and lost
- Ran the pipeline on a Django Q task queue with requeue on failure; versioned prompts and tracked cost per run so prompt changes could be measured against review rates and re-run on old calls
- Extended the API with a Google Chat app: chat commands and interactive dialogs let staff update HubSpot tickets without leaving chat
- Delivered the backend and visual design for a customer quoting portal (Django API, Nuxt frontend by my team): real-time pricing, signed PDF proposals, HubSpot handoff; customers get a proposal without a sales rep
- Developed the reporting platform for an affiliated contractor's $5M NYCHA lead-inspection contract: parses instrument exports, validates against NYCHA rules, generates the PDF and Excel compliance package; report generation went from about 3 hours to under 3 minutes
- Added an interactive Google Maps tool that shows technician routes and coverage gaps, with a cached route-calculation layer that keeps API costs down, and a scraper that pulls work orders and PDFs out of a vendor app with no API
- Wrote automated tests for the API endpoints, scraping and utility code, and the Google Chat command handlers and dialog builder (pytest for framework-free code, Django's test runner with fixtures for the rest); CI pipelines deploy the NYCHA platform and Arcus
- Partnered with the owners and department directors: interviewed staff to find their pain points, documented and diagrammed processes, then replaced them with workflows and software
- Hired and led a team of up to three engineers since 2021 while staying the primary backend engineer; owned code review and merges; the team shipped the Nuxt quoting-portal frontend
- Ran network, Active Directory, Windows and Linux servers, and backups; rolled out Claude Projects loaded with company SOPs and context, and trained staff on every platform rollout
- Wrote a real-time vehicle-tracking dashboard (PHP, jQuery, Bootstrap) that plotted the GPS fleet against scheduled jobs and alerted schedulers when a technician was out of range at job time
## Projects

**Arcus** | Nuxt, TypeScript, Supabase, Vitest | 2025 | getarcus.com | github.com/schir2/arcus
Project management app with real-time multi-user editing: streams Supabase Realtime changes into a layered store/action architecture; Vue Flow renders task dependency graphs

**Calcura** | Nuxt, TypeScript, Django REST Framework, Vitest | 2024 | calcura.org | github.com/schir2/calcura
Retirement simulator that projects 401(k), IRA, Roth, brokerage, debt, and income year by year through user-reorderable command sequences

## Education

**Bachelor of Technology (B.Tech), Computer Engineering Technology**, New York City College of Technology (CUNY)
