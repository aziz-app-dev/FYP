import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/food/food_model.dart';

/// Vendor-side food CRUD: create / list by restaurant / toggle availability / delete.
class FoodCrudController extends GetxController {
  final box = GetStorage();

  // Submission state (add food)
  final RxBool _isSubmitting = false.obs;
  bool get isSubmitting => _isSubmitting.value;

  // List state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<FoodModel> foods = <FoodModel>[].obs;

  Map<String, String> get _headers {
    final String? token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// POST /api/foods/  (vendor only)
  /// Returns true on success.
  Future<bool> createFood(Map<String, dynamic> body) async {
    _isSubmitting.value = true;
    try {
      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/api/foods/'),
        headers: _headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showSuccess('Food added', 'Your food item is live.');
        return true;
      }
      final err = errorModelFromJson(response.body);
      Utils.showError('Failed to add food', err.message);
      return false;
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    } finally {
      _isSubmitting.value = false;
    }
  }

  /// PUT /api/foods/:id — update a food item.
  /// Returns true on success.
  Future<bool> updateFood(String foodId, Map<String, dynamic> body) async {
    _isSubmitting.value = true;
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/api/foods/$foodId'),
        headers: _headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        Utils.showSuccess('Food updated', 'Your changes are saved.');
        return true;
      }
      final err = errorModelFromJson(response.body);
      Utils.showError('Failed to update', err.message);
      return false;
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    } finally {
      _isSubmitting.value = false;
    }
  }

  /// GET /api/foods/byRestaurant/:id
  Future<void> fetchByRestaurant(String restaurantId) async {
    _isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/foods/byRestaurant/$restaurantId'),
      );
      if (response.statusCode == 200) {
        foods.assignAll(foodModelFromJson(response.body));
      } else if (response.statusCode == 404) {
        foods.clear();
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to load foods', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  /// PATCH /api/foods/:id  — toggles `isAvailable` on the server.
  Future<void> toggleAvailability(String foodId) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppUrl.baseUrl}/api/foods/$foodId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        // Optimistic local flip
        final idx = foods.indexWhere((f) => f.id == foodId);
        if (idx != -1) {
          final f = foods[idx];
          foods[idx] = FoodModel(
            id: f.id,
            title: f.title,
            time: f.time,
            description: f.description,
            foodTags: f.foodTags,
            foodType: f.foodType,
            category: f.category,
            code: f.code,
            isAvailable: !f.isAvailable,
            restaurant: f.restaurant,
            rating: f.rating,
            ratingCount: f.ratingCount,
            price: f.price,
            additives: f.additives,
            imageUrl: f.imageUrl,
          );
        }
        Utils.showSuccess('Updated', 'Availability toggled');
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Update failed', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    }
  }

  /// DELETE /api/foods/:id
  Future<void> deleteFood(String foodId) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppUrl.baseUrl}/api/foods/$foodId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        foods.removeWhere((f) => f.id == foodId);
        Utils.showSuccess('Deleted', 'Food item removed');
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Delete failed', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    }
  }
}
