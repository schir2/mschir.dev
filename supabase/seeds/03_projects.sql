insert into public.projects (name, slug, description, summary, company_id, year, image_url)
values
    (
        'Customer Quoting Application',
        'customer-quoting-application',
        'Internal application for generating and managing customer quotes.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2024,
        null
    ),
    (
        'Lead Analyzer Reporting Platform',
        'lead-analyzer-reporting-platform',
        'Reporting and analytics platform for inbound leads.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2023,
        null
    ),
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
        'Field Service Management System Extension',
        'field-service-management-system-extension',
        'Extensions and customizations for the field service management platform.',
        null,
        (select id from public.companies where name = 'MMPC'),
        2017,
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

insert into public.projects (name, slug, description, summary, company_id, year, image_url)
values
    (
        'Arcus',
        'arcus',
        'An Asana and Linear-inspired task management app I built from scratch. Arcus organizes work into projects, sections, and tasks with support for priorities, dependencies, color-coded tags, subtasks, and deadline tracking — all updating in real time via Supabase. Built with Nuxt, Supabase, and TypeScript, deployed at getarcus.com.',
        'Personal take on task management, inspired by Asana and Linear, with real-time updates and a clean interface.',
        null,
        2025,
        null
    )
on conflict (name) do nothing;

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
