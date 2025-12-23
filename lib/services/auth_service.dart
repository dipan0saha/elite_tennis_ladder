import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication service for handling Supabase auth operations
/// Provides email/password signup, login, password reset, and state management
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the current authenticated user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get the authentication state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Check if user is currently authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign up a new user with email and password
  /// Throws AuthException if signup fails
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const AuthException('An unexpected error occurred during signup');
    }
  }

  /// Sign in an existing user with email and password
  /// Throws AuthException if login fails
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const AuthException('An unexpected error occurred during login');
    }
  }

  /// Send a password reset email to the user
  /// Throws AuthException if the operation fails
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const AuthException(
          'An unexpected error occurred during password reset');
    }
  }

  /// Sign out the current user
  /// Throws AuthException if sign out fails
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const AuthException('An unexpected error occurred during sign out');
    }
  }
}
