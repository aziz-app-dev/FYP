import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/error/error_model.dart';
import '../../models/food/food_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_result.dart';

FetchHook useFetchFoodByCategory(String categoryValue) {
  // final _categoryController = Get.find<CategoryController>();
  final foods = useState<List<FoodModel>?>(null);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    // print(_categoryController.categoryValue);
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/foods/$categoryValue/123456');
      final response = await http.get(url);
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        foods.value = foodModelFromJson(response.body);
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      Get.to(() => const GeneralExceptionWidget());
      if (e is Exception) {
        error.value = e;
        if (kDebugMode) {
          print(e.toString());
        }
      } else {
        error.value = Exception('An unexpected error occurred: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
