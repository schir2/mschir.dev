insert into public.projects (name, slug, description, summary, company_id, year, image_url)
values
    (
        'Vehicle GPS Alerting System for Field Service Workers',
        'vehicle-gps-alerting-system-for-field-service-workers',
        'GPS-based alerting system for tracking and monitoring field technicians.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2022,
        null
    ),
    (
        'Field Service Management API',
        'field-service-management-api',
        'API services supporting field service operations.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Visual Lead Inspection Job Tracking System',
        'visual-lead-inspection-job-tracking-system',
        'Job tracking system with visual inspection workflows.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Automated User Lookup and Reporting System',
        'automated-user-lookup-and-reporting-system',
        'Automated reporting and user lookup tools.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2009,
        null
    )
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
values
    (
        'NYCHA XRF Lead Inspection and Reporting Platform',
        'nycha-xrf-lead-inspection-and-reporting-platform',
        $desc$Green Orchard Group held a $5M NYCHA contract to conduct XRF lead-based paint inspections across New York City public housing. I built the platform that managed the inspection workflow and generated the compliance reports each job required.

NYCHA's reporting requirements are detailed: each inspection produces a 20-30 page PDF compliance report alongside a templated Excel data sheet with embedded formulas. A rejected submission restarts a review cycle that can delay payment by months and may require a full reinspection.

The platform covers the workflow from upload to submission: field technicians upload raw CSV exports from their XRF devices, the system parses the instrument-specific format, validates every reading against NYCHA's component and measurement rules, and flags discrepancies before report generation. Two outputs are produced per job: a PDF compliance report rendered from Django HTML templates via pdfkit, and a formatted Excel data sheet converted via Win32COM to preserve embedded formula integrity. Both are merged into a single submission package.

Report generation went from around three hours per inspection to under three minutes.

## Architecture

```mermaid
flowchart TD
    A[XRF Instrument] -->|CSV export| B[Web Upload]
    B --> C[Version Detection]
    C --> D[Instrument Parser]
    D --> E[Normalized Readings]

    subgraph validation["Validation Engine"]
        E --> F[Reading Completeness]
        F --> G[Room Component Checks]
    end

    REF1[(Component\nTemplates)] --> G
    REF2[(Developments\nand Addresses)] --> H

    G --> ERR{Issues\nfound?}
    ERR -->|Yes| WARN[Warnings / Errors\nshown to technician]
    ERR -->|No| H[Job and Visit Records]

    H --> GEN[Report Generation]

    subgraph reports["Outputs"]
        GEN -->|pdfkit| PDF[PDF Report]
        GEN -->|Win32COM| XLS[Excel Data Sheet]
    end

    PDF --> SUB[NYCHA Submission]
    XLS --> SUB
```

XRF instruments export readings as CSV files. Before parsing, the platform detects the instrument firmware version from the file header, since different versions output different column layouts and field encodings. The detected version routes the file to the correct parser, which normalizes readings into a common schema.

Report generation runs two parallel paths: HTML templates rendered by Django feed into pdfkit to produce the PDF compliance report; a separate Excel template is populated and converted to PDF via Win32COM, chosen over a pure-Python library to preserve the integrity of embedded formulas that NYCHA auditors check. Both outputs are merged into a single submission package.

## Validation

Validation is where most of the complexity lives. NYCHA defines component requirements per room type: each room category has an expected set of components that must be inspected, and the platform checks each visit's readings against those templates. Missing or incomplete components surface as warnings or errors before a report can be generated, with enough specificity to tell the technician exactly what to fix.

NYCHA updated these requirements regularly, sometimes monthly. Component templates had to be kept current without invalidating existing records. The same applied to development and address data: NYCHA's property records changed over time, and the platform maintained its own models of developments, buildings, and units, with logic to reconcile incoming data against the current reference.

## Key Engineering Decisions

**Instrument version detection:** Different firmware versions of the same XRF device model output CSV files in subtly different formats: column ordering, field names, and decimal precision all varied. Rather than a single parser that tried to handle all variants, the platform detects the version from the file header and routes accordingly. Adding support for a new firmware version means adding a new parser path, not modifying existing ones.

**Per-instrument CSV parsers:** Each device model also has a fundamentally different CSV structure. Separate parser classes per model keep the logic isolated and make it straightforward to add new devices without touching existing code.

**Paint chip sample overrides:** When an XRF reading falls in the inconclusive range, NYCHA requires a paint chip sample to confirm the result. The platform models this as an override: a paint chip concentration, when present, replaces the XRF reading as the final reported value, mirroring NYCHA's procedural hierarchy and keeping the validation logic auditable.

**Continuous schema evolution:** NYCHA updated its reporting requirements roughly every month or two. The Django migration history reflects this across two years of active use.$desc$,
        'A Django platform for managing NYCHA XRF lead inspection workflows, from raw instrument data import through PDF and Excel compliance report generation.',
        (select id from public.companies where name = 'Green Orchard Group'),
        2023,
        'https://github.com/mmpc-nyc/mmpcWebApps',
        false,
        null
    )
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
values
    (
        'EPA Pesticide Registry Scraper',
        'epa-pesticide-registry-scraper',
        'I built this to replace a slow manual process at MMPC: searching the EPA''s Pesticide Product Label System, downloading labels, and compiling specs across hundreds of registered products. Given an EPA registration number, it navigates the portal with Selenium and returns structured data including active ingredients with concentrations, application sites, and target pests. Built with Python and Selenium to support compliance documentation and procurement analysis for sourcing generic alternatives, it reached proof of concept but never shipped.',
        'Python and Selenium proof of concept for extracting structured pesticide registration data from the EPA''s PPLS portal.',
        (select id from public.companies where name = 'MMPC'),
        2023,
        'https://github.com/mmpc-nyc/epa-scraper',
        false,
        null
    )
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, project_url, is_public, image_url)
values
    (
        'Arcus',
        'arcus',
        $desc$Arcus is a project and task management app I built after getting tired of paying for Asana. I needed something to organize my own website builds that had the same core features without the subscription. What started as a side idea grew into a full platform with real-time collaboration, a Vue Flow dependency diagram, and a layered state management architecture built for live multi-user editing.

The app is live at [getarcus.com](https://getarcus.com). It is not widely advertised yet; a small group of early users has access while I finish the current architectural work. Core task management works: projects with customizable statuses and priorities, tracks that organize work by domain or responsibility (each with a default assignee so tasks inherit ownership on creation), tasks with comments, tags, due dates, and a visual dependency graph built with Vue Flow.

### Architecture

```mermaid
flowchart LR
    Components[Vue Components] -->|field patch| Stores[Entity Stores]
    Components -->|orchestration| Actions[Action Layer]
    Actions -->|CRUD + RPC| Supabase[(Supabase)]
    Actions -->|hydrate| Stores
    Realtime[Supabase Realtime] -->|DB events| Stores
    Stores -->|reactive| Components
```

The architecture has three explicit layers. Stores hold state only; no fetching, no RPC calls. A `createObjectStore` factory generates uniform store instances for each entity. Actions own all orchestration: API calls, multi-store coordination, error handling, and notifications. Each action exposes its own `isLoading` and `error` state so buttons get accurate spinners. Components call stores directly for single-field patches and emit upward only when an operation needs service-layer logic.

### Realtime Pipeline

```mermaid
flowchart TD
    DB[(Supabase DB)] -->|DB changes| RT[Supabase Realtime]
    RT -->|WebSocket| Factory[useRealtimeChannelFactory]
    Factory -->|INSERT / UPDATE| upsert["store.upsert(payload.new)"]
    Factory -->|DELETE| remove["store.removeLocal(payload.old.id)"]
    upsert --> Store[projectDetailStore.related.*]
    remove --> Store
    Store -->|reactive| UI[Vue components]
```

When multiple users edit a project simultaneously, Supabase Realtime streams Postgres changes directly to the client. A channel factory applies inserts, updates, and deletes to the matching store without a round-trip to the server, so every connected user sees changes instantly.

### What I Planned but Have Not Built Yet

Two features I wanted to add but have not gotten to.

The first is democratic task prioritization. In team settings, traditional priority levels break down when everything is urgent. The idea: give each team member a limited pool of votes to allocate across project tasks. Scarcity forces real trade-offs; tasks surface ranked by vote weight rather than whatever the person who set up the board decided.

The second is an AI-executable workflow template system. Tracks already model the ownership and handoff structure of a project, and the dependency diagram renders that structure visually. I wanted to add a way to define a structured sequence of task templates that an agent could instantiate and execute, using the track graph as the workflow scaffold. Claude Workflows shipped a few weeks after I had the idea, which was both validating and mildly deflating. The visual builder angle still feels like a useful layer on top.$desc$,
        'Asana alternative I built from scratch, with real-time multi-user editing and a layered Pinia store architecture.',
        null,
        2025,
        'https://github.com/schir2/arcus',
        'https://getarcus.com',
        true,
        null
    )
on conflict (name) do update set
    description = excluded.description,
    summary = excluded.summary,
    repo_url = excluded.repo_url,
    project_url = excluded.project_url,
    is_public = excluded.is_public;

insert into public.projects (name, slug, description, summary, company_id, year, image_url)
values
    (
        'Calcura',
        'calcura',
        'I built Calcura to make the logic of investing legible to people who find it intimidating, partly to understand the work of someone close to me who was a CFA/CFP and partly for myself. It runs multi-variable retirement simulations and renders results as interactive Chart.js charts, letting you compare how changes in savings rate, asset allocation, and expected returns ripple across a working lifetime. Built with Nuxt, Vue, Naive UI, TypeScript, and Chart.js on the frontend; originally backed by Django REST Framework, now migrating to Supabase.',
        'Retirement scenario planner that shows how savings and investment choices compound over a working lifetime.',
        null,
        2024,
        null
    )
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
values (
    'MM Portal',
    'mm-portal',
    $desc$MM Portal is the internal web platform I built for M&M Environmental alongside ServiceCEO, a 2007-era field service management desktop application running on SQL Server 2005 that took three to five minutes to load a single page and no longer accepted new user licenses. Rather than replace it, MM Portal extends it: scheduling, sales, accounting, and customer service teams get fast, role-gated web access to the same underlying data without touching ServiceCEO's slow interface. The company has since grown from 30 to over 100 employees.

Core features include job, customer, invoice, and service dashboards backed by a live MSSQL connection to ServiceCEO. The scheduling team uses a TomTom-powered routing tool that maps technician locations, scores route efficiency, and visualizes coverage gaps. A web scraper logs into ServiceBridge, a third-party mobile field app also connected to ServiceCEO, to download work orders, service agreements, and other generated PDFs that are otherwise inaccessible via API.

The AI layer connects 3CX phone calls and ServiceCEO job data to HubSpot: faster-whisper transcribes calls, then a Pydantic AI agent backed by Claude identifies service requests, sales opportunities, and scheduling conflicts and creates deals, tickets, and enriched contact records in HubSpot. A parallel pipeline runs the same extraction over ServiceCEO job and invoice notes. The goal is to catch overlooked signals (unactioned call follow-ups, missed upsell moments, late-caught scheduling conflicts) and put them in front of the right team before the window closes. Built with Django, Python, HTMX, Bootstrap, MySQL, and MSSQL; used daily by over 50 people.

## How It Grew

MM Portal started as one thing and became another. The timeline below shows how each phase added a new layer without replacing what came before.

```mermaid
timeline
    title MM Portal · Eight Years of Growth
    2017 : Core dashboards
         : Job, customer, invoice, and service visibility
         : Role-gated web access replacing ServiceCEO UI
    2020 : GPS routing tool with TomTom and Google Maps
         : ServiceBridge PDF scraper
    2022 : HubSpot webhook integration
         : Contact, deal, and ticket sync
    2025 : faster-whisper call transcription
         : Pydantic AI enrichment agent backed by Claude
         : EnrichmentTask token tracking and prompt versioning
```

## Architecture

MM Portal connects five external systems through a single Django application. ServiceCEO (legacy MSSQL) is read directly for dashboards and feeds the AI pipeline via job and invoice notes. 3CX phone events arrive via webhook; ServiceBridge PDFs are pulled by a web scraper. All enriched data flows out to HubSpot.

```mermaid
flowchart TD
    SCEO[("ServiceCEO\nMSSQL")]
    CX[("3CX\nPhone System")]
    SB[("ServiceBridge")]

    subgraph portal["MM Portal · Django + MySQL"]
        DASH["Dashboards\nJobs · Customers · Invoices"]
        ROUTE["Routing Tool\nTomTom · Google Maps"]
        SCRAPER["PDF Scraper"]
        subgraph ai["AI Pipeline · Django Q"]
            WHISPER["faster-whisper\ntranscription"]
            AGENT["Pydantic AI Agent\nbacked by Claude"]
        end
    end

    HS[("HubSpot CRM")]

    SCEO -->|live queries| DASH
    SCEO -->|job & invoice notes| AGENT
    CX -->|call recordings| WHISPER
    WHISPER -->|transcript| AGENT
    SB -->|web scraping| SCRAPER
    AGENT -->|"deals · tickets · contacts"| HS
```

## AI Call Enrichment Pipeline

Every 3CX call that ends goes through a two-stage async pipeline. Part 1 runs synchronously inside `process_threecx_event`: it creates a HubSpot Call Activity and resolves the contact (via entity_id fast-path, phone search, or sparse contact creation). Part 2 is dispatched independently as a Django Q task, so the call log is in HubSpot before enrichment starts. If a transcript is missing or low-quality, a `transcribe_call_activity` task runs faster-whisper against the recording URL first, then re-queues enrichment.

The enrichment task runs a Pydantic AI agent backed by Claude with five Django-backed tools: contact search, deal lookup, owner resolution, HubSpot enum option fetching, and a fill-if-blank contact write. The agent classifies each call into a domain-specific type hierarchy with confidence thresholds; calls below the threshold are flagged for human review rather than silently misfiled. It produces a validated `CallAnalysisResult` that drives writes to 45 custom HubSpot Call Activity properties and a structured HTML call body. Every attempt is recorded in an `EnrichmentTask` row that tracks token counts, model name, and `analysis_version`. That version string comes from the YAML frontmatter of the system prompt, so when a new prompt ships, `enrich_calls --before-version vN` re-enriches all older calls and the task records make it straightforward to compare review flag rates and escalation rates across versions.

```mermaid
flowchart TD
    A["3CX call ends"] --> B["Django webhook\nThreeCXCallEvent stored\ndeduplicated by number · start · agent"]
    B --> C["Django Q\nprocess_threecx_event"]
    C --> D["Part 1: Call Activity created\nin HubSpot · contact resolved"]
    D --> GATE{"transcript\npresent?"}
    GATE -->|No| T["transcribe_call_activity\nfaster-whisper streams recording URL\nTranscriptionTask created"]
    GATE -->|Yes| E
    T --> E["enrich_call_activity\nDjango Q task"]

    E --> AG["Pydantic AI Agent\nClaude claude-sonnet-4-6"]
    AG <-->|"tool calls"| TOOLS["search contacts · deals · owners\nfetch enum options · write contact"]
    AG --> OUT["CallAnalysisResult\nvalidated Pydantic model"]

    OUT --> HS["HubSpot\n45 custom Call Activity properties\ncontact fields enriched\nHTML call body written"]
    OUT --> ET["EnrichmentTask\ntokens · model · analysis_version\nreview_required · escalation_required"]

    ET --> Q{"transcript_quality\n= low + no prior\ntranscription?"}
    Q -->|Yes| T
    Q -->|No| WF["HubSpot Workflows\nread enriched properties\ncreate tickets · deals\nroute to right team"]

    subgraph loop["Prompt Iteration"]
        VER["analysis_version\nin prompt YAML frontmatter"]
        BACK["enrich_calls --before-version vN\nre-enriches all older calls"]
        CMP["query EnrichmentTask\nreview_required rate · escalation rate\nby version"]
        VER --> BACK --> CMP --> VER
    end

    ET -.-> loop
```

## EnrichmentTask State Machine

The `EnrichmentTask` model tracks every enrichment attempt with bounded retry and a terminal `dead` state. A blank `analysis_version` on a HubSpot Call Activity is the idempotency sentinel: blank means not yet enriched, present means done. The `untranscribable` state handles a specific failure mode: if a second enrichment attempt (after re-transcription with faster-whisper) still classifies the transcript as low quality, Django writes `transcript_quality = untranscribable` directly to the HubSpot Call Activity. That value is visible to operators in HubSpot without any Django access, so they know to listen to the recording manually.

```mermaid
stateDiagram-v2
    [*] --> PENDING : task dispatched\n(unique per object + version)
    PENDING --> SUCCESS : enrichment complete\ntokens and result stored
    PENDING --> FAILURE : agent error or API timeout
    FAILURE --> PENDING : Django Q retry\nattempt_count++
    FAILURE --> DEAD : max retries exceeded
    SUCCESS --> PENDING : re-enrich\n(new prompt version)
    DEAD --> [*]
    SUCCESS --> [*]
```

## Key Engineering Decisions

**Part 1 and Part 2 run as separate Django Q tasks.** The call log exists in HubSpot as soon as Part 1 completes. `ThreeCXCallEvent` is marked `PROCESSED` after Part 1, not after enrichment; the status accurately reflects whether the call log is in HubSpot, not whether enrichment succeeded.

**Per-call `WhisperModel` instantiation, not a singleton.** Loading `large-v3` (~5 GB) on each transcription is slow, but holding it resident across workers would exhaust RAM on the current server. The `transcribe_from_url()` interface abstracts the implementation; swapping Whisper for a remote transcription service later is a change inside one file.

**`analysis_version` on HubSpot as the idempotency sentinel.** A blank property means not yet enriched. HubSpot is already the authoritative store for call data; using a Django-side flag would create a second source of truth and silently hide calls where the write-back to HubSpot failed. The management command queries HubSpot directly with no Django state required.

**`EnrichmentTask` generalized before the second enrichment type existed.** The first design was call-specific. Before any migration was created, the schema was refactored to `(object_type, object_id, analysis_version)` with accumulated token counts across retries. Five enrichment types are planned. One row per object means "total spend this month across all types" is a single aggregation query.$desc$,
    'Internal Django platform that extends M&M Environmental''s aging field service system, giving 50-plus employees fast web access, GPS routing, and an AI pipeline that turns missed call signals and job notes into actionable HubSpot tasks.',
    (select id from public.companies where name = 'MMPC'),
    2017,
    'https://github.com/mmpc-nyc/mmportal-django',
    false,
    null
)
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
values (
    'Recurring Service Quoting Portal',
    'recurring-service-quoting-portal',
    $desc$MMPC operates two recurring pest control programs for residential and commercial properties across New York City. Getting an accurate quote for either required back-and-forth between sales reps and property managers, and pricing varied by building type, unit count, service method, contract length, and optional add-ons that made manual calculation unreliable.

The portal replaced that back-and-forth. Property managers can fill out a multi-step intake form, receive a real-time price, and get a signed PDF proposal without any sales rep involvement. The same form also serves as a training tool for sales reps, walking them through the conditional questions that determine scope and price for complex jobs.

I worked on the Django backend and the visual design of the frontend. Two other developers on the team built out the Nuxt frontend. The stack runs in Docker, with the statically generated SPA served by Nginx and API calls proxied to Django under Gunicorn.

### Architecture

```mermaid
flowchart TD
    A["Customer / Sales Rep\nNuxt SPA"] -->|REST| B[Django API]
    B --> C[(Database)]
    B -->|PDF + digital signature| D["wkhtmltopdf\npyHanko"]
    B -->|Ticket + contact| E[HubSpot CRM]
    B -->|Service agreement email| F[SMTP]
    A -->|Address autocomplete| G[TomTom API]
    H["Staff Manager View\nDjango + HTMX"] --> B
```

### Quote Lifecycle

```mermaid
stateDiagram-v2
    [*] --> New: Customer submits
    [*] --> Draft: Save for later
    Draft --> New: Resume and submit
    New --> Quoted: Staff generates proposal
    Quoted --> Completed: Customer signs
```

### Key Engineering Decisions

Pricing is calculated server-side through a strategy pattern, one implementation per program type, so the rules live in one place and can be tested in isolation. The frontend sends form data to the API and renders the returned price rather than computing it locally.

Draft save uses a magic link rather than requiring account creation. A customer can save a link to their email and resume the form on any device.

PDF proposals are rendered from Django HTML templates through pdfkit and wkhtmltopdf, then digitally signed with pyHanko. HubSpot contact and ticket records are created on submission so the sales team can track quote status without logging into the portal.$desc$,
    'Customer-facing quoting portal for MMPC''s recurring pest control programs, automating multi-step intake, real-time pricing, and signed PDF proposal delivery.',
    (select id from public.companies where name = 'MMPC'),
    2024,
    'https://github.com/mmpc-nyc/mmpc-website-apps',
    false,
    null
)
on conflict (name) do nothing;

insert into public.projects (name, slug, description, summary, company_id, year, repo_url, is_public, image_url)
values (
    'SQL Server Connection Proxy',
    'sql-server-connection-proxy',
    $desc$This is one of my favorite projects. Reverse-engineering a proprietary wire protocol to keep vendor-abandoned software running in production required a deep understanding of TDS.

The proxy sits transparently between application clients and a Microsoft SQL Server instance, handling both TCP connections and UDP broadcast discovery queries. On the TCP side, every packet is decoded against the TDS (Tabular Data Stream) specification, the binary protocol SQL Server uses for all client communication, inspected for specific query patterns, and modified before being forwarded upstream. On the UDP side, SQL Browser discovery traffic is forwarded as-is. Clients cannot tell the difference from a direct connection.

### TDS Packet Structure

TDS packets carry an 8-byte fixed header followed by a variable-length payload. Understanding those fields was the key to building the decoder:

| Field | Size | Description |
|---|---|---|
| Type | 1 byte | Packet type: SQL Batch (`0x01`), Pre-Login (`0x02`), RPC Request (`0x03`), Tabular Result (`0x05`) |
| Status | 1 byte | Bitfield flags: EOM (`0x01`), Ignore (`0x02`), Reset Connection (`0x08`) |
| Length | 2 bytes | Total packet length, header included |
| SPID | 2 bytes | Session process ID; ties the packet to a specific client session |
| Packet ID | 1 byte | Sequence number for multi-packet messages |
| Window | 1 byte | Reserved |

SQL Batch payloads, the packet type that carries raw SQL queries, are encoded as UTF-16-LE. Decoding them is straightforward once you know the type field; working out what to intercept and why required understanding the full exchange.

Deployed as multiple Docker containers on a Linux host with a custom ipvlan network, the service handles the full connection lifecycle. I developed both synchronous (ThreadPoolExecutor) and async (asyncio) variants, which turned into its own exploration of how Python handles concurrent I/O at the network layer. The Docker side of things, container networking, running multiple instances, and isolating traffic, was as much of a learning thread as the protocol work. Structured logging with log rotation covers production observability. The proxy has been running in production since 2024.

## Architecture

```mermaid
flowchart LR
    subgraph Clients["Application Clients"]
        C1[Client]
        C2[Client]
        C3[Client]
    end
    subgraph Proxy["Proxy (Docker)"]
        TCP["TCP Listener\n:1433"]
        UDP["UDP Listener\n:1434"]
    end
    subgraph Server["SQL Server"]
        SQLS["SQL Server\n:1435"]
        SQLB["SQL Browser\n:1434"]
    end
    C1 & C2 & C3 -- TCP --> TCP
    C1 & C2 & C3 -- UDP --> UDP
    TCP -- TCP :1435 --> SQLS
    UDP -- UDP :1434 --> SQLB
```

## TDS Packet Pipeline

```mermaid
flowchart TD
    A[Incoming TCP Packet] --> B[Parse TDS Header]
    B --> C{Packet Type}
    C -- SQL Batch --> D[Decode UTF-16LE Payload]
    C -- Other --> G[Forward Unchanged]
    D --> E[Apply Query Modifiers]
    E --> F{Pattern Match?}
    F -- Yes --> H[Modify Packet]
    F -- No --> G
    H --> G
    G --> I[SQL Server]
```$desc$,
    'A transparent TCP/UDP proxy that decodes TDS protocol packets to extend the operational life of a vendor-abandoned platform, running in production since 2024.',
    (select id from public.companies where name = 'MMPC'),
    2024,
    'https://github.com/mmpc-nyc/serviceCEOProxy',
    false,
    null
)
on conflict (name) do nothing;
