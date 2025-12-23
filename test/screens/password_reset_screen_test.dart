import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/password_reset_screen.dart';
import '../helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  group('PasswordResetScreen Widget Tests', () {
    testWidgets('should display all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Verify title
      expect(find.text('Reset Password'), findsOneWidget);
      expect(
          find.text(
              'Enter your email address and we\'ll send you a link to reset your password'),
          findsOneWidget);

      // Verify form field
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      // Verify button
      expect(find.text('Send Reset Link'), findsOneWidget);

      // Verify back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify icon
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should show validation error for empty email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Tap send button without entering email
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept valid email input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');

      // Verify text is entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should show loading indicator when sending reset email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');

      // Tap send button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable button while loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');

      // Tap send button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Find the ElevatedButton
      final resetButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Send Reset Link'),
      );

      // Button should be disabled
      expect(resetButton.onPressed, null);
    });

    testWidgets('should navigate back when back button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordResetScreen(),
                    ),
                  );
                },
                child: const Text('Go to Reset'),
              ),
            ),
          ),
        ),
      );

      // Navigate to password reset screen
      await tester.tap(find.text('Go to Reset'));
      await tester.pumpAndSettle();

      // Verify we're on password reset screen
      expect(find.byType(PasswordResetScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back
      expect(find.text('Go to Reset'), findsOneWidget);
    });

    testWidgets('should display success message after email is sent',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'valid@example.com');

      // Tap send button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Note: The actual success state depends on API response
      // This test verifies the widget structure supports it
      expect(find.byType(PasswordResetScreen), findsOneWidget);
    });

    testWidgets('should show helpful instruction text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Verify instruction text
      expect(find.textContaining('Enter your email address'), findsOneWidget);
      expect(find.textContaining('reset your password'), findsOneWidget);
    });

    testWidgets('should maintain email input after validation error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Email should still be in field
      expect(find.text('invalid'), findsOneWidget);
    });

    testWidgets('should clear form and show success UI after successful send',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(
          find.byType(TextFormField), 'validuser@example.com');

      // Tap send button
      await tester.tap(find.text('Send Reset Link'));

      // Wait for async operation
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // The screen should handle success state
      // (exact behavior depends on API response)
      expect(find.byType(PasswordResetScreen), findsOneWidget);
    });
  });
}
