-- Migration: Create Database Views
-- Created: 2025-01-01
-- Description: Useful views for common queries

BEGIN;

-- View: Ladder Rankings with Player Details
CREATE OR REPLACE VIEW ladder_rankings AS
SELECT 
    lm.id,
    lm.ladder_id,
    l.name as ladder_name,
    lm.player_id,
    p.username,
    p.full_name,
    p.avatar_url,
    lm.rank,
    lm.points,
    lm.wins,
    lm.losses,
    lm.win_rate,
    lm.rank_change,
    lm.consecutive_wins,
    lm.consecutive_losses,
    lm.highest_rank,
    lm.last_match_date,
    lm.joined_at,
    lm.status,
    lm.division
FROM ladder_members lm
JOIN profiles p ON lm.player_id = p.id
JOIN ladders l ON lm.ladder_id = l.id
WHERE lm.status = 'active'
ORDER BY lm.ladder_id, lm.rank;

-- View: Match History with Player Details
CREATE OR REPLACE VIEW match_history AS
SELECT 
    m.id,
    m.ladder_id,
    l.name as ladder_name,
    m.challenge_id,
    m.player1_id,
    p1.username as player1_username,
    p1.full_name as player1_name,
    p1.avatar_url as player1_avatar,
    m.player2_id,
    p2.username as player2_username,
    p2.full_name as player2_name,
    p2.avatar_url as player2_avatar,
    m.winner_id,
    pw.username as winner_username,
    pw.full_name as winner_name,
    m.status,
    m.scheduled_at,
    m.started_at,
    m.completed_at,
    m.location,
    m.court_surface,
    m.player1_set1_score,
    m.player1_set2_score,
    m.player1_set3_score,
    m.player2_set1_score,
    m.player2_set2_score,
    m.player2_set3_score,
    m.player1_verified,
    m.player2_verified,
    m.created_at
FROM matches m
JOIN ladders l ON m.ladder_id = l.id
JOIN profiles p1 ON m.player1_id = p1.id
JOIN profiles p2 ON m.player2_id = p2.id
LEFT JOIN profiles pw ON m.winner_id = pw.id
ORDER BY m.completed_at DESC NULLS LAST, m.scheduled_at DESC;

-- View: Challenge Details with Player Information
CREATE OR REPLACE VIEW challenge_details AS
SELECT 
    c.id,
    c.ladder_id,
    l.name as ladder_name,
    c.challenger_id,
    p1.username as challenger_username,
    p1.full_name as challenger_name,
    p1.avatar_url as challenger_avatar,
    lm1.rank as challenger_rank,
    c.opponent_id,
    p2.username as opponent_username,
    p2.full_name as opponent_name,
    p2.avatar_url as opponent_avatar,
    lm2.rank as opponent_rank,
    c.status,
    c.message,
    c.decline_reason,
    c.expires_at,
    c.responded_at,
    c.created_at,
    -- Hours until expiry (negative means expired)
    EXTRACT(EPOCH FROM (c.expires_at - NOW())) / 3600 as hours_until_expiry
FROM challenges c
JOIN ladders l ON c.ladder_id = l.id
JOIN profiles p1 ON c.challenger_id = p1.id
JOIN profiles p2 ON c.opponent_id = p2.id
LEFT JOIN ladder_members lm1 ON c.ladder_id = lm1.ladder_id AND c.challenger_id = lm1.player_id
LEFT JOIN ladder_members lm2 ON c.ladder_id = lm2.ladder_id AND c.opponent_id = lm2.player_id
ORDER BY c.created_at DESC;

-- View: Ladder Statistics
CREATE OR REPLACE VIEW ladder_statistics AS
SELECT 
    l.id as ladder_id,
    l.name as ladder_name,
    l.admin_id,
    COUNT(DISTINCT lm.player_id) FILTER (WHERE lm.status = 'active') as active_members,
    COUNT(DISTINCT lm.player_id) FILTER (WHERE lm.status = 'pending') as pending_members,
    COUNT(DISTINCT m.id) FILTER (WHERE m.status = 'completed') as total_matches,
    COUNT(DISTINCT c.id) FILTER (WHERE c.status = 'pending') as pending_challenges,
    MAX(m.completed_at) as last_match_date,
    l.created_at,
    l.is_active
