# Database Migrations

This directory contains SQL migration files for the Elite Tennis Ladder database schema.

## Migration Naming Convention

Migration files should follow this naming pattern:
```
YYYYMMDDHHMMSS_description.sql
```

Example:
```
20250123100000_create_users_table.sql
20250123100100_create_ladders_table.sql
20250123100200_create_challenges_table.sql
```

## Creating Migrations

### Using Supabase CLI (Recommended)

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Initialize Supabase in your project (if not done):
   ```bash
   supabase init
   ```

3. Create a new migration:
   ```bash
   supabase migration new description_of_change
   ```

4. Edit the generated migration file in `supabase/migrations/`

5. Apply migrations:
   ```bash
   supabase db push
   ```

### Manual Migration Creation

1. Create a new `.sql` file with the naming convention above
2. Write your SQL schema changes
3. Apply via Supabase Dashboard SQL Editor or CLI

## Migration Best Practices

1. **One change per migration**: Keep migrations focused on a single logical change
2. **Include rollback**: Add comments explaining how to rollback if needed
3. **Test thoroughly**: Test migrations on a development database first
4. **Use transactions**: Wrap changes in transactions when possible
5. **Add comments**: Document why changes are being made
6. **Order matters**: Migrations run in alphanumeric order

## Example Migration Structure

```sql
-- Migration: Create users table
-- Created: 2025-01-23
-- Description: Initial user profile table with basic authentication fields

BEGIN;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    skill_level TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can read their own data
CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

-- Create policy: Users can update their own data
CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

COMMIT;

-- Rollback instructions:
-- DROP TABLE IF EXISTS users CASCADE;
```

## Applying Migrations

### Development
```bash
supabase db reset  # Reset and apply all migrations
```

### Production
```bash
supabase db push  # Apply new migrations only
```

## Troubleshooting

- **Migration failed**: Check syntax and dependencies
- **Order issues**: Ensure timestamps are correct
- **RLS errors**: Verify policies are correctly configured

## Future Migrations

Planned migrations for Elite Tennis Ladder:

1. ⬜ Users table
2. ⬜ Ladders table
3. ⬜ Ladder members table
4. ⬜ Challenges table
5. ⬜ Matches table
6. ⬜ Rankings table
7. ⬜ Notifications table
8. ⬜ Indexes for performance
9. ⬜ Functions and triggers
10. ⬜ Real-time subscriptions setup
