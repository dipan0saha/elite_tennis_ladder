-- Migration: Enable Required PostgreSQL Extensions
-- Created: 2025-01-01
-- Description: Enable necessary PostgreSQL extensions for UUID generation and other features

BEGIN;

-- Enable UUID generation extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable pgcrypto for additional cryptographic functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enable pg_net for HTTP requests (useful for webhooks/notifications)
-- Note: This extension may not be available in all Supabase instances
-- CREATE EXTENSION IF NOT EXISTS "pg_net";

COMMIT;

-- Rollback instructions:
-- DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;
-- DROP EXTENSION IF EXISTS "pgcrypto" CASCADE;
-- DROP EXTENSION IF EXISTS "pg_net" CASCADE;
