import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/stats/admin_stats_model.dart';

/// Dashboard stats — GET /api/order/admin/stats.
class AdminStatsController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<AdminStatsModel> stats = Rxn<AdminStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Map<String, String> get _headers {
    final String? token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchStats() async {
    _isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppUrl.adminStatsApi),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        stats.value = adminStatsModelFromJson(response.body);
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to load stats', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
