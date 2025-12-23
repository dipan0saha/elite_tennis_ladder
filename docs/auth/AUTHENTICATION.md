# Supabase Authentication Implementation

This document provides a comprehensive guide to the Supabase authentication integration in the Elite Tennis Ladder app.

## Overview

The app now includes complete email/password authentication using Supabase Auth, including:
- User signup with email verification
- User login
- Password reset flow
- Authentication state management
- Automatic navigation based on auth state

## Architecture

### Service Layer

**`lib/services/auth_service.dart`**
- Centralized authentication service
- Wraps Supabase auth operations
- Provides clean API for auth operations
- Handles error cases consistently

Key methods:
- `signUp(email, password)` - Register new users
- `signIn(email, password)` - Authenticate existing users
- `resetPassword(email)` - Initiate password reset
- `signOut()` - Log out current user
- `authStateChanges` - Stream of auth state changes
- `currentUser` - Get current user info

### UI Screens

**`lib/screens/login_screen.dart`**
- Email/password login form
- Link to signup screen
- Link to password reset
- Form validation
- Loading states
- Error handling

**`lib/screens/signup_screen.dart`**
- Email/password registration form
- Password confirmation
- Form validation (email format, password length, password match)
- Loading states
- Error handling
- Automatic email verification notification

**`lib/screens/password_reset_screen.dart`**
- Password reset request form
- Email validation
- Success/error states
- Option to resend reset email

**`lib/screens/home_screen.dart`**
- Placeholder authenticated home screen
- Displays user email
- Logout functionality

### State Management

**`lib/main.dart`**
- Supabase initialization on app start
- Environment variable loading
- `AuthWrapper` widget listens to auth state changes
- Automatic navigation between login and home screens

## Setup Instructions

### 1. Configure Supabase

Create a Supabase project at [supabase.com](https://supabase.com) if you haven't already.

### 2. Environment Variables

Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

Update the `.env` file with your Supabase credentials:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**Important:** Never commit the `.env` file to version control.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## User Flow

### Signup Flow

1. User opens app → Sees login screen
2. Taps "Sign Up" → Navigates to signup screen
3. Enters email, password, and confirms password
4. Submits form → Account created in Supabase
5. Receives email verification notification
6. Automatically redirected to login screen
7. User checks email and verifies account (handled by Supabase)
8. User can now log in

### Login Flow

1. User opens app → Sees login screen (if not authenticated)
2. Enters email and password
3. Submits form → Authenticates with Supabase
4. On success → Automatically navigates to home screen
5. Session persisted across app restarts

### Password Reset Flow

1. User taps "Forgot Password?" on login screen
2. Enters email address
3. Submits form → Supabase sends reset email
4. User receives email with reset link
5. Clicks link → Opens password reset page (handled by Supabase)
6. User sets new password
7. Returns to app and logs in with new password

### Logout Flow

1. User taps logout button on home screen
2. Session cleared
3. Automatically redirected to login screen

## Security Features

### Password Requirements
- Minimum 6 characters (enforced by client validation)
- Supabase default settings apply (can be configured in Supabase dashboard)

### Email Verification
- Optional email verification (configure in Supabase dashboard)
- Users receive verification email after signup
- Can be required before login (configure in Supabase settings)

### Session Management
- Secure token-based authentication
- Automatic token refresh
- Session persistence across app restarts
- Automatic logout on token expiration

### Error Handling
- All auth operations wrapped in try-catch
- User-friendly error messages
- Loading states during operations
- Form validation before submission

## Testing

### Unit Tests

Run unit tests:
```bash
flutter test test/services/auth_service_test.dart
```

### Widget Tests

Run widget tests:
```bash
flutter test test/widget_test.dart
```

### Manual Testing Checklist

- [ ] Signup with valid email/password
- [ ] Signup with invalid email format
- [ ] Signup with weak password
- [ ] Signup with mismatched passwords
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Password reset with valid email
- [ ] Password reset with invalid email
- [ ] Logout functionality
- [ ] Session persistence (close and reopen app)
- [ ] Email verification flow

## Configuration Options

### Supabase Dashboard Settings

Configure these in your Supabase project dashboard:

**Auth > Settings:**
- Enable/disable email confirmations
- Set password requirements
- Configure email templates
- Set redirect URLs for password reset
- Enable/disable sign-ups

**Auth > Email Templates:**
- Customize confirmation email
- Customize password reset email
- Customize magic link email

## Troubleshooting

### Common Issues

**"Invalid API key" error:**
- Check that `.env` file exists and contains correct credentials
- Verify SUPABASE_URL and SUPABASE_ANON_KEY are set correctly
- Ensure `.env` is listed in `pubspec.yaml` assets

**Email not received:**
- Check spam/junk folder
- Verify email settings in Supabase dashboard
- Check Supabase logs for delivery status
- Ensure SMTP is configured correctly in Supabase

**"User already exists" error:**
- Email is already registered
- Try logging in instead
- Use password reset if password is forgotten

**Session not persisting:**
- Check that Supabase is initialized before `runApp()`
- Verify auth state listener is set up correctly
- Check for errors in console

## Next Steps

Future enhancements to consider:
- Social authentication (Google, Apple, etc.)
- Two-factor authentication
- Biometric authentication
- Remember me functionality
- Account deletion
- Email change functionality
- Profile management

## Related Documentation

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Project README](../../README.md)
- [Supabase Setup Guide](../../supabase/README.md)
