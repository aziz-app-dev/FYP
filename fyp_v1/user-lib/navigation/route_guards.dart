import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../view_models/controller/account_switcher/account_switcher_controller.dart';
import 'route_names.dart';

/// Middleware to check if user is authenticated
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null) {
      return const RouteSettings(name: RouteNames.login);
    }
    return null;
  }
}

/// Middleware to ensure user is in vendor mode and has vendor privileges
class VendorModeMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final controller = Get.find<AccountSwitcherController>();

      if (!controller.canSwitchToVendor) {
        Get.snackbar(
          'Access Denied',
          'You need a vendor account to access this feature',
          snackPosition: SnackPosition.BOTTOM,
        );
        return const RouteSettings(name: RouteNames.customerMain);
      }

      if (!controller.isVendorMode) {
        Get.snackbar(
          'Switch Mode',
          'Please switch to Vendor mode to access this feature',
          snackPosition: SnackPosition.BOTTOM,
        );
        return const RouteSettings(name: RouteNames.customerMain);
      }
    } catch (e) {
      // Controller not found, redirect to customer main
      return const RouteSettings(name: RouteNames.customerMain);
    }

    return null;
  }
}

/// Middleware to handle customer mode routes
class CustomerModeMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final controller = Get.find<AccountSwitcherController>();

      // If user is in vendor mode, redirect vendor routes
      if (controller.isVendorMode && controller.canSwitchToVendor) {
        // Allow access but could show a notification
        return null;
      }
    } catch (e) {
      // Controller not found, allow access
    }

    return null;
  }
}

/// Middleware to check if user is logged in (for protected routes)
class LoggedInMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null) {
      // Store the intended route to redirect after login
      box.write('redirectAfterLogin', route);
      return const RouteSettings(name: RouteNames.login);
    }
    return null;
  }
}

/// Middleware to redirect logged-in users away from auth pages
class GuestOnlyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final token = box.read('token');

    if (token != null) {
      // User is already logged in, redirect to main
      try {
        final controller = Get.find<AccountSwitcherController>();
        if (controller.isVendorMode && controller.canSwitchToVendor) {
          return const RouteSettings(name: RouteNames.vendorMain);
        }
      } catch (e) {
        // Controller not found
      }
      return const RouteSettings(name: RouteNames.customerMain);
    }
    return null;
  }
}
