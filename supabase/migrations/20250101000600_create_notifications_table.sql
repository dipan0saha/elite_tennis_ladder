-- Migration: Create Notifications Table
-- Created: 2025-01-01
-- Description: Track in-app notifications for users

BEGIN;

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN (
        'challenge_received',
        'challenge_accepted',
        'challenge_declined',
        'challenge_cancelled',
        'challenge_expired',
        'match_scheduled',
        'match_reminder',
        'match_completed',
        'score_verification_required',
        'score_disputed',
        'ranking_changed',
        'inactivity_warning',
        'ladder_invitation',
        'admin_message'
    )),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    related_entity_type TEXT CHECK (related_entity_type IN ('challenge', 'match', 'ladder', 'profile')),
    related_entity_id UUID,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    action_url TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);

-- Enable Row Level Security
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only view their own notifications
CREATE POLICY "Users can view own notifications"
    ON notifications FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: System/app can insert notifications (handled by functions)
CREATE POLICY "System can insert notifications"
    ON notifications FOR INSERT
    WITH CHECK (true);

-- Policy: Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications"
    ON notifications FOR UPDATE
    USING (auth.uid() = user_id);

-- Policy: Users can delete their own notifications
CREATE POLICY "Users can delete own notifications"
    ON notifications FOR DELETE
    USING (auth.uid() = user_id);

-- Function to mark notification as read
CREATE OR REPLACE FUNCTION public.mark_notification_read(notification_id UUID)
RETURNS void AS $$
BEGIN
    UPDATE notifications
    SET 
        is_read = true,
        read_at = NOW()
    WHERE 
        id = notification_id AND
        user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to mark all notifications as read
CREATE OR REPLACE FUNCTION public.mark_all_notifications_read()
RETURNS void AS $$
BEGIN
    UPDATE notifications
    SET 
        is_read = true,
        read_at = NOW()
    WHERE 
        user_id = auth.uid() AND
        is_read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create notification
CREATE OR REPLACE FUNCTION public.create_notification(
    p_user_id UUID,
    p_type TEXT,
    p_title TEXT,
    p_message TEXT,
    p_related_entity_type TEXT DEFAULT NULL,
    p_related_entity_id UUID DEFAULT NULL,
    p_action_url TEXT DEFAULT NULL,
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS UUID AS $$
DECLARE
    new_notification_id UUID;
BEGIN
    INSERT INTO notifications (
        user_id,
        type,
        title,
        message,
        related_entity_type,
        related_entity_id,
        action_url,
        metadata
    ) VALUES (
        p_user_id,
        p_type,
        p_title,
        p_message,
        p_related_entity_type,
        p_related_entity_id,
        p_action_url,
        p_metadata
    )
    RETURNING id INTO new_notification_id;
    
    RETURN new_notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;

-- Rollback instructions:
-- DROP FUNCTION IF EXISTS public.create_notification(UUID, TEXT, TEXT, TEXT, TEXT, UUID, TEXT, JSONB);
-- DROP FUNCTION IF EXISTS public.mark_all_notifications_read();
-- DROP FUNCTION IF EXISTS public.mark_notification_read(UUID);
-- DROP TABLE IF EXISTS notifications CASCADE;
