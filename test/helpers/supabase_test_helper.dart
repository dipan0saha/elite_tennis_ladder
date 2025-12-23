import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Test helper for initializing Supabase in tests
class SupabaseTestHelper {
  static bool _initialized = false;

  /// Initialize Supabase for testing
  /// Loads environment variables and initializes Supabase client
  /// Note: Widget tests run on the host VM; SharedPreferences is mocked.
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    TestWidgetsFlutterBinding.ensureInitialized();

    // Supabase Auth persists session via SharedPreferences; in widget tests
    // we must provide a mock implementation.
    SharedPreferences.setMockInitialValues(<String, Object>{});

    try {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      // Try to initialize Supabase
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? 'https://test.supabase.co',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'test-key',
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 0,
        ),
      );

      _initialized = true;
    } catch (e) {
      // If initialization fails, allow tests to proceed.
      _initialized = true;
      // ignore: avoid_print
      print('Supabase initialization skipped in unit test: $e');
    }
  }
}
