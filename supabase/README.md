# Supabase Configuration

This directory contains Supabase configuration and database migrations for the Elite Tennis Ladder application.

## Directory Structure

```
supabase/
├── migrations/          # Database migration files
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
│   ├── 20250101001100_sample_data.sql  # Sample data for testing
│   └── README.md       # Migration guidelines
└── README.md           # This file
```

## Current Setup Status

✅ **Supabase Project**: Created and linked  
✅ **Environment Variables**: Configured in `.env` file  
✅ **Database Schema**: Migration file ready for application  
✅ **Test Infrastructure**: Supabase test helpers and updated test files  
⚠️ **Database Migration**: Needs manual application in Supabase Dashboard  
⚠️ **Email Confirmations**: Should be disabled for testing  

## Setup Instructions

### 1. Supabase Project (Already Completed)

Your Supabase project is already set up:
- **Project URL**: `https://vgygheamrsozgmwcldfh.supabase.co`
- **Status**: Linked and ready for use

### 2. API Keys (Already Configured)

Your API keys are stored in the `.env` file in the project root:
```
SUPABASE_URL=https://vgygheamrsozgmwcldfh.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
```

### 3. Environment Variables (Already Configured)

The `.env` file has been created and configured with your Supabase credentials. **Never commit this file to version control!**

### 4. Database Schema Setup

The database schema includes comprehensive tables for the tennis ladder system:

- **profiles**: User profiles with tennis-specific fields (skill level, availability, etc.)
- **ladders**: Ladder configurations and settings
- **ladder_members**: Player memberships in ladders
- **challenges**: Challenge requests between players
- **matches**: Match results and scoring
- **notifications**: In-app notification system
- Plus ranking functions, triggers, and database views

All tables use Row Level Security (RLS) for data privacy and security.

### 5. Apply Database Migrations

**Important**: You need to apply all migration files to your Supabase database in order:

1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Navigate to your project: `elite-tennis-ladder`
3. Go to **SQL Editor**

For each migration file in order, copy and paste the contents and click **Run**:

1. `supabase/migrations/20250101000000_enable_extensions.sql`
2. `supabase/migrations/20250101000100_create_profiles_table.sql`
3. `supabase/migrations/20250101000200_create_ladders_table.sql`
4. `supabase/migrations/20250101000300_create_ladder_members_table.sql`
5. `supabase/migrations/20250101000400_create_challenges_table.sql`
6. `supabase/migrations/20250101000500_create_matches_table.sql`
7. `supabase/migrations/20250101000600_create_notifications_table.sql`
8. `supabase/migrations/20250101000700_create_ranking_functions.sql`
9. `supabase/migrations/20250101000800_create_notification_triggers.sql`
10. `supabase/migrations/20250101000900_create_views.sql`
11. `supabase/migrations/20250101001000_seed_data.sql` (optional)
12. `supabase/migrations/20250101001100_sample_data.sql` (optional - for testing)

### 6. Disable Email Confirmations (For Testing)

For development and testing:

1. In Supabase Dashboard, go to **Authentication → Settings**
2. Scroll to **Email Confirmations**
3. Turn off **Enable email confirmations**
4. Save changes

### 7. Row Level Security (RLS)

The profiles table uses PostgreSQL Row Level Security:

- Users can only read/update their own profile data
- Profile creation is handled automatically via database trigger
- All operations are secured at the database level

### 8. Testing Configuration

The app includes comprehensive test setup:

1. **Test Helper**: `test/helpers/supabase_test_helper.dart`
   - Initializes Supabase for testing
   - Loads environment variables from `.env`
   - Sets up test bindings

2. **Test Files Updated**:
   - All test files now initialize Supabase
   - Skip flags removed from Supabase-dependent tests
   - 40 unit tests pass, 42 integration tests ready for device testing

3. **Running Tests**:
   ```bash
   # Unit tests (no Supabase required)
   flutter test test/utils/ test/services/
   
   # Integration tests (requires device/emulator)
   flutter test integration_test/
   
   # All tests (requires device/emulator)
   flutter test
   ```

## Database Migrations

Current migrations (apply in this order):
1. `20250101000000_enable_extensions.sql` - Enable PostgreSQL extensions
2. `20250101000100_create_profiles_table.sql` - User profiles table with RLS
3. `20250101000200_create_ladders_table.sql` - Ladder configurations
4. `20250101000300_create_ladder_members_table.sql` - Player memberships
5. `20250101000400_create_challenges_table.sql` - Challenge system
6. `20250101000500_create_matches_table.sql` - Match tracking
7. `20250101000600_create_notifications_table.sql` - Notifications system
8. `20250101000700_create_ranking_functions.sql` - Ranking calculations
9. `20250101000800_create_notification_triggers.sql` - Notification triggers
10. `20250101000900_create_views.sql` - Database views
11. `20250101001000_seed_data.sql` - Helper functions and seed data
12. `20250101001100_sample_data.sql` - Sample data for testing

To create future migrations:
1. Create a new file: `YYYYMMDDHHMMSS_description.sql`
2. Write your SQL migration
3. Apply via Supabase Dashboard SQL Editor

## Useful Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime Subscriptions](https://supabase.com/docs/guides/realtime)
- [Flutter + Supabase](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
