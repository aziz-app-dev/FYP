import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/restaurant/restaurant_model.dart';

/// Tracks which restaurant the logged-in vendor is operating on.
/// A vendor may own multiple — we default to the first one returned.
class VendorRestaurantController extends GetxController {
  final box = GetStorage();

  final Rxn<RestaurantModel> _active = Rxn<RestaurantModel>();
  RestaurantModel? get active => _active.value;

  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;

  final RxBool _loading = false.obs;
  bool get isLoading => _loading.value;

  /// GET /api/restaurant/mine → picks the first restaurant as active.
  Future<void> fetchMine() async {
    _loading.value = true;
    try {
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/restaurant/mine'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List list = body['restaurants'] ?? [];
        restaurants.assignAll(
            list.map((e) => RestaurantModel.fromJson(e)).toList());
        if (restaurants.isNotEmpty) {
          _active.value = restaurants.first;
          box.write('activeRestaurantId', restaurants.first.id);
        }
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Could not load your restaurants', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _loading.value = false;
    }
  }

  void setActive(RestaurantModel r) {
    _active.value = r;
    box.write('activeRestaurantId', r.id);
  }

  String? get activeId =>
      _active.value?.id ?? (box.read('activeRestaurantId') as String?);

  /// True only when the vendor has an active restaurant AND it has been
  /// verified by an admin. Anything that actually goes live on the
  /// customer app (food CRUD, toggling Open/Close) must gate on this.
  bool get isVerified => _active.value?.verification == 'Verified';

  /// Current verification status of the active restaurant, or null if
  /// the vendor has no restaurant at all.
  String? get verificationStatus => _active.value?.verification;

  final RxBool _saving = false.obs;
  bool get isSaving => _saving.value;

  Map<String, String> get _headers {
    final token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// POST /api/restaurant/ — create a new restaurant for the logged-in vendor.
  Future<bool> createRestaurant(Map<String, dynamic> body) async {
    _saving.value = true;
    try {
      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/api/restaurant/'),
        headers: _headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showSuccess('Restaurant created', 'Pending admin verification.');
        await fetchMine();
        return true;
      }
      final err = errorModelFromJson(response.body);
      Utils.showError('Create failed', err.message);
      return false;
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    } finally {
      _saving.value = false;
    }
  }

  /// PUT /api/restaurant/:id — edit an existing restaurant.
  Future<bool> updateRestaurant(
      String id, Map<String, dynamic> updates) async {
    _saving.value = true;
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/api/restaurant/$id'),
        headers: _headers,
        body: jsonEncode(updates),
      );
      if (response.statusCode == 200) {
        Utils.showSuccess('Saved', 'Restaurant updated.');
        await fetchMine();
        return true;
      }
      final err = errorModelFromJson(response.body);
      Utils.showError('Update failed', err.message);
      return false;
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    } finally {
      _saving.value = false;
    }
  }

  /// PATCH /api/restaurant/:id — toggle isAvailable.
  /// Shows a distinct 2-line toast for each outcome:
  ///   - Shop opened  → "You are now accepting new orders."
  ///   - Shop closed  → "Customers can no longer place orders."
  ///   - Update error → "Toggle failed — <server message>"
  Future<void> toggleAvailability(String id) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppUrl.baseUrl}/api/restaurant/$id'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        // Backend returns the new state in `isAvailable`.
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final bool nowOpen = body['isAvailable'] == true;

        if (nowOpen) {
          Utils.showSuccess(
            'Shop opened',
            'You are now accepting new orders.',
          );
        } else {
          Utils.showInfo(
            'Shop closed',
            'Customers can no longer place orders.',
          );
        }
        await fetchMine();
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError(
          'Could not update availability',
          err.message.isEmpty
              ? 'Please try again in a moment.'
              : err.message,
        );
      }
    } catch (e) {
      Utils.showError(
        'Network error',
        'Could not reach the server. Please check your connection.',
      );
    }
  }
}
