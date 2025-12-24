-- Migration: Grant INSERT on ladders to authenticated role
-- Created: 2025-12-23
-- Description: Allow authenticated users to INSERT into public.ladders

BEGIN;

-- Allow authenticated users to insert new ladders (RLS restricts rows by admin_id)
GRANT INSERT ON TABLE public.ladders TO authenticated;

COMMIT;

-- Apply via Supabase SQL editor or Supabase CLI migrations
