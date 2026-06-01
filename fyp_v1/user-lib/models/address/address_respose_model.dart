// import 'dart:convert';

// List<AddressResponseModel> addressResponseModelFromJson(String str) =>
//     List<AddressResponseModel>.from(
//         json.decode(str).map((x) => AddressResponseModel.fromJson(x)));

// String addressResponseModelToJson(List<AddressResponseModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class AddressResponseModel {
//   final String id;
//   final String userId;
//   final String addressLine1;
//   final String postalCode;
//   final String city;
//   final String district;
//   final String province;
//   final String country;
//   final bool addressResponseModelDefault;
//   // final double latitude; // Optional if sometimes missing
//   // final double longitude; // Optional if sometimes missing
//   final double? latitude; // Optional if sometimes missing
//   final double? longitude; // Optional if sometimes missing
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;

//   AddressResponseModel({
//     required this.id,
//     required this.userId,
//     required this.addressLine1,
//     required this.postalCode,
//     required this.city,
//     required this.district,
//     required this.province,
//     required this.country,
//     required this.addressResponseModelDefault,
//     required this.latitude,
//     required this.longitude,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory AddressResponseModel.fromJson(Map<String, dynamic> json) =>
//       AddressResponseModel(
//         id: json["_id"],
//         userId: json["userId"],
//         addressLine1: json["addressLine1"],
//         postalCode: json["postalCode"],
//         city: json["city"],
//         district: json["district"],
//         province: json["province"],
//         country: json["country"],
//         addressResponseModelDefault: json["default"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "addressLine1": addressLine1,
//         "postalCode": postalCode,
//         "city": city,
//         "district": district,
//         "province": province,
//         "country": country,
//         "default": addressResponseModelDefault,
//         "latitude": latitude,
//         "longitude": longitude,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "__v": v,
//       };
// }
// To parse this JSON data, do
//
//     final addressResponseModel = addressResponseModelFromJson(jsonString);

import 'dart:convert';

List<AddressResponseModel> addressResponseModelFromJson(String str) =>
    List<AddressResponseModel>.from(
        json.decode(str).map((x) => AddressResponseModel.fromJson(x)));

String addressResponseModelToJson(List<AddressResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressResponseModel {
  final String id;
  final String userId;
  final String addressLine1;
  final String postalCode;
  final String city;
  final String district;
  final String province;
  final String country;
  final double latitude;
  final double longitude;
  final String instruction;
  final bool addressResponseModelDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  AddressResponseModel({
    required this.id,
    required this.userId,
    required this.addressLine1,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.province,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.instruction,
    required this.addressResponseModelDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) =>
      AddressResponseModel(
        id: json["_id"],
        userId: json["userId"],
        addressLine1: json["addressLine1"],
        postalCode: json["postalCode"],
        city: json["city"],
        district: json["district"],
        province: json["province"],
        country: json["country"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        instruction: json["instruction"],
        addressResponseModelDefault: json["default"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "addressLine1": addressLine1,
        "postalCode": postalCode,
        "city": city,
        "district": district,
        "province": province,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "instruction": instruction,
        "default": addressResponseModelDefault,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
