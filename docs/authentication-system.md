# Authentication System Documentation - Frontend

## Table of Contents
- [Overview](#overview)
- [Architecture Migration](#architecture-migration)
- [Google OAuth Implementation](#google-oauth-implementation)
- [JWT Token Management](#jwt-token-management)
- [Cross-Platform Support](#cross-platform-support)
- [State Management](#state-management)
- [User Experience](#user-experience)
- [Migration Strategy](#migration-strategy)
- [Testing & Development](#testing--development)
- [Troubleshooting](#troubleshooting)

---
**Last Updated:** January 2025  
**Related Documentation:**
- [Privacy Model](privacy-model.md)
- [Rating System](rating-system.md)
- **Backend Authentication** - See `rest-api/docs/authentication-system.md`
---

## Overview

A la carte's authentication system has evolved from a profile-based selection model to a modern Google OAuth implementation with JWT token security. This transformation provides:

- **Secure API access** - All endpoints protected with JWT tokens
- **Cross-platform sync** - Same user data accessible on web, mobile, desktop
- **Standard authentication** - Familiar Google OAuth flow users expect
- **Enhanced privacy** - Real user identity enables proper sharing controls
- **Development velocity** - Focus on core features instead of custom auth

### Why Google OAuth?

After evaluating multiple authentication approaches (magic links, passkeys, device-based crypto), Google OAuth emerged as the optimal choice because:
- ✅ **Universal access** - Nearly everyone has a Google account
- ✅ **Zero infrastructure** - No email servers or SMS services required
- ✅ **Cross-platform** - Works identically on web, mobile, desktop
- ✅ **Security** - Google handles all security aspects
- ✅ **User expectation** - Standard authentication pattern

## Architecture Migration

### Current Profile System → Google OAuth

**Before (Profile-based):**
```
App Launch → Profile Selection Screen → User Context → Unprotected API Calls
```

**After (OAuth-based):**
```
App Launch → Google OAuth → JWT Token → Protected API Calls
```

### Frontend Architecture Changes

#### **Components Removed:**
```dart
// These become obsolete
- UserSelectionScreen
- UserSelectionProvider
- Complex profile switching logic
- Multi-user state management
- Profile creation/editing screens
- User switching navigation logic
- Complex app initialization with profile validation
```

#### **Components Added:**
```dart
// Simple OAuth replacements
- AuthScreen (Google sign-in button)
- AuthProvider (OAuth state management)
- JWT token management
- Simplified app initialization
- Display name setup screen
```

#### **State Management Transformation:**

**Before (Complex Multi-User):**
```dart
// Multiple user context management
final selectedUserId = ref.watch(selectedUserIdProvider);
final userSelectionState = ref.watch(userSelectionProvider);

// Complex initialization with offline profile validation
class AppInitializationProvider {
  // 100+ lines handling profile validation, connectivity, etc.
}
```

**After (Simple Single User):**
```dart
// Single authenticated user
final currentUser = ref.watch(authProvider).user;
final isAuthenticated = ref.watch(authProvider).isAuthenticated;

// Simple initialization
class AppInitializationProvider {
  Future<InitializationState> initialize() async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token != null && !_isExpired(token)) {
      return InitializationState.authenticated(_parseUser(token));
    }
    return InitializationState.needsAuth();
  }
}
```

## Google OAuth Implementation

### Core Authentication Flow

#### **1. AuthProvider (State Management)**

```dart
// lib/providers/auth_provider.dart
class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider() : super(const AuthState.loading()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token != null && !_isTokenExpired(token)) {
        final user = _parseUserFromToken(token);
        state = AuthState.authenticated(user, token);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AuthState.loading();
      
      // Google OAuth flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Exchange Google token for our JWT
      final response = await _apiService.authenticateWithGoogle(
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      // Store JWT securely
      await _secureStorage.write(key: 'jwt_token', value: response.token);
      
      state = AuthState.authenticated(response.user, response.token);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _secureStorage.delete(key: 'jwt_token');
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
```

#### **2. AuthState (Freezed Union Types)**

```dart
// lib/providers/auth_state.dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user, String token) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// Extension for convenience
extension AuthStateX on AuthState {
  bool get isAuthenticated => this is _Authenticated;
  User? get user => mapOrNull(authenticated: (state) => state.user);
  String? get token => mapOrNull(authenticated: (state) => state.token);
}
```

#### **3. AuthScreen (User Interface)**

```dart
// lib/screens/auth/auth_screen.dart
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App branding
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.welcomeToAlaCarte,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.authSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Google Sign In Button
              authState.when(
                loading: () => const CircularProgressIndicator(),
                authenticated: (_, __) => const SizedBox.shrink(),
                unauthenticated: () => _buildGoogleSignInButton(context, ref),
                error: (message) => _buildErrorState(context, ref, message),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
        icon: Image.asset(
          'assets/images/google_logo.png',
          height: 24,
          width: 24,
        ),
        label: Text(context.l10n.continueWithGoogle),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
          child: Text(context.l10n.tryAgain),
        ),
      ],
    );
  }
}
```

### Display Name Setup

After successful Google OAuth, users complete their profile:

```dart
// lib/screens/auth/display_name_setup_screen.dart
class DisplayNameSetupScreen extends ConsumerStatefulWidget {
  const DisplayNameSetupScreen({super.key});

  @override
  ConsumerState<DisplayNameSetupScreen> createState() => _DisplayNameSetupScreenState();
}

class _DisplayNameSetupScreenState extends ConsumerState<DisplayNameSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  bool _allowSharing = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-suggest display name from Google profile
    final user = ref.read(authProvider).user;
    if (user != null) {
      _displayNameController.text = _generateDisplayName(user.fullName);
    }
  }

  String _generateDisplayName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length < 2) return parts[0];
    
    final firstName = parts[0];
    final lastInitial = parts.last[0];
    return '$firstName $lastInitial.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.completeProfile),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.chooseDisplayName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.displayNameHelperText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Display name input
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: context.l10n.displayName,
                  hintText: context.l10n.displayNameHint,
                  helperText: context.l10n.displayNameHelper,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.displayNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.displayNameTooShort;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Privacy setting
              SwitchListTile(
                title: Text(context.l10n.allowSharing),
                subtitle: Text(context.l10n.allowSharingSubtitle),
                value: _allowSharing,
                onChanged: (value) => setState(() => _allowSharing = value),
                contentPadding: EdgeInsets.zero,
              ),

              const Spacer(),

              // Complete setup button
              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.completeSetup),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(userServiceProvider).completeProfile(
        displayName: _displayNameController.text.trim(),
        discoverable: _allowSharing,
      );

      // Update auth state
      await ref.read(authProvider.notifier).refreshUser();

      // Navigate to home
      if (mounted) {
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.profileSetupError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
```

## JWT Token Management

### Secure Storage

```dart
// lib/services/token_storage_service.dart
class TokenStorageService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('Error reading token: $e');
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('Error saving token: $e');
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Error deleting tokens: $e');
    }
  }

  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'] as int?;
      if (exp == null) return true;

      return DateTime.now().millisecondsSinceEpoch / 1000 >= exp;
    } catch (e) {
      return true;
    }
  }
}
```

### HTTP Interceptor

```dart
// lib/services/dio_client.dart (Enhanced)
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login endpoints
    if (options.path.contains('/auth/') || options.path == '/health') {
      return handler.next(options);
    }

    final token = await TokenStorageService.getToken();
    if (token != null && !TokenStorageService.isTokenExpired(token)) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Token expired or invalid - sign out user
      final container = ProviderContainer();
      await container.read(authProvider.notifier).signOut();
    }
    
    handler.next(err);
  }
}
```

## Cross-Platform Support

### Web Implementation

```dart
// lib/services/auth_service_web.dart
class AuthServiceWeb implements AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'your-web-client-id.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult.cancelled();
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return _exchangeTokens(auth.idToken!, auth.accessToken!);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
```

### Mobile Implementation

```dart
// lib/services/auth_service_mobile.dart
class AuthServiceMobile implements AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult.cancelled();
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return _exchangeTokens(auth.idToken!, auth.accessToken!);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
```

### Desktop Implementation

```dart
// lib/services/auth_service_desktop.dart
class AuthServiceDesktop implements AuthService {
  @override
  Future<AuthResult> signInWithGoogle() async {
    // Desktop uses OAuth flow in system browser
    try {
      final result = await FlutterWebAuth.authenticate(
        url: _buildGoogleOAuthUrl(),
        callbackUrlScheme: 'alacarte',
      );

      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      if (code == null) {
        return AuthResult.cancelled();
      }

      return _exchangeCodeForTokens(code);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  String _buildGoogleOAuthUrl() {
    final params = {
      'client_id': 'your-desktop-client-id.apps.googleusercontent.com',
      'redirect_uri': 'alacarte://oauth/callback',
      'scope': 'email profile',
      'response_type': 'code',
      'access_type': 'offline',
    };

    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://accounts.google.com/oauth/authorize?$query';
  }
}
```

## State Management

### Provider Setup

```dart
// lib/providers/providers.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authService: ref.read(authServiceProvider),
    userService: ref.read(userServiceProvider),
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  // Platform-specific implementation
  if (kIsWeb) {
    return AuthServiceWeb();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return AuthServiceMobile();
  } else {
    return AuthServiceDesktop();
  }
});

// Computed providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});
```

### Route Guards

```dart
// lib/routes/app_router.dart (Updated)
final appRouter = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.initialization,
    refreshListenable: _AuthStateNotifier(ref),
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.location.startsWith('/auth');
      final isSetupRoute = state.location.startsWith('/setup');
      
      // Handle different auth states
      return authState.when(
        loading: () => RouteNames.initialization,
        authenticated: (user, _) {
          // Check if user needs to complete profile setup
          if (!user.hasCompletedSetup) {
            return isSetupRoute ? null : RouteNames.displayNameSetup;
          }
          
          // Redirect away from auth pages if already authenticated
          if (isAuthRoute) return RouteNames.home;
          
          return null; // Allow navigation
        },
        unauthenticated: () {
          // Redirect to auth if trying to access protected routes
          if (!isAuthRoute && !isSetupRoute) {
            return RouteNames.auth;
          }
          return null;
        },
        error: (_) => RouteNames.auth,
      );
    },
    routes: [
      GoRoute(
        path: RouteNames.initialization,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: RouteNames.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RouteNames.displayNameSetup,
        builder: (context, state) => const DisplayNameSetupScreen(),
      ),
      // ... existing protected routes
    ],
  );
});
```

## User Experience

### Authentication Flow

```
1. App Launch
   ↓
2. Check for valid JWT token
   ↓
3a. Valid token → Navigate to Home
3b. Invalid/missing token → Navigate to Auth Screen
   ↓
4. User clicks "Continue with Google"
   ↓
5. Google OAuth flow (platform-specific)
   ↓
6. Exchange Google token for JWT
   ↓
7a. Existing user → Navigate to Home
7b. New user → Navigate to Display Name Setup
   ↓
8. Complete profile setup
   ↓
9. Navigate to Home
```

### Error Handling

```dart
// lib/utils/auth_error_handler.dart
class AuthErrorHandler {
  static String getLocalizedMessage(BuildContext context, String error) {
    if (error.contains('network_error')) {
      return context.l10n.authNetworkError;
    } else if (error.contains('cancelled')) {
      return context.l10n.authCancelled;
    } else if (error.contains('invalid_token')) {
      return context.l10n.authInvalidToken;
    } else {
      return context.l10n.authGeneralError;
    }
  }

  static void showAuthError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getLocalizedMessage(context, error)),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: context.l10n.tryAgain,
          onPressed: () {
            // Retry authentication
            context.read(authProvider.notifier).signInWithGoogle();
          },
        ),
      ),
    );
  }
}
```

## Migration Strategy

### Phase 1: Parallel Implementation
- Add OAuth system alongside existing profile system
- New users get OAuth authentication
- Existing profile users continue with current system
- Zero disruption to current functionality

### Phase 2: Profile Migration
```dart
// lib/services/migration_service.dart
class MigrationService {
  static Future<void> migrateProfileToAccount() async {
    final savedProfile = await _getUserFromStorage();
    if (savedProfile == null) return;

    // Show migration dialog
    final shouldMigrate = await _showMigrationDialog();
    if (!shouldMigrate) return;

    try {
      // Authenticate with Google
      final authResult = await AuthService.signInWithGoogle();
      if (!authResult.isSuccess) return;

      // Migrate profile data to new user account
      await _migrateUserData(savedProfile, authResult.user);
      
      // Clear old profile data
      await _clearLegacyData();
      
      // Show success message
      _showMigrationSuccess();
    } catch (e) {
      _showMigrationError(e.toString());
    }
  }

  static Future<void> _migrateUserData(OldProfile profile, User newUser) async {
    // Migrate ratings
    await _migrateRatings(profile.id, newUser.id);
    
    // Migrate sharing relationships
    await _migrateSharingRelationships(profile.id, newUser.id);
    
    // Update display name if needed
    if (newUser.displayName.isEmpty) {
      await UserService.updateDisplayName(profile.name);
    }
  }
}
```

### Phase 3: OAuth-Only
- Remove profile selection components
- Clean up legacy code
- Update documentation
- Simplified authentication flow

## Testing & Development

### Development Setup

```dart
// lib/config/auth_config.dart
class AuthConfig {
  static const bool useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH');
  
  static const googleClientIdWeb = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_WEB',
    defaultValue: 'your-web-client-id.apps.googleusercontent.com',
  );
  
  static const googleClientIdAndroid = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_ANDROID', 
    defaultValue: 'your-android-client-id.apps.googleusercontent.com',
  );
}
```

### Mock Authentication (for development)

```dart
// lib/services/mock_auth_service.dart
class MockAuthService implements AuthService {
  @override
  Future<AuthResult> signInWithGoogle() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final mockUser = User(
      id: 1,
      googleId: 'mock_google_id',
      email: 'developer@example.com',
      fullName: 'Mock Developer',
      displayName: 'Mock D.',
      hasCompletedSetup: true,
    );
    
    const mockToken = 'mock_jwt_token_for_development';
    
    return AuthResult.success(mockUser, mockToken);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
```

### Testing

```dart
// test/providers/auth_provider_test.dart
void main() {
  late AuthNotifier authNotifier;
  late MockAuthService mockAuthService;
  late MockUserService mockUserService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserService = MockUserService();
    authNotifier = AuthNotifier(
      authService: mockAuthService,
      userService: mockUserService,
    );
  });

  group('AuthProvider Tests', () {
    test('initial state should be loading', () {
      expect(authNotifier.state, const AuthState.loading());
    });

    test('successful sign in should update state to authenticated', () async {
      when(() => mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => AuthResult.success(mockUser, 'token'));

      await authNotifier.signInWithGoogle();

      expect(authNotifier.state, isA<_Authenticated>());
    });

    test('sign out should update state to unauthenticated', () async {
      // Set up authenticated state first
      authNotifier.state = AuthState.authenticated(mockUser, 'token');

      await authNotifier.signOut();

      expect(authNotifier.state, const AuthState.unauthenticated());
    });
  });
}
```

## Troubleshooting

### Common Issues

#### **1. Google OAuth Fails**
**Symptoms:** "OAuth flow cancelled" or network errors
**Solutions:**
- Verify Google OAuth client ID configuration
- Check network connectivity
- Ensure correct redirect URIs in Google Console
- Verify platform-specific setup (Android SHA certificates, iOS URL schemes)

#### **2. JWT Token Expired**
**Symptoms:** 401 errors, automatic sign-out
**Solutions:**
- Implement token refresh mechanism
- Check server clock synchronization
- Verify JWT expiration time configuration
- Handle expired tokens gracefully in UI

#### **3. Cross-Platform Issues**
**Symptoms:** Works on one platform but not another
**Solutions:**
- Verify platform-specific OAuth client IDs
- Check platform-specific configuration files
- Test OAuth flows on each target platform
- Review platform-specific error logs

### Debug Tools

```dart
// lib/utils/auth_debug.dart
class AuthDebug {
  static void logTokenInfo(String token) {
    if (kDebugMode) {
      try {
        final parts = token.split('.');
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
        );
        
        debugPrint('JWT Payload: ${JsonEncoder.withIndent('  ').convert(payload)}');
        debugPrint('Expires: ${DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000)}');
      } catch (e) {
        debugPrint('Error parsing token: $e');
      }
    }
  }

  static void logAuthState(AuthState state) {
    if (kDebugMode) {
      state.when(
        loading: () => debugPrint('Auth State: Loading'),
        authenticated: (user, token) => debugPrint('Auth State: Authenticated as ${user.displayName}'),
        unauthenticated: () => debugPrint('Auth State: Unauthenticated'),
        error: (message) => debugPrint('Auth State: Error - $message'),
      );
    }
  }
}
```

### Performance Monitoring

```dart
// lib/utils/auth_performance.dart
class AuthPerformance {
  static final Map<String, DateTime> _timers = {};

  static void startTimer(String operation) {
    _timers[operation] = DateTime.now();
  }

  static void endTimer(String operation) {
    final startTime = _timers[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      debugPrint('Auth Operation "$operation" took: ${duration.inMilliseconds}ms');
      _timers.remove(operation);
    }
  }
}

// Usage:
// AuthPerformance.startTimer('google_oauth');
// await signInWithGoogle();
// AuthPerformance.endTimer('google_oauth');
```

---

**This authentication system provides a secure, scalable foundation for A la carte while maintaining the app's focus on personal taste preference management.**

**Next Steps:**
1. Implement OAuth providers for target platforms
2. Set up Google OAuth configuration
3. Create migration path from existing profile system
4. Test cross-platform authentication flows
5. Monitor authentication performance and user experience
