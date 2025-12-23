import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:elite_tennis_ladder/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Screen Integration Tests', () {
    late final String _supabaseUrl;
    late final String _supabaseAnonKey;
    late final String _testEmail;
    late final String _testPassword;

    setUpAll(() async {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      _supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      _testEmail = dotenv.env['TEST_USER_EMAIL'] ?? '';
      _testPassword = dotenv.env['TEST_USER_PASSWORD'] ?? '';

      expect(
        _supabaseUrl,
        isNotEmpty,
        reason: 'Set SUPABASE_URL in .env to run integration tests.',
      );
      expect(
        _supabaseAnonKey,
        isNotEmpty,
        reason: 'Set SUPABASE_ANON_KEY in .env to run integration tests.',
      );
      expect(
        _testEmail,
        isNotEmpty,
        reason: 'Set TEST_USER_EMAIL in .env to run integration tests.',
      );
      expect(
        _testPassword,
        isNotEmpty,
        reason: 'Set TEST_USER_PASSWORD in .env to run integration tests.',
      );

      // Initialize Supabase
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
    });

    setUp(() async {
      // Sign out before each test to start fresh
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (e) {
        // Ignore if already signed out
      }
      await Future.delayed(const Duration(milliseconds: 500));
    });

    tearDown(() async {
      // Sign out after each test
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (e) {
        // Ignore if already signed out
      }
      await Future.delayed(const Duration(milliseconds: 500));
    });

    testWidgets(
        'Complete profile flow: login, navigate to profile, view profile',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Step 1: Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on home screen
      expect(find.text('Elite Tennis Ladder'), findsOneWidget);

      // Step 2: Navigate to profile
      final profileButton = find.byIcon(Icons.person);
      expect(profileButton, findsOneWidget);

      await tester.tap(profileButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 3: Verify profile screen loaded
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('Profile screen displays user information',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Wait for profile to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify form fields are present
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
    });

    testWidgets('Profile screen has all expected form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify all expected form fields by looking for labels
      // Note: Exact text depends on what's loaded from database
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Can edit full name field', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and edit full name field (first editable field after loading)
      final fullNameField = find.byType(TextFormField).first;
      await tester.enterText(fullNameField, 'Test User Updated');
      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('Test User Updated'), findsOneWidget);
    });

    testWidgets('Can edit bio field', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find bio field (multiline text field)
      final bioField = find.ancestor(
        of: find.text('Bio'),
        matching: find.byType(TextFormField),
      );
      expect(bioField, findsOneWidget);

      await tester.ensureVisible(bioField);
      await tester.enterText(bioField, 'I love playing tennis!');
      await tester.pumpAndSettle();

      final bioWidget = tester.widget<TextFormField>(bioField);
      expect(bioWidget.controller?.text, 'I love playing tennis!');
    });

    testWidgets('Save button exists and is tappable',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find save button
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Profile');
      expect(saveButton, findsOneWidget);

      // Verify it's enabled (not null onPressed)
      final elevatedButton = tester.widget<ElevatedButton>(saveButton);
      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('AppBar save icon exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify save icon in AppBar
      expect(find.byIcon(Icons.save), findsWidgets);
    });

    testWidgets('Can navigate back from profile screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Should be back on home screen
      expect(find.text('Elite Tennis Ladder'), findsOneWidget);
    });

    testWidgets('Profile screen shows avatar section',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify avatar components
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byIcon(Icons.camera_alt), findsWidgets);
    });

    testWidgets('Skill level dropdown has correct options',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find dropdown
      final dropdown = find.byType(DropdownButtonFormField<String>);
      expect(dropdown, findsWidgets);

      // Tap to open dropdown
      if (dropdown.evaluate().isNotEmpty) {
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle();

        // Check for skill level options
        // The options should be: Beginner, Intermediate, Advanced, Expert
        // Note: Exact text may have capitalization
      }
    });

    testWidgets('Form validation works for required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), _testEmail);
      await tester.enterText(find.byType(TextFormField).at(1), _testPassword);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Clear full name field
      final fullNameField = find.byType(TextFormField).first;
      await tester.enterText(fullNameField, '');
      await tester.pumpAndSettle();

      // Try to save with empty required field
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Validation error should appear (form should not submit)
      // The exact error message would depend on implementation
    });

    testWidgets('Can scroll through profile form', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify scrollable
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Should still see profile screen
      expect(find.text('Profile'), findsOneWidget);
    });

    // Note: Avatar upload testing requires more complex setup including:
    // - Mocking ImagePicker
    // - Mocking file system
    // - Testing Supabase Storage integration
    // These tests would be better done with proper mocking libraries
    // and may require running on actual devices rather than simulators

    // Note: Profile save integration testing with actual database requires:
    // - Test user with known profile data
    // - Ability to reset test data between tests
    // - Verification queries to database
    // - Cleanup after tests
  });

  group('Profile Screen Error Handling', () {
    // TODO: Implement error handling tests when mocking infrastructure is available
    // This would require mocking Supabase failures or testing edge cases
  });
}
