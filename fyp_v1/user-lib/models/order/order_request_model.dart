// import 'dart:convert';

// OrderRequestModel orderRequestModelFromJson(String str) =>
//     OrderRequestModel.fromJson(json.decode(str));

// String orderRequestModelToJson(OrderRequestModel data) =>
//     json.encode(data.toJson());

// class OrderRequestModel {
//   final List<OrderItem> orderItems;
//   final double orderTotal;
//   final double deliveryFee;
//   final double grandTotal;
//   final String deliveryAddress;
//   final String restaurantAddress;
//   final List<double> restaurantCoords;
//   final List<double> recipientCoords;
//   final String? paymentMethod;
//   final String? paymentStatus;
//   final String? orderStatus;
//   final String restaurantId;
//   final String? driverId;
//   final double? rating;
//   final String? feedBack;
//   final String? promoCode;
//   final double? discountAmount;
//   final String notes;

//   OrderRequestModel({
//     required this.orderItems,
//     required this.orderTotal,
//     required this.deliveryFee,
//     required this.grandTotal,
//     required this.deliveryAddress,
//     required this.restaurantAddress,
//     required this.restaurantCoords,
//     required this.recipientCoords,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.orderStatus,
//     required this.restaurantId,
//     required this.driverId,
//     required this.rating,
//     required this.feedBack,
//     required this.promoCode,
//     required this.discountAmount,
//     required this.notes,
//   });

//   factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
//       OrderRequestModel(
//         orderItems: List<OrderItem>.from(
//             json["orderItems"].map((x) => OrderItem.fromJson(x))),
//         orderTotal: json["orderTotal"]?.toDouble(),
//         deliveryFee: json["deliveryFee"]?.toDouble(),
//         grandTotal: json["grandTotal"]?.toDouble(),
//         deliveryAddress: json["deliveryAddress"],
//         restaurantAddress: json["restaurantAddress"],
//         restaurantCoords: List<double>.from(
//             json["restaurantCoords"].map((x) => x?.toDouble())),
//         recipientCoords: List<double>.from(
//             json["recipientCoords"].map((x) => x?.toDouble())),
//         paymentMethod: json["paymentMethod"],
//         paymentStatus: json["paymentStatus"],
//         orderStatus: json["orderStatus"],
//         restaurantId: json["restaurantId"],
//         driverId: json["driverId"],
//         rating: json["rating"],
//         feedBack: json["feedBack"],
//         promoCode: json["promoCode"],
//         discountAmount: json["discountAmount"],
//         notes: json["notes"],
//       );

//   Map<String, dynamic> toJson() => {
//         "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
//         "orderTotal": orderTotal,
//         "deliveryFee": deliveryFee,
//         "grandTotal": grandTotal,
//         "deliveryAddress": deliveryAddress,
//         "restaurantAddress": restaurantAddress,
//         "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
//         "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
//         "paymentMethod": paymentMethod,
//         "paymentStatus": paymentStatus,
//         "orderStatus": orderStatus,
//         "restaurantId": restaurantId,
//         "driverId": driverId,
//         "rating": rating,
//         "feedBack": feedBack,
//         "promoCode": promoCode,
//         "discountAmount": discountAmount,
//         "notes": notes,
//       };
// }

// class OrderItem {
//   final String foodId;
//   final int quantity;
//   final double price;
//   final List<String> additives;
//   final String instruction;

//   OrderItem({
//     required this.foodId,
//     required this.quantity,
//     required this.price,
//     required this.additives,
//     required this.instruction,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
//         foodId: json["foodId"],
//         quantity: json["quantity"],
//         price: json["price"]?.toDouble(),
//         additives: List<String>.from(json["additives"].map((x) => x)),
//         instruction: json["instruction"],
//       );

//   Map<String, dynamic> toJson() => {
//         "foodId": foodId,
//         "quantity": quantity,
//         "price": price,
//         "additives": List<dynamic>.from(additives.map((x) => x)),
//         "instruction": instruction,
//       };
// }

import 'dart:convert';

OrderRequestModel orderRequestModelFromJson(String str) =>
    OrderRequestModel.fromJson(json.decode(str));

String orderRequestModelToJson(OrderRequestModel data) =>
    json.encode(data.toJson());

class OrderRequestModel {
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddress;
  final String restaurantAddress;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? orderStatus;
  final String restaurantId;
  final String? driverId;
  final double? rating;
  final String? feedBack;
  final String? promoCode;
  final double? discountAmount;
  final String? notes;

  OrderRequestModel({
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.restaurantAddress,
    required this.restaurantCoords,
    required this.recipientCoords,
    this.paymentMethod,
    this.paymentStatus,
    this.orderStatus,
    required this.restaurantId,
    this.driverId,
    this.rating,
    this.feedBack,
    this.promoCode,
    this.discountAmount,
    this.notes,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderRequestModel(
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        grandTotal: json["grandTotal"]?.toDouble(),
        deliveryAddress: json["deliveryAddress"],
        restaurantAddress: json["restaurantAddress"],
        restaurantCoords: List<double>.from(
            json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(
            json["recipientCoords"].map((x) => x?.toDouble())),
        paymentMethod: json["paymentMethod"] ?? 'Cash',
        paymentStatus: json["paymentStatus"] ?? 'Pending',
        orderStatus: json["orderStatus"] ?? "Pending",
        restaurantId: json["restaurantId"],
        driverId: json["driverId"] ?? '',
        rating: json["rating"]?.toDouble() ?? 3.0,
        feedBack: json["feedBack"],
        promoCode: json["promoCode"] ?? '',
        discountAmount: json["discountAmount"]?.toDouble(),
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "restaurantAddress": restaurantAddress,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "restaurantId": restaurantId,
        "driverId": driverId,
        "rating": rating,
        "feedBack": feedBack,
        "promoCode": promoCode,
        "discountAmount": discountAmount,
        "notes": notes,
      };
}

class OrderItem {
  final String foodId;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instruction;

  OrderItem({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instruction,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instruction: json["instruction"],
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instruction": instruction,
      };
}
