import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  final bool status;
  final String message;

  ApiResponse({
    required this.status,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };

  ApiResponse copyWith({
    bool? status,
    String? message,
  }) =>
      ApiResponse(
        status: status ?? this.status,
        message: message ?? this.message,
      );
}
