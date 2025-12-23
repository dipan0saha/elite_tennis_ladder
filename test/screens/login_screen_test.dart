import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/login_screen.dart';
import 'package:elite_tennis_ladder/screens/signup_screen.dart';
import 'package:elite_tennis_ladder/screens/password_reset_screen.dart';
import '../helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('should display all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verify title
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Elite Tennis Ladder'), findsOneWidget);

      // Verify form fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify buttons
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Tap login button without entering data
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should toggle password visibility',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Find password field
      final passwordField = find.byType(TextFormField).last;

      // Initially password should be obscured
      EditableText editableText = tester.widget<EditableText>(
        find.descendant(of: passwordField, matching: find.byType(EditableText)),
      );
      expect(editableText.obscureText, true);

      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Password should now be visible
      editableText = tester.widget<EditableText>(
        find.descendant(of: passwordField, matching: find.byType(EditableText)),
      );
      expect(editableText.obscureText, false);

      // Verify icon changed
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should navigate to SignupScreen when Sign Up is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Tap Sign Up
      await tester.tap(find.widgetWithText(TextButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify navigation to SignupScreen
      expect(find.byType(SignupScreen), findsOneWidget);
    });

    testWidgets(
        'should navigate to PasswordResetScreen when Forgot Password is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Tap Forgot Password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify navigation to PasswordResetScreen
      expect(find.byType(PasswordResetScreen), findsOneWidget);
    });

    testWidgets('should accept valid email and password input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Verify text is entered
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
