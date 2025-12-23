-- Migration: Create Ranking Functions and Triggers
-- Created: 2025-01-01
-- Description: Implement automated ranking calculation logic

BEGIN;

-- Function to update ladder member statistics after match completion
CREATE OR REPLACE FUNCTION public.update_ladder_stats_after_match()
RETURNS TRIGGER AS $$
DECLARE
    loser_id UUID;
    ladder_settings RECORD;
BEGIN
    -- Only process when match is completed and verified
    IF NEW.status = 'completed' AND NEW.winner_id IS NOT NULL THEN
        -- Get ladder settings
        SELECT * INTO ladder_settings FROM ladders WHERE id = NEW.ladder_id;
        
        -- Determine loser
        loser_id := CASE 
            WHEN NEW.winner_id = NEW.player1_id THEN NEW.player2_id
            ELSE NEW.player1_id
        END;
        
        -- Update winner stats
        UPDATE ladder_members
        SET 
            wins = wins + 1,
            points = CASE 
                WHEN ladder_settings.scoring_system = 'points' THEN points + 100
                ELSE points
            END,
            consecutive_wins = consecutive_wins + 1,
            consecutive_losses = 0,
            last_match_date = NEW.completed_at
        WHERE 
            ladder_id = NEW.ladder_id AND 
            player_id = NEW.winner_id;
        
        -- Update loser stats
        UPDATE ladder_members
        SET 
            losses = losses + 1,
            points = CASE 
                WHEN ladder_settings.scoring_system = 'points' THEN GREATEST(points - 50, 0)
                ELSE points
            END,
            consecutive_losses = consecutive_losses + 1,
            consecutive_wins = 0,
            last_match_date = NEW.completed_at
        WHERE 
            ladder_id = NEW.ladder_id AND 
            player_id = loser_id;
        
        -- Update rankings based on scoring system
        IF ladder_settings.scoring_system = 'swap' THEN
            PERFORM update_swap_rankings(NEW.ladder_id, NEW.winner_id, loser_id);
        ELSIF ladder_settings.scoring_system = 'points' THEN
            PERFORM update_points_rankings(NEW.ladder_id);
        END IF;
        
        -- Mark challenge as completed if it exists
        IF NEW.challenge_id IS NOT NULL THEN
            UPDATE challenges
            SET 
                status = 'completed',
                completed_at = NEW.completed_at
            WHERE id = NEW.challenge_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to implement swap/leapfrog ranking algorithm
CREATE OR REPLACE FUNCTION public.update_swap_rankings(
    p_ladder_id UUID,
    p_winner_id UUID,
    p_loser_id UUID
)
RETURNS void AS $$
DECLARE
    winner_rank INTEGER;
    loser_rank INTEGER;
BEGIN
    -- Get current ranks
    SELECT rank INTO winner_rank FROM ladder_members 
    WHERE ladder_id = p_ladder_id AND player_id = p_winner_id;
    
    SELECT rank INTO loser_rank FROM ladder_members 
    WHERE ladder_id = p_ladder_id AND player_id = p_loser_id;
    
    -- Only update if winner was ranked lower (upset victory)
    IF winner_rank IS NOT NULL AND loser_rank IS NOT NULL AND winner_rank > loser_rank THEN
        -- Move winner to loser's position
        UPDATE ladder_members
        SET 
            rank = loser_rank,
            rank_change = loser_rank - winner_rank
        WHERE ladder_id = p_ladder_id AND player_id = p_winner_id;
        
        -- Shift everyone between old winner rank and loser rank down by 1
        UPDATE ladder_members
        SET 
            rank = rank + 1,
            rank_change = -1
        WHERE 
            ladder_id = p_ladder_id AND
            rank >= loser_rank AND
            rank < winner_rank AND
            player_id != p_winner_id;
        
        -- Update loser rank change
        UPDATE ladder_members
        SET rank_change = 1
        WHERE ladder_id = p_ladder_id AND player_id = p_loser_id;
    ELSE
        -- Higher ranked player won, no rank changes
        UPDATE ladder_members
        SET rank_change = 0
        WHERE ladder_id = p_ladder_id AND player_id IN (p_winner_id, p_loser_id);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to implement points-based ranking algorithm
CREATE OR REPLACE FUNCTION public.update_points_rankings(p_ladder_id UUID)
RETURNS void AS $$
BEGIN
    -- Recalculate all ranks based on points
    WITH ranked_players AS (
        SELECT 
            id,
            player_id,
            ROW_NUMBER() OVER (ORDER BY points DESC, wins DESC, created_at ASC) as new_rank,
            rank as old_rank
        FROM ladder_members
        WHERE ladder_id = p_ladder_id AND status = 'active'
    )
    UPDATE ladder_members lm
    SET 
        rank = rp.new_rank,
        rank_change = CASE
            WHEN rp.old_rank IS NULL THEN 0
            WHEN rp.old_rank > rp.new_rank THEN rp.old_rank - rp.new_rank  -- Moved up
            WHEN rp.old_rank < rp.new_rank THEN -(rp.new_rank - rp.old_rank) -- Moved down
            ELSE 0
        END
    FROM ranked_players rp
    WHERE lm.id = rp.id;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update stats and rankings after match completion
DROP TRIGGER IF EXISTS update_ladder_stats_trigger ON matches;
CREATE TRIGGER update_ladder_stats_trigger
    AFTER UPDATE ON matches
    FOR EACH ROW
    WHEN (NEW.status = 'completed' AND OLD.status != 'completed')
    EXECUTE FUNCTION public.update_ladder_stats_after_match();

-- Function to initialize rankings for new ladder members
CREATE OR REPLACE FUNCTION public.initialize_member_ranking()
RETURNS TRIGGER AS $$
DECLARE
    max_rank INTEGER;
BEGIN
    IF NEW.status = 'active' AND NEW.rank IS NULL THEN
        -- Get the current max rank in the ladder
        SELECT COALESCE(MAX(rank), 0) INTO max_rank
        FROM ladder_members
        WHERE ladder_id = NEW.ladder_id AND status = 'active';
        
        -- Assign next rank
        NEW.rank = max_rank + 1;
        NEW.joined_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to initialize ranking for new members
DROP TRIGGER IF EXISTS initialize_member_ranking_trigger ON ladder_members;
CREATE TRIGGER initialize_member_ranking_trigger
    BEFORE INSERT OR UPDATE ON ladder_members
    FOR EACH ROW
    WHEN (NEW.status = 'active')
    EXECUTE FUNCTION public.initialize_member_ranking();

COMMIT;

-- Rollback instructions:
-- DROP TRIGGER IF EXISTS initialize_member_ranking_trigger ON ladder_members;
-- DROP FUNCTION IF EXISTS public.initialize_member_ranking();
-- DROP TRIGGER IF EXISTS update_ladder_stats_trigger ON matches;
-- DROP FUNCTION IF EXISTS public.update_points_rankings(UUID);
-- DROP FUNCTION IF EXISTS public.update_swap_rankings(UUID, UUID, UUID);
-- DROP FUNCTION IF EXISTS public.update_ladder_stats_after_match();
