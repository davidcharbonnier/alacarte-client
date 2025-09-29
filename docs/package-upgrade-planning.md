# Package Upgrade Planning and Dependency Management

## Current Status

**Last Updated**: September 23, 2025  
**Flutter Version**: 3.35.6 (stable channel)  
**Dart Version**: 3.9.2

## Current Package Versions

### Core Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.6.1        # Available: 3.0.0+ (MAJOR)
  go_router: ^16.2.1               # Available: 16.2.2+ (MINOR)
  dio: ^5.7.0                      # Available: 5.8.0+ (MINOR)
  connectivity_plus: ^6.0.5        # Available: 7.8.0+ (MAJOR)
  shared_preferences: ^2.3.2       # Available: 2.4.13+ (MINOR)
  cupertino_icons: ^1.0.8          # Available: 1.0.8 (CURRENT)
```

### Development Dependencies
```yaml
dev_dependencies:
  json_serializable: ^6.8.0       # Available: 6.8.0+ (MINOR)
  build_runner: ^2.4.13            # Available: 2.4.13+ (PATCH)
  freezed: ^3.2.3                  # Available: 3.2.3+ (PATCH)
```

## Upgrade Risk Assessment

### Low Risk Upgrades (Safe to Apply)

#### 1. Minor Version Updates
- **`dio`**: 5.7.0 → 5.8.0+
  - **Risk**: Low - patch/minor updates typically backward compatible
  - **Impact**: Potential bug fixes and performance improvements
  - **Testing Required**: Basic API communication verification

- **`shared_preferences`**: 2.3.2 → 2.4.13+
  - **Risk**: Low - stable API, minor version bump
  - **Impact**: Better platform support, bug fixes
  - **Testing Required**: User profile storage/retrieval

- **`go_router`**: 16.2.1 → 16.2.2+
  - **Risk**: Low - patch version update
  - **Impact**: Bug fixes in routing
  - **Testing Required**: Navigation flow verification

### High Risk Upgrades (Require Careful Testing)

#### 1. Riverpod 2.6.1 → 3.0.0+
**Risk Level**: HIGH - Major version with breaking changes

**Potential Breaking Changes**:
- Provider listening patterns may change
- StateNotifier deprecation (possible migration to Notifier)
- AsyncValue handling updates
- Provider family syntax changes

**Testing Requirements**:
```dart
// Current patterns to verify:
ref.listen(authProvider, (previous, next) { /* ... */ });
ref.watch(authProvider.select((state) => state.isAuthenticated));
StateNotifierProvider<AuthNotifier, AuthState>(...);
```

**Migration Strategy**:
1. Test in isolated branch
2. Check all provider listeners in app
3. Verify AsyncValue.when() usage
4. Test state management patterns
5. Update documentation if patterns change

#### 2. Connectivity Plus 6.0.5 → 7.8.0+
**Risk Level**: HIGH - Major version with API changes

**Potential Breaking Changes**:
- ConnectivityResult enum changes
- Platform-specific implementation updates
- Stream handling modifications

**Current Usage to Verify**:
```dart
// In connectivity_provider.dart
final connectivityResults = await Connectivity().checkConnectivity();
Connectivity().onConnectivityChanged.listen(...);
```

**Testing Requirements**:
- Connectivity detection on all platforms
- Network state changes handling
- Offline/online transitions
- Background connectivity monitoring

## Upgrade Strategy

### Phase 1: Safe Updates First
Update low-risk packages to latest versions:

```yaml
dependencies:
  dio: ^5.8.0
  shared_preferences: ^2.4.13
  go_router: ^16.2.2
