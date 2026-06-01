import 'dart:convert';

UserInformationModel userInformationModelFromJson(String str) =>
    UserInformationModel.fromJson(json.decode(str));

String userInformationModelToJson(UserInformationModel data) =>
    json.encode(data.toJson());

class UserInformationModel {
  final String id;
  final String username;
  final String email;
  final String otp;
  final String fmc;
  final bool verification;
  final String phone;
  final bool phoneVerification;
  final String userType;
  final String profile;
  final int v;

  UserInformationModel({
    required this.id,
    required this.username,
    required this.email,
    required this.otp,
    required this.fmc,
    required this.verification,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.v,
  });

  factory UserInformationModel.fromJson(Map<String, dynamic> json) =>
      UserInformationModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        otp: json["otp"],
        fmc: json["fmc"],
        verification: json["verification"],
        phone: json["phone"],
        phoneVerification: json["phoneVerification"],
        userType: json["userType"],
        profile: json["profile"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "otp": otp,
        "fmc": fmc,
        "verification": verification,
        "phone": phone,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "__v": v,
      };
}
