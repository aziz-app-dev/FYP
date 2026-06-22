import '../../../data/api/network_services_api.dart';
import '../../../model/movies_model.dart';
import 'movies_repo.dart';

class MoviesHttpRepo implements MoviesRepo {
  final _apiServies = NetworkServicesApi();

  @override
  Future<MoviesModel> fetchMoviesApi() async {
    final res = await _apiServies.getApi(
      "https://www.episodate.com/api/most-popular?page=1",
    );
    return MoviesModel.fromJson(res);
  }
}
