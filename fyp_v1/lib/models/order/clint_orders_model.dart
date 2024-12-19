import 'dart:convert';

List<ClientOrderModel> clientOrderModelFromJson(String str) =>
    List<ClientOrderModel>.from(
        json.decode(str).map((x) => ClientOrderModel.fromJson(x)));

String clientOrderModelToJson(List<ClientOrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClientOrderModel {
  final String id;
  final String userId;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddress;
  final String restaurantAddress;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String restaurantId;
  final dynamic driverId;
  final int rating;
  final dynamic feedBack;
  final dynamic promoCode;
  final dynamic discountAmount;
  final dynamic notes;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ClientOrderModel({
    required this.id,
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.restaurantAddress,
    required this.restaurantCoords,
    required this.recipientCoords,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.restaurantId,
    required this.driverId,
    required this.rating,
    required this.feedBack,
    required this.promoCode,
    required this.discountAmount,
    required this.notes,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ClientOrderModel.fromJson(Map<String, dynamic> json) =>
      ClientOrderModel(
        id: json["_id"],
        userId: json["userId"],
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
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        restaurantId: json["restaurantId"],
        driverId: json["driverId"],
        rating: json["rating"],
        feedBack: json["feedBack"],
        promoCode: json["promoCode"],
        discountAmount: json["discountAmount"],
        notes: json["notes"],
        orderDate: DateTime.parse(json["orderDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
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
        "orderDate": orderDate.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class OrderItem {
  final FoodId foodId;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instruction;
  final String id;

  OrderItem({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instruction,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: FoodId.fromJson(json["foodId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instruction: json["instruction"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId.toJson(),
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instruction": instruction,
        "_id": id,
      };
}

class FoodId {
  final String id;
  final String title;
  final String time;
  final double rating;
  final List<String> imageUrl;

  FoodId({
    required this.id,
    required this.title,
    required this.time,
    required this.rating,
    required this.imageUrl,
  });

  factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        rating: json["rating"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "rating": rating,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
      };
}