FROM ladders l
LEFT JOIN ladder_members lm ON l.id = lm.ladder_id
LEFT JOIN matches m ON l.id = m.ladder_id
LEFT JOIN challenges c ON l.id = c.ladder_id
GROUP BY l.id, l.name, l.admin_id, l.created_at, l.is_active;

-- View: Player Statistics
CREATE OR REPLACE VIEW player_statistics AS
SELECT 
    p.id as player_id,
    p.username,
    p.full_name,
    p.avatar_url,
    COUNT(DISTINCT lm.ladder_id) FILTER (WHERE lm.status = 'active') as ladders_joined,
    SUM(lm.wins) as total_wins,
    SUM(lm.losses) as total_losses,
    CASE 
        WHEN SUM(lm.wins + lm.losses) > 0 
        THEN ROUND((SUM(lm.wins)::DECIMAL / SUM(lm.wins + lm.losses)) * 100, 2)
        ELSE 0 
    END as overall_win_rate,
    MAX(lm.consecutive_wins) as best_win_streak,
    MIN(lm.rank) as best_rank_achieved,
    COUNT(DISTINCT m.id) FILTER (WHERE m.status = 'completed') as total_matches_played
FROM profiles p
LEFT JOIN ladder_members lm ON p.id = lm.player_id AND lm.status = 'active'
LEFT JOIN matches m ON (p.id = m.player1_id OR p.id = m.player2_id)
GROUP BY p.id, p.username, p.full_name, p.avatar_url;

-- View: Unread Notification Count per User
CREATE OR REPLACE VIEW unread_notifications_count AS
SELECT 
    user_id,
    COUNT(*) as unread_count
FROM notifications
WHERE is_read = false
GROUP BY user_id;

-- View: Recent Activity (for activity feeds)
CREATE OR REPLACE VIEW recent_activity AS
SELECT 
    'match' as activity_type,
    m.id as activity_id,
    m.ladder_id,
    l.name as ladder_name,
    m.completed_at as activity_date,
    p1.full_name || ' defeated ' || p2.full_name as activity_description,
    m.winner_id as primary_user_id,
    pw.full_name as primary_user_name,
    pw.avatar_url as primary_user_avatar
FROM matches m
JOIN ladders l ON m.ladder_id = l.id
JOIN profiles p1 ON m.player1_id = p1.id
JOIN profiles p2 ON m.player2_id = p2.id
JOIN profiles pw ON m.winner_id = pw.id
WHERE m.status = 'completed'

UNION ALL

SELECT 
    'challenge' as activity_type,
    c.id as activity_id,
    c.ladder_id,
    l.name as ladder_name,
    c.created_at as activity_date,
    p1.full_name || ' challenged ' || p2.full_name as activity_description,
    c.challenger_id as primary_user_id,
    p1.full_name as primary_user_name,
    p1.avatar_url as primary_user_avatar
FROM challenges c
JOIN ladders l ON c.ladder_id = l.id
JOIN profiles p1 ON c.challenger_id = p1.id
JOIN profiles p2 ON c.opponent_id = p2.id
WHERE c.status = 'accepted'

ORDER BY activity_date DESC
LIMIT 100;

COMMIT;

-- Rollback instructions:
-- DROP VIEW IF EXISTS recent_activity;
-- DROP VIEW IF EXISTS unread_notifications_count;
-- DROP VIEW IF EXISTS player_statistics;
-- DROP VIEW IF EXISTS ladder_statistics;
-- DROP VIEW IF EXISTS challenge_details;
-- DROP VIEW IF EXISTS match_history;
-- DROP VIEW IF EXISTS ladder_rankings;
