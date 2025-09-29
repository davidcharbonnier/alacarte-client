import 'package:flutter/foundation.dart';

/// Application configuration settings
class AppConfig {
  static const String appName = 'A la carte';
  static const String appVersion = '{{APP_VERSION}}';

  // API Configuration - all values injected from GitHub secrets/variables
  static const String baseUrl = kDebugMode
      ? '{{DEVELOPMENT_API_URL}}'
      : '{{PRODUCTION_API_URL}}';

  // Google OAuth Configuration - all values injected from GitHub secrets
  // Web client ID - used for both web app and as serverClientId for Android
  static const String googleWebClientId = kDebugMode
      ? '{{DEVELOPMENT_GOOGLE_CLIENT_ID}}'
      : '{{PRODUCTION_GOOGLE_CLIENT_ID}}';

  // TODO: Add API key management when implemented on backend
  // static const String apiKeyHeaderName = 'Authorization';
  // static String apiKeyPrefix = 'Bearer';

  // Local storage keys
  static const String selectedUserIdKey = 'selected_user_id';
  static const String appSettingsKey = 'app_settings';

  // UI Configuration
  static const int defaultPageSize = 20;
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
