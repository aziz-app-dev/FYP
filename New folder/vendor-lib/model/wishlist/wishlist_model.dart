// ignore_for_file: unnecessary_cast

import '../home/home_model.dart';

class WishlistResponse {
  final bool? status;
  final String? message;
  final List<WishlistItem>? data;

  WishlistResponse({this.status, this.message, this.data});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      status: json['status'],
      message: json['message']?.toString(),
      data: json['data'] == null
          ? []
          : List<WishlistItem>.from(
              json['data'].map((x) => WishlistItem.fromJson(x)),
            ),
    );
  }
}

class WishlistItem {
  final String? id;
  final String? foodId;
  final FoodItem? food;
  final DateTime? addedAt;

  WishlistItem({this.id, this.foodId, this.food, this.addedAt});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    // Handle both formats:
    // Backend getWishlist returns: {id, food, addedAt}
    // Backend addToWishlist returns: {_id, userId, foodId, createdAt}

    final id = json['id']?.toString() ?? json['_id']?.toString();

    // For getWishlist: food is the populated food object
    // For addToWishlist: foodId is just the string ID
    final foodData = json['food'] ?? json['foodId'];
    final bool isFoodMap = foodData is Map;
    final foodId = isFoodMap
        ? (foodData as Map<String, dynamic>)['_id']?.toString()
        : foodData?.toString();
    final food = isFoodMap
        ? FoodItem.fromJson(Map<String, dynamic>.from(foodData as Map))
        : null;

    final addedAt = json['addedAt'] ?? json['createdAt'];

    return WishlistItem(
      id: id,
      foodId: foodId,
      food: food,
      addedAt: addedAt != null ? DateTime.tryParse(addedAt.toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'foodId': foodId};
}

class AddToWishlistRequest {
  final String foodId;

  AddToWishlistRequest({required this.foodId});

  Map<String, dynamic> toJson() => {'foodId': foodId};
}
