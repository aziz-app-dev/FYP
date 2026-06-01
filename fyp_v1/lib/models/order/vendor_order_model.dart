import 'dart:convert';

List<VendorOrder> vendorOrdersFromJson(String str) =>
    List<VendorOrder>.from(
        json.decode(str).map((x) => VendorOrder.fromJson(x)));

class VendorOrder {
  final String id;
  final String userId;
  final List<VendorOrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddress;
  final String restaurantAddress;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String? paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String restaurantId;
  final DateTime? createdAt;

  VendorOrder({
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
    this.createdAt,
  });

  factory VendorOrder.fromJson(Map<String, dynamic> json) => VendorOrder(
        id: json["_id"] ?? '',
        userId: json["userId"] ?? '',
        orderItems: List<VendorOrderItem>.from(
            (json["orderItems"] ?? []).map((x) => VendorOrderItem.fromJson(x))),
        orderTotal: (json["orderTotal"] ?? 0.0).toDouble(),
        deliveryFee: (json["deliveryFee"] ?? 0.0).toDouble(),
        grandTotal: (json["grandTotal"] ?? 0.0).toDouble(),
        deliveryAddress: json["deliveryAddress"]?.toString() ?? '',
        restaurantAddress: json["restaurantAddress"] ?? '',
        restaurantCoords: List<double>.from(
            (json["restaurantCoords"] ?? []).map((x) => (x ?? 0).toDouble())),
        recipientCoords: List<double>.from(
            (json["recipientCoords"] ?? []).map((x) => (x ?? 0).toDouble())),
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"] ?? 'Pending',
        orderStatus: json["orderStatus"] ?? 'Pending',
        restaurantId: json["restaurantId"]?.toString() ?? '',
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
      );
}

class VendorOrderItem {
  final String foodId;
  final String foodTitle;
  final String foodTime;
  final List<String> foodImageUrl;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instruction;

  VendorOrderItem({
    required this.foodId,
    required this.foodTitle,
    required this.foodTime,
    required this.foodImageUrl,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instruction,
  });

  factory VendorOrderItem.fromJson(Map<String, dynamic> json) {
    // foodId may be a string OR a populated food document.
    String id = '';
    String title = 'Unknown food';
    String time = '';
    List<String> images = [];

    final food = json["foodId"];
    if (food is String) {
      id = food;
    } else if (food is Map<String, dynamic>) {
      id = food["_id"]?.toString() ?? '';
      title = food["title"] ?? 'Unknown food';
      time = food["time"] ?? '';
      images = List<String>.from(food["imageUrl"] ?? []);
    }

    return VendorOrderItem(
      foodId: id,
      foodTitle: title,
      foodTime: time,
      foodImageUrl: images,
      quantity: json["quantity"] ?? 1,
      price: (json["price"] ?? 0.0).toDouble(),
      additives: List<String>.from(json["additives"] ?? []),
      instruction: json["instruction"] ?? '',
    );
  }
}
