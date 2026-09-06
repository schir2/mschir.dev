# Marek Schir

New York City Metropolitan Area | [fill: email] | [fill: phone] | linkedin.com/in/marek-schir-95229684 | github.com/schir2 | mschir.dev

**Senior Software Engineer (Backend) | Python, Django, PostgreSQL, asyncio, systems integration**

Backend engineer with 13 years building and operating the data-heavy systems a 100-person company runs on: a Django platform with 50+ daily users across three database engines, a hand-built proxy for SQL Server's wire protocol, a compliance reporting engine with a 60x speedup, and a production LLM pipeline with cost tracking and human-in-the-loop review. Only engineer on all of it, from schema to deploy.

## Skills

**Core:** Python, Django, Django REST Framework (DRF), Flask, asyncio, ThreadPoolExecutor, Django Q, SQL

**Data:** PostgreSQL, MySQL, Microsoft SQL Server (MSSQL), SQLite, schema design and migrations, query optimization, instrument and CSV data parsing

**Integration:** REST APIs, webhooks, HubSpot API, 3CX, TomTom, Selenium, TDS protocol, pdfkit/wkhtmltopdf, pyHanko, Win32COM

**LLM:** Anthropic Claude API, OpenAI API, Pydantic AI, tool calling, structured outputs, faster-whisper

**Infrastructure:** Docker, Linux, Nginx, Gunicorn, DigitalOcean, Amazon Web Services (AWS), Supabase, GitHub; TypeScript, Vue, and Nuxt for frontends

## Selected Projects

All at M&M Environmental unless noted.

**SQL Server Connection Proxy** | Python asyncio, TDS protocol, Docker | 2024 – Present

- Reverse-engineered the TDS wire protocol to build a transparent TCP/UDP proxy that decodes SQL Batch packets (UTF-16LE), rewrites matching queries in flight, and forwards SQL Browser discovery traffic, so clients cannot tell it from a direct connection
- Deployed as multiple containers on a Linux host with an ipvlan network, with sync (ThreadPoolExecutor) and async (asyncio) variants and structured rotating logs; has kept a vendor-abandoned field-service system in production since 2024

**AI Call Enrichment Pipeline (MM Portal)** | Django Q, faster-whisper, Pydantic AI, Claude, HubSpot | 2025

- Two-stage async pipeline: every 3CX call is logged to HubSpot first, then transcribed and analyzed by a five-tool Claude agent whose schema-validated output fills 45 custom properties; confidence thresholds route uncertain calls to human review
- Idempotent by design (webhook dedup, a HubSpot property as sentinel), bounded retries ending in a dead state, per-run token and prompt-version tracking, and re-enrichment by version to compare review rates across prompts

**NYCHA XRF Compliance Reporting Platform** | Django, pdfkit, Win32COM | 2023, for Green Orchard Group

- Detects XRF instrument firmware from CSV headers and routes to per-instrument parsers, validates every reading against NYCHA's per-room component templates, and models paint-chip overrides; generates 20-30 page PDF and formula-preserving Excel packages
- Cut report generation from about 3 hours to under 3 minutes per inspection on a $5M contract; absorbed monthly NYCHA requirement changes for two years through continuous schema migration

## Experience

**M&M Environmental**, Queens, NY | May 2012 – Present

Pest control and environmental services company that grew from 30 to 100+ employees. Progressed from part-time Software Developer to Director of IT while remaining the only engineer for all internal software.

**Director of IT (Lead Software Engineer)** | May 2021 – Present

- Owned MM Portal end to end (Django, HTMX, MySQL, live MSSQL), used daily by 50+ staff; added HubSpot webhook sync, GPS alerting for field vehicles, and the AI pipeline above
- Built the Django backend for a customer quoting portal: server-side strategy-pattern pricing, magic-link drafts, pdfkit proposals signed with pyHanko, HubSpot ticket creation; Docker, Nginx, Gunicorn
- Ran network, Active Directory, Windows and Linux servers, and backups alongside engineering work

**IT Manager** | 2019 – 2021

- Added a TomTom/Google Maps routing tool to MM Portal and a Selenium scraper that pulls work orders and PDFs from a vendor field app with no API; built Flask REST APIs over MSSQL and a Django/PostgreSQL inspection job tracker

**Programming Analyst (Full-Stack Developer)** | 2015 – 2019

- Designed and built MM Portal from scratch against a 2007-era SQL Server system with 3-5 minute page loads, giving scheduling, sales, accounting, and customer service role-gated web dashboards over the same data

**Software Developer (part-time)** | May 2012 – 2015

- Built internal reporting and user-lookup tools on SQL Server while completing a degree in Computer Engineering

## Open Source

**Arcus** | Nuxt, Supabase Realtime | 2025 | getarcus.com | github.com/schir2/arcus: real-time multi-user project management with a layered store/action architecture

**Calcura** | Nuxt, Django REST Framework | 2024 | calcura.org | github.com/schir2/calcura: retirement simulator with a command-sequence engine and Vitest coverage across every account manager

## Education

**Bachelor's, Computer Engineering** [fill: confirm exact degree name], New York City College of Technology (City Tech), CUNY

Cisco CCNA and Cisco Certified Specialist, Enterprise Advanced Infrastructure Implementation (both expired)
