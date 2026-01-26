import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/error/error_model.dart';
import '../../models/order/clint_orders_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';

List<ClientOrderModel> clientOrderModelFromJson(String str) =>
    List<ClientOrderModel>.from(
        json.decode(str).map((x) => ClientOrderModel.fromJson(x)));

String clientOrderModelToJson(List<ClientOrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

FetchHook useFetchOrders(String orderStatus, String paymentStatus) {
  final context = useContext();
  final box = GetStorage();
  String accessToken = box.read("token");
  final orders = useState<List<ClientOrderModel>>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse(
          '${AppUrl.baseUrl}/api/order?paymentStatus=$paymentStatus&orderStatus=$orderStatus');

      final response = await http.get(url, headers: headers);
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        orders.value = clientOrderModelFromJson(response.body);
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
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

class FetchHook {
  final dynamic data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchHook(
      {required this.data,
      required this.isLoading,
      required this.error,
      required this.refetch});
}
