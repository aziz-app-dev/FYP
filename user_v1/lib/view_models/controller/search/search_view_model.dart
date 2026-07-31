import 'package:get/get.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/search/search_reqpositry.dart';

class FoodSearchController extends GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  final searchFoodList = <FoodModel>[].obs;
  final RxString error = ''.obs;

  final SearchRepository _api = SearchRepository();

  void setSearchFoodList(List<FoodModel> value) =>
      searchFoodList.assignAll(value);
  void setError(String value) => error.value = value;

  void searchSearchApi(String text) {
    setLoading = true;
    _api.searchApi(text).then((value) {
      setLoading = false;
      searchFoodList(value);
    }).onError((error, stackTrace) {
      setLoading = false;
      // print(error.toString());
      setError(error.toString());
    });
  }

  void refreshApi(String text) {
    setLoading = true;
    _api.searchApi(text).then((value) {
      setLoading = false;
      searchFoodList(value);
    }).onError((error, stackTrace) {
      setLoading = false;
      setError(error.toString());
      // print(error.toString());
    });
  }
}
