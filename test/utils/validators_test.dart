import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/utils/validators.dart';

void main() {
  group('Validators - Email', () {
    test('validateEmail returns null for valid email', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('test.user@domain.co.uk'), isNull);
      expect(Validators.validateEmail('user+tag@example.org'), isNull);
    });

    test('validateEmail returns error for empty email', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('validateEmail returns error for invalid email format', () {
      expect(Validators.validateEmail('@invalid'), isNotNull);
      expect(Validators.validateEmail('invalid@'), isNotNull);
      expect(Validators.validateEmail('invalid'), isNotNull);
      expect(Validators.validateEmail('invalid.com'), isNotNull);
      expect(Validators.validateEmail('invalid@domain'), isNotNull);
      expect(Validators.validateEmail('@'), isNotNull);
    });
  });

  group('Validators - Password', () {
    test('validatePassword returns null for valid password', () {
      expect(Validators.validatePassword('password123'), isNull);
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('a1b2c3'), isNull);
    });

    test('validatePassword returns error for empty password', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('validatePassword returns error for short password', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('abc'), isNotNull);
      expect(Validators.validatePassword('a'), isNotNull);
    });

    test('validatePassword respects custom minLength', () {
      expect(Validators.validatePassword('12345678', minLength: 8), isNull);
      expect(Validators.validatePassword('1234567', minLength: 8), isNotNull);
    });
  });

  group('Validators - Password Confirmation', () {
    test('validatePasswordConfirmation returns null when passwords match', () {
      expect(
        Validators.validatePasswordConfirmation('password123', 'password123'),
        isNull,
      );
      expect(
        Validators.validatePasswordConfirmation('abc123', 'abc123'),
        isNull,
      );
    });

    test('validatePasswordConfirmation returns error for empty confirmation', () {
      expect(
        Validators.validatePasswordConfirmation('', 'password123'),
        isNotNull,
      );
      expect(
        Validators.validatePasswordConfirmation(null, 'password123'),
        isNotNull,
      );
    });

    test('validatePasswordConfirmation returns error when passwords do not match', () {
      expect(
        Validators.validatePasswordConfirmation('password123', 'password456'),
        isNotNull,
      );
      expect(
        Validators.validatePasswordConfirmation('abc', 'def'),
        isNotNull,
      );
    });
  });
}
