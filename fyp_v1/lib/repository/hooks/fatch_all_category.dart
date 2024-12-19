import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/category/category_model.dart';
import '../../models/error/error_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_result.dart';

FetchHook useFetchCategory() {
  final categoryItems = useState<List<CategoryModel>?>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse('${AppUrl.baseUrl}/api/category/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        categoryItems.value = categoryModelFromJson(response.body);
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      Get.to(() => const GeneralExceptionWidget());
      if (e is Exception) {
        Get.to(() => const GeneralExceptionWidget());
        error.value = e;
      } else {
        Get.to(() => const GeneralExceptionWidget());
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
    data: categoryItems.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
