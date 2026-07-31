// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/error/error_model.dart';
import '../../models/food/food_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';

FetchFoodById useFetchFoodById(String foodId) {
  final context = useContext();
  final food = useState<FoodModel?>(null);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/foods/$foodId');

      final response = await http.get(url);
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        food.value = FoodModel.fromJson(data);
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      if (!context.mounted) return;
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      if (!context.mounted) return;
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
      if (context.mounted) {
        isLoading.value = false;
      }
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

  return FetchFoodById(
    data: food.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

class FetchFoodById {
  final FoodModel? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchFoodById(
      {required this.data,
      required this.isLoading,
      required this.error,
      required this.refetch});
}
