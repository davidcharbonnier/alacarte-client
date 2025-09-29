/// Application configuration settings
class AppConfig {
  static const String appName = 'Cheese Rating App';
  static const String appVersion = '1.0.0';

  // Environment settings
  static const bool isDevelopment = false;

  // API Configuration
  static const String baseUrl = isDevelopment
      ? 'http://localhost:8080'
      : 'https://alacarte-api-414358220433.northamerica-northeast1.run.app';

  // Google OAuth Configuration
  // Web client ID - used for both web app and as serverClientId for Android
  static const String googleWebClientId = isDevelopment
      ? 'your-dev-web-client-id.apps.googleusercontent.com'
      : '414358220433-utddgtujirv58gt6g33kb7jei3shih27.apps.googleusercontent.com';

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
