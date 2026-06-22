import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../model/auth/user_model.dart';

class ProfileRepo {
  final _api = NetworkServicesApi();

  /// Helper method to check for API errors
  void _checkForError(dynamic response) {
    if (response['status'] == false) {
      throw ApiErrorResponse.fromJson(response);
    }
  }

  /// Get response data from either 'data' or 'message' field
  dynamic _getResponseData(dynamic response) {
    // Try 'data' first, then 'message'
    if (response['data'] != null) {
      return response['data'];
    }
    if (response['message'] != null && response['message'] is Map) {
      return response['message'];
    }
    return null;
  }

  /// Update profile image
  Future<UserModel> updateProfileImage({
    required String imagePath,
    required String token,
  }) async {
    final response = await _api.patchMultipartWithAuth(
      AppUrl.updateProfileImageUrl,
      imagePath,
      'image',
      token,
    );
    _checkForError(response);

    // Response structure: { data: { user: {...} } } or { message: { user: {...} } }
    final data = _getResponseData(response);
    if (data != null && data['user'] != null) {
      return UserModel.fromJson(data['user']);
    }
    // Fallback: data itself is the user
    if (data != null) {
      return UserModel.fromJson(data);
    }
    throw ApiErrorResponse(status: false, message: 'No user data received');
  }

  /// Get user profile
  Future<UserModel> getUser({required String token}) async {
    final response = await _api.getApiWithAuth(AppUrl.userUrl, token);
    _checkForError(response);
    final data = _getResponseData(response);
    if (data == null) {
      throw ApiErrorResponse(status: false, message: 'No user data received');
    }
    return UserModel.fromJson(data);
  }

  /// Update user profile
  Future<void> updateUser({
    required Map<String, dynamic> data,
    required String token,
  }) async {
    final response = await _api.putApiWithAuth(AppUrl.userUrl, data, token);
    _checkForError(response);
  }
}
