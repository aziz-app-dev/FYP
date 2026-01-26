import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/gestures.dart';

// Navigation
import 'navigation/app_router.dart';

// Controllers
import 'res/colors/app_color.dart';
import 'view_models/controller/account_switcher/account_switcher_controller.dart';

// Views
import 'view/user/main/main_view.dart';
import 'view/vendor/home/vendor_home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize global controllers that persist across the app
  _initializeGlobalControllers();

  runApp(const MyApp());
}

/// Initialize controllers that should persist throughout the app lifecycle
void _initializeGlobalControllers() {
  // Account switcher controller - manages customer/vendor mode switching
  Get.put(AccountSwitcherController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Home Town Bite',
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          theme: ThemeData(
            scaffoldBackgroundColor: kOffWhite,
            iconTheme: const IconThemeData(color: kDark),
            primarySwatch: Colors.grey,
            useMaterial3: true,
          ),
          // Use unified router
          getPages: AppRouter.getRoutes(),
          // Use InitialRouteDecider to determine starting screen
          home: const InitialRouteDecider(),
        );
      },
    );
  }
}

/// Widget that decides the initial route based on auth state and saved mode
class InitialRouteDecider extends StatelessWidget {
  const InitialRouteDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final accountController = Get.find<AccountSwitcherController>();

    // Refresh eligibility in case user data changed
    accountController.refreshEligibility();

    // Check if user is logged in
    if (token == null) {
      // Not logged in - show customer main (browsing allowed without login)
      return const MainScreen();
    }

    // User is logged in - check their preferred mode
    if (accountController.isVendorMode && accountController.canSwitchToVendor) {
      // User prefers vendor mode and has vendor privileges
      return const VendorHomeView();
    }

    // Default to customer mode
    return const MainScreen();
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
