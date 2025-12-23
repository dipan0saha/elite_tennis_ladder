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

    testWidgets('App launches and shows login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app launches and shows login screen
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
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

    testWidgets('Signup form accepts input', (WidgetTester tester) async {
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

    testWidgets('Password reset form accepts input',
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
  });
}
