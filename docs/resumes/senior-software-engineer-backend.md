# Marek Schir

New York City Metropolitan Area | (718) 909-3737 | schir2@gmail.com | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Backend Software Engineer | Python, Django, PostgreSQL, asyncio, systems integration**

Backend engineer with 14 years building the data-heavy systems a 100-person company runs on: a Django platform with 50+ daily users, a hand-built proxy for SQL Server's wire protocol, and a production LLM pipeline. Primary engineer end to end; team lead since 2021.

## Skills

**Core:** Python, Django, Django REST Framework (DRF), Flask, asyncio, Django Q, SQL

**Data:** PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, schema design and migrations, query optimization

**Integration:** REST APIs, webhooks, HubSpot API, 3CX, TomTom, Selenium, TDS protocol, PDF generation and signing

**LLM:** Anthropic Claude API, OpenAI API, Pydantic AI, tool calling, structured outputs, faster-whisper

**Infrastructure:** Docker, Linux, Nginx, Gunicorn, DigitalOcean, Amazon Web Services (AWS), Supabase, GitHub; TypeScript, Vue, and Nuxt for frontends

## Selected Projects

All at M&M Environmental.

**SQL Server Connection Proxy** | Python asyncio, TDS protocol, Docker | 2024 – Present

- Reverse-engineered SQL Server's wire protocol to build a transparent proxy that rewrites queries in flight; clients cannot tell it from a direct connection
- Keeps a vendor-abandoned field-service system in production without a migration

**AI Enrichment Pipeline** | Django Q, faster-whisper, Pydantic AI, Claude, HubSpot | 2025

- Reads inbound calls, technician job notes, emails, meeting notes, and Google Chat rooms and acts on what it finds: escalates issues, routes jobs and complaints, flags equipment needs and sales opportunities, and creates the HubSpot records behind them; uncertain results go to a person
- Produces call analytics on where sales are won and lost, used by the owners to decide marketing spend
- Idempotent with bounded retries; prompts versioned and cost tracked per run so changes can be measured and re-run on old calls

**NYCHA Lead-Inspection Reporting Platform** | Django, pdfkit | 2023

- Parses XRF instrument exports, validates them against NYCHA rules, and generates the PDF and Excel compliance package
- Report generation went from about 3 hours to under 3 minutes on a $5M contract; absorbed monthly rule changes for two years

## Experience

**M&M Environmental (M&M Pest Control / MMPC)**, Queens, NY | May 2012 – Present

Pest control and environmental services company that grew from 30 to 100+ employees. Primary engineer for all internal software throughout; team lead since 2021.

**Director of IT (Lead Software Engineer)** | May 2021 – Present

- Own MM Portal, the Django platform 50+ staff use every day in place of a slow legacy field-service system; added HubSpot sync, GPS alerts, and the AI pipeline above
- Built the backend for a customer quoting portal: real-time pricing, signed PDF proposals, HubSpot handoff
- Designed the Django REST Framework API behind the internal tooling: custom endpoints over the field-service system, HubSpot (CRM), 3CX (VoIP), Google Maps, and TomTom, with caching, scraping scripts, and the Django Q enrichment pipeline behind them
- Extended the API with a Google Chat app: chat commands and interactive dialogs let staff update HubSpot tickets without leaving chat
- Set up an n8n instance on DigitalOcean as the outer integration layer: it takes webhooks from HubSpot, Stripe, Yelp, and other external platforms and hands the work to the Django API
- Hired and led a team of up to three engineers since 2021 while staying the primary backend engineer; owned code review and merges
- Wrote automated tests for the API endpoints, scraping and utility code, and the Google Chat command handlers and dialog builder (pytest for framework-free code, Django's test runner with fixtures for the rest); CI pipelines deploy the NYCHA platform and Arcus
- Ran network, Active Directory, servers, and backups alongside engineering work

**IT Manager** | 2019 – May 2021

- Added technician routing to MM Portal, a scraper for a vendor app with no API, REST APIs over MSSQL, and a Django/PostgreSQL job tracker

**Programming Analyst (Full-Stack Developer)** | 2015 – 2019

- Designed and built MM Portal from scratch: analyzed the legacy field-service database, rebuilt its stored procedures into views, and added a caching layer so routine tasks take under 1 minute instead of 10-15
- Wrote a real-time vehicle-tracking dashboard (PHP, jQuery, Bootstrap) that plotted the GPS fleet against scheduled jobs and alerted schedulers when a technician was out of range at job time

**Software Developer (part-time)** | May 2012 – 2015

- Wrote scripts and small tools: a Yelp scraper with alerts, PHP pages, SQL report generation, and upkeep of the company WordPress site

## Open Source

**Arcus** | Nuxt, Supabase | getarcus.com | github.com/schir2/arcus: real-time multi-user project management

**Calcura** | Nuxt, Django REST Framework | calcura.org | github.com/schir2/calcura: retirement simulator with a command-sequence engine

## Education

**B.Tech, Computer Engineering Technology**, New York City College of Technology (City Tech), CUNY

Cisco CCNA, CCNA Security, and CCNP (all expired)
