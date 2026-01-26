import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;

import '../../models/address/address_respose_model.dart';
import '../../models/error/error_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_address.dart';

FetchAddressHook useFetchAddress() {
  final context = useContext();
  final addresses = useState<List<AddressResponseModel>?>(null);
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
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/address');

      final response = await http.get(url, headers: headers);
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        json.decode(response.body);
        addresses.value = addressResponseModelFromJson(response.body);
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      if (!context.mounted) return;
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      if (!context.mounted) return;
      if (e is Exception) {
        Get.to(() => const GeneralExceptionWidget());
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
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchAddressHook(
    data: addresses.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
