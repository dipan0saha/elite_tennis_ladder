# User Profile Feature Implementation

## Overview
This implementation adds user profile functionality to the Elite Tennis Ladder app, allowing users to:
- View and edit their profile information
- Upload and display avatar images
- Add a bio and personal information
- Set their tennis skill level
- Update phone number and other details

## Files Created/Modified

### Models
- **lib/models/user_profile.dart** - Data model representing user profiles
  - Maps to the `profiles` table in Supabase
  - Includes serialization (fromJson/toJson) methods
  - Supports copyWith for immutable updates

### Services
- **lib/services/profile_service.dart** - Service layer for profile operations
  - `getProfile(userId)` - Fetch any user's profile
  - `getCurrentUserProfile()` - Fetch authenticated user's profile
  - `updateProfile(...)` - Update profile fields
  - `uploadAvatar(...)` - Upload avatar image to Supabase Storage
  - `deleteAvatar(url)` - Remove avatar from storage

### Screens
- **lib/screens/profile_screen.dart** - Profile UI screen
  - Avatar display with camera icon overlay
  - Tap to change avatar (image picker integration)
  - Form fields for full name, phone, bio
  - Skill level dropdown (beginner/intermediate/advanced/expert)
  - Read-only username and email fields
  - Save button in AppBar and at bottom
  - Loading and saving states with progress indicators
  - Success/error snackbar notifications

### Navigation
- **lib/screens/home_screen.dart** - Updated home screen
  - Added profile icon button in AppBar
  - Navigation to ProfileScreen

### Database Migrations
- **supabase/migrations/20250101001200_create_avatars_storage.sql**
  - Creates 'avatars' storage bucket in Supabase
  - Sets up Row Level Security (RLS) policies
  - Public read access for avatars
  - User-specific upload/update/delete permissions

### Tests
- **test/models/user_profile_test.dart** - UserProfile model tests
  - JSON serialization/deserialization
  - copyWith functionality
  - Null handling for optional fields
  
- **test/services/profile_service_test.dart** - ProfileService tests
  - Basic instantiation tests
  - Note: Integration tests require test Supabase instance
  
- **test/screens/profile_screen_test.dart** - ProfileScreen widget tests
  - Basic widget rendering tests
  - Note: Comprehensive tests require mocking

### Dependencies
- **pubspec.yaml** - Added image_picker dependency
  - Version: ^1.0.4
  - No security vulnerabilities found

## Database Schema

The implementation uses the existing `profiles` table with these fields:
- `id` (UUID) - Primary key, references auth.users
- `username` (TEXT) - Unique username
- `full_name` (TEXT) - User's full name
- `email` (TEXT) - User's email address
- `phone` (TEXT) - Optional phone number
- `avatar_url` (TEXT) - Optional avatar image URL
- `bio` (TEXT) - Optional biography
- `skill_level` (TEXT) - Tennis skill level (beginner/intermediate/advanced/expert)
- `availability_status` (TEXT) - User status (active/vacation/injured/inactive)
- `notification_preferences` (JSONB) - Notification settings
- `privacy_settings` (JSONB) - Privacy settings
- `created_at` (TIMESTAMP) - Creation timestamp
- `updated_at` (TIMESTAMP) - Last update timestamp

## Storage Configuration

The avatars are stored in Supabase Storage:
- Bucket: `avatars` (public)
- Path structure: `{userId}/{filename}`
- File format: JPEG images
- Max dimensions: 1024x1024 pixels
- Quality: 85%

### RLS Policies
1. **Public Read**: Anyone can view avatars (public bucket)
2. **User Upload**: Users can only upload to their own folder
3. **User Update**: Users can only update their own avatars
4. **User Delete**: Users can only delete their own avatars

## User Flow

1. User logs in and lands on home screen
2. User clicks profile icon in AppBar
3. Profile screen loads with existing data
4. User can:
   - Tap avatar to select new image from gallery
   - Edit full name, phone, bio fields
   - Select skill level from dropdown
   - Click save button to persist changes
5. Avatar uploads to Supabase Storage
6. Profile data saves to database
7. Success message displayed
8. User returns to home screen

## UI Components

### Avatar Section
- Circular avatar (120x120 dp)
- Camera icon overlay (bottom-right)
- Displays either:
  - Selected image (from gallery)
  - Existing avatar URL
  - Default person icon

### Form Fields
1. **Full Name** (required)
   - Text input with person icon
   - Validation: Cannot be empty

2. **Username** (read-only)
   - Displays current username
   - Cannot be edited

3. **Email** (read-only)
   - Displays user email
   - Cannot be edited

4. **Phone** (optional)
   - Text input with phone icon
   - Numeric keyboard
   - No validation

5. **Bio** (optional)
   - Multi-line text input (4 lines)
   - 500 character limit
   - Description icon

6. **Skill Level** (optional)
   - Dropdown menu
   - Options: Beginner, Intermediate, Advanced, Expert
   - Tennis icon

### Buttons
- **Save (AppBar)**: Icon button in AppBar
- **Save (Bottom)**: Full-width elevated button
- Both disabled during save operation
- Show loading spinner when saving

## Testing

### Unit Tests
- Model serialization/deserialization
- Service instantiation
- Widget rendering

### Integration Tests (Requires Setup)
To properly test the full functionality:
1. Set up test Supabase project
2. Configure test credentials in .env
3. Create test user accounts
4. Run integration tests against test database

## Security Considerations

1. **Authentication**: All profile operations require authentication
2. **Authorization**: Users can only modify their own profiles
3. **RLS Policies**: Database-level security via Supabase RLS
4. **File Upload**: 
   - User-specific folders prevent unauthorized access
   - Image optimization reduces file size
   - Public bucket for easy avatar display

## Future Enhancements

Potential improvements for future sprints:
1. Image cropping before upload
2. Multiple profile photo support
3. Profile visibility settings
4. Tennis statistics (wins, losses, ranking)
5. Match history integration
6. Social features (followers, following)
7. Achievements and badges
8. Profile completion percentage

## Dependencies

- **flutter**: SDK
- **supabase_flutter**: ^2.0.0 (database and auth)
- **image_picker**: ^1.0.4 (avatar selection)
- **flutter_dotenv**: ^5.1.0 (environment variables)

## Notes

- Flutter SDK not available in current environment for build/test
- All code follows existing project patterns and conventions
- Uses Material Design 3 theming
- Responsive to light/dark mode
- Follows Flutter best practices
- Minimal changes to existing code
- No breaking changes to existing functionality
