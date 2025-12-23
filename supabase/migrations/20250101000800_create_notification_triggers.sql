-- Migration: Create Notification Triggers
-- Created: 2025-01-01
-- Description: Automatically create notifications for key events

BEGIN;

-- Function to notify on new challenge
CREATE OR REPLACE FUNCTION public.notify_challenge_created()
RETURNS TRIGGER AS $$
DECLARE
    challenger_name TEXT;
BEGIN
    -- Get challenger's name
    SELECT full_name INTO challenger_name FROM profiles WHERE id = NEW.challenger_id;
    
    -- Create notification for opponent
    PERFORM create_notification(
        NEW.opponent_id,
        'challenge_received',
        'New Challenge!',
        challenger_name || ' has challenged you to a match.',
        'challenge',
        NEW.id,
        '/challenges/' || NEW.id::TEXT
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for challenge creation
DROP TRIGGER IF EXISTS notify_challenge_created_trigger ON challenges;
CREATE TRIGGER notify_challenge_created_trigger
    AFTER INSERT ON challenges
    FOR EACH ROW
    EXECUTE FUNCTION public.notify_challenge_created();

-- Function to notify on challenge response
CREATE OR REPLACE FUNCTION public.notify_challenge_response()
RETURNS TRIGGER AS $$
DECLARE
    opponent_name TEXT;
BEGIN
    IF NEW.status != OLD.status AND NEW.status IN ('accepted', 'declined') THEN
        -- Get opponent's name
        SELECT full_name INTO opponent_name FROM profiles WHERE id = NEW.opponent_id;
        
        -- Notify challenger
        PERFORM create_notification(
            NEW.challenger_id,
            'challenge_' || NEW.status,
            CASE 
                WHEN NEW.status = 'accepted' THEN 'Challenge Accepted!'
                ELSE 'Challenge Declined'
            END,
            opponent_name || ' has ' || NEW.status || ' your challenge.',
            'challenge',
            NEW.id,
            '/challenges/' || NEW.id::TEXT
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for challenge response
DROP TRIGGER IF EXISTS notify_challenge_response_trigger ON challenges;
CREATE TRIGGER notify_challenge_response_trigger
    AFTER UPDATE ON challenges
    FOR EACH ROW
    WHEN (NEW.status IN ('accepted', 'declined', 'expired'))
    EXECUTE FUNCTION public.notify_challenge_response();

-- Function to notify on ranking change
CREATE OR REPLACE FUNCTION public.notify_ranking_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rank_change != 0 AND NEW.rank_change IS NOT NULL THEN
        PERFORM create_notification(
            NEW.player_id,
            'ranking_changed',
            CASE 
                WHEN NEW.rank_change > 0 THEN 'You moved up!'
                ELSE 'Ranking Update'
            END,
            CASE 
                WHEN NEW.rank_change > 0 THEN 'Congratulations! You moved up ' || ABS(NEW.rank_change)::TEXT || ' position(s) to rank #' || NEW.rank::TEXT
                ELSE 'Your ranking changed to #' || NEW.rank::TEXT
            END,
            'ladder',
            NEW.ladder_id,
            '/ladders/' || NEW.ladder_id::TEXT || '/rankings'
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for ranking change notification
DROP TRIGGER IF EXISTS notify_ranking_change_trigger ON ladder_members;
CREATE TRIGGER notify_ranking_change_trigger
    AFTER UPDATE ON ladder_members
    FOR EACH ROW
    WHEN (NEW.rank_change != 0 OR (OLD.rank IS DISTINCT FROM NEW.rank))
    EXECUTE FUNCTION public.notify_ranking_change();

-- Function to notify on match completion
CREATE OR REPLACE FUNCTION public.notify_match_completion()
RETURNS TRIGGER AS $$
DECLARE
    winner_name TEXT;
    opponent_id UUID;
BEGIN
    IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
        -- Get winner's name
        SELECT full_name INTO winner_name FROM profiles WHERE id = NEW.winner_id;
        
        -- Notify both players
        -- Notify player 1
        PERFORM create_notification(
            NEW.player1_id,
            'match_completed',
            'Match Completed',
            CASE 
                WHEN NEW.winner_id = NEW.player1_id THEN 'Congratulations! You won the match.'
                ELSE 'Match completed. Better luck next time!'
            END,
            'match',
            NEW.id,
            '/matches/' || NEW.id::TEXT
        );
        
        -- Notify player 2
        PERFORM create_notification(
            NEW.player2_id,
            'match_completed',
            'Match Completed',
            CASE 
                WHEN NEW.winner_id = NEW.player2_id THEN 'Congratulations! You won the match.'
                ELSE 'Match completed. Better luck next time!'
            END,
            'match',
            NEW.id,
            '/matches/' || NEW.id::TEXT
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for match completion
DROP TRIGGER IF EXISTS notify_match_completion_trigger ON matches;
CREATE TRIGGER notify_match_completion_trigger
    AFTER UPDATE ON matches
    FOR EACH ROW
    WHEN (NEW.status = 'completed')
    EXECUTE FUNCTION public.notify_match_completion();

-- Function to notify on score verification needed
CREATE OR REPLACE FUNCTION public.notify_score_verification()
RETURNS TRIGGER AS $$
DECLARE
    reporter_name TEXT;
BEGIN
    -- Only notify if one player verified but not the other
    IF NEW.player1_verified != OLD.player1_verified AND NEW.player1_verified = true AND NEW.player2_verified = false THEN
        SELECT full_name INTO reporter_name FROM profiles WHERE id = NEW.player1_id;
        PERFORM create_notification(
            NEW.player2_id,
            'score_verification_required',
            'Score Verification Needed',
            reporter_name || ' has reported the match score. Please verify.',
            'match',
            NEW.id,
            '/matches/' || NEW.id::TEXT
        );
    ELSIF NEW.player2_verified != OLD.player2_verified AND NEW.player2_verified = true AND NEW.player1_verified = false THEN
        SELECT full_name INTO reporter_name FROM profiles WHERE id = NEW.player2_id;
        PERFORM create_notification(
            NEW.player1_id,
            'score_verification_required',
            'Score Verification Needed',
            reporter_name || ' has reported the match score. Please verify.',
            'match',
            NEW.id,
            '/matches/' || NEW.id::TEXT
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for score verification notification
DROP TRIGGER IF EXISTS notify_score_verification_trigger ON matches;
CREATE TRIGGER notify_score_verification_trigger
    AFTER UPDATE ON matches
    FOR EACH ROW
    WHEN ((NEW.player1_verified IS DISTINCT FROM OLD.player1_verified) OR 
          (NEW.player2_verified IS DISTINCT FROM OLD.player2_verified))
    EXECUTE FUNCTION public.notify_score_verification();

COMMIT;

-- Rollback instructions:
-- DROP TRIGGER IF EXISTS notify_score_verification_trigger ON matches;
-- DROP FUNCTION IF EXISTS public.notify_score_verification();
-- DROP TRIGGER IF EXISTS notify_match_completion_trigger ON matches;
-- DROP FUNCTION IF EXISTS public.notify_match_completion();
-- DROP TRIGGER IF EXISTS notify_ranking_change_trigger ON ladder_members;
-- DROP FUNCTION IF EXISTS public.notify_ranking_change();
-- DROP TRIGGER IF EXISTS notify_challenge_response_trigger ON challenges;
-- DROP FUNCTION IF EXISTS public.notify_challenge_response();
-- DROP TRIGGER IF EXISTS notify_challenge_created_trigger ON challenges;
-- DROP FUNCTION IF EXISTS public.notify_challenge_created();
