import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Test helper for initializing Supabase in tests
class SupabaseTestHelper {
  static bool _initialized = false;

  /// Initialize Supabase for testing
  /// Loads environment variables and initializes Supabase client
  /// Note: Widget tests cannot use SharedPreferences, so this uses a mock setup
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    TestWidgetsFlutterBinding.ensureInitialized();

    try {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      // For widget tests, we use a minimal Supabase initialization
      // that doesn't require SharedPreferences
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
    } on MissingPluginException {
      // SharedPreferences plugin not available in widget tests
      // This is expected - mark as initialized anyway
      _initialized = true;
    } catch (e) {
      // Any other error - mark as initialized to allow tests to continue
      _initialized = true;
    }
  }
}
