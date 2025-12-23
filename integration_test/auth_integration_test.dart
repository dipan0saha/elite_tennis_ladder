import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:elite_tennis_ladder/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    setUpAll(() async {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      // Initialize Supabase
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      );
    });

    tearDown(() async {
      // Sign out after each test to reset state
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (e) {
        // Ignore if already signed out
      }
      await Future.delayed(const Duration(milliseconds: 500));
    });

    testWidgets('App launches and shows login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app launches and shows login screen
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.byType(TextFormField),
          findsNWidgets(2)); // email and password fields
    });

    testWidgets('Login with valid credentials succeeds',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter valid credentials
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Wait for authentication
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to home screen
      expect(find.text('Elite Tennis Ladder'), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('You are now logged in!'), findsOneWidget);
    });

    testWidgets('Login with invalid credentials shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter invalid credentials
      await tester.enterText(
          find.byType(TextFormField).at(0), 'invalid@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Wait for error
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should still be on login screen (auth failed)
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Try to login without entering anything
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Can navigate to signup screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find and tap the signup navigation (TextButton with Sign Up)
      final textButtons = find.byType(TextButton);
      bool foundSignup = false;
      for (int i = 0; i < tester.widgetList(textButtons).length; i++) {
        final button = tester.widget<TextButton>(textButtons.at(i));
        if (button.child is Text && (button.child as Text).data == 'Sign Up') {
          await tester.tap(textButtons.at(i));
          foundSignup = true;
          break;
        }
      }
      expect(foundSignup, true);
      await tester.pumpAndSettle();

      // Verify we're on signup screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join the Elite Tennis Ladder'), findsOneWidget);
    });

    testWidgets('Signup form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to signup
      final textButtons = find.byType(TextButton);
      for (int i = 0; i < tester.widgetList(textButtons).length; i++) {
        final button = tester.widget<TextButton>(textButtons.at(i));
        if (button.child is Text && (button.child as Text).data == 'Sign Up') {
          await tester.tap(textButtons.at(i));
          break;
        }
      }
      await tester.pumpAndSettle();

      // Try to signup without entering anything
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Signup with mismatched passwords shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to signup
      final textButtons = find.byType(TextButton);
      for (int i = 0; i < tester.widgetList(textButtons).length; i++) {
        final button = tester.widget<TextButton>(textButtons.at(i));
        if (button.child is Text && (button.child as Text).data == 'Sign Up') {
          await tester.tap(textButtons.at(i));
          break;
        }
      }
      await tester.pumpAndSettle();

      // Enter mismatched passwords
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@example.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'password456');
      await tester.pumpAndSettle();

      // Try to signup
      await tester
          .ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Signup form accepts valid input', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to signup
      final textButtons = find.byType(TextButton);
      for (int i = 0; i < tester.widgetList(textButtons).length; i++) {
        final button = tester.widget<TextButton>(textButtons.at(i));
        if (button.child is Text && (button.child as Text).data == 'Sign Up') {
          await tester.tap(textButtons.at(i));
          break;
        }
      }
      await tester.pumpAndSettle();

      // Enter test data
      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(3)); // email, password, confirm password

      await tester.enterText(fields.at(0), 'test@example.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'password123');
      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Can navigate to password reset screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to password reset
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify we're on password reset screen
      expect(find.text('Reset Password'), findsWidgets);
    });

    testWidgets('Password reset form validation works',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to password reset
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Try to submit without entering email
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Password reset form accepts valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to password reset
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Enter email
      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Toggle password visibility works',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter some password
      await tester.enterText(
          find.byType(TextFormField).at(1), 'secretpassword');
      await tester.pumpAndSettle();

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Icon should change
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('Navigate from signup back to login',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to signup
      final textButtons = find.byType(TextButton);
      for (int i = 0; i < tester.widgetList(textButtons).length; i++) {
        final button = tester.widget<TextButton>(textButtons.at(i));
        if (button.child is Text && (button.child as Text).data == 'Sign Up') {
          await tester.tap(textButtons.at(i));
          break;
        }
      }
      await tester.pumpAndSettle();

      // Verify we're on signup screen
      expect(find.text('Create Account'), findsOneWidget);

      // Navigate back to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Navigate from password reset back to login',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to password reset
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify we're on password reset screen
      expect(find.text('Reset Password'), findsWidgets);

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Logout from home screen works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should be on home screen
      expect(find.text('Elite Tennis Ladder'), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);

      // Tap logout icon button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should be back on login screen
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });
  });
}
