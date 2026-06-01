import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/enums/user_type.dart';
import '../../../utils/utils.dart';

/// Controller for managing account mode switching between Customer and Vendor
class AccountSwitcherController extends GetxController {
  final GetStorage _box = GetStorage();

  // Observable for current active mode
  final Rx<UserType> _currentMode = UserType.customer.obs;
  UserType get currentMode => _currentMode.value;

  // Whether user has vendor privileges and can switch to vendor mode
  final RxBool _canSwitchToVendor = false.obs;
  bool get canSwitchToVendor => _canSwitchToVendor.value;

  // User type from backend (what the user registered as)
  final RxString _userType = 'customer'.obs;
  String get userType => _userType.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedMode();
    _checkVendorEligibility();
  }

  /// Load the saved mode from local storage
  void _loadSavedMode() {
    final savedMode = _box.read('activeMode');
    if (savedMode != null) {
      _currentMode.value = UserType.fromString(savedMode);
    }
  }

  /// Check if user is eligible to switch to vendor mode based on their userType
  void _checkVendorEligibility() {
    final userId = _box.read('userId');
    if (userId != null) {
      final userData = _box.read(userId);
      if (userData != null) {
        try {
          final userMap = json.decode(userData);
          final type = userMap['userType'] as String? ?? 'customer';
          _userType.value = type;
          // User can switch to vendor if their userType is 'vendor' or 'both'
          _canSwitchToVendor.value =
              type.toLowerCase() == 'vendor' || type.toLowerCase() == 'both';
        } catch (e) {
          _canSwitchToVendor.value = false;
        }
      }
    }
  }

  /// Refresh vendor eligibility (call after login)
  void refreshEligibility() {
    _checkVendorEligibility();
  }

  /// Switch to customer mode
  void switchToCustomerMode() {
    _currentMode.value = UserType.customer;
    _box.write('activeMode', UserType.customer.toStorageString());
  }

  /// Switch to vendor mode (if eligible)
  bool switchToVendorMode() {
    if (!canSwitchToVendor) {
      Utils.showError(
        'Access Denied',
        'You need a vendor account to access vendor features',
      );
      return false;
    }
    _currentMode.value = UserType.vendor;
    _box.write('activeMode', UserType.vendor.toStorageString());
    return true;
  }

  /// Check if currently in vendor mode
  bool get isVendorMode => _currentMode.value == UserType.vendor;

  /// Check if currently in customer mode
  bool get isCustomerMode => _currentMode.value == UserType.customer;

  /// Clear mode on logout
  void clearMode() {
    _currentMode.value = UserType.customer;
    _canSwitchToVendor.value = false;
    _box.remove('activeMode');
  }
}
