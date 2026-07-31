import 'package:get/get.dart';

import '../../../views/auth/login_view.dart';
import '../../../views/shell/admin_shell.dart';
import '../../../views/splash/splash_view.dart';
import 'routes_name.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.LoginScreen,
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.adminHome,
          page: () => const AdminShell(),
          transition: Transition.fadeIn,
        ),
      ];
}
