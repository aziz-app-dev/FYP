import 'package:get_it/get_it.dart';

import '../repo/driver/driver_repo.dart';

void registerRepositories(GetIt sl) {
  sl.registerLazySingleton<DriverRepo>(() => DriverRepo());
}
