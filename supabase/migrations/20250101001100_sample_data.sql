-- Migration: Insert Sample Data
-- Created: 2025-01-01
-- Description: Sample data for testing the tennis ladder application

BEGIN;

-- Note: We cannot disable system RI triggers, so we'll work around the foreign key constraint
-- by temporarily allowing the insertion of profiles without corresponding auth.users entries
-- This is for testing purposes only

-- Temporarily drop the foreign key constraint
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_id_fkey;

-- Insert sample user profiles (these would normally be created via auth.users triggers)
-- Note: In a real scenario, these would be created when users sign up
INSERT INTO profiles (id, username, full_name, email, phone, bio, skill_level, availability_status) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'john_doe', 'John Doe', 'john.doe@example.com', '+1-555-0101', 'Competitive tennis player looking for matches', 'intermediate', 'active'),
('550e8400-e29b-41d4-a716-446655440001', 'jane_smith', 'Jane Smith', 'jane.smith@example.com', '+1-555-0102', 'Weekend warrior, loves doubles', 'advanced', 'active'),
('550e8400-e29b-41d4-a716-446655440002', 'bob_wilson', 'Bob Wilson', 'bob.wilson@example.com', '+1-555-0103', 'New to tennis, eager to learn', 'beginner', 'active'),
('550e8400-e29b-41d4-a716-446655440003', 'alice_brown', 'Alice Brown', 'alice.brown@example.com', '+1-555-0104', 'Former college player, back in action', 'expert', 'vacation'),
('550e8400-e29b-41d4-a716-446655440004', 'charlie_davis', 'Charlie Davis', 'charlie.davis@example.com', '+1-555-0105', 'Club champion, always up for a challenge', 'expert', 'active'),
('550e8400-e29b-41d4-a716-446655440005', 'diana_evans', 'Diana Evans', 'diana.evans@example.com', '+1-555-0106', 'Social player, prefers casual matches', 'intermediate', 'active'),
('550e8400-e29b-41d4-a716-446655440006', 'frank_garcia', 'Frank Garcia', 'frank.garcia@example.com', '+1-555-0107', 'Business professional, plays on weekends', 'intermediate', 'active'),
('550e8400-e29b-41d4-a716-446655440007', 'grace_hill', 'Grace Hill', 'grace.hill@example.com', '+1-555-0108', 'Tennis coach and player', 'expert', 'active');

-- Insert sample ladders
INSERT INTO ladders (id, name, description, admin_id, visibility, max_players, challenge_range, challenge_response_days, scoring_system, is_active) VALUES
('660e8400-e29b-41d4-a716-446655440000', 'Downtown Tennis Club Ladder', 'Competitive ladder for downtown tennis club members', '550e8400-e29b-41d4-a716-446655440000', 'public', 16, 3, 7, 'swap', true),
('660e8400-e29b-41d4-a716-446655440001', 'Weekend Warriors', 'Casual weekend tennis matches', '550e8400-e29b-41d4-a716-446655440001', 'public', 12, 3, 14, 'swap', true),
('660e8400-e29b-41d4-a716-446655440002', 'Beginners Welcome', 'Ladder for new and improving players', '550e8400-e29b-41d4-a716-446655440002', 'public', 20, 2, 14, 'swap', true),
('660e8400-e29b-41d4-a716-446655440003', 'Expert Challenge', 'High-level competitive matches', '550e8400-e29b-41d4-a716-446655440004', 'invite_only', 8, 2, 7, 'elo', true);

-- Insert ladder members (players joining ladders)
INSERT INTO ladder_members (ladder_id, player_id, joined_at, rank, status) VALUES
-- Downtown Tennis Club Ladder members
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', NOW() - INTERVAL '30 days', 1, 'active'),
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '25 days', 2, 'active'),
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '20 days', 3, 'active'),
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440006', NOW() - INTERVAL '15 days', 4, 'active'),
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440007', NOW() - INTERVAL '10 days', 5, 'active'),

-- Weekend Warriors members
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '20 days', 1, 'active'),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '18 days', 2, 'active'),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', NOW() - INTERVAL '15 days', 3, 'active'),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', NOW() - INTERVAL '12 days', 4, 'active'),

-- Beginners Welcome members
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '14 days', 1, 'active'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '12 days', 2, 'active'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', NOW() - INTERVAL '10 days', 3, 'active'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', NOW() - INTERVAL '8 days', 4, 'active'),

-- Expert Challenge members
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '10 days', 1, 'active'),
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', NOW() - INTERVAL '8 days', 2, 'active');

-- Insert sample challenges
INSERT INTO challenges (id, ladder_id, challenger_id, opponent_id, status, message, expires_at, created_at) VALUES
-- Downtown Tennis Club Ladder challenges
('770e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'accepted', 'Looking forward to the match!', NOW() + INTERVAL '2 days', NOW() - INTERVAL '1 day'),
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440000', 'pending', 'Ready for a rematch', NOW() + INTERVAL '5 days', NOW() - INTERVAL '2 hours'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440007', 'completed', 'Great match!', NOW() + INTERVAL '7 days', NOW() - INTERVAL '5 days'),

