import 'package:flutter/foundation.dart';

import '../../repo/user/address/address_repo.dart';
import '../../repo/user/profile/profile_repo.dart';
import '../../repo/user/settings/settings_repo.dart';
import '../session/session_manger.dart';

/// Callback for when token expires
typedef OnTokenExpiredCallback = void Function();

/// Service to handle background data loading without blocking UI
class BackgroundDataService {
  static final BackgroundDataService _instance = BackgroundDataService._internal();

  final SessionManager _sessionManager = SessionManager();
  final SettingsRepo _settingsRepo = SettingsRepo();
  final ProfileRepo _profileRepo = ProfileRepo();
  final AddressRepo _addressRepo = AddressRepo();

  bool _isLoadingSettings = false;
  bool _isLoadingProfile = false;
  bool _isLoadingAddresses = false;
  bool _isCheckingToken = false;

  /// Callback to be called when token expires
  OnTokenExpiredCallback? onTokenExpired;

  BackgroundDataService._internal();

  factory BackgroundDataService() {
    return _instance;
  }

  /// Load all background data (settings + profile if logged in)
  /// This runs in the background and doesn't block navigation
  Future<void> loadAllBackgroundData() async {
    // First check if token is expired
    unawaited(_checkTokenExpiration());

    // Run all in parallel without waiting
    unawaited(_loadSettingsInBackground());
    unawaited(_loadProfileInBackground());
    unawaited(_loadAddressesInBackground());
  }

  /// Check if token is expired and handle logout
  Future<void> _checkTokenExpiration() async {
    if (_isCheckingToken) return;
    _isCheckingToken = true;

    try {
      if (!_sessionManager.isLoggedIn) return;

      final isExpired = await _sessionManager.checkAndHandleTokenExpiration();
      if (isExpired) {
        debugPrint('BackgroundDataService: Token expired, user logged out');
        // Notify listeners that token expired
        onTokenExpired?.call();
      } else {
        // Check if token will expire soon (within 1 day)
        final willExpire = await _sessionManager.willTokenExpireSoon(
          threshold: const Duration(days: 1),
        );
        if (willExpire) {
          debugPrint('BackgroundDataService: Token will expire soon');
          // You could trigger a token refresh here if your backend supports it
        }
      }
    } catch (e) {
      debugPrint('BackgroundDataService: Error checking token: $e');
    } finally {
      _isCheckingToken = false;
    }
  }

  /// Load settings in background
  Future<void> _loadSettingsInBackground() async {
    if (_isLoadingSettings) return;
    _isLoadingSettings = true;

    try {
      debugPrint('BackgroundDataService: Loading settings...');
      final settings = await _settingsRepo.getSettings();
      await _sessionManager.saveSettings(settings);
      debugPrint('BackgroundDataService: Settings loaded and saved');
    } catch (e) {
      debugPrint('BackgroundDataService: Error loading settings: $e');
      // Silently fail - user can still use cached data
    } finally {
      _isLoadingSettings = false;
    }
  }

  /// Load profile in background (only if user is logged in and token valid)
  Future<void> _loadProfileInBackground() async {
    if (_isLoadingProfile) return;

    // Only load profile if user is logged in
    if (!_sessionManager.isLoggedIn) {
      debugPrint('BackgroundDataService: User not logged in, skipping profile load');
      return;
    }

    // Check token before making API call
    final isExpired = await _sessionManager.isTokenExpired();
    if (isExpired) {
      debugPrint('BackgroundDataService: Token expired, skipping profile load');
      return;
    }

    _isLoadingProfile = true;

    try {
      final token = await _sessionManager.getToken();
      if (token == null) {
        debugPrint('BackgroundDataService: No token, skipping profile load');
        return;
      }

      debugPrint('BackgroundDataService: Loading profile...');
      final user = await _profileRepo.getUser(token: token);
      await _sessionManager.updateUser(user);
      debugPrint('BackgroundDataService: Profile loaded and saved');
    } catch (e) {
      debugPrint('BackgroundDataService: Error loading profile: $e');
      // Check if error is due to invalid/expired token (403 or 401)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('401') ||
          errorString.contains('403') ||
          errorString.contains('unauthorized') ||
          errorString.contains('invalid token')) {
        debugPrint('BackgroundDataService: Token invalid, logging out');
        await _sessionManager.clearSession();
        onTokenExpired?.call();
      }
      // Silently fail for other errors - user can still use cached data
    } finally {
      _isLoadingProfile = false;
    }
  }

  /// Load user addresses in background (only if logged in)
  Future<void> _loadAddressesInBackground() async {
    if (_isLoadingAddresses) return;

    if (!_sessionManager.isLoggedIn) {
      debugPrint('BackgroundDataService: User not logged in, skipping addresses load');
      return;
    }

    final isExpired = await _sessionManager.isTokenExpired();
    if (isExpired) {
      debugPrint('BackgroundDataService: Token expired, skipping addresses load');
      return;
    }

    _isLoadingAddresses = true;

    try {
      final token = await _sessionManager.getToken();
      if (token == null) {
        debugPrint('BackgroundDataService: No token, skipping addresses load');
        return;
      }

      debugPrint('BackgroundDataService: Loading addresses...');
      final addresses = await _addressRepo.getUserAddresses(token);
      await _sessionManager.saveAddresses(addresses);

      // Find and save default address
      final defaultAddr = addresses.where((a) => a.isDefault).firstOrNull;
      if (defaultAddr != null) {
        await _sessionManager.saveDefaultAddress(defaultAddr);
      }

      debugPrint('BackgroundDataService: Addresses loaded and saved (${addresses.length})');
    } catch (e) {
      debugPrint('BackgroundDataService: Error loading addresses: $e');
    } finally {
      _isLoadingAddresses = false;
    }
  }

  /// Refresh settings only
  Future<void> refreshSettings() async {
    await _loadSettingsInBackground();
  }

  /// Refresh profile only
  Future<void> refreshProfile() async {
    await _loadProfileInBackground();
  }

  /// Refresh addresses only
  Future<void> refreshAddresses() async {
    await _loadAddressesInBackground();
  }

  /// Check token expiration manually
  Future<bool> checkTokenExpiration() async {
    await _checkTokenExpiration();
    return !_sessionManager.isLoggedIn;
  }
}

/// Helper function for fire-and-forget futures
void unawaited(Future<void> future) {
  // Intentionally not awaiting
}
