-- Migration: Create Challenges Table
-- Created: 2025-01-01
-- Description: Track match challenge requests between players

BEGIN;

-- Create challenges table
CREATE TABLE IF NOT EXISTS challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ladder_id UUID NOT NULL REFERENCES ladders(id) ON DELETE CASCADE,
    challenger_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    opponent_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    status TEXT CHECK (status IN ('pending', 'accepted', 'declined', 'cancelled', 'expired', 'completed')) DEFAULT 'pending',
    message TEXT,
    decline_reason TEXT,
    cancellation_reason TEXT,
    expires_at TIMESTAMP WITH TIME ZONE,
    responded_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CHECK (challenger_id != opponent_id)
);

-- Create index on ladder_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_challenges_ladder_id ON challenges(ladder_id);

-- Create index on challenger_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_challenges_challenger_id ON challenges(challenger_id);

-- Create index on opponent_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_challenges_opponent_id ON challenges(opponent_id);

-- Create index on status for filtering
CREATE INDEX IF NOT EXISTS idx_challenges_status ON challenges(status);

-- Create composite index for pending challenges lookup
CREATE INDEX IF NOT EXISTS idx_challenges_pending ON challenges(opponent_id, status) WHERE status = 'pending';

-- Enable Row Level Security
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Policy: Players can view challenges they are involved in
CREATE POLICY "Players can view their own challenges"
    ON challenges FOR SELECT
    USING (
        challenger_id = auth.uid() OR 
        opponent_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Policy: Players can create challenges (with business logic validation in app)
CREATE POLICY "Players can create challenges"
    ON challenges FOR INSERT
    WITH CHECK (
        auth.uid() = challenger_id AND
        status = 'pending'
    );

-- Policy: Players can update challenges they are involved in
CREATE POLICY "Players can update their challenges"
    ON challenges FOR UPDATE
    USING (
        challenger_id = auth.uid() OR 
        opponent_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Policy: Players can delete their own challenges (soft delete preferred)
CREATE POLICY "Players can delete their challenges"
    ON challenges FOR DELETE
    USING (
        challenger_id = auth.uid() OR
        ladder_id IN (SELECT id FROM ladders WHERE admin_id = auth.uid())
    );

-- Trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_challenges_updated_at ON challenges;
CREATE TRIGGER update_challenges_updated_at
    BEFORE UPDATE ON challenges
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to set expiration date on challenge creation
CREATE OR REPLACE FUNCTION public.set_challenge_expiration()
RETURNS TRIGGER AS $$
DECLARE
    response_days INTEGER;
BEGIN
    IF NEW.expires_at IS NULL THEN
        -- Get challenge_response_days from ladder settings
        SELECT challenge_response_days INTO response_days
        FROM ladders
        WHERE id = NEW.ladder_id;
        
        -- Set expiration date
        NEW.expires_at = NEW.created_at + (response_days || ' days')::INTERVAL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to set expiration date
DROP TRIGGER IF EXISTS set_challenge_expiration_trigger ON challenges;
CREATE TRIGGER set_challenge_expiration_trigger
    BEFORE INSERT ON challenges
    FOR EACH ROW EXECUTE FUNCTION public.set_challenge_expiration();

-- Function to auto-expire challenges
CREATE OR REPLACE FUNCTION public.auto_expire_challenges()
RETURNS void AS $$
BEGIN
    UPDATE challenges
    SET 
        status = 'expired',
        updated_at = NOW()
    WHERE 
        status = 'pending' AND
        expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

COMMIT;

-- Rollback instructions:
-- DROP FUNCTION IF EXISTS public.auto_expire_challenges();
-- DROP TRIGGER IF EXISTS set_challenge_expiration_trigger ON challenges;
-- DROP FUNCTION IF EXISTS public.set_challenge_expiration();
-- DROP TRIGGER IF EXISTS update_challenges_updated_at ON challenges;
-- DROP TABLE IF EXISTS challenges CASCADE;
