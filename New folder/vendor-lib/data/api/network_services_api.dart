// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../exceptions/api_error_response.dart';
import '../exceptions/app_exception.dart';
import 'base_api_services.dart';

class NetworkServicesApi implements BaseApiServices {
  // ── Device-info middleware ─────────────────────────────────────────────────
  // Every outgoing request is stamped with the client's platform so the
  // backend can record it (e.g. on `orders.platform`) and aggregate it for
  // the dashboard's `platformAnalytics`. The backend reads the header in its
  // own request middleware — the app just passes the parameter.

  /// Detected once on first access; cheap, no async, no extra package.
  static final String _clientPlatform = _detectPlatform();

  static String _detectPlatform() {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return 'Desktop';
      default:
        return 'Other';
    }
  }

  Map<String, String> get _deviceHeaders => {
        'X-Client-Platform': _clientPlatform,
      };

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PostmanRuntime/7.28.4',
        ..._deviceHeaders,
      };

  Map<String, String> _getAuthHeaders(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        ..._deviceHeaders,
      };

  @override
  Future<dynamic> getApi(String url) async {
    try {
      debugPrint("url:$url");
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 30));
      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");
      return returnResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
  }

  /// GET request with authentication token
  Future<dynamic> getApiWithAuth(String url, String token) async {
    try {
      debugPrint("url:$url");
      final response = await http
          .get(Uri.parse(url), headers: _getAuthHeaders(token))
          .timeout(const Duration(seconds: 30));
      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");
      return returnResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data) async {
    debugPrint("Data:$data");
    debugPrint("url:$url");
    try {
      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// POST request with authentication token
  Future<dynamic> postApiWithAuth(
    String url,
    dynamic data,
    String token,
  ) async {
    debugPrint("Data:$data");
    debugPrint("url:$url");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _getAuthHeaders(token),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// PUT request with authentication token
  Future<dynamic> putApiWithAuth(String url, dynamic data, String token) async {
    debugPrint("Data:$data");
    debugPrint("url:$url");
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _getAuthHeaders(token),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// DELETE request with authentication token
  Future<dynamic> deleteApiWithAuth(String url, String token) async {
    debugPrint("url:$url");
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _getAuthHeaders(token))
          .timeout(const Duration(seconds: 30));

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// PATCH request with authentication token
  Future<dynamic> patchApiWithAuth(String url, dynamic data, String token) async {
    debugPrint("Data:$data");
    debugPrint("url:$url");
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: _getAuthHeaders(token),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// PATCH request with multipart form data (for file uploads)
  Future<dynamic> patchMultipartWithAuth(
    String url,
    String filePath,
    String fieldName,
    String token,
  ) async {
    debugPrint("url:$url");
    debugPrint("filePath:$filePath");
    try {
      final request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers.addAll(_deviceHeaders);

      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }

  /// POST request with multipart form data (for file uploads)
  Future<dynamic> postMultipartWithAuth(
    String url,
    String filePath,
    String fieldName,
    String token,
  ) async {
    debugPrint("url:$url");
    debugPrint("filePath:$filePath");
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers.addAll(_deviceHeaders);

      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Response Body: ${response.body}");
      debugPrint("Status Code: ${response.statusCode}");

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException("");
    } on TimeoutException {
      throw RequestTimeOutException("");
    }
  }
}

dynamic returnResponse(http.Response res) {
  final body = jsonDecode(res.body);

  // Check for standardized backend response: {status: bool, message: string, data: {}}
  if (body is Map<String, dynamic> && body.containsKey('status')) {
    // Backend returns standardized format
    if (body['status'] == false) {
      // Error response - throw with backend message
      throw ApiErrorResponse.fromJson(body);
    }
    // Success response - return full body
    return body;
  }

  // Fallback for non-standardized responses (legacy support)
  switch (res.statusCode) {
    case 200:
    case 201:
      return body;

    case 400:
    case 401:
    case 403:
    case 404:
    case 422:
    case 500:
      // All errors now throw ApiErrorResponse for unified handling
      throw ApiErrorResponse(
        status: false,
        message: body['message']?.toString() ?? _getDefaultErrorMessage(res.statusCode),
      );

    default:
      throw ApiErrorResponse(
        status: false,
        message: 'Unexpected error (${res.statusCode})',
      );
  }
}

String _getDefaultErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Access forbidden';
    case 404:
      return 'Not found';
    case 422:
      return 'Validation failed';
    case 500:
      return 'Server error';
    default:
      return 'An error occurred';
  }
}
