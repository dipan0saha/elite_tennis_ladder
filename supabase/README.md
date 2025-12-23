# Supabase Configuration

This directory contains Supabase configuration and database migrations for the Elite Tennis Ladder application.

## Directory Structure

```
supabase/
├── migrations/          # Database migration files
│   ├── 20251223000000_initial_schema.sql  # Initial schema with profiles table
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

The current database schema includes:

- **profiles**: User profile data linked to Supabase Auth users
  - Stores additional user information (full_name, bio, skill_level, etc.)
  - Automatically created when users sign up
  - Row Level Security enabled for user privacy

### 5. Apply Database Migration

**Important**: You need to manually apply the migration to your Supabase database:

1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Navigate to your project: `elite-tennis-ladder`
3. Go to **SQL Editor**
4. Copy and paste the contents of `supabase/migrations/20251223000000_initial_schema.sql`
5. Click **Run** to execute the migration

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

Current migration:
- `20251223000000_initial_schema.sql`: Creates profiles table with RLS policies and triggers

To create future migrations:
1. Create a new file: `YYYYMMDDHHMMSS_description.sql`
2. Write your SQL migration
3. Apply via Supabase Dashboard SQL Editor

## Useful Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter + Supabase](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime Subscriptions](https://supabase.com/docs/guides/realtime)
- [Flutter + Supabase](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
