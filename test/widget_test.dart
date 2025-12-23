// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_tennis_ladder/main.dart';

void main() {
  setUpAll(() async {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Supabase for testing
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  });

  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

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
