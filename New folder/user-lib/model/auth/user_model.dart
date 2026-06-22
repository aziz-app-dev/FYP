import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final bool? verification;
  final bool? phoneVerification;
  final String? userType;
  final String? profile;
  final String? userToken;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.verification,
    this.phoneVerification,
    this.userType,
    this.profile,
    this.userToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        verification: json["verification"],
        phoneVerification: json["phoneVerification"],
        userType: json["userType"],
        profile: json["profile"],
        userToken: json["userToken"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "verification": verification,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "userToken": userToken,
      };

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    bool? verification,
    bool? phoneVerification,
    String? userType,
    String? profile,
    String? userToken,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        verification: verification ?? this.verification,
        phoneVerification: phoneVerification ?? this.phoneVerification,
        userType: userType ?? this.userType,
        profile: profile ?? this.profile,
        userToken: userToken ?? this.userToken,
      );
}
