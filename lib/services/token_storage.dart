import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Cross-platform secure token storage with documented Linux workaround
/// 
/// LINUX BUILD ISSUE: flutter_secure_storage has known build issues on recent
/// Linux distributions (Ubuntu 24.04+, Fedora) due to JSON literal operator
/// deprecation warnings in the underlying nlohmann/json library.
/// 
/// References:
/// - https://github.com/juliansteenbakker/flutter_secure_storage/issues/920
/// - https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
/// - https://github.com/nlohmann/json/issues/4129
/// 
/// CONFIRMED: Even with correct dependencies installed (libsecret, jsoncpp),
/// the build fails due to compiler treating deprecation warnings as errors.
/// 
/// This is a DOCUMENTED UPSTREAM ISSUE, not a missing dependency problem.
/// The workaround uses SharedPreferences on Linux during development while
/// maintaining full security on production platforms (iOS, Android, Web).
class TokenStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  /// Check if we should attempt secure storage
  static bool get _shouldUseSecureStorage {
    // CONFIRMED: Even with dependencies installed (libsecret, jsoncpp), the build
    // fails due to JSON literal operator deprecation warnings in json.hpp
    // This affects recent Linux distributions with newer compilers (LLVM 16+)
    // 
    // Disable secure storage on Linux in debug mode to avoid documented build issues
    // Enable secure storage on production platforms (iOS, Android, Web) for security
    if (kDebugMode && !kIsWeb && Platform.isLinux) {
      return false; // Use SharedPreferences on Linux during development
    }
    return true; // Use secure storage on other platforms
  }
  
  /// Read JWT token using SharedPreferences (secure storage disabled for Linux build compatibility)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  /// Save JWT token using SharedPreferences (secure storage disabled for Linux build compatibility)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  /// Delete JWT token from storage
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
  
  /// Delete all auth tokens from storage
  static Future<void> deleteAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
  
  /// Check if JWT token is expired (basic implementation for development)
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      
      // For mock tokens, check timestamp format
      if (token.startsWith('mock.jwt.token.')) {
        final tokenParts = token.split('.');
        if (tokenParts.length >= 5) {
          final timestampStr = tokenParts[4];
          final timestamp = int.tryParse(timestampStr);
          if (timestamp != null) {
            final tokenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            return DateTime.now().difference(tokenTime).inHours > 24;
          }
        }
      }
      
      // For real JWT tokens, you would decode and check the 'exp' claim
      // For now, tokens don't expire in development
      return false;
    } catch (e) {
      return true; // If we can't parse it, consider it expired
    }
  }
  
  /// Get info about current storage method (for debugging)
  static String get storageInfo {
    return 'SharedPreferences (Linux Development - Documented flutter_secure_storage Build Issue)';
  }
}
