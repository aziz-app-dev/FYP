// // To parse this JSON data, do
// //
// //     final restaurantModel = restaurantModelFromJson(jsonString);

// import 'dart:convert';

// List<RestaurantModel> restaurantModelFromJson(String str) =>
//     List<RestaurantModel>.from(
//         json.decode(str).map((x) => RestaurantModel.fromJson(x)));

// String restaurantModelToJson(List<RestaurantModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class RestaurantModel {
//   final String id;
//   final String title;
//   final String time;
//   final String imageUrl;
//   final List<dynamic> food;
//   final bool pickup;
//   final bool delivery;
//   final String owner;
//   final bool isAvailable;
//   final String code;
//   final String logoUrl;
//   final double rating;
//   final String? ratingCount;
//   final Coords coords;
//   final String verification;
//   final String verificationMessage;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   RestaurantModel({
//     required this.id,
//     required this.title,
//     required this.time,
//     required this.imageUrl,
//     required this.food,
//     required this.pickup,
//     required this.delivery,
//     required this.owner,
//     required this.isAvailable,
//     required this.code,
//     required this.logoUrl,
//     required this.rating,
//     this.ratingCount,
//     required this.coords,
//     this.verification = "Pending",
//     this.verificationMessage =
//         "Your restaurant is under review. We will notify you once it is verified.",
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
//       RestaurantModel(
//         id: json["_id"],
//         title: json["title"],
//         time: json["time"],
//         imageUrl: json["imageUrl"],
//         food: List<dynamic>.from(json["food"].map((x) => x)),
//         pickup: json["pickup"],
//         delivery: json["delivery"],
//         owner: json["owner"],
//         isAvailable: json["isAvailable"],
//         code: json["code"],
//         logoUrl: json["logoUrl"],
//         rating: json["rating"],
//         ratingCount: json["ratingCount"],
//         coords: Coords.fromJson(json["coords"]),
//         verification: json["verification"] ?? "Pending",
//         verificationMessage: json["verificationMessage"] ??
//             "Your restaurant is under review. We will notify you once it is verified.",
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "time": time,
//         "imageUrl": imageUrl,
//         "food": List<dynamic>.from(food.map((x) => x)),
//         "pickup": pickup,
//         "delivery": delivery,
//         "owner": owner,
//         "isAvailable": isAvailable,
//         "code": code,
//         "logoUrl": logoUrl,
//         "rating": rating,
//         "ratingCount": ratingCount,
//         "coords": coords.toJson(),
//         "verification": verification,
//         "verificationMessage": verificationMessage,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//       };
// }

// class Coords {
//   final String id;
//   final double latitude;
//   final double longitude;
//   final String address;
//   final String title;
//   final double longitudeDelta;
//   final double latitudeDelta;

//   Coords({
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.title,
//     required this.longitudeDelta,
//     required this.latitudeDelta,
//   });

//   factory Coords.fromJson(Map<String, dynamic> json) => Coords(
//         id: json["id"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         address: json["address"],
//         title: json["title"],
//         longitudeDelta: json["longitudeDelta"]?.toDouble(),
//         latitudeDelta: json["latitudeDelta"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "latitude": latitude,
//         "longitude": longitude,
//         "address": address,
//         "title": title,
//         "longitudeDelta": longitudeDelta,
//         "latitudeDelta": latitudeDelta,
//       };
// }
// To parse this JSON data, do
//
//     final restaurantModel = restaurantModelFromJson(jsonString);

import 'dart:convert';

List<RestaurantModel> restaurantModelFromJson(String str) =>
    List<RestaurantModel>.from(
        json.decode(str).map((x) => RestaurantModel.fromJson(x)));

String restaurantModelToJson(List<RestaurantModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantModel {
  final String id;
  final String title;
  final String time;
  final String imageUrl;
  final List<dynamic> food;
  final bool pickup;
  final bool delivery;
  final String owner;
  final bool isAvailable;
  final String code;
  final String logoUrl;
  final Coords coords;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;

  RestaurantModel({
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.food,
    required this.pickup,
    required this.delivery,
    required this.owner,
    required this.isAvailable,
    required this.code,
    required this.logoUrl,
    required this.coords,
    required this.createdAt,
    required this.updatedAt,
    required this.rating,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        food: List<dynamic>.from(json["food"].map((x) => x)),
        pickup: json["pickup"],
        delivery: json["delivery"],
        owner: json["owner"],
        isAvailable: json["isAvailable"],
        code: json["code"],
        logoUrl: json["logoUrl"],
        coords: Coords.fromJson(json["coords"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "food": List<dynamic>.from(food.map((x) => x)),
        "pickup": pickup,
        "delivery": delivery,
        "owner": owner,
        "isAvailable": isAvailable,
        "code": code,
        "logoUrl": logoUrl,
        "coords": coords.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "rating": rating,
      };
}

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String title;
  final double longitudeDelta;
  final double latitudeDelta;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
    required this.longitudeDelta,
    required this.latitudeDelta,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "longitudeDelta": longitudeDelta,
        "latitudeDelta": latitudeDelta,
      };
}
