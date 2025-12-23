-- Migration: Create Ladders Table
-- Created: 2025-01-01
-- Description: Tennis ladder configurations and settings

BEGIN;

-- Create ladders table
CREATE TABLE IF NOT EXISTS ladders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    visibility TEXT CHECK (visibility IN ('public', 'private', 'invite_only')) DEFAULT 'public',
    max_players INTEGER CHECK (max_players > 0) DEFAULT 100,
    challenge_range INTEGER CHECK (challenge_range > 0) DEFAULT 3,
    max_concurrent_challenges INTEGER CHECK (max_concurrent_challenges > 0) DEFAULT 2,
    challenge_cooldown_days INTEGER CHECK (challenge_cooldown_days >= 0) DEFAULT 14,
    challenge_response_days INTEGER CHECK (challenge_response_days > 0) DEFAULT 7,
    inactivity_warning_days INTEGER CHECK (inactivity_warning_days > 0) DEFAULT 45,
    inactivity_penalty_days INTEGER CHECK (inactivity_penalty_days > 0) DEFAULT 60,
    inactivity_action TEXT CHECK (inactivity_action IN ('bottom', 'inactive_pool', 'remove')) DEFAULT 'inactive_pool',
    scoring_system TEXT CHECK (scoring_system IN ('swap', 'points', 'elo')) DEFAULT 'swap',
    require_score_verification BOOLEAN DEFAULT true,
    allow_score_disputes BOOLEAN DEFAULT true,
    divisions_enabled BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on admin_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_ladders_admin_id ON ladders(admin_id);

-- Create index on visibility for filtering
CREATE INDEX IF NOT EXISTS idx_ladders_visibility ON ladders(visibility);

-- Create index on is_active for filtering
CREATE INDEX IF NOT EXISTS idx_ladders_is_active ON ladders(is_active);

-- Enable Row Level Security
ALTER TABLE ladders ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view public ladders
CREATE POLICY "Public ladders are viewable by everyone"
    ON ladders FOR SELECT
    USING (visibility = 'public' OR admin_id = auth.uid());

-- Policy: Anyone authenticated can create a ladder
CREATE POLICY "Authenticated users can create ladders"
    ON ladders FOR INSERT
    WITH CHECK (auth.uid() = admin_id);

-- Policy: Only ladder admins can update their ladder
CREATE POLICY "Admins can update own ladder"
    ON ladders FOR UPDATE
    USING (auth.uid() = admin_id);

-- Policy: Only ladder admins can delete their ladder
CREATE POLICY "Admins can delete own ladder"
    ON ladders FOR DELETE
    USING (auth.uid() = admin_id);

-- Trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_ladders_updated_at ON ladders;
CREATE TRIGGER update_ladders_updated_at
    BEFORE UPDATE ON ladders
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

COMMIT;

-- Rollback instructions:
-- DROP TRIGGER IF EXISTS update_ladders_updated_at ON ladders;
-- DROP TABLE IF EXISTS ladders CASCADE;
