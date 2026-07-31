import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/user/admin_user_model.dart';

/// Users list — GET /api/user/admin/all?userType=X.
class AdminUsersController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<AdminUser> users = <AdminUser>[].obs;

  /// '' = every user type.
  final RxString filter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Map<String, String> get _headers {
    final String? token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> setFilter(String userType) {
    filter.value = userType;
    return fetchUsers();
  }

  Future<void> fetchUsers() async {
    _isLoading.value = true;
    try {
      final query = filter.value.isEmpty ? '' : '?userType=${filter.value}';
      final response = await http.get(
        Uri.parse('${AppUrl.adminUsersApi}$query'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final parsed = adminUsersResponseFromJson(response.body);
        users.assignAll(parsed.users);
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to load users', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
