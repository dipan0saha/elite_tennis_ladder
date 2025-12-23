import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/services/auth_service.dart';

void main() {
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
