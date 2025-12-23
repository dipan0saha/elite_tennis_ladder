-- Migration: Seed Data for Testing
-- Created: 2025-01-01
-- Description: Insert sample data for development and testing

BEGIN;

-- Note: This migration should only be run in development/staging environments
-- The seed data includes test ladders and sample configurations

-- Insert sample ladder (will be created by actual admin users in production)
-- This is commented out as it requires actual user IDs from auth.users
-- Uncomment and modify for local development

/*
-- Sample Ladder 1: Community Tennis Club
INSERT INTO ladders (id, name, description, admin_id, visibility, max_players, challenge_range, scoring_system)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Community Tennis Club',
    'A friendly competitive ladder for local tennis players',
    'YOUR_ADMIN_USER_ID_HERE',
    'public',
    50,
    3,
    'swap'
) ON CONFLICT (id) DO NOTHING;

-- Sample Ladder 2: Elite Players League
INSERT INTO ladders (id, name, description, admin_id, visibility, max_players, challenge_range, scoring_system)
VALUES (
    '00000000-0000-0000-0000-000000000002',
    'Elite Players League',
    'Advanced players only - highly competitive matches',
    'YOUR_ADMIN_USER_ID_HERE',
    'private',
    30,
    5,
    'points'
) ON CONFLICT (id) DO NOTHING;
*/

-- Insert lookup/reference data that doesn't depend on users

-- Create a function to generate sample notification templates
CREATE OR REPLACE FUNCTION public.get_notification_template(notification_type TEXT)
RETURNS TABLE(title TEXT, message_template TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE notification_type
            WHEN 'challenge_received' THEN 'New Challenge!'
            WHEN 'challenge_accepted' THEN 'Challenge Accepted!'
            WHEN 'challenge_declined' THEN 'Challenge Declined'
            WHEN 'match_scheduled' THEN 'Match Scheduled'
            WHEN 'match_reminder' THEN 'Match Reminder'
            WHEN 'match_completed' THEN 'Match Completed'
            WHEN 'score_verification_required' THEN 'Score Verification Needed'
            WHEN 'ranking_changed' THEN 'Ranking Update'
            WHEN 'inactivity_warning' THEN 'Inactivity Warning'
            ELSE 'Notification'
        END as title,
        CASE notification_type
            WHEN 'challenge_received' THEN '{challenger_name} has challenged you to a match.'
            WHEN 'challenge_accepted' THEN '{opponent_name} has accepted your challenge.'
            WHEN 'challenge_declined' THEN '{opponent_name} has declined your challenge.'
            WHEN 'match_scheduled' THEN 'Your match is scheduled for {match_date}.'
            WHEN 'match_reminder' THEN 'Your match with {opponent_name} is coming up soon!'
            WHEN 'match_completed' THEN 'Your match has been completed.'
            WHEN 'score_verification_required' THEN '{opponent_name} has reported the match score. Please verify.'
            WHEN 'ranking_changed' THEN 'Your ranking has changed to #{rank}.'
            WHEN 'inactivity_warning' THEN 'You have been inactive for {days} days. Play a match to stay active.'
            ELSE 'You have a new notification.'
        END as message_template;
END;
$$ LANGUAGE plpgsql;

-- Create helper function to check challenge eligibility
CREATE OR REPLACE FUNCTION public.is_challenge_eligible(
    p_ladder_id UUID,
    p_challenger_id UUID,
    p_opponent_id UUID
)
RETURNS TABLE(
    is_eligible BOOLEAN,
    reason TEXT
) AS $$
DECLARE
    challenger_rank INTEGER;
    opponent_rank INTEGER;
    challenge_range INTEGER;
    pending_challenges INTEGER;
    max_challenges INTEGER;
    recent_decline_date TIMESTAMP WITH TIME ZONE;
    cooldown_days INTEGER;
BEGIN
    -- Get ladder settings
    SELECT l.challenge_range, l.max_concurrent_challenges, l.challenge_cooldown_days
    INTO challenge_range, max_challenges, cooldown_days
    FROM ladders l
    WHERE l.id = p_ladder_id;
    
    -- Get player ranks
    SELECT lm.rank INTO challenger_rank
    FROM ladder_members lm
    WHERE lm.ladder_id = p_ladder_id AND lm.player_id = p_challenger_id AND lm.status = 'active';
    
    SELECT lm.rank INTO opponent_rank
    FROM ladder_members lm
    WHERE lm.ladder_id = p_ladder_id AND lm.player_id = p_opponent_id AND lm.status = 'active';
    
    -- Check if both players are in the ladder
    IF challenger_rank IS NULL THEN
        RETURN QUERY SELECT false, 'You are not an active member of this ladder';
        RETURN;
    END IF;
    
    IF opponent_rank IS NULL THEN
        RETURN QUERY SELECT false, 'Opponent is not an active member of this ladder';
        RETURN;
    END IF;
    
    -- Check rank range
    IF challenger_rank <= opponent_rank OR (challenger_rank - opponent_rank) > challenge_range THEN
        RETURN QUERY SELECT false, 'Opponent is outside your challenge range';
        RETURN;
    END IF;
    
    -- Check pending challenges count
    SELECT COUNT(*) INTO pending_challenges
    FROM challenges
    WHERE challenger_id = p_challenger_id 
        AND ladder_id = p_ladder_id 
        AND status = 'pending';
    
    IF pending_challenges >= max_challenges THEN
        RETURN QUERY SELECT false, 'You have reached the maximum number of pending challenges';
        RETURN;
    END IF;
    
    -- Check cooldown period after decline
    SELECT MAX(responded_at) INTO recent_decline_date
    FROM challenges
    WHERE challenger_id = p_challenger_id 
        AND opponent_id = p_opponent_id
        AND ladder_id = p_ladder_id 
        AND status = 'declined';
    
    IF recent_decline_date IS NOT NULL AND recent_decline_date > (NOW() - (cooldown_days || ' days')::INTERVAL) THEN
        RETURN QUERY SELECT false, 'You must wait before challenging this player again';
        RETURN;
    END IF;
    
    -- All checks passed
    RETURN QUERY SELECT true, 'Challenge is allowed';
END;
$$ LANGUAGE plpgsql;

COMMIT;

-- Rollback instructions:
-- DROP FUNCTION IF EXISTS public.is_challenge_eligible(UUID, UUID, UUID);
-- DROP FUNCTION IF EXISTS public.get_notification_template(TEXT);
-- -- If you inserted sample data, you would need to delete it:
-- -- DELETE FROM ladders WHERE id IN ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002');
