import 'package:get_it/get_it.dart';

import '../bloc/shared/profile/profile_bloc.dart';
import '../bloc/driver/driver_cubit.dart';
import '../repo/driver/driver_repo.dart';
import '../services/session/session_manger.dart';

void registerBlocs(GetIt sl) {
  // Shared
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());

  // Driver
  sl.registerFactory<DriverCubit>(
    () => DriverCubit(repo: sl<DriverRepo>(), session: SessionManager()),
  );
}
