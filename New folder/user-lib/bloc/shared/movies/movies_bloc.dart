import 'package:bloc/bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../repo/shared/movies/movies_http_repo.dart';
import 'movies_events.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesHttpRepo moviesHttpRepo;
  MoviesBloc({required this.moviesHttpRepo})
    : super(MoviesState(moviesList: ApiResponse.loading())) {
    on<FetchMovies>(fetchMovies);
  }
  Future<void> fetchMovies(FetchMovies event, Emitter<MoviesState> emit) async {
    await moviesHttpRepo
        .fetchMoviesApi()
        .then((value) {
          emit(state.copyWith(moviesList: ApiResponse.success(value)));
        })
        .onError((error, stackTrace) {
          emit(state.copyWith(moviesList: ApiResponse.error(error.toString())));
        });
  }
}
