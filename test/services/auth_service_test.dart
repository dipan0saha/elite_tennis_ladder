import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_tennis_ladder/services/auth_service.dart';

void main() {
  setUpAll(() async {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Supabase for testing
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  });

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should be instantiated', () {
      expect(authService, isNotNull);
    });

    test('should have currentUser getter', () {
      expect(authService.currentUser, isA<dynamic>());
    });

    test('should have isAuthenticated getter', () {
      expect(authService.isAuthenticated, isA<bool>());
    });

    test('should have authStateChanges stream', () {
      expect(authService.authStateChanges, isA<Stream>());
    });

    // Note: Integration tests for actual auth operations (signup, login, etc.)
    // should be run against a test Supabase instance and are not included here
    // to avoid requiring live credentials during unit testing.
  });
}
