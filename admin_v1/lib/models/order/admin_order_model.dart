import 'dart:convert';

/// Orders as returned by GET /api/order/admin — userId, restaurantId and
/// orderItems.foodId come back populated (objects), but every populated
/// field is parsed defensively so a plain ObjectId string never crashes
/// the app.
List<AdminOrder> adminOrderListFromJson(String str) =>
    List<AdminOrder>.from(json.decode(str).map((x) => AdminOrder.fromJson(x)));

class AdminOrder {
  final String id;
  final OrderUser user;
  final OrderRestaurant restaurant;
  final List<AdminOrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddress;
  final String restaurantAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime? createdAt;

  AdminOrder({
    required this.id,
    required this.user,
    required this.restaurant,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.restaurantAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
  });

  factory AdminOrder.fromJson(Map<String, dynamic> json) => AdminOrder(
        id: json["_id"] ?? '',
        user: OrderUser.fromJson(json["userId"]),
        restaurant: OrderRestaurant.fromJson(json["restaurantId"]),
        orderItems: json["orderItems"] == null
            ? []
            : List<AdminOrderItem>.from(
                json["orderItems"].map((x) => AdminOrderItem.fromJson(x))),
        orderTotal: (json["orderTotal"] ?? 0).toDouble(),
        deliveryFee: (json["deliveryFee"] ?? 0).toDouble(),
        grandTotal: (json["grandTotal"] ?? 0).toDouble(),
        deliveryAddress: json["deliveryAddress"]?.toString() ?? '',
        restaurantAddress: json["restaurantAddress"] ?? '',
        paymentMethod: json["paymentMethod"] ?? 'Cash',
        paymentStatus: json["paymentStatus"] ?? 'Pending',
        orderStatus: json["orderStatus"] ?? 'Pending',
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
      );
}

/// Populated `userId` — falls back to just the id when not populated.
class OrderUser {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String profile;

  OrderUser({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.profile,
  });

  factory OrderUser.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return OrderUser(
        id: json["_id"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        profile: json["profile"] ?? '',
      );
    }
    return OrderUser(
      id: json?.toString() ?? '',
      username: '',
      email: '',
      phone: '',
      profile: '',
    );
  }
}

/// Populated `restaurantId` — falls back to just the id when not populated.
class OrderRestaurant {
  final String id;
  final String title;
  final String logoUrl;
  final String imageUrl;
  final String verification;

  OrderRestaurant({
    required this.id,
    required this.title,
    required this.logoUrl,
    required this.imageUrl,
    required this.verification,
  });

  factory OrderRestaurant.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return OrderRestaurant(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        logoUrl: json["logoUrl"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        verification: json["verification"] ?? '',
      );
    }
    return OrderRestaurant(
      id: json?.toString() ?? '',
      title: '',
      logoUrl: '',
      imageUrl: '',
      verification: '',
    );
  }
}

class AdminOrderItem {
  final String foodId;
  final String foodTitle;
  final String foodTime;
  final List<String> foodImageUrl;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instruction;

  AdminOrderItem({
    required this.foodId,
    required this.foodTitle,
    required this.foodTime,
    required this.foodImageUrl,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instruction,
  });

  factory AdminOrderItem.fromJson(Map<String, dynamic> json) {
    final dynamic food = json["foodId"];
    String foodId = '';
    String foodTitle = '';
    String foodTime = '';
    List<String> foodImageUrl = [];

    if (food is Map<String, dynamic>) {
      foodId = food["_id"] ?? '';
      foodTitle = food["title"] ?? '';
      foodTime = food["time"] ?? '';
      foodImageUrl = food["imageUrl"] == null
          ? []
          : List<String>.from(food["imageUrl"].map((x) => x.toString()));
    } else {
      foodId = food?.toString() ?? '';
    }

    return AdminOrderItem(
      foodId: foodId,
      foodTitle: foodTitle,
      foodTime: foodTime,
      foodImageUrl: foodImageUrl,
      quantity: (json["quantity"] ?? 1).toInt(),
      price: (json["price"] ?? 0).toDouble(),
      additives: json["additives"] == null
          ? []
          : List<String>.from(json["additives"].map((x) => x.toString())),
      instruction: json["instruction"] ?? '',
    );
  }
}
