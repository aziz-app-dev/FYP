import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/login_res_model.dart';

class LoginRepo {
  final api = NetworkServicesApi();

  Future<LoginModel> login(dynamic data) async {
    final response = await api.postApi(AppUrl.loginUrl, data);
    return loginModelFromJson(response);
  }
}
