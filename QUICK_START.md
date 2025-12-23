# Quick Start Guide - Supabase Authentication

This guide will help you get started with the newly implemented Supabase authentication in the Elite Tennis Ladder app.

## Prerequisites

- Flutter SDK 3.16.0 or higher
- A Supabase account and project ([sign up here](https://supabase.com))

## Setup (5 minutes)

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/dipan0saha/elite_tennis_ladder.git
cd elite_tennis_ladder
flutter pub get
```

### 2. Configure Supabase Credentials

Create your `.env` file from the template:

```bash
cp .env.example .env
```

Edit `.env` and add your Supabase credentials:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**Where to find these values:**
1. Go to your [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Click on "Settings" (gear icon) → "API"
4. Copy the "Project URL" (SUPABASE_URL)
5. Copy the "anon/public" key (SUPABASE_ANON_KEY)

### 3. Run the App

```bash
flutter run
```

That's it! The app should now open with the login screen.

## Features Available

### For Users

1. **Sign Up**: Create a new account with email and password
2. **Login**: Access your account with your credentials
3. **Password Reset**: Request a password reset email if you forget your password
4. **Auto-login**: Stay logged in across app restarts
5. **Logout**: Sign out from your account

### For Developers

1. **Auth Service**: Use `AuthService()` to access authentication methods
2. **Auth State**: Listen to auth state changes with `authService.authStateChanges`
3. **Current User**: Check current user with `authService.currentUser`
4. **Validation**: Use `Validators` utility for email/password validation

## Quick Code Examples

### Check if User is Authenticated

```dart
final authService = AuthService();
if (authService.isAuthenticated) {
  // User is logged in
  print('User email: ${authService.currentUser?.email}');
} else {
  // User is not logged in
  print('Please log in');
}
```

### Listen to Auth State Changes

```dart
final authService = AuthService();
authService.authStateChanges.listen((authState) {
  if (authState.session != null) {
    print('User logged in: ${authState.session?.user.email}');
  } else {
    print('User logged out');
  }
});
```

### Programmatically Login

```dart
final authService = AuthService();
try {
  await authService.signIn(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Login successful!');
} on AuthException catch (e) {
  print('Login failed: ${e.message}');
}
```

### Validate Email

```dart
String? emailError = Validators.validateEmail('user@example.com');
if (emailError == null) {
  print('Email is valid');
} else {
  print('Email error: $emailError');
}
```

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Tests

```bash
# Validator tests
flutter test test/utils/validators_test.dart

# Auth service tests
flutter test test/services/auth_service_test.dart

# Widget tests
flutter test test/widget_test.dart
```

### Test with Coverage

```bash
flutter test --coverage
```

## Common Issues

### "Invalid API key" Error

**Solution**: Check that your `.env` file exists and contains correct values from Supabase dashboard.

### App Shows Blank Screen

**Solution**: Make sure Supabase is initialized before running the app. Check console for errors.

### Email Not Received

**Solution**: 
1. Check spam folder
2. Verify email settings in Supabase dashboard
3. For development, check Supabase logs in the dashboard

## Project Structure

```
lib/
├── main.dart                      # App entry point, Supabase initialization
├── services/
│   └── auth_service.dart         # Authentication service
├── screens/
│   ├── login_screen.dart         # Login UI
│   ├── signup_screen.dart        # Signup UI
│   ├── password_reset_screen.dart # Password reset UI
│   └── home_screen.dart          # Post-login home screen
├── utils/
│   └── validators.dart           # Form validation utilities
└── theme/                         # App theme (unchanged)

test/
├── services/
│   └── auth_service_test.dart    # Auth service tests
├── utils/
│   └── validators_test.dart      # Validator tests
└── widget_test.dart              # Widget tests
```

## Next Steps

Now that authentication is set up, you can:

1. Build features that require authentication
2. Access user data with `authService.currentUser`
3. Protect routes based on authentication state
4. Add user profiles
5. Implement role-based access control

## Documentation

For more detailed information, see:

- [Authentication Documentation](docs/auth/AUTHENTICATION.md)
- [Implementation Verification](IMPLEMENTATION_VERIFICATION.md)
- [Project README](README.md)
- [Supabase Documentation](https://supabase.com/docs)

## Support

- 🐛 Issues: [GitHub Issues](https://github.com/dipan0saha/elite_tennis_ladder/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/dipan0saha/elite_tennis_ladder/discussions)

---

Happy coding! 🎾
