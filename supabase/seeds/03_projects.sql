insert into public.projects (name, description, company_id, year, image_url)
values
    (
        'Customer Quoting Application',
        'Internal application for generating and managing customer quotes.',
        (select id from public.companies where name = 'MMPC'),
        2024,
        null
    ),
    (
        'Lead Analyzer Reporting Platform',
        'Reporting and analytics platform for inbound leads.',
        (select id from public.companies where name = 'MMPC'),
        2023,
        null
    ),
    (
        'Vehicle GPS Alerting System for Field Service Workers',
        'GPS-based alerting system for tracking and monitoring field technicians.',
        (select id from public.companies where name = 'MMPC'),
        2022,
        null
    ),
    (
        'Field Service Management API',
        'API services supporting field service operations.',
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Visual Lead Inspection Job Tracking System',
        'Job tracking system with visual inspection workflows.',
        (select id from public.companies where name = 'MMPC'),
        2021,
        null
    ),
    (
        'Field Service Management System Extension',
        'Extensions and customizations for the field service management platform.',
        (select id from public.companies where name = 'MMPC'),
        2017,
        null
    ),
    (
        'Automated User Lookup and Reporting System',
        'Automated reporting and user lookup tools.',
        (select id from public.companies where name = 'MMPC'),
        2009,
        null
    )
on conflict (name) do nothing;
