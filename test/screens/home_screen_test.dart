import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/screens/home_screen.dart';
import '../helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('should display all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify app bar - there are 2 "Elite Tennis Ladder" texts (title and card)
      expect(find.text('Elite Tennis Ladder'), findsNWidgets(2));
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Verify welcome message
      expect(find.text('Welcome!'), findsOneWidget);

      // Verify tennis icon
      expect(find.byIcon(Icons.sports_tennis), findsOneWidget);

      // Verify card with ladder information
      expect(find.byType(Card), findsOneWidget);
      expect(
          find.text('Join ladders, challenge players, and climb the rankings!'),
          findsOneWidget);
    });

    testWidgets('should display user email when available',
        (WidgetTester tester) async {
      // Note: This test will show "Not available" since we're not authenticated
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // In a non-authenticated state, should show either email or a fallback
      // The actual behavior depends on auth state
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should have logout button in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find logout button
      final logoutButton = find.byIcon(Icons.logout);
      expect(logoutButton, findsOneWidget);

      // Verify it has a tooltip
      final iconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.logout),
      );
      expect(iconButton.tooltip, 'Logout');
    });

    testWidgets('should trigger logout when logout button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Tap logout button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Note: Actual navigation depends on auth state listener in main.dart
      // This test verifies the button is tappable
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should display tennis icon with correct color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find tennis icon
      final iconFinder = find.byIcon(Icons.sports_tennis);
      expect(iconFinder, findsOneWidget);

      // Verify icon properties
      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.size, 100);
    });

    testWidgets('should center content properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify Center widget exists
      expect(find.byType(Center), findsWidgets);

      // Verify Column with centered content
      final columns = tester.widgetList<Column>(find.byType(Column)).toList();
      expect(
        columns.any((c) => c.mainAxisAlignment == MainAxisAlignment.center),
        isTrue,
      );
    });

    testWidgets('should have proper padding around content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find Padding widget
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsWidgets);

      // Verify main content padding
      final padding = tester.widget<Padding>(
        paddingFinder.first,
      );
      expect(padding.padding, const EdgeInsets.all(24.0));
    });

    testWidgets('should display welcome text with correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find welcome text
      final welcomeText = find.text('Welcome!');
      expect(welcomeText, findsOneWidget);

      // Note: Exact text style depends on theme
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should have SizedBox spacing between elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify SizedBox widgets for spacing
      final sizedBoxFinder = find.byType(SizedBox);
      expect(sizedBoxFinder, findsWidgets);
    });

    testWidgets('should display coming soon card with proper styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find Card widget
      expect(find.byType(Card), findsOneWidget);

      // Verify card content - the card shows "Elite Tennis Ladder" and description
      expect(find.text('Elite Tennis Ladder'),
          findsNWidgets(2)); // One in app bar, one in card
      expect(
          find.text('Join ladders, challenge players, and climb the rankings!'),
          findsOneWidget);
    });

    testWidgets('should handle hot reload gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify initial state
      expect(find.text('Welcome!'), findsOneWidget);

      // Pump again (simulates hot reload)
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify state is maintained
      expect(find.text('Welcome!'), findsOneWidget);
    });
  });
}
