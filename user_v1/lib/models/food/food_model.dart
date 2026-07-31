// import 'dart:convert';

// List<FoodModel> foodModelFromJson(String str) =>
//     List<FoodModel>.from(json.decode(str).map((x) => FoodModel.fromJson(x)));

// String foodModelToJson(List<FoodModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class FoodModel {
//   final String id;
//   final String title;
//   final String time;
//   final String description;
//   final List<String> foodTags;
//   final List<String> foodType;
//   final String category;
//   final String code;
//   final bool isAvailable;
//   final String restaurant;
//   final double rating;
//   final String ratingCount;
//   final double price;
//   final List<Additive> additives;
//   final List<String> imageUrl;

//   FoodModel({
//     required this.id,
//     required this.title,
//     required this.time,
//     required this.description,
//     required this.foodTags,
//     required this.foodType,
//     required this.category,
//     required this.code,
//     required this.isAvailable,
//     required this.restaurant,
//     required this.rating,
//     required this.ratingCount,
//     required this.price,
//     required this.additives,
//     required this.imageUrl,
//   });

//   factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
//         id: json["_id"] ?? '',
//         title: json["title"] ?? '',
//         time: json["time"] ?? '',
//         description: json["description"] ?? '',
//         foodTags: List<String>.from(json["foodTags"] ?? []),
//         foodType: List<String>.from(json["foodType"] ?? []),
//         category: json["category"] ?? '',
//         code: json["code"] ?? '',
//         isAvailable: json["isAvailable"] ?? false,
//         restaurant: json["restaurant"] ?? '',
//         rating: (json["rating"] ?? 0.0).toDouble(),
//         ratingCount: json["ratingCount"]?.toString() ?? '',
//         price: (json["price"] ?? 0.0).toDouble(),
//         additives: List<Additive>.from(
//             json["additives"]?.map((x) => Additive.fromJson(x)) ?? []),
//         imageUrl: List<String>.from(json["imageUrl"] ?? []),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "time": time,
//         "description": description,
//         "foodTags": List<dynamic>.from(foodTags),
//         "foodType": List<dynamic>.from(foodType),
//         "category": category,
//         "code": code,
//         "isAvailable": isAvailable,
//         "restaurant": restaurant,
//         "rating": rating,
//         "ratingCount": ratingCount,
//         "price": price,
//         "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
//         "imageUrl": List<dynamic>.from(imageUrl),
//       };
// }

// class Additive {
//   final int id;
//   final String title;
//   final dynamic price;

//   Additive({
//     required this.id,
//     required this.title,
//     required this.price,
//   });

//   factory Additive.fromJson(Map<String, dynamic> json) => Additive(
//         id: json["id"] ?? 0,
//         title: json["title"] ?? "",
//         price: json["price"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "price": price,
//       };
// }
import 'dart:convert';

List<FoodModel> foodModelFromJson(String str) =>
    List<FoodModel>.from(json.decode(str).map((x) => FoodModel.fromJson(x)));

String foodModelToJson(List<FoodModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodModel {
  final String id;
  final String title;
  final String time;
  final String description;
  final List<String> foodTags;
  final List<String> foodType;
  final String category;
  final String code;
  final bool isAvailable;
  final String restaurant;
  final double rating;
  final String ratingCount;
  final double price;
  final List<Additive> additives;
  final List<String> imageUrl;

  FoodModel({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    required this.foodTags,
    required this.foodType,
    required this.category,
    required this.code,
    required this.isAvailable,
    required this.restaurant,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.additives,
    required this.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["_id"] ?? json["id"] ?? '',
        title: json["title"] ?? '',
        time: json["time"] ?? '',
        description: json["description"] ?? '',
        foodTags: List<String>.from(json["foodTags"] ?? []),
        foodType: List<String>.from(json["foodType"] ?? []),
        category: json["category"] ?? '',
        code: json["code"] ?? '',
        isAvailable: json["isAvailable"] ?? false,
        restaurant: json["restaurant"] ?? '',
        rating: (json["rating"] ?? 0.0).toDouble(),
        ratingCount: json["ratingCount"]?.toString() ?? '',
        price: (json["price"] ?? 0.0).toDouble(),
        additives: List<Additive>.from(
            json["additives"]?.map((x) => Additive.fromJson(x)) ?? []),
        imageUrl: List<String>.from(json["imageUrl"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "description": description,
        "foodTags": List<dynamic>.from(foodTags),
        "foodType": List<dynamic>.from(foodType),
        "category": category,
        "code": code,
        "isAvailable": isAvailable,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
        "imageUrl": List<dynamic>.from(imageUrl),
      };
}

class Additive {
  final int id;
  final String title;
  final dynamic price;

  Additive({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
      };
}
