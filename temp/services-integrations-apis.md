# Integrations & APIs

Most businesses reach a point where their tools stop working together. A CRM that doesn't know what the phone system recorded. A job management system that doesn't sync with invoicing. Reports that someone has to manually compile every week because nothing shares data automatically.

That's the kind of work I do here.

## What this typically involves

Every project starts with a systems audit. Before any code gets written, I map what you have, how data moves between systems today, and where the gaps and friction points are. From there, the work usually falls into one of a few areas:

- Connecting platforms via APIs and webhooks so data moves automatically without manual entry
- Building custom middleware and API servers in Python (Django REST Framework, Flask, FastAPI) when the business logic requires real control over how data moves and transforms
- Designing and building API surfaces so your existing systems can be accessed by other tools, AI systems, or future integrations
- Building MCP servers that give AI systems structured access to your legacy applications without requiring a full rebuild
- Web scraping and login proxies when a platform has no API but does have a web interface. Not ideal, but sometimes the only path in

My default is Python. It gives more flexibility than point-and-click automation tools, makes AI enrichment straightforward to layer in, and doesn't come with the usage limits and escalating costs that tools like Zapier carry as your automation footprint grows. Those tools are useful for quick prototypes, but they're rarely the right long-term answer once a business's integration needs get serious.

A platform doesn't need to have an existing API for it to be connectable. If there's a database that's accessible, or a web interface that can be scripted, an API can be built around it. I've done exactly that for platforms that had neither.

## Platforms I've worked with

HubSpot, Jobber, 3CX, FreePBX, Twilio, Stripe, and various CRM and operations platforms. If your system has a database, an API, or a web interface, there's usually a way in.

## What it looks like in practice

The systems I've connected range from straightforward webhook setups to multi-platform pipelines involving phone systems, CRMs, legacy databases, and AI enrichment all talking to each other. The complexity varies, but the starting point is always the same: map what exists, then figure out the simplest path to making it work.

## Who this is for

Business owners who know their systems should be sharing data but aren't. Teams spending hours on manual work that should be automatic. Companies sitting on years of operational data in platforms that don't talk to each other.

You don't need to know what the solution looks like. That's what the audit is for.

[Get in touch](/contact)
