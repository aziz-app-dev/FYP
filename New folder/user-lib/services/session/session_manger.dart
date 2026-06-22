import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../model/address/address_model.dart';
import '../../model/auth/user_model.dart';
import '../../model/settings/card_style_settings.dart';
import '../../model/settings/food_details_config.dart';
import '../../model/settings/settings_model.dart';
import '../../utils/jwt_utils.dart';
import '../storage/local_storage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  final LocalStorage _localStorage = LocalStorage();

  UserModel? user;
  SettingsModel? settings;
  CardStyleSettings cardStyleSettings = CardStyleSettings.defaults();
  List<AddressModel>? addresses;
  AddressModel? defaultAddress;
  bool isLoggedIn = false;
  bool isFirstTime = true;

  SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  // Keys for storage
  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsFirstTime = 'is_first_time';
  static const String _keyToken = 'user_token';
  static const String _keySettings = 'app_settings';
  static const String _keyAddresses = 'user_addresses';
  static const String _keyDefaultAddress = 'default_address';
  static const String _keyCardStyles = 'card_style_settings';

  /// Save user data after successful login
  Future<void> saveUser(UserModel userData) async {
    try {
      user = userData;
      isLoggedIn = true;

      await _localStorage.setValue(_keyUser, jsonEncode(userData.toJson()));
      await _localStorage.setValue(_keyIsLoggedIn, 'true');
      if (userData.userToken != null) {
        await _localStorage.setValue(_keyToken, userData.userToken!);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get user token
  Future<String?> getToken() async {
    return await _localStorage.getValue(_keyToken);
  }

  /// Load user session from storage
  Future<void> loadSession() async {
    try {
      final userJson = await _localStorage.getValue(_keyUser);
      final loggedIn = await _localStorage.getValue(_keyIsLoggedIn);
      final firstTime = await _localStorage.getValue(_keyIsFirstTime);

      if (userJson != null && userJson.isNotEmpty) {
        user = UserModel.fromJson(jsonDecode(userJson));
        isLoggedIn = loggedIn == 'true';
      }

      // If firstTime key doesn't exist, it's the first time
      isFirstTime = firstTime == null;

      // Load addresses and card styles
      await loadAddresses();
      await loadCardStyleSettings();
    } catch (e) {
      isLoggedIn = false;
      user = null;
    }
  }

  /// Mark onboarding as completed (no longer first time)
  Future<void> completeOnboarding() async {
    isFirstTime = false;
    await _localStorage.setValue(_keyIsFirstTime, 'false');
  }

  /// Check if this is the first time opening the app
  Future<bool> checkFirstTime() async {
    final firstTime = await _localStorage.getValue(_keyIsFirstTime);
    isFirstTime = firstTime == null;
    return isFirstTime;
  }

  /// Clear user session (logout)
  Future<void> clearSession() async {
    user = null;
    addresses = null;
    defaultAddress = null;
    isLoggedIn = false;

    await _localStorage.clearValues(_keyUser);
    await _localStorage.clearValues(_keyIsLoggedIn);
    await _localStorage.clearValues(_keyToken);
    await _localStorage.clearValues(_keyAddresses);
    await _localStorage.clearValues(_keyDefaultAddress);
  }

  /// Clear all data including first time flag
  Future<void> clearAll() async {
    user = null;
    settings = null;
    addresses = null;
    defaultAddress = null;
    isLoggedIn = false;
    isFirstTime = true;

    await _localStorage.clearAll();
  }

  /// Update user profile image in local storage
  Future<void> updateProfileImage(String imageUrl) async {
    if (user != null) {
      user = user!.copyWith(profile: imageUrl);
      await _localStorage.setValue(_keyUser, jsonEncode(user!.toJson()));
    }
  }

  /// Update user data in local storage
  Future<void> updateUser(UserModel updatedUser) async {
    // Preserve the existing token
    final existingToken = user?.userToken;
    user = updatedUser.copyWith(userToken: existingToken ?? updatedUser.userToken);
    await _localStorage.setValue(_keyUser, jsonEncode(user!.toJson()));
  }

  /// Save settings to local storage
  Future<void> saveSettings(SettingsModel settingsData) async {
    try {
      settings = settingsData;
      await _localStorage.setValue(_keySettings, jsonEncode(settingsData.toJson()));
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  /// Load settings from local storage
  Future<void> loadSettings() async {
    try {
      final settingsJson = await _localStorage.getValue(_keySettings);
      if (settingsJson != null && settingsJson.isNotEmpty) {
        settings = SettingsModel.fromJson(jsonDecode(settingsJson));
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      settings = null;
    }
  }

  // ============= Card Style Settings =============

  /// Save card style settings to local storage
  Future<void> saveCardStyleSettings(CardStyleSettings styleSettings) async {
    try {
      cardStyleSettings = styleSettings;
      await _localStorage.setValue(_keyCardStyles, styleSettings.toJsonString());
    } catch (e) {
      debugPrint('Error saving card style settings: $e');
    }
  }

  /// Load card style settings from local storage
  Future<void> loadCardStyleSettings() async {
    try {
      final json = await _localStorage.getValue(_keyCardStyles);
      if (json != null && json.isNotEmpty) {
        cardStyleSettings = CardStyleSettings.fromJsonString(json);
      }
    } catch (e) {
      debugPrint('Error loading card style settings: $e');
      cardStyleSettings = CardStyleSettings.defaults();
    }
  }

  // ============= Address Methods =============

  /// Save addresses to local storage
  Future<void> saveAddresses(List<AddressModel> addressList) async {
    try {
      addresses = addressList;
      final jsonList = addressList.map((a) => a.toJson()).toList();
      await _localStorage.setValue(_keyAddresses, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  /// Save default address to local storage
  Future<void> saveDefaultAddress(AddressModel address) async {
    try {
      defaultAddress = address;
      await _localStorage.setValue(_keyDefaultAddress, jsonEncode(address.toJson()));
    } catch (e) {
      debugPrint('Error saving default address: $e');
    }
  }

  /// Load addresses from local storage
  Future<void> loadAddresses() async {
    try {
      final addressesJson = await _localStorage.getValue(_keyAddresses);
      if (addressesJson != null && addressesJson.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(addressesJson);
        addresses = jsonList.map((json) => AddressModel.fromJson(json)).toList();
      }

      final defaultJson = await _localStorage.getValue(_keyDefaultAddress);
      if (defaultJson != null && defaultJson.isNotEmpty) {
        defaultAddress = AddressModel.fromJson(jsonDecode(defaultJson));
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
      addresses = null;
      defaultAddress = null;
    }
  }

  /// Clear only addresses
  Future<void> clearAddresses() async {
    addresses = null;
    defaultAddress = null;
    await _localStorage.clearValues(_keyAddresses);
    await _localStorage.clearValues(_keyDefaultAddress);
  }

  /// Check if user has addresses
  bool get hasAddresses => addresses != null && addresses!.isNotEmpty;

  /// Get display address (default or first)
  AddressModel? get displayAddress {
    if (defaultAddress != null) return defaultAddress;
    if (addresses != null && addresses!.isNotEmpty) {
      final def = addresses!.where((a) => a.isDefault).firstOrNull;
      return def ?? addresses!.first;
    }
    return null;
  }

  // ============= Settings Getters =============

  /// Get currency symbol from settings
  String get currencySymbol => settings?.currencySymbol ?? '\$';

  /// Get delivery fee from settings
  double get deliveryFee => settings?.deliveryFee ?? 0.0;

  /// Get tax rate from settings
  double get taxRate => settings?.taxRate ?? 0.0;

  /// Check if app is in multi-vendor mode
  bool get isMultiVendor => settings?.serviceMode == 'multi-vendor';

  /// Get food details config from settings (or defaults)
  FoodDetailsConfig get foodDetailsConfig =>
      settings?.foodDetailsConfig ?? FoodDetailsConfig.defaults();

  /// Check if ordering is enabled
  bool get isOrderingEnabled => settings?.isOrderingEnabled ?? true;

  /// Check if app is in reservation-only mode
  bool get isReservationOnly => !isOrderingEnabled && isTableReservationEnabled;

  /// Check if app is in single restaurant mode (with ordering)
  bool get isSingleRestaurant => !isMultiVendor && isOrderingEnabled;

  /// Get the default restaurant ID (for single mode)
  String? get defaultRestaurantId => settings?.defaultRestaurantId;

  /// Check if table reservation is enabled globally
  bool get isTableReservationEnabled =>
      settings?.reservationConfig?.enableTableReservation ?? false;

  /// Check if RTL is enabled
  bool get rtl => settings?.rtl ?? false;

  /// Get the current app language
  String get language => settings?.language ?? 'en';

  // ============= API & Payment Key Getters =============

  String get mapboxAccessToken => settings?.apiKeys?.mapboxKey ?? '';
  String get googlePlacesApiKey => settings?.apiKeys?.googleMapsKey ?? '';
  String get admobBannerKey => settings?.apiKeys?.admobBannerKey ?? '';
  String get admobNativeKey => settings?.apiKeys?.admobNativeKey ?? '';
  String get admobInterstitialKey => settings?.apiKeys?.admobInterstitialKey ?? '';
  
  String get stripePublishableKey => settings?.apiKeys?.stripePublishableKey ?? '';
  String get stripeSecretKey => settings?.apiKeys?.stripeSecretKey ?? '';
  String get paypalClientId => settings?.apiKeys?.paypalClientId ?? '';
  String get paypalSecretKey => settings?.apiKeys?.paypalSecretKey ?? '';

  // ============= Vendor Getters =============

  /// Check if the current user is a vendor
  bool get isVendor => user?.userType == 'Vendor';

  /// Check if the current user is an admin
  bool get isAdmin => user?.userType == 'Admin';

  /// Check if the current user is a driver
  bool get isDriver =>
      user?.userType?.toLowerCase() == 'driver' ||
      user?.userType?.toLowerCase() == 'delivery';

  /// Check if the current user is a client
  bool get isClient => user?.userType == 'Client' || user?.userType == null;

  // ============= Token Methods =============

  /// Get token synchronously from user model (for headers)
  String? get token => user?.userToken;

  /// Check if the user token is expired
  Future<bool> isTokenExpired() async {
    final token = await getToken();
    return JwtUtils.isTokenExpired(token);
  }

  /// Check token and logout if expired
  /// Returns true if token was expired and user was logged out
  Future<bool> checkAndHandleTokenExpiration() async {
    if (!isLoggedIn) return false;

    final token = await getToken();
    if (JwtUtils.isTokenExpired(token)) {
      debugPrint('SessionManager: Token expired, logging out user');
      await clearSession();
      return true;
    }
    return false;
  }

  /// Get token expiration date
  Future<DateTime?> getTokenExpirationDate() async {
    final token = await getToken();
    return JwtUtils.getExpirationDate(token);
  }

  /// Check if token will expire soon (within given duration)
  Future<bool> willTokenExpireSoon({Duration threshold = const Duration(days: 1)}) async {
    final token = await getToken();
    return JwtUtils.willExpireSoon(token, threshold);
  }
}
