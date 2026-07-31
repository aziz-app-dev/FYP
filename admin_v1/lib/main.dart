import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'common/res/colors/app_color.dart';
import 'common/res/routes/routes.dart';
import 'common/utils/utils.dart';
import 'views/splash/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FYP Super Admin',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Utils.scaffoldMessengerKey,
      scrollBehavior: _AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSecondary),
        scaffoldBackgroundColor: kOffWhite,
        useMaterial3: true,
      ),
      getPages: AppRoutes.appRoutes(),
      home: const SplashScreen(),
    );
  }
}

/// Allow mouse-drag scrolling too (useful on web/desktop builds).
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
