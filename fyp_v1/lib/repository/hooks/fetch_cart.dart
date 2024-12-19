import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/cart/cart_response_model.dart';
import '../../models/error/error_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_cart.dart';

FetchCartHook useFetchCart() {
  final carts = useState<List<CartResponseModel>?>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);
  Future<void> fetchData() async {
    isLoading.value = true;
    final box = GetStorage();
    String? accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/cart');

      final response = await http.get(url, headers: headers);
      // print('StatusCode:---${response.statusCode}');
      // print('BodyResponse:---${response.body}');

      if (response.statusCode == 200) {
        carts.value = cartResponseModelFromJson(response.body);
        // print('Parsed Addresses:---${carts.value}');
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
      // }
      // on SocketException {
      //   Get.to(() => const InterNetExceptionWidget());
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      Get.to(() => const GeneralExceptionWidget());
      if (e is Exception) {
        error.value = e;
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

  return FetchCartHook(
    data: carts.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