```

**Testing Checklist**:
- [ ] API communication works
- [ ] User profile storage functions correctly
- [ ] Navigation flows work as expected
- [ ] No new warnings or errors

### Phase 2: Individual Major Updates

#### A. Test Riverpod 3.x Migration
1. **Create test branch**: `feature/riverpod-3-upgrade`
2. **Update dependency**: `flutter_riverpod: ^3.0.0`
3. **Run analysis**: `flutter analyze`
4. **Address breaking changes** systematically
5. **Test all provider functionality**
6. **Update documentation** if patterns change

#### B. Test Connectivity Plus 7.x Migration  
1. **Create test branch**: `feature/connectivity-plus-7-upgrade`
2. **Update dependency**: `connectivity_plus: ^7.8.0`
3. **Check connectivity implementation**
4. **Test on multiple platforms** (Linux, Web, Android)
5. **Verify offline/online transitions**

### Phase 3: Combined Testing
Once individual upgrades are verified:
1. **Merge all updates** into single branch
2. **Test complete app functionality**
3. **Run on all target platforms**
4. **Performance testing**
5. **User acceptance testing**

## Testing Protocol

### Pre-Upgrade Testing
Document current behavior to verify nothing breaks:

```bash
# Run comprehensive tests
flutter test
flutter analyze
flutter build web --release
flutter build apk --debug

# Platform-specific testing
flutter run -d linux
flutter run -d web-server
flutter run -d android
```

### Post-Upgrade Verification

#### Core Functionality Testing
- [ ] User authentication and profile management
- [ ] Rating CRUD operations (create, edit, delete, share)
- [ ] Item management (cheese CRUD)
- [ ] Search and filtering functionality
- [ ] Offline/online connectivity handling
- [ ] Navigation and routing behavior
- [ ] Settings and privacy controls

#### Platform-Specific Testing
- [ ] **Linux**: Desktop UI and functionality
- [ ] **Web**: Browser compatibility and PWA features
- [ ] **Android**: Mobile UI and device-specific features

#### Performance Testing
- [ ] App startup time
- [ ] Navigation responsiveness
- [ ] API call performance
- [ ] Memory usage patterns
- [ ] Build time changes

## Migration Documentation

### Breaking Changes Log
Document any required code changes during upgrades:

```markdown
## Riverpod 2.x → 3.x Migration

### Provider Listening Changes
- Before: `ref.listen(provider, callback)`
- After: `ref.listen(provider, callback)` (same, but callback signature may change)

### StateNotifier Deprecation
- Before: `class AuthNotifier extends StateNotifier<AuthState>`
- After: `class AuthNotifier extends Notifier<AuthState>` (if deprecated)
```

### Performance Impact Assessment
Track performance changes during upgrades:

```markdown
## Performance Comparison

### Before Upgrade
- Startup time: ~500ms
- Navigation transition: ~100ms
- API response handling: ~50ms

### After Upgrade  
- Startup time: [TBD]
- Navigation transition: [TBD]
- API response handling: [TBD]
```

## Rollback Strategy

### Version Pinning
Keep working version configuration in version control:

```yaml
# Known working configuration (September 2025)
dependencies:
  flutter_riverpod: 2.6.1
  go_router: 16.2.1
  dio: 5.7.0
  connectivity_plus: 6.0.5
  shared_preferences: 2.3.2
```

### Quick Rollback Process
```bash
# Restore previous pubspec.yaml
git checkout HEAD~1 -- pubspec.yaml
flutter clean
flutter pub get
flutter run -d [platform]
```

## Future Considerations

### Long-Term Maintenance
- **Regular update schedule**: Monthly review of package updates
- **Security updates**: Prioritize packages with security fixes
- **Flutter SDK alignment**: Keep packages compatible with target Flutter version
- **Deprecation planning**: Monitor for package deprecation announcements

### Platform-Specific Packages
As the app expands to more platforms:
- **iOS-specific dependencies**: Add when iOS development begins
- **Web-specific optimizations**: PWA-related packages
- **Desktop enhancements**: Platform-specific integrations

This upgrade planning ensures the A la carte app maintains stability while benefiting from the latest improvements in the Flutter ecosystem.
