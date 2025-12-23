# User Profile Feature Architecture

## Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐                    ┌──────────────────────┐  │
│  │  HomeScreen  │ ──NavigateTo────▶  │   ProfileScreen      │  │
│  │              │                    │                      │  │
│  │  - Profile   │                    │  - Avatar Display    │  │
│  │    Button    │                    │  - Image Picker      │  │
│  │  - Logout    │                    │  - Form Fields       │  │
│  └──────────────┘                    │  - Save Button       │  │
│                                      │  - Validation        │  │
│                                      └──────────┬───────────┘  │
│                                                 │               │
└─────────────────────────────────────────────────┼───────────────┘
                                                  │
                                                  │ Uses
                                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Business Logic                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              ProfileService                              │  │
│  │                                                          │  │
│  │  + getProfile(userId)                                    │  │
│  │  + getCurrentUserProfile()                               │  │
│  │  + updateProfile(userId, data)                           │  │
│  │  + uploadAvatar(userId, imageFile, fileName)             │  │
│  │  + deleteAvatar(avatarUrl)                               │  │
│  │                                                          │  │
│  │  Uses: SupabaseClient                                    │  │
│  └──────────────────────┬───────────────────────────────────┘  │
│                         │                                       │
│                         │ Maps to/from                          │
│                         ▼                                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              UserProfile (Model)                         │  │
│  │                                                          │  │
│  │  Properties:                                             │  │
│  │  - id, username, fullName, email                         │  │
│  │  - phone, avatarUrl, bio                                 │  │
│  │  - skillLevel, availabilityStatus                        │  │
│  │  - createdAt, updatedAt                                  │  │
│  │                                                          │  │
│  │  Methods:                                                │  │
│  │  + fromJson(json) → UserProfile                          │  │
│  │  + toJson() → Map<String, dynamic>                       │  │
│  │  + copyWith(...) → UserProfile                           │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  │ Communicates with
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Data Layer (Supabase)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────┐        ┌──────────────────────────┐  │
│  │  Database (Postgres) │        │   Storage (Avatars)      │  │
│  │                      │        │                          │  │
│  │  profiles Table:     │        │  Bucket: avatars         │  │
│  │  ┌────────────────┐  │        │  Path: {userId}/file.jpg │  │
│  │  │ id (PK)        │  │        │                          │  │
│  │  │ username       │  │        │  RLS Policies:           │  │
│  │  │ full_name      │  │        │  - Public read           │  │
│  │  │ email          │  │        │  - User upload           │  │
│  │  │ phone          │  │        │  - User update           │  │
│  │  │ avatar_url     │  │        │  - User delete           │  │
│  │  │ bio            │  │        │                          │  │
│  │  │ skill_level    │  │        └──────────────────────────┘  │
│  │  │ ...            │  │                                      │
│  │  └────────────────┘  │                                      │
│  │                      │                                      │
│  │  RLS Policies:       │                                      │
│  │  - Public SELECT     │                                      │
│  │  - User UPDATE own   │                                      │
│  │  - User INSERT own   │                                      │
│  └──────────────────────┘                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Loading Profile
```
User clicks Profile button
     │
     ▼
ProfileScreen.initState()
     │
     ▼
ProfileService.getCurrentUserProfile()
     │
     ▼
Supabase: SELECT * FROM profiles WHERE id = auth.uid()
     │
     ▼
UserProfile.fromJson(response)
     │
     ▼
setState() → UI updates with profile data
```

### Saving Profile with Avatar
```
User edits fields and selects new avatar
     │
     ▼
User clicks Save button
     │
     ▼
Form validation
     │
     ▼
ProfileService.uploadAvatar(userId, imageFile, fileName)
     │
     ▼
Supabase Storage: Upload to avatars/{userId}/{fileName}
     │
     ▼
Get public URL for uploaded file
     │
     ▼
ProfileService.updateProfile(userId, {..., avatarUrl})
     │
     ▼
Supabase: UPDATE profiles SET ... WHERE id = userId
     │
     ▼
UserProfile.fromJson(response)
     │
     ▼
setState() → UI updates
     │
     ▼
Show success message
```

## Security Model

### Database (RLS Policies)
- **SELECT**: Anyone can view all profiles (public information)
- **UPDATE**: Users can only update their own profile (auth.uid() = id)
- **INSERT**: Users can only create their own profile (auth.uid() = id)

### Storage (RLS Policies)
- **SELECT**: Anyone can view avatars (public bucket)
- **INSERT**: Users can only upload to their folder ({userId}/)
- **UPDATE**: Users can only update their own avatars
- **DELETE**: Users can only delete their own avatars

## File Organization

```
lib/
├── models/
│   └── user_profile.dart          # Data model
├── services/
│   ├── auth_service.dart          # Authentication
│   └── profile_service.dart       # Profile operations (NEW)
├── screens/
│   ├── home_screen.dart           # Navigation to profile (UPDATED)
│   └── profile_screen.dart        # Profile UI (NEW)
└── main.dart

test/
├── models/
│   └── user_profile_test.dart     # Model tests (NEW)
├── services/
│   └── profile_service_test.dart  # Service tests (NEW)
└── screens/
    └── profile_screen_test.dart   # Screen tests (NEW)

supabase/
└── migrations/
    └── 20250101001200_create_avatars_storage.sql  # Storage setup (NEW)

docs/
└── USER_PROFILE_IMPLEMENTATION.md  # This documentation (NEW)
```

## Key Design Decisions

### 1. Separation of Concerns
- **Model**: Pure data structure with serialization
- **Service**: Business logic and API communication
- **Screen**: UI and user interaction

### 2. Image Handling
- Client-side optimization (1024x1024, 85% quality)
- User-specific folders in storage
- File overwrite on re-upload (upsert: true)

### 3. Form Management
- TextEditingController for text fields
- Dropdown for skill level
- Image picker for avatar
- Validation on save

### 4. Error Handling
- Try-catch blocks in all async operations
- User-friendly error messages via SnackBar
- Loading states during operations

### 5. State Management
- StatefulWidget with setState()
- Loading, saving, and error states
- Form validation

### 6. Optional Fields
- Empty strings converted to null for database
- Allows clearing of optional fields (phone, bio)
- Skill level can remain unset

## Testing Strategy

### Unit Tests
- Model: JSON serialization, copyWith, defaults
- Service: Instantiation (integration tests require DB)
- Screen: Basic rendering (full tests require mocking)

### Integration Tests (Not Included)
Would require:
- Test Supabase instance
- Test user credentials
- Mock image picker
- Widget interaction tests

## Performance Considerations

1. **Image Optimization**: Reduced to 1024x1024 @ 85% quality
2. **Lazy Loading**: Profile loads only when screen opens
3. **Efficient Updates**: Only modified fields sent to database
4. **Public Storage**: No auth required for avatar access
5. **Single Query**: Profile fetch with single SELECT

## Accessibility

- Semantic labels on form fields
- Icon descriptions (tooltips)
- Error messages read by screen readers
- Touch targets (48x48 minimum)
- Color contrast meets WCAG standards
