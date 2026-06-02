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
