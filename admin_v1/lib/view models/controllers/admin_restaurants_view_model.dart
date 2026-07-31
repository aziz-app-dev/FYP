import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/restaurant/restaurant_model.dart';

/// Restaurant applications — GET /api/restaurant/admin/all and
/// PATCH /api/restaurant/verify/:id for approve / reject.
class AdminRestaurantsController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Id of the restaurant whose verify request is in flight ('' = none) —
  /// lets the card show a spinner on just the tapped button.
  final RxString updatingId = ''.obs;

  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Map<String, String> get _headers {
    final String? token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  List<RestaurantModel> byVerification(String verification) =>
      restaurants.where((r) => r.verification == verification).toList();

  Future<void> fetchRestaurants() async {
    _isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppUrl.adminRestaurantsApi),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final list = decoded is Map ? decoded['restaurants'] : decoded;
        if (list is List) {
          restaurants.assignAll(
              list.map((e) => RestaurantModel.fromJson(e)).toList());
        } else {
          restaurants.clear();
        }
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to load restaurants', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  /// PATCH /api/restaurant/verify/:id
  /// with { verification: "Verified" | "Rejected" | "Pending" }.
  Future<void> setVerification(String restaurantId, String verification) async {
    updatingId.value = restaurantId;
    try {
      final response = await http.patch(
        Uri.parse(AppUrl.restaurantVerifyApi(restaurantId)),
        headers: _headers,
        body: jsonEncode({'verification': verification}),
      );
      if (response.statusCode == 200) {
        Utils.showSuccess('Done', 'Restaurant marked "$verification"');
        await fetchRestaurants();
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Update failed', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      updatingId.value = '';
    }
  }
}
