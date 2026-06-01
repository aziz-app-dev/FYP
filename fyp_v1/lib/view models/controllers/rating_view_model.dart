import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/rating/rating_summary_model.dart';

/// Fetches the ratings summary + review list for a given restaurant.
/// Call [fetch] with the restaurant id; observe [summary] / [isLoading].
class RatingController extends GetxController {
  final Rxn<RatingSummary> _summary = Rxn<RatingSummary>();
  RatingSummary? get summary => _summary.value;

  final RxBool _loading = false.obs;
  bool get isLoading => _loading.value;

  Future<void> fetch(String restaurantId) async {
    _loading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/rating/restaurant/$restaurantId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _summary.value = ratingSummaryFromJson(response.body);
      }
    } catch (e) {
      Utils.showError('Error', 'Could not load ratings: $e');
    } finally {
      _loading.value = false;
    }
  }
}
