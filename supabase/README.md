# Supabase Configuration

This directory contains Supabase configuration and database migrations for the Elite Tennis Ladder application.

## Directory Structure

```
supabase/
├── migrations/          # Database migration files
│   └── README.md       # Migration guidelines
└── README.md           # This file
```

## Setup Instructions

### 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in project details:
   - Project name: `elite-tennis-ladder`
   - Database password: (choose a strong password)
   - Region: (choose closest to your users)
   - Pricing plan: Free tier is sufficient for development

### 2. Get Your API Keys

1. In your Supabase project dashboard, go to Settings → API
2. Copy the following values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **Anon/Public Key**: `eyJhbGc...` (safe to use in client-side code)
   - **Service Role Key**: `eyJhbGc...` (keep secret, only for server-side)

### 3. Configure Environment Variables

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Update the `.env` file with your Supabase credentials:
   ```
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

3. **Important**: Never commit the `.env` file to version control!

### 4. Database Schema Setup

The database schema will be defined in migration files. Key tables include:

- **users**: User profiles and authentication data
- **ladders**: Tennis ladder configurations
- **ladder_members**: Players in each ladder
- **challenges**: Challenge requests between players
- **matches**: Match results and scores
- **rankings**: Current player rankings in each ladder

### 5. Row Level Security (RLS)

Supabase uses PostgreSQL Row Level Security to ensure data privacy:

- Users can only read their own profile data
- Players can only see ladders they are members of
- Admins have full access to their ladder's data
- Match results require both players' confirmation

### 6. Real-time Subscriptions

The app will use Supabase real-time subscriptions for:

- Ladder ranking updates
- New challenge notifications
- Match result updates
- Score dispute alerts

### 7. Testing Configuration

For testing, you may want to:

1. Create a separate Supabase project for testing
2. Use a `.env.test` file with test credentials
3. Run migrations on the test database

## Database Migrations

Migrations are stored in the `migrations/` directory and should be applied in order.

To create a new migration:

1. Create a new file: `YYYYMMDDHHMMSS_description.sql`
2. Write your SQL migration
3. Apply migrations using Supabase CLI or dashboard

See `migrations/README.md` for detailed migration guidelines.

## Useful Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime Subscriptions](https://supabase.com/docs/guides/realtime)
- [Flutter + Supabase](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
