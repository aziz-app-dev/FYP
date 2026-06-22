import '../../../model/home/home_model.dart';

abstract class HomeRepo {
  Future<HomeData> fetchHomeData();
}
