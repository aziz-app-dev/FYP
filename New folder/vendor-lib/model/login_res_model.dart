import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final String? token;

  LoginModel({this.token});

  LoginModel copyWith({String? token}) =>
      LoginModel(token: token ?? this.token);

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      LoginModel(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": token};
}
