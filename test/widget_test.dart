// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/main.dart';
import 'helpers/supabase_test_helper.dart';

void main() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for auth state stream to settle.
    await tester.pumpAndSettle();

    // Verify that app has a title
    expect(find.text('Elite Tennis Ladder'), findsOneWidget);
  });

  testWidgets('Login screen is displayed for unauthenticated user',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for auth state to settle
    await tester.pumpAndSettle();

    // Verify that login UI elements are present
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Login'), findsAtLeastNWidgets(1));
  });
}
