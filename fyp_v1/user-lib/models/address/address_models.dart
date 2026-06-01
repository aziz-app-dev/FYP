import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  final String addressLine1;
  final String city;
  final String district;
  final String province;
  final String postalCode;
  final String country;
  final String deliveryInstruction;
  final bool addressModelDefault;
  final double latitude;
  final double longitude;

  AddressModel({
    required this.addressLine1,
    required this.city,
    required this.district,
    required this.province,
    required this.postalCode,
    required this.country,
    required this.deliveryInstruction,
    required this.addressModelDefault,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressLine1: json["addressLine1"],
        city: json["city"],
        district: json["district"],
        province: json["province"],
        postalCode: json["postalCode"],
        country: json["country"],
        deliveryInstruction: json["deliveryInstruction"],
        addressModelDefault: json["default"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "addressLine1": addressLine1,
        "city": city,
        "district": district,
        "province": province,
        "postalCode": postalCode,
        "country": country,
        "deliveryInstruction": deliveryInstruction,
        "default": addressModelDefault,
        "latitude": latitude,
        "longitude": longitude,
      };
}
