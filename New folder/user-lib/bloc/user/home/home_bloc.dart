import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../repo/user/home/home_http_repo.dart';
import 'home_events.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  final HomeHttpRepo homeHttpRepo;

  HomeBloc({required this.homeHttpRepo})
      : super(HomeStates(homeData: ApiResponse.loading())) {
    on<FetchHomeData>(_fetchHomeData);
  }

  Future<void> _fetchHomeData(
      FetchHomeData event, Emitter<HomeStates> emit) async {
    emit(state.copyWith(homeData: ApiResponse.loading()));
    await homeHttpRepo.fetchHomeData().then((value) {
      emit(state.copyWith(homeData: ApiResponse.success(value)));
    }).onError((error, stackTrace) {
      emit(state.copyWith(homeData: ApiResponse.error(error.toString())));
    });
  }
}
