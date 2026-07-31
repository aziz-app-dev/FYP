import 'dart:convert';

/// Restaurant as returned by GET /api/restaurant/admin/all.
RestaurantModel restaurantModelFromJson(String str) =>
    RestaurantModel.fromJson(json.decode(str));

class RestaurantModel {
  final String id;
  final String title;
  final String time;
  final String imageUrl;
  final String logoUrl;
  final String owner;
  final String code;
  final bool isAvailable;
  final double rating;
  final Coords coords;
  final String verification;
  final String verificationMessage;

  RestaurantModel({
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.logoUrl,
    required this.owner,
    required this.code,
    required this.isAvailable,
    required this.rating,
    required this.coords,
    required this.verification,
    required this.verificationMessage,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        time: json["time"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        logoUrl: json["logoUrl"] ?? '',
        owner: json["owner"] ?? '',
        code: json["code"] ?? '',
        isAvailable: json["isAvailable"] ?? true,
        rating: (json["rating"] ?? 0.0).toDouble(),
        coords: Coords.fromJson(json["coords"] ?? {}),
        verification: json["verification"] ?? 'Pending',
        verificationMessage: json["verificationMessage"] ?? '',
      );
}

class Coords {
  final double latitude;
  final double longitude;
  final String address;
  final String title;

  Coords({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        latitude: (json["latitude"] ?? 0.0).toDouble(),
        longitude: (json["longitude"] ?? 0.0).toDouble(),
        address: json["address"] ?? '',
        title: json["title"] ?? '',
      );
}
