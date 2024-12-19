import 'dart:convert';

UserUpdateRequestModel userUpdateRequestModelFromJson(String str) =>
    UserUpdateRequestModel.fromJson(json.decode(str));

String userUpdateRequestModelToJson(UserUpdateRequestModel data) =>
    json.encode(data.toJson());

class UserUpdateRequestModel {
  final String username;
  final String phone;
  final String profile;

  UserUpdateRequestModel({
    required this.username,
    required this.phone,
    required this.profile,
  });

  factory UserUpdateRequestModel.fromJson(Map<String, dynamic> json) =>
      UserUpdateRequestModel(
        username: json["username"],
        phone: json["phone"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "phone": phone,
        "profile": profile,
      };
}