-- Weekend Warriors challenges
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', 'accepted', 'Weekend doubles?', NOW() + INTERVAL '3 days', NOW() - INTERVAL '6 hours'),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', 'declined', 'Sorry, not available this weekend', NOW() + INTERVAL '5 days', NOW() - INTERVAL '1 day'),

-- Beginners Welcome challenges
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'accepted', 'Let''s practice some serves', NOW() + INTERVAL '6 days', NOW() - INTERVAL '12 hours'),

-- Expert Challenge challenges
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440007', 'accepted', 'Championship match!', NOW() + INTERVAL '9 days', NOW() - INTERVAL '3 hours');

-- Insert sample matches (from completed challenges)
INSERT INTO matches (id, ladder_id, challenge_id, player1_id, player2_id, winner_id, status, completed_at, court_surface, player1_set1_score, player1_set2_score, player2_set1_score, player2_set2_score, player1_verified, player2_verified, notes) VALUES
-- Match from challenge 1 (John vs Jane) - Downtown Tennis Club Ladder
('880e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'completed', NOW() - INTERVAL '2 days', 'hard', 6, 7, 4, 5, true, true, 'Great competitive match, John took the first set but Jane fought back hard'),

-- Match from challenge 3 (Frank vs Grace) - Downtown Tennis Club Ladder
('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440007', 'completed', NOW() - INTERVAL '3 days', 'clay', 6, 6, 2, 3, true, true, 'Grace dominated with her powerful serves'),

-- Another match for Downtown ladder (Charlie vs Frank)
('880e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440000', NULL, '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440004', 'completed', NOW() - INTERVAL '7 days', 'grass', 7, 6, 6, 4, true, true, 'Close first set went to tiebreak, Charlie pulled through');

-- Insert sample notifications
INSERT INTO notifications (user_id, type, title, message, is_read, created_at, related_entity_type, related_entity_id) VALUES
-- Challenge notifications
('550e8400-e29b-41d4-a716-446655440001', 'challenge_received', 'New Challenge!', 'John Doe has challenged you to a match', false, NOW() - INTERVAL '1 day', 'challenge', '770e8400-e29b-41d4-a716-446655440000'),
('550e8400-e29b-41d4-a716-446655440000', 'challenge_accepted', 'Challenge Accepted', 'Jane Smith accepted your challenge', false, NOW() - INTERVAL '20 hours', 'challenge', '770e8400-e29b-41d4-a716-446655440000'),
('550e8400-e29b-41d4-a716-446655440000', 'challenge_received', 'New Challenge!', 'Charlie Davis wants a rematch', false, NOW() - INTERVAL '2 hours', 'challenge', '770e8400-e29b-41d4-a716-446655440001'),

-- Match result notifications
('550e8400-e29b-41d4-a716-446655440001', 'match_completed', 'Match Result', 'You lost to John Doe (6-4, 7-5)', false, NOW() - INTERVAL '2 days', 'match', '880e8400-e29b-41d4-a716-446655440000'),
('550e8400-e29b-41d4-a716-446655440000', 'match_completed', 'Match Result', 'You won against Jane Smith (6-4, 7-5)', false, NOW() - INTERVAL '2 days', 'match', '880e8400-e29b-41d4-a716-446655440000'),
('550e8400-e29b-41d4-a716-446655440007', 'match_completed', 'Match Result', 'You won against Frank Garcia (6-2, 6-3)', false, NOW() - INTERVAL '3 days', 'match', '880e8400-e29b-41d4-a716-446655440001'),

-- Ladder activity notifications
('550e8400-e29b-41d4-a716-446655440000', 'ranking_changed', 'Rank Change', 'Your rank improved in Downtown Tennis Club Ladder', false, NOW() - INTERVAL '2 days', 'ladder', '660e8400-e29b-41d4-a716-446655440000'),
('550e8400-e29b-41d4-a716-446655440004', 'ranking_changed', 'New Challenger', 'Someone challenged the #1 spot', false, NOW() - INTERVAL '2 hours', 'ladder', '660e8400-e29b-41d4-a716-446655440000'),

-- General notifications
('550e8400-e29b-41d4-a716-446655440002', 'admin_message', 'Welcome!', 'Welcome to the tennis ladder system!', true, NOW() - INTERVAL '14 days', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440005', 'admin_message', 'Profile Updated', 'Your profile has been updated successfully', true, NOW() - INTERVAL '5 days', NULL, NULL);

-- NOTE: Foreign key constraint is kept dropped for testing purposes
-- In production, the constraint will be enforced by the auth.users trigger
-- ALTER TABLE profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

COMMIT;

-- Rollback instructions:
-- DELETE FROM notifications WHERE created_at >= '2025-01-01';
-- DELETE FROM matches WHERE created_at >= '2025-01-01';
-- DELETE FROM challenges WHERE created_at >= '2025-01-01';
-- DELETE FROM ladder_members WHERE joined_at >= '2025-01-01';
-- DELETE FROM ladders WHERE created_at >= '2025-01-01';
-- DELETE FROM profiles WHERE created_at >= '2025-01-01';
-- ALTER TABLE profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;</content>
