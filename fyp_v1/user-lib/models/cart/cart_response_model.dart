// import 'dart:convert';

// List<CartResponseModel> cartResponseModelFromJson(String str) =>
//     List<CartResponseModel>.from(
//         json.decode(str).map((x) => CartResponseModel.fromJson(x)));

// String cartResponseModelToJson(List<CartResponseModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class CartResponseModel {
//   final String id;
//   final String userId;
//   final ProductId productId;
//   final List<String> additives;
//   final String instructions;
//   final int quantity;
//   final int totalPrice;
//   final int v;

//   CartResponseModel({
//     required this.id,
//     required this.userId,
//     required this.productId,
//     required this.additives,
//     required this.instructions,
//     required this.quantity,
//     required this.totalPrice,
//     required this.v,
//   });

//   factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
//       CartResponseModel(
//         id: json["_id"],
//         userId: json["userId"],
//         productId: ProductId.fromJson(json["productId"]),
//         additives: List<String>.from(json["additives"].map((x) => x)),
//         instructions: json["instructions"],
//         quantity: json["quantity"],
//         totalPrice: json["totalPrice"],
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "productId": productId.toJson(),
//         "additives": List<dynamic>.from(additives.map((x) => x)),
//         "instructions": instructions,
//         "quantity": quantity,
//         "totalPrice": totalPrice,
//         "__v": v,
//       };
// }

// class ProductId {
//   final String id;
//   final String title;
//   final String restaurant;
//   final double rating;
//   final String ratingCount;
//   final double price;
//   final List<String> imageUrl;

//   ProductId({
//     required this.id,
//     required this.title,
//     required this.restaurant,
//     required this.rating,
//     required this.ratingCount,
//     required this.price,
//     required this.imageUrl,
//   });

//   factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
//         id: json["_id"],
//         title: json["title"],
//         restaurant: json["restaurant"],
//         rating: json["rating"]?.toDouble(),
//         ratingCount: json["ratingCount"],
//         price: json["price"]?.toDouble(),
//         imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "restaurant": restaurant,
//         "rating": rating,
//         "ratingCount": ratingCount,
//         "price": price,
//         "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
//       };
// }
// To parse this JSON data, do
//
//     final cartResponseModel = cartResponseModelFromJson(jsonString);

// import 'dart:convert';

// List<CartResponseModel> cartResponseModelFromJson(String str) =>
//     List<CartResponseModel>.from(
//         json.decode(str).map((x) => CartResponseModel.fromJson(x)));

// String cartResponseModelToJson(List<CartResponseModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class CartResponseModel {
//   final String id;
//   final String userId;
//   final ProductId productId;
//   final List<dynamic> additives;
//   final String instructions;
//   final int quantity;
//   final double totalPrice;
//   final int v;

//   CartResponseModel({
//     required this.id,
//     required this.userId,
//     required this.productId,
//     required this.additives,
//     required this.instructions,
//     required this.quantity,
//     required this.totalPrice,
//     required this.v,
//   });

//   factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
//       CartResponseModel(
//         id: json["_id"],
//         userId: json["userId"],
//         productId: ProductId.fromJson(json["productId"]),
//         additives: List<dynamic>.from(json["additives"].map((x) => x)),
//         instructions: json["instructions"],
//         quantity: json["quantity"],
//         totalPrice: json["totalPrice"]?.toDouble(),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "productId": productId.toJson(),
//         "additives": List<dynamic>.from(additives.map((x) => x)),
//         "instructions": instructions,
//         "quantity": quantity,
//         "totalPrice": totalPrice,
//         "__v": v,
//       };
// }

// class ProductId {
//   final String id;
//   final String title;
//   final String restaurant;
//   final double rating;
//   final String ratingCount;
//   final double price;
//   final List<String> imageUrl;

//   ProductId({
//     required this.id,
//     required this.title,
//     required this.restaurant,
//     required this.rating,
//     required this.ratingCount,
//     required this.price,
//     required this.imageUrl,
//   });

//   factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
//         id: json["_id"],
//         title: json["title"],
//         restaurant: json["restaurant"],
//         rating: json["rating"]?.toDouble(),
//         ratingCount: json["ratingCount"],
//         price: json["price"]?.toDouble(),
//         imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "restaurant": restaurant,
//         "rating": rating,
//         "ratingCount": ratingCount,
//         "price": price,
//         "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
//       };
// }
// To parse this JSON data, do
//
//     final cartResponseModel = cartResponseModelFromJson(jsonString);

import 'dart:convert';

List<CartResponseModel> cartResponseModelFromJson(String str) =>
    List<CartResponseModel>.from(
        json.decode(str).map((x) => CartResponseModel.fromJson(x)));

String cartResponseModelToJson(List<CartResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponseModel {
  final String id;
  final String userId;
  final ProductId productId;
  final List<String> additives;
  final String instructions;
  final int quantity;
  final double totalPrice;
  final int v;

  CartResponseModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.additives,
    required this.instructions,
    required this.quantity,
    required this.totalPrice,
    required this.v,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      CartResponseModel(
        id: json["_id"],
        userId: json["userId"],
        productId: ProductId.fromJson(json["productId"]),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"],
        quantity: json["quantity"],
        totalPrice: json["totalPrice"]?.toDouble(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "productId": productId.toJson(),
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
        "quantity": quantity,
        "totalPrice": totalPrice,
        "__v": v,
      };
}

class ProductId {
  final String id;
  final String title;
  final String restaurant;
  final double rating;
  final String ratingCount;
  final double price;
  final List<String> imageUrl;

  ProductId({
    required this.id,
    required this.title,
    required this.restaurant,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.imageUrl,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        title: json["title"],
        restaurant: json["restaurant"],
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        price: json["price"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "price": price,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
      };
}
