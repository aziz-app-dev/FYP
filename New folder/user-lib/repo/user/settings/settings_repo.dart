import 'dart:developer';

import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../model/settings/settings_model.dart';
import '../../../services/session/session_manger.dart';

class SettingsRepo {
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

  /// Get app settings (public endpoint - no auth required)
  Future<SettingsModel> getSettings() async {
    log('SettingsRepo.getSettings() -> ${AppUrl.settingsUrl}');
    final response = await _api.getApi(AppUrl.settingsUrl);
    log('SettingsRepo.getSettings() response: $response');
    _checkForError(response);
    final data = _getResponseData(response);
    if (data == null) {
      throw ApiErrorResponse(status: false, message: 'No settings data received');
    }
    return SettingsModel.fromJson(data);
  }

  /// Update settings (authenticated - admin only)
  Future<void> updateSettings(Map<String, dynamic> updates) async {
    final token = await SessionManager().getToken();
    log('SettingsRepo.updateSettings() token: ${token != null ? "present" : "null"}');
    if (token == null) {
      throw ApiErrorResponse(status: false, message: 'Not authenticated');
    }
    final response = await _api.putApiWithAuth(
      AppUrl.settingsUrl,
      updates,
      token,
    );
    log('SettingsRepo.updateSettings() response: $response');
    _checkForError(response);
  }

  /// Patch specific settings fields (authenticated - admin only)
  Future<void> patchSettings(Map<String, dynamic> updates) async {
    final token = await SessionManager().getToken();
    log('SettingsRepo.patchSettings() data: $updates');
    log('SettingsRepo.patchSettings() token: ${token != null ? "present" : "null"}');
    if (token == null) {
      throw ApiErrorResponse(status: false, message: 'Not authenticated');
    }
    final response = await _api.patchApiWithAuth(
      AppUrl.settingsUrl,
      updates,
      token,
    );
    log('SettingsRepo.patchSettings() response: $response');
    _checkForError(response);
  }
}
