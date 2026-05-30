-- Enable pgTAP for local development so IDE introspection finds the test functions.
-- supabase test db enables this automatically at runtime, but without it here
-- the local database schema doesn't include pgTAP and IDEs flag plan(), finish(), etc. as unknown.
create extension if not exists pgtap;
