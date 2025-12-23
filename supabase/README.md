# Supabase Database Setup

Complete setup guide for the Elite Tennis Ladder Supabase backend.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Database Schema](#database-schema)
- [Running Migrations](#running-migrations)
- [Security](#security)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

## Overview

This directory contains the complete Supabase backend configuration for Elite Tennis Ladder, including:

- **11 Migration Files**: Complete database schema as code
- **Row Level Security**: Secure data access policies
- **Automated Triggers**: For rankings, notifications, and business logic
- **Database Functions**: Custom PL/pgSQL functions for complex operations
- **Useful Views**: Pre-built queries for common data access patterns

## Quick Start

### Prerequisites

- Node.js 16+ and npm
- PostgreSQL knowledge (basic)
- A Supabase account (free tier works)

### Option 1: Local Development (Recommended)

```bash
# 1. Install Supabase CLI
npm install -g supabase

# 2. Start local Supabase
supabase start

# 3. Apply all migrations
supabase db reset

# 4. Get your local credentials
supabase status
```

Your local Supabase is now running with the complete schema!

### Option 2: Remote Supabase Project

```bash
# 1. Install Supabase CLI
npm install -g supabase

# 2. Create a project at supabase.com

# 3. Link your project
supabase link --project-ref your-project-ref

# 4. Push migrations
supabase db push
```

## Detailed Setup

### 1. Create a Supabase Project (Remote Only)

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click **"New Project"**
3. Configure your project:
   - **Name**: `elite-tennis-ladder` (or your preference)
   - **Database Password**: Use a strong password (save it!)
   - **Region**: Choose closest to your users
   - **Plan**: Free tier is sufficient for development

### 2. Get Your API Credentials

#### For Remote Projects:

1. In your Supabase dashboard, navigate to **Settings → API**
2. Copy these values:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **Anon/Public Key**: `eyJhbGc...` (safe for client-side)
   - **Service Role Key**: `eyJhbGc...` (KEEP SECRET!)

#### For Local Development:

```bash
# Get local credentials
supabase status

# Look for:
# API URL: http://localhost:54321
# anon key: eyJhbGc...
```

### 3. Configure Environment Variables

1. **Copy the environment template**:
   ```bash
   cd /path/to/elite_tennis_ladder
   cp .env.example .env
   ```

2. **Update `.env` with your credentials**:
   ```bash
   # For remote Supabase
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   
   # For local Supabase
   SUPABASE_URL=http://localhost:54321
   SUPABASE_ANON_KEY=your-local-anon-key
   ```

3. **⚠️ NEVER commit `.env` to git!** (it's already in `.gitignore`)

### 4. Apply Database Migrations

All database schema is managed as code in `supabase/migrations/`.

#### Local Development:

```bash
# Apply all migrations (fresh start)
supabase db reset

# Or apply new migrations only
supabase db push
```

#### Remote/Production:

```bash
# Link to your project first
supabase link --project-ref your-project-ref

# Push migrations (only applies new ones)
supabase db push
```

#### Manual Migration (Alternative):

If you prefer not to use the CLI:

1. Go to your Supabase Dashboard → **SQL Editor**
2. Open each migration file in `supabase/migrations/` (in order)
3. Copy and paste the SQL
4. Execute each migration

## Database Schema

### Core Tables

| Table | Description |
|-------|-------------|
| `profiles` | User profiles extending auth.users |
| `ladders` | Tennis ladder configurations |
| `ladder_members` | Player membership and rankings |
| `challenges` | Match challenge requests |
| `matches` | Match results and scoring |
| `notifications` | In-app notification system |

### Key Features

✅ **11 Complete Migrations** covering all tables, functions, and triggers  
✅ **Row Level Security (RLS)** on all tables  
✅ **Automated Ranking Updates** after matches  
✅ **Notification System** with triggers  
✅ **Challenge Eligibility Validation**  
✅ **Performance Indexes** on all key columns  
✅ **Useful Views** for common queries  

### Schema Diagram

```
auth.users (Supabase Auth)
    ↓
profiles (User Profiles)
    ↓
┌─────────────────┐
│  ladder_members │ ←→ ladders (Ladder Config)
└─────────────────┘
    ↓
challenges (Challenge Requests)
    ↓
matches (Match Results)
    ↓
notifications (In-App Alerts)
```

See `migrations/README.md` for complete details on each migration.

## Running Migrations

### All Migrations at Once

```bash
# Fresh start (⚠️ destroys existing data)
supabase db reset

# Or apply new migrations only
supabase db push
```

### Individual Migrations

```bash
# Via psql
psql "your-connection-string" -f supabase/migrations/20250101000000_enable_extensions.sql
psql "your-connection-string" -f supabase/migrations/20250101000100_create_profiles_table.sql
# ... etc
```

### Verify Migrations

```bash
# Check schema
supabase db list

# Or connect directly
psql "your-connection-string" -c "\dt"  # List tables
psql "your-connection-string" -c "\df"  # List functions
psql "your-connection-string" -c "\dv"  # List views
```

## Security

### Row Level Security (RLS)

All tables have **RLS enabled** with granular policies:

#### Profiles
- ✅ Anyone can view profiles (public info)
- ✅ Users can only update their own profile

#### Ladders
- ✅ Public ladders viewable by all
- ✅ Private ladders only by members/admin
- ✅ Only admins can modify their ladder

#### Challenges & Matches
- ✅ Players see only their own challenges/matches
- ✅ Ladder members can view public matches
- ✅ Admins have full visibility

#### Notifications
- ✅ Users only see their own notifications

### Testing RLS Policies

```sql
-- Test as a specific user
SET LOCAL role TO authenticated;
SET LOCAL request.jwt.claim.sub TO 'user-uuid';

-- Run your query
SELECT * FROM profiles;

-- Reset
RESET ROLE;
```

## Testing

### Local Test Environment

```bash
# Start local Supabase with seed data
supabase start
supabase db reset

# Run your Flutter tests
flutter test
```

### Seed Data

The `20250101001000_seed_data.sql` migration includes helper functions for testing:

- `get_notification_template()` - Get notification text templates
- `is_challenge_eligible()` - Validate challenge rules

To add test users and ladders, modify the seed data migration.

## Real-time Subscriptions

All tables support Supabase real-time subscriptions:

```dart
// Example: Subscribe to ranking changes
final subscription = supabase
  .from('ladder_members')
  .stream(primaryKey: ['id'])
  .eq('player_id', userId)
  .listen((data) {
    // Handle ranking updates
  });
```

## Troubleshooting

### Issue: "permission denied" errors

**Cause**: RLS policies preventing access

**Solution**: 
- Check that `auth.uid()` matches expected user
- Verify user is authenticated
- Review RLS policies in migration files

### Issue: "relation already exists"

**Cause**: Migration already applied

**Solution**: 
- Migrations are idempotent, safe to re-run
- For fresh start: `supabase db reset`

### Issue: Trigger/function not found

**Cause**: Migrations run out of order

**Solution**: 
- Ensure migrations run by timestamp order
- Use `supabase db reset` to apply all in order

### Issue: Local Supabase won't start

**Solution**:
```bash
# Stop and remove containers
supabase stop --no-backup
docker system prune -a

# Start fresh
supabase start
```

### Issue: Can't connect to database

**Solution**:
```bash
# Check status
supabase status

# Ensure services are running
docker ps | grep supabase
```

## Useful Commands

```bash
# Start local Supabase
supabase start

# Stop local Supabase (keeps data)
supabase stop

# Stop and remove all data
supabase stop --no-backup

# View connection info
supabase status

# Create new migration
supabase migration new your_description

# Apply migrations
supabase db push

# Reset database (⚠️ destructive)
supabase db reset

# Generate TypeScript types from schema
supabase gen types typescript --local > lib/database.types.ts
```

## Directory Structure

```
supabase/
├── migrations/                         # All database migrations
│   ├── 20250101000000_enable_extensions.sql
│   ├── 20250101000100_create_profiles_table.sql
│   ├── 20250101000200_create_ladders_table.sql
│   ├── 20250101000300_create_ladder_members_table.sql
│   ├── 20250101000400_create_challenges_table.sql
│   ├── 20250101000500_create_matches_table.sql
│   ├── 20250101000600_create_notifications_table.sql
│   ├── 20250101000700_create_ranking_functions.sql
│   ├── 20250101000800_create_notification_triggers.sql
│   ├── 20250101000900_create_views.sql
│   ├── 20250101001000_seed_data.sql
│   └── README.md                      # Migration documentation
└── README.md                          # This file
```

## Additional Resources

- 📚 [Supabase Documentation](https://supabase.com/docs)
- 🔐 [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- ⚡ [Realtime Subscriptions](https://supabase.com/docs/guides/realtime)
- 📱 [Flutter + Supabase Quickstart](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- 🛠️ [Supabase CLI Reference](https://supabase.com/docs/reference/cli/introduction)
- 💾 [Database Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)

## Support

If you encounter issues:

1. Check this README and `migrations/README.md`
2. Review Supabase documentation
3. Check GitHub issues
4. Open a new issue with details

---

**Ready to build! 🎾** Your database is now fully configured as code and ready for development.
