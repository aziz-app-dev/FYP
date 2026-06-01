import 'dart:convert';

UserUpdateResponseModel userUpdateResponseModelFromJson(String str) =>
    UserUpdateResponseModel.fromJson(json.decode(str));

String userUpdateResponseModelToJson(UserUpdateResponseModel data) =>
    json.encode(data.toJson());

class UserUpdateResponseModel {
  final bool status;
  final String message;

  UserUpdateResponseModel({
    required this.status,
    required this.message,
  });

  factory UserUpdateResponseModel.fromJson(Map<String, dynamic> json) =>
      UserUpdateResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
