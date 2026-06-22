import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import '../../../services/session/session_manger.dart';
import 'home_repo.dart';

class HomeHttpRepo implements HomeRepo {
  final _apiServices = NetworkServicesApi();
  final _sessionManager = SessionManager();

  @override
  Future<HomeData> fetchHomeData() async {
    // Send token if available (for recentOrders section)
    final token = await _sessionManager.getToken();
    final res = token != null && token.isNotEmpty
        ? await _apiServices.getApiWithAuth(AppUrl.homeUrl, token)
        : await _apiServices.getApi(AppUrl.homeUrl);
    final homeModel = HomeModel.fromJson(res);

    if (homeModel.status == false) {
      throw Exception(homeModel.message ?? "Failed to fetch home data");
    }

    return homeModel.data ?? HomeData();
  }
}
