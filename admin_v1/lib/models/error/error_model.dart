import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  final bool status;
  final String message;

  ErrorModel({required this.status, required this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        status: json["status"] ?? false,
        message: json["message"] ?? 'Something went wrong',
      );

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
