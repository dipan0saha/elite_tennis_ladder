-- Migration: Add RLS policies for ladder_members
-- Created: 2025-12-23
-- Purpose: Allow authenticated users to insert/update/delete their own ladder_members rows

BEGIN;

-- Ensure RLS is enabled (idempotent if already enabled)
ALTER TABLE IF EXISTS public.ladder_members ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to insert a membership row only when they are the user
DROP POLICY IF EXISTS "auth_insert_ladder_members" ON public.ladder_members;
CREATE POLICY "auth_insert_ladder_members"
  ON public.ladder_members
  FOR INSERT
  TO authenticated
  WITH CHECK (player_id = auth.uid());

-- Allow authenticated users to update their own membership rows
DROP POLICY IF EXISTS "auth_update_ladder_members" ON public.ladder_members;
CREATE POLICY "auth_update_ladder_members"
  ON public.ladder_members
  FOR UPDATE
  TO authenticated
  USING (player_id = auth.uid())
  WITH CHECK (player_id = auth.uid());

-- Allow authenticated users to delete their own membership rows
DROP POLICY IF EXISTS "auth_delete_ladder_members" ON public.ladder_members;
CREATE POLICY "auth_delete_ladder_members"
  ON public.ladder_members
  FOR DELETE
  TO authenticated
  USING (player_id = auth.uid());

-- Optionally allow authenticated users to select membership rows (adjust as needed)
DROP POLICY IF EXISTS "auth_select_ladder_members" ON public.ladder_members;
CREATE POLICY "auth_select_ladder_members"
  ON public.ladder_members
  FOR SELECT
  TO authenticated
  USING (true);

COMMIT;

-- Apply via Supabase SQL editor or include in migration pipeline
