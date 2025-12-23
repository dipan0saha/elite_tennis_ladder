# Database Migrations

This directory contains SQL migration files for the Elite Tennis Ladder database schema.

## Migration Files

All migrations are organized in execution order:

1. ✅ `20250101000000_enable_extensions.sql` - Enable PostgreSQL extensions (uuid-ossp, pgcrypto)
2. ✅ `20250101000100_create_profiles_table.sql` - User profiles table with RLS policies
3. ✅ `20250101000200_create_ladders_table.sql` - Ladder configurations with RLS policies
4. ✅ `20250101000300_create_ladder_members_table.sql` - Player membership tracking with RLS policies
5. ✅ `20250101000400_create_challenges_table.sql` - Challenge system with RLS policies
6. ✅ `20250101000500_create_matches_table.sql` - Match tracking and scoring with RLS policies
7. ✅ `20250101000600_create_notifications_table.sql` - In-app notifications with RLS policies
8. ✅ `20250101000700_create_ranking_functions.sql` - Ranking calculation functions and triggers
9. ✅ `20250101000800_create_notification_triggers.sql` - Automated notification triggers
10. ✅ `20250101000900_create_views.sql` - Useful database views for queries
11. ✅ `20250101001000_seed_data.sql` - Helper functions and optional seed data

## Quick Start

### Prerequisites

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Ensure you have a Supabase project (local or remote)

### Option 1: Apply All Migrations (Recommended for New Projects)

For a **fresh local development instance**:

```bash
# Start local Supabase
supabase start

# Apply all migrations
supabase db reset
```

For a **remote Supabase project**:

```bash
# Link your project
supabase link --project-ref your-project-ref

# Push migrations
supabase db push
```

### Option 2: Manual Migration Execution

If you prefer to run migrations manually via psql or Supabase Dashboard:

1. **Get Database Connection String** from your Supabase project settings
2. **Execute migrations in order** using psql:

```bash
# Example for local Supabase
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/migrations/20250101000000_enable_extensions.sql
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/migrations/20250101000100_create_profiles_table.sql
# ... continue for all migrations
```

3. **Or use Supabase Dashboard**:
   - Go to SQL Editor in your Supabase Dashboard
   - Copy and paste the content of each migration file
   - Execute them in order

## Migration Characteristics

### Idempotency

All migrations are **idempotent** and can be safely run multiple times:

- Use `CREATE TABLE IF NOT EXISTS`
- Use `CREATE OR REPLACE FUNCTION`
- Use `DROP TRIGGER IF EXISTS` before creating triggers
- Use `CREATE INDEX IF NOT EXISTS`

### Transactions

All migrations use **transactions** (`BEGIN` and `COMMIT`) to ensure:

- Atomic execution (all-or-nothing)
- Automatic rollback on errors
- Data consistency

### Rollback Support

Each migration includes **rollback instructions** in comments at the bottom:

```sql
-- Rollback instructions:
-- DROP TABLE IF EXISTS table_name CASCADE;
-- DROP FUNCTION IF EXISTS function_name();
```

## Migration Features

### Core Tables

- **profiles**: User profiles extending Supabase auth.users
- **ladders**: Tennis ladder configurations
- **ladder_members**: Player membership and rankings
- **challenges**: Match challenge requests
- **matches**: Match results and scoring
- **notifications**: In-app notification system

### Security (Row Level Security)

All tables have **RLS enabled** with appropriate policies:

- Users can only view/update their own data
- Ladder admins have elevated permissions
- Public data (rankings, etc.) is viewable by all
- Sensitive data is protected

### Automation

**Automatic Triggers** handle:

- Profile creation on user signup
- Ranking updates after match completion
- Notification creation for key events
- Challenge expiration
- Timestamp updates

**Database Functions** implement:

- Swap/leapfrog ranking algorithm
- Points-based ranking system
- Challenge eligibility validation
- Notification management

### Performance

**Indexes** are created on:

- Foreign key columns
- Frequently queried fields (status, rank, dates)
- Composite indexes for common queries

**Views** provide:

- Ladder rankings with player details
- Match history
- Challenge details
- Player and ladder statistics
- Recent activity feeds

## Verification

After applying migrations, verify the schema:

```bash
# List all tables
supabase db list

# Or connect to database
psql "your-connection-string" -c "\dt"

# Check functions
psql "your-connection-string" -c "\df public.*"

# Check views
psql "your-connection-string" -c "\dv"
```

## Creating New Migrations

### Using Supabase CLI (Recommended)

```bash
# Create a new migration
supabase migration new your_migration_description

# This creates: supabase/migrations/YYYYMMDDHHMMSS_your_migration_description.sql
```

### Manual Creation

1. Create a new file following the naming convention:
   ```
   YYYYMMDDHHMMSS_description.sql
   ```

2. Use this template:
   ```sql
   -- Migration: [Description]
   -- Created: [Date]
   -- Description: [Detailed explanation]

   BEGIN;

   -- Your SQL changes here
   
   COMMIT;

   -- Rollback instructions:
   -- [SQL to undo changes]
   ```

3. Ensure migration is:
   - **Idempotent**: Can run multiple times safely
   - **Atomic**: Uses transactions
   - **Documented**: Clear comments and rollback instructions

### Migration Best Practices

1. ✅ **One logical change per migration**
2. ✅ **Test on local/staging before production**
3. ✅ **Use transactions (BEGIN/COMMIT)**
4. ✅ **Make migrations idempotent**
5. ✅ **Include rollback instructions**
6. ✅ **Add descriptive comments**
7. ✅ **Consider backward compatibility**
8. ✅ **Backup production data before major changes**

## Troubleshooting

### Common Issues

**Issue**: Migration fails with "permission denied"

**Solution**: Ensure you're using the `postgres` role or have sufficient privileges

---

**Issue**: "relation already exists" error

**Solution**: Migrations are idempotent, but check for conflicting objects

---

**Issue**: RLS policy prevents access

**Solution**: Check policy definitions and ensure `auth.uid()` is available

---

**Issue**: Function or trigger not found

**Solution**: Ensure migrations run in correct order (by timestamp)

### Getting Help

- Check migration logs: `supabase db inspect`
- View database logs in Supabase Dashboard
- Test migrations on a fresh local instance first

## Environment-Specific Notes

### Local Development

```bash
# Start Supabase locally
supabase start

# Apply migrations
supabase db reset

# Stop when done
supabase stop
```

### Staging/Production

```bash
# Link to remote project
supabase link --project-ref your-project-ref

# Push only new migrations
supabase db push

# Never use db reset in production!
```

## Schema Diagram

```
auth.users (Supabase)
    ↓
profiles (1:1)
    ↓
ladder_members (N:M with ladders)
    ↓
ladders ← admin_id
    ↓
challenges ← ladder_id, challenger_id, opponent_id
    ↓
matches ← ladder_id, challenge_id, player1_id, player2_id
    ↓
notifications ← related to challenges, matches, rankings
```

## Additional Resources

- [Supabase Migrations Documentation](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [PostgreSQL Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli/introduction)
