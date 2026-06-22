import 'package:flutter/material.dart';

import '../model/order/order_model.dart';
import '../ui/driver/auth/driver_otp_page.dart';
import '../ui/driver/main/driver_main_screen.dart';
import '../ui/driver/ratings/driver_ratings_page.dart';
import '../ui/driver/tasks/driver_task_details_page.dart';
import 'route_name.dart';

class AppRouter {
  static MaterialPageRoute<dynamic> genrateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.driverMain:
        return MaterialPageRoute(builder: (_) => const DriverMainScreen());
      case RouteName.driverOtp:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => DriverOtpPage(email: email));
      case RouteName.driverRatings:
        return MaterialPageRoute(builder: (_) => const DriverRatingsPage());
      case RouteName.driverTaskDetails:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => DriverTaskDetailsPage(order: order),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
