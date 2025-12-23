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
      expect(find.text('Join the tennis ladder community'), findsOneWidget);

      // Verify form fields
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Verify buttons
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Already have an account? Login'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
    });

    testWidgets('should show validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Tap signup button without entering data
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
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
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
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
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.textContaining('at least 8 characters'), findsOneWidget);
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
      await tester.tap(find.text('Sign Up'));
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
      TextField textField = tester.widget(passwordField);
      expect(textField.obscureText, true);

      // Tap first visibility icon
      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pumpAndSettle();

      // Password should now be visible
      textField = tester.widget(passwordField);
      expect(textField.obscureText, false);
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
      TextField textField = tester.widget(confirmPasswordField);
      expect(textField.obscureText, true);

      // Tap second visibility icon
      await tester.tap(find.byIcon(Icons.visibility).last);
      await tester.pumpAndSettle();

      // Password should now be visible
      textField = tester.widget(confirmPasswordField);
      expect(textField.obscureText, false);
    });

    testWidgets('should navigate to LoginScreen when login link is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Tap login link
      await tester.tap(find.text('Already have an account? Login'));
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

    testWidgets('should show loading indicator when signup is in progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
          find.byType(TextFormField).at(0), 'newuser@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'ValidPass123!');
      await tester.enterText(find.byType(TextFormField).at(2), 'ValidPass123!');

      // Tap signup button
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable form interactions while loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
          find.byType(TextFormField).at(0), 'newuser@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'ValidPass123!');
      await tester.enterText(find.byType(TextFormField).at(2), 'ValidPass123!');

      // Tap signup button
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Find the ElevatedButton (Sign Up button)
      final signupButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
      );

      // Button should be disabled (onPressed is null)
      expect(signupButton.onPressed, null);
    });

    testWidgets('should display password requirements hint',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Look for password requirements text
      expect(find.textContaining('at least 8 characters'), findsWidgets);
    });
  });
}
