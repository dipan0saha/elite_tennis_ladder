-- Migration: Create Ladder Members Table
-- Created: 2025-01-01
-- Description: Track player membership and status in ladders

BEGIN;

-- Create ladder_members table
CREATE TABLE IF NOT EXISTS ladder_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ladder_id UUID NOT NULL REFERENCES ladders(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    rank INTEGER,
    points INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    win_rate DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE WHEN (wins + losses) > 0 
        THEN (wins::DECIMAL / (wins + losses)) * 100 
        ELSE 0 END
    ) STORED,
    status TEXT CHECK (status IN ('active', 'pending', 'inactive', 'removed')) DEFAULT 'pending',
    division TEXT,
    join_requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    joined_at TIMESTAMP WITH TIME ZONE,
    last_match_date TIMESTAMP WITH TIME ZONE,
    rank_change INTEGER DEFAULT 0,
    consecutive_wins INTEGER DEFAULT 0,
    consecutive_losses INTEGER DEFAULT 0,
    highest_rank INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(ladder_id, player_id)
);

-- Create index on ladder_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_ladder_members_ladder_id ON ladder_members(ladder_id);

-- Create index on player_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_ladder_members_player_id ON ladder_members(player_id);

-- Create index on rank for ordering
CREATE INDEX IF NOT EXISTS idx_ladder_members_rank ON ladder_members(ladder_id, rank) WHERE rank IS NOT NULL;

-- Create index on status for filtering
CREATE INDEX IF NOT EXISTS idx_ladder_members_status ON ladder_members(ladder_id, status);

-- Enable Row Level Security
ALTER TABLE ladder_members ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active ladder members in public ladders
CREATE POLICY "Ladder members are viewable by ladder members and admins"
    ON ladder_members FOR SELECT
    USING (
        status = 'active' OR 
        player_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Policy: Users can request to join a ladder
CREATE POLICY "Users can request to join ladders"
    ON ladder_members FOR INSERT
    WITH CHECK (
        auth.uid() = player_id AND
        status = 'pending'
    );

-- Policy: Ladder admins can update member status and rankings
CREATE POLICY "Admins can update ladder members"
    ON ladder_members FOR UPDATE
    USING (
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid()) OR
        player_id = auth.uid()
    );

-- Policy: Players can leave ladders (soft delete by setting status)
CREATE POLICY "Players can leave ladders"
    ON ladder_members FOR DELETE
    USING (
        player_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_ladder_members_updated_at ON ladder_members;
CREATE TRIGGER update_ladder_members_updated_at
    BEFORE UPDATE ON ladder_members
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to track highest rank
CREATE OR REPLACE FUNCTION public.update_highest_rank()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rank IS NOT NULL THEN
        IF NEW.highest_rank IS NULL OR NEW.rank < NEW.highest_rank THEN
            NEW.highest_rank = NEW.rank;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update highest_rank
DROP TRIGGER IF EXISTS update_ladder_members_highest_rank ON ladder_members;
CREATE TRIGGER update_ladder_members_highest_rank
    BEFORE UPDATE ON ladder_members
    FOR EACH ROW EXECUTE FUNCTION public.update_highest_rank();

COMMIT;

-- Rollback instructions:
-- DROP TRIGGER IF EXISTS update_ladder_members_updated_at ON ladder_members;
-- DROP TRIGGER IF EXISTS update_ladder_members_highest_rank ON ladder_members;
-- DROP FUNCTION IF EXISTS public.update_highest_rank();
-- DROP TABLE IF EXISTS ladder_members CASCADE;
