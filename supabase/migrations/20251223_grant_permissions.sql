-- Migration: Grant necessary permissions to authenticated/anon roles
-- Created: 2025-12-23
-- Description: Grants required SQL privileges so RLS policies can be enforced
-- NOTE: Row Level Security (RLS) on each table continues to enforce per-row access.

BEGIN;

-- Ladders: allow anonymous users to read public ladders (used for browsing)
GRANT SELECT ON TABLE public.ladders TO anon;

-- Ladders: allow authenticated users to read ladders (RLS still applies)
GRANT SELECT ON TABLE public.ladders TO authenticated;

-- Profiles: allow authenticated users to select their own profile (RLS restricts rows)
GRANT SELECT ON TABLE public.profiles TO authenticated;

-- Profiles: allow authenticated users to update their own profile (RLS restricts updates to owner)
GRANT UPDATE ON TABLE public.profiles TO authenticated;

COMMIT;

-- To apply: run this file in Supabase SQL editor or apply via Supabase CLI migrations.
