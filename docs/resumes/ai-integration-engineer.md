# Marek Schir

New York City Metropolitan Area | (718) 909-3737 | schir2@gmail.com | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Software Engineer, AI Integration | LLM pipelines (Claude, Pydantic AI), systems integration (HubSpot, 3CX, Stripe, legacy MSSQL), Python/Django**

Software engineer with 14 years wiring software into the systems a 100-person field-service company actually runs on, most recently a production LLM pipeline that turns phone calls into CRM records. Integrates with anything: HubSpot, a phone system, no-API vendor apps, a 2007-era SQL Server. Gathers requirements from owners, ships, and trains the people who use it.

## Skills

**LLM and agents:** Anthropic Claude API (Sonnet 4.6), OpenAI API, Pydantic AI, tool calling, structured outputs, prompt versioning, human-in-the-loop review, cost tracking, faster-whisper transcription, Claude Code

**Integrations and APIs:** REST, webhooks, HubSpot (webhooks, custom properties, workflows), 3CX, Stripe, TSheets, FieldWorks, Google Chat, Gmail, TomTom, Dograh voice agents, Zapier, n8n, Python automation, Selenium

**Languages and backend:** Python, Django, Django REST Framework (DRF), Flask, Django Q, asyncio, TypeScript, Vue, Nuxt, HTMX

**Data:** PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, schema design and migrations, TDS protocol

**Infrastructure:** Docker, Linux, Nginx, Gunicorn, DigitalOcean, Amazon Web Services (AWS), Supabase, networking (Cisco CCNA/CCNP), Active Directory

## Experience

**M&M Environmental (M&M Pest Control / MMPC)**, Queens, NY | May 2012 – Present

Pest control and environmental services company that grew from 30 to 100+ employees. Primary engineer for all internal software, integrations, and infrastructure throughout; team lead since 2021.

**Director of IT (Lead Software Engineer)** | May 2021 – Present

*AI and integration*

- Built an LLM pipeline (Claude, Pydantic AI, faster-whisper) that reads inbound calls, technician job notes, emails, meeting notes, and Google Chat rooms and acts on what it finds: escalates issues, routes jobs and complaints, flags equipment needs and sales opportunities, and writes the HubSpot records behind them; uncertain results go to a person
- The same pipeline produces call analytics on where sales are won and lost, which the owners use to decide marketing spend
- Ran it unattended on a Django Q task queue: idempotent writes, requeue on failure with bounded retries, and a flag in HubSpot when a recording cannot be transcribed so staff know to listen
- Versioned prompts and tracked cost per run so prompt changes could be measured against review rates and re-run on old calls; tuned prompts so cheaper models held quality
- Built the tools and API endpoints for a Dograh voice agent that handles inbound calls and reads and writes company systems
- Designed the Django REST Framework API behind the internal tooling: custom endpoints over the field-service system, HubSpot (CRM), 3CX (VoIP), Google Maps, and TomTom, with caching, scraping scripts, and the Django Q enrichment pipeline behind them
- Extended the API with a Google Chat app: chat commands and interactive dialogs let staff update HubSpot tickets without leaving chat
- Integrated HubSpot, 3CX, Stripe, TSheets, FieldWorks, Google Chat, Gmail, and TomTom into internal systems, including a custom 3CX CRM integration that replaces the stock HubSpot connector and routes call events to the pipeline's webhook; set up an n8n instance on DigitalOcean as the outer integration layer that takes webhooks from HubSpot, Stripe, Yelp, and other external platforms and hands the work to the Django API
- Reverse-engineered SQL Server's TDS protocol into a transparent proxy that keeps a vendor-abandoned system in production (Python asyncio, Docker)

*Platform and delivery*

- Built the backend for a customer quoting portal: real-time pricing, signed PDF proposals, HubSpot handoff; customers get a proposal without a sales rep
- Built the reporting platform for a $5M NYCHA lead-inspection contract; report generation went from about 3 hours to under 3 minutes
- Gathered requirements from owners and department heads, prototyped in Figma, ran rollouts, trained staff, and wrote SOPs
- Hired and led a team of up to three engineers since 2021 while staying the primary backend engineer; owned code review and merges; rolled out Claude Projects to staff
- Wrote automated tests for the API endpoints, scraping and utility code, and the Google Chat command handlers and dialog builder (pytest for framework-free code, Django's test runner with fixtures for the rest); CI pipelines deploy the NYCHA platform and Arcus
- Ran network, Active Directory, servers, and backups

**IT Manager** | 2019 – May 2021

- Added technician routing to MM Portal (TomTom, Google Maps) so schedulers could see route efficiency and coverage gaps
- Wrote a scraper that pulls work orders and PDFs out of a vendor app with no API
- Built REST APIs over MSSQL for field operations and a Django/PostgreSQL job tracker for lead inspections

**Programming Analyst (Full-Stack Developer)** | 2015 – 2019

- Designed and built MM Portal from scratch (Django, MySQL, live MSSQL): analyzed the legacy field-service database, rebuilt its stored procedures into views, and added a caching layer; routine tasks went from 10-15 minutes to under 1 minute, and 50+ staff still use it daily
- Wrote a real-time vehicle-tracking dashboard (PHP, jQuery, Bootstrap) that plotted the GPS fleet against scheduled jobs and alerted schedulers when a technician was out of range at job time

**Software Developer (part-time)** | May 2012 – 2015

- Wrote scripts and small tools: a Yelp scraper with alerts, PHP pages, SQL report generation, and upkeep of the company WordPress site

## Projects

**Arcus** | Nuxt, TypeScript, Supabase | getarcus.com | github.com/schir2/arcus
Project management app with real-time multi-user editing and a task dependency graph

**Calcura** | Nuxt, TypeScript, Django REST Framework | calcura.org | github.com/schir2/calcura
Retirement simulator that projects 401(k), IRA, brokerage, debt, and income year by year

## Education and Certifications

**B.Tech, Computer Engineering Technology**, New York City College of Technology (City Tech), CUNY

Cisco CCNA, CCNA Security, and CCNP (all expired)

Coursera: Machine Learning; Mathematics for Machine Learning specialization; Python for Data Science and AI
