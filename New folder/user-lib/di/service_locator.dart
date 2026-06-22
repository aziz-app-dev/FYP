import 'package:get_it/get_it.dart';

import 'bloc_module.dart';
import 'repo_module.dart';
import '../services/socket/socket_service.dart';
import '../services/notification/notification_service.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
void setupServiceLocator() {
  // Register repositories first (BLoCs depend on them)
  registerRepositories(getIt);

  // Register BLoCs (factories — new instance per call)
  registerBlocs(getIt);

  // Register Services
  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
}
