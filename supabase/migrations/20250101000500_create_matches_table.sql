-- Migration: Create Matches Table
-- Created: 2025-01-01
-- Description: Track tennis match details and results

BEGIN;

-- Create matches table
CREATE TABLE IF NOT EXISTS matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ladder_id UUID NOT NULL REFERENCES ladders(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES challenges(id) ON DELETE SET NULL,
    player1_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    player2_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    winner_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    status TEXT CHECK (status IN ('scheduled', 'in_progress', 'completed', 'disputed', 'cancelled')) DEFAULT 'scheduled',
    scheduled_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    location TEXT,
    court_surface TEXT CHECK (court_surface IN ('hard', 'clay', 'grass', 'carpet')),
    
    -- Score details (best of 3 sets)
    player1_set1_score INTEGER CHECK (player1_set1_score >= 0),
    player1_set2_score INTEGER CHECK (player1_set2_score >= 0),
    player1_set3_score INTEGER CHECK (player1_set3_score >= 0),
    player2_set1_score INTEGER CHECK (player2_set1_score >= 0),
    player2_set2_score INTEGER CHECK (player2_set2_score >= 0),
    player2_set3_score INTEGER CHECK (player2_set3_score >= 0),
    
    -- Score verification
    player1_verified BOOLEAN DEFAULT false,
    player2_verified BOOLEAN DEFAULT false,
    player1_verified_at TIMESTAMP WITH TIME ZONE,
    player2_verified_at TIMESTAMP WITH TIME ZONE,
    
    -- Dispute handling
    disputed_by UUID REFERENCES profiles(id),
    dispute_reason TEXT,
    dispute_evidence_url TEXT,
    disputed_at TIMESTAMP WITH TIME ZONE,
    dispute_resolved_at TIMESTAMP WITH TIME ZONE,
    dispute_resolution TEXT,
    
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CHECK (player1_id != player2_id)
);

-- Create indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_matches_ladder_id ON matches(ladder_id);
CREATE INDEX IF NOT EXISTS idx_matches_challenge_id ON matches(challenge_id);
CREATE INDEX IF NOT EXISTS idx_matches_player1_id ON matches(player1_id);
CREATE INDEX IF NOT EXISTS idx_matches_player2_id ON matches(player2_id);
CREATE INDEX IF NOT EXISTS idx_matches_winner_id ON matches(winner_id);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_matches_scheduled_at ON matches(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_matches_completed_at ON matches(completed_at);

-- Enable Row Level Security
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

-- Policy: Players can view matches they are involved in and public ladder matches
CREATE POLICY "Players can view their own matches"
    ON matches FOR SELECT
    USING (
        player1_id = auth.uid() OR 
        player2_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid()) OR
        ladder_id IN (SELECT ladder_id FROM ladder_members WHERE player_id = auth.uid() AND status = 'active')
    );

-- Policy: Players can create matches
CREATE POLICY "Players can create matches"
    ON matches FOR INSERT
    WITH CHECK (
        auth.uid() IN (player1_id, player2_id) AND
        status = 'scheduled'
    );

-- Policy: Players can update matches they are involved in
CREATE POLICY "Players can update their matches"
    ON matches FOR UPDATE
    USING (
        player1_id = auth.uid() OR 
        player2_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Policy: Admins can delete matches
CREATE POLICY "Admins can delete matches"
    ON matches FOR DELETE
    USING (
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_matches_updated_at ON matches;
CREATE TRIGGER update_matches_updated_at
    BEFORE UPDATE ON matches
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to determine winner based on sets won
CREATE OR REPLACE FUNCTION public.calculate_match_winner()
RETURNS TRIGGER AS $$
DECLARE
    player1_sets INTEGER := 0;
    player2_sets INTEGER := 0;
BEGIN
    -- Only calculate if match is completed
    IF NEW.status = 'completed' THEN
        -- Count sets won by each player
        IF NEW.player1_set1_score > NEW.player2_set1_score THEN
            player1_sets := player1_sets + 1;
        ELSIF NEW.player2_set1_score > NEW.player1_set1_score THEN
            player2_sets := player2_sets + 1;
        END IF;
        
        IF NEW.player1_set2_score > NEW.player2_set2_score THEN
            player1_sets := player1_sets + 1;
        ELSIF NEW.player2_set2_score > NEW.player1_set2_score THEN
            player2_sets := player2_sets + 1;
        END IF;
        
        IF NEW.player1_set3_score IS NOT NULL AND NEW.player2_set3_score IS NOT NULL THEN
            IF NEW.player1_set3_score > NEW.player2_set3_score THEN
                player1_sets := player1_sets + 1;
            ELSIF NEW.player2_set3_score > NEW.player1_set3_score THEN
                player2_sets := player2_sets + 1;
            END IF;
        END IF;
        
        -- Set winner
        IF player1_sets > player2_sets THEN
            NEW.winner_id := NEW.player1_id;
        ELSIF player2_sets > player1_sets THEN
            NEW.winner_id := NEW.player2_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to calculate winner
DROP TRIGGER IF EXISTS calculate_match_winner_trigger ON matches;
CREATE TRIGGER calculate_match_winner_trigger
    BEFORE UPDATE ON matches
    FOR EACH ROW
    WHEN (NEW.status = 'completed')
    EXECUTE FUNCTION public.calculate_match_winner();

COMMIT;

-- Rollback instructions:
-- DROP TRIGGER IF EXISTS calculate_match_winner_trigger ON matches;
-- DROP FUNCTION IF EXISTS public.calculate_match_winner();
-- DROP TRIGGER IF EXISTS update_matches_updated_at ON matches;
-- DROP TABLE IF EXISTS matches CASCADE;
