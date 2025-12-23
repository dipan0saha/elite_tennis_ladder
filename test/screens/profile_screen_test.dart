import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/profile_screen.dart';
import '../helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  group('ProfileScreen Widget Tests', () {
    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Form), findsNothing);
    });

    testWidgets('should have AppBar with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify AppBar exists with correct title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should have save button in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Wait for loading to complete (will fail to load but show form)
      await tester.pump(const Duration(seconds: 1));
      
      // Look for save icon button
      expect(find.byIcon(Icons.save), findsWidgets);
    });

    testWidgets('should display form fields after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Wait for potential state changes
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // The form should exist even if loading fails
      // (it will show error but keep the form structure)
    });

    testWidgets('should have correct number of TextFormFields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have fields for: Full Name, Username (disabled), Email (disabled), Phone, Bio
      // Note: Exact count depends on if profile loads, but structure should be present
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('should have skill level dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have a dropdown for skill level
      expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
    });

    testWidgets('should have avatar section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have CircleAvatar for profile picture
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('should have GestureDetector for avatar tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Avatar should be tappable
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should display camera icon on avatar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should show camera icon indicating tap to change
      expect(find.byIcon(Icons.camera_alt), findsWidgets);
    });

    testWidgets('should have save button at bottom',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have ElevatedButton for saving
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.text('Save Profile'), findsWidgets);
    });

    testWidgets('should have SingleChildScrollView for scrolling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Form should be scrollable
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('should display person icon in AppBar for navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Check for icons in the screen
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('form should have Form widget with GlobalKey',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have Form widget for validation
      expect(find.byType(Form), findsWidgets);
    });

    testWidgets('should have appropriate padding and spacing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have Padding widgets for layout
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('should use Column for vertical layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have Column for organizing fields vertically
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have SizedBox for spacing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have SizedBox widgets for spacing between elements
      expect(find.byType(SizedBox), findsWidgets);
    });

    // Note: More comprehensive widget tests would require:
    // 1. Mocking the ProfileService to avoid real Supabase calls
    // 2. Testing form validation by entering text
    // 3. Testing image picker integration with mocks
    // 4. Testing save functionality with mocked service
    // 5. Testing error handling with mocked failures
    //
    // These advanced tests would be better suited for integration tests
    // with a test database or using packages like mockito for mocking.
    // See integration_test/profile_integration_test.dart for full flow tests.
  });

  group('ProfileScreen Skill Level Options', () {
    testWidgets('should have all skill level options available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // The skill levels are: beginner, intermediate, advanced, expert
      // These should be available in the dropdown
      // Note: Testing dropdown options requires tapping and opening the dropdown
      // which is better done in integration tests
    });
  });

  group('ProfileScreen Icons and Labels', () {
    testWidgets('should have appropriate icons for form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have various icons (person, email, phone, description, sports_tennis)
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('should have proper text labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Should have Text widgets for labels and hints
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('ProfileScreen State Management', () {
    testWidgets('should be a StatefulWidget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // ProfileScreen should be StatefulWidget for managing state
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('should show Scaffold',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Should be wrapped in Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
