import '../../../model/movies_model.dart';

abstract class MoviesRepo {
  Future<MoviesModel> fetchMoviesApi();
}
