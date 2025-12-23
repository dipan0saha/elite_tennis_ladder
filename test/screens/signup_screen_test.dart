import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/signup_screen.dart';
import 'package:elite_tennis_ladder/screens/login_screen.dart';
import '../helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  group('SignupScreen Widget Tests', () {
    testWidgets('should display all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Verify title
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join the Elite Tennis Ladder'), findsOneWidget);

      // Verify form fields
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Verify buttons
      expect(find.text('Sign Up'), findsNWidgets(2));
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
    });

    testWidgets('should show validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Tap signup button without entering data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should show validation error for weak password',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter weak password
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'weak');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.textContaining('at least 6 characters'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter mismatched passwords
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'ValidPass123!');
      await tester.enterText(
          find.byType(TextFormField).at(2), 'DifferentPass123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should toggle password visibility for password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Find password field (second TextFormField)
      final passwordField = find.byType(TextFormField).at(1);

      // Initially password should be obscured
      EditableText editableText = tester.widget<EditableText>(
        find.descendant(of: passwordField, matching: find.byType(EditableText)),
      );
      expect(editableText.obscureText, true);

      // Tap first visibility icon
      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pumpAndSettle();

      // Password should now be visible
      editableText = tester.widget<EditableText>(
        find.descendant(of: passwordField, matching: find.byType(EditableText)),
      );
      expect(editableText.obscureText, false);
    });

    testWidgets('should toggle password visibility for confirm password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Find confirm password field (third TextFormField)
      final confirmPasswordField = find.byType(TextFormField).at(2);

      // Initially password should be obscured
      EditableText editableText = tester.widget<EditableText>(
        find.descendant(
          of: confirmPasswordField,
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.obscureText, true);

      // Tap second visibility icon
      await tester.tap(find.byIcon(Icons.visibility_outlined).last);
      await tester.pumpAndSettle();

      // Password should now be visible
      editableText = tester.widget<EditableText>(
        find.descendant(
          of: confirmPasswordField,
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.obscureText, false);
    });

    testWidgets('should navigate to LoginScreen when login link is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Tap login link
      await tester.ensureVisible(find.widgetWithText(TextButton, 'Login'));
      await tester.tap(
        find.widgetWithText(TextButton, 'Login'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Verify navigation to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should accept valid input in all fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter valid data
      await tester.enterText(
          find.byType(TextFormField).at(0), 'newuser@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'ValidPass123!');
      await tester.enterText(find.byType(TextFormField).at(2), 'ValidPass123!');

      // Verify text is entered
      expect(find.text('newuser@example.com'), findsOneWidget);
      expect(find.text('ValidPass123!'), findsNWidgets(2));
    });
  });
}
