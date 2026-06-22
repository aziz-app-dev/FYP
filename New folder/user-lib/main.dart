// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'bloc/shared/profile/profile_bloc.dart';
import 'bloc/shared/profile/profile_event.dart';
import 'bloc/shared/profile/profile_state.dart';
import 'config/config.dart';
import 'di/service_locator.dart';
import 'routes/app_router.dart';
import 'routes/route_name.dart';
import 'services/notification/notification_service.dart';
import 'services/socket/socket_service.dart';
import 'const/urls/user_url.dart';
import 'services/session/session_manger.dart';

StreamSubscription<Map<String, dynamic>>? _globalNotificationSub;
StreamSubscription<Map<String, dynamic>>? _restaurantStatusSub;
StreamSubscription<Map<String, dynamic>>? _adminRestaurantRequestSub;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserUrl.init();
  setupServiceLocator();

  // Initialize Notification Service
  await getIt<NotificationService>().init();

  // Try to initialize Socket Service if user is already logged in
  final session = SessionManager();
  _globalNotificationSub = getIt<SocketService>().globalNotifications.listen((
    data,
  ) {
    final title = data['title']?.toString() ?? 'Notification';
    final body = data['body']?.toString() ?? 'You have a new notification';
    unawaited(
      getIt<NotificationService>().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
      ),
    );
  });
  _restaurantStatusSub = getIt<SocketService>().restaurantStatusUpdates.listen((
    data,
  ) {
    final title = data['title']?.toString() ?? 'Restaurant Update';
    final body =
        data['body']?.toString() ?? 'Your restaurant status has changed.';
    unawaited(
      getIt<NotificationService>().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
      ),
    );
  });
  _adminRestaurantRequestSub = getIt<SocketService>().adminRestaurantRequests
      .listen((data) {
        final title = 'New Restaurant Request';
        final body = data['title']?.toString().isNotEmpty == true
            ? '${data['title']} is waiting for review.'
            : 'A restaurant request is waiting for review.';
        unawaited(
          getIt<NotificationService>().showNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: title,
            body: body,
          ),
        );
      });

  final token = await session.getToken();
  if (token != null) {
    getIt<SocketService>().init(token, userId: session.user?.id);
  }

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<ProfileBloc>()
                ..add(LoadThemeEvent())
                ..add(LoadSettingsEvent()),
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.rtl != current.rtl ||
                previous.language != current.language,
            builder: (context, state) {
              return MaterialApp(
                title: 'Foodie',
                debugShowCheckedModeBanner: false,
                // initialRoute: RouteName.onboardingTwo,
                initialRoute: RouteName.splash,
                onGenerateRoute: AppRouter.genrateRoute,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                locale: Locale(state.language),
                builder: (context, child) {
                  return Directionality(
                    textDirection: state.rtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: child!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
