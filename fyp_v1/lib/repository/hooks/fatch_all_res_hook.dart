import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/error/error_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_result.dart';

FetchHook useFetchAllRestaurant() {
  final categoryItems = useState<List<RestaurantModel>?>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/restaurant/all/pk000');
      final response = await http.get(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        categoryItems.value = restaurantModelFromJson(response.body);
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      // if (e is Exception) {
      //   error.value = e;
      // } else {
      //   error.value = Exception('An unexpected error occurred: $e');
      // }
      error.value = e as Exception;
      Get.to(() => const GeneralExceptionWidget());
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
    data: categoryItems.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
