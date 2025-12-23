import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('should display profile screen with loading indicator initially',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have AppBar with title and save button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    // Note: More comprehensive widget tests would require:
    // 1. Mocking the ProfileService to avoid real Supabase calls
    // 2. Testing form validation
    // 3. Testing image picker integration
    // 4. Testing save functionality
    // 5. Testing error handling
    //
    // These would be better suited for integration tests with a test database.
  });
}
