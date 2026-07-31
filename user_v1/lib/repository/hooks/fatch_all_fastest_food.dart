import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/error/error_model.dart';
import '../../models/food/food_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_food.dart';

FetchFood useFetchFastestFood() {
  final context = useContext();
  final foods = useState<List<FoodModel>?>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/foods/all/123456');
      final response = await http.get(url);
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        foods.value = foodModelFromJson(response.body);
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

    // Return a cleanup function to handle disposal
    return () {
      // This is where you handle disposal if necessary
    };
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchFood(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
