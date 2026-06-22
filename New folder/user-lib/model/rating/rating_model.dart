import 'package:equatable/equatable.dart';

enum RatingType { food, restaurant, driver }

class RatingModel extends Equatable {
  final String? id;
  final String userId;
  final RatingType ratingType;
  final String productId;
  final double rating;
  final String? comment;
  final String? orderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Product data (populated from backend)
  final ProductData? productData;

  const RatingModel({
    this.id,
    required this.userId,
    required this.ratingType,
    required this.productId,
    required this.rating,
    this.comment,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.productData,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString() ?? '',
      ratingType: _parseRatingType(json['ratingType']),
      productId: json['product']?.toString() ?? '',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : 0.0,
      comment: json['comment']?.toString(),
      orderId: json['orderId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      productData: json['productData'] != null
          ? ProductData.fromJson(json['productData'], _parseRatingType(json['ratingType']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'ratingType': _ratingTypeToString(ratingType),
      'product': productId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (orderId != null) 'orderId': orderId,
    };
  }

  static RatingType _parseRatingType(dynamic type) {
    final typeStr = type?.toString().toLowerCase() ?? '';
    switch (typeStr) {
      case 'food':
        return RatingType.food;
      case 'restaurant':
        return RatingType.restaurant;
      case 'driver':
        return RatingType.driver;
      default:
        return RatingType.food;
    }
  }

  static String _ratingTypeToString(RatingType type) {
    switch (type) {
      case RatingType.food:
        return 'Food';
      case RatingType.restaurant:
        return 'Restaurant';
      case RatingType.driver:
        return 'Driver';
    }
  }

  String get ratingTypeString => _ratingTypeToString(ratingType);

  /// Get display name for the rated item
  String get displayName {
    return productData?.name ?? 'Unknown';
  }

  /// Get image URL for the rated item
  String? get imageUrl {
    return productData?.imageUrl;
  }

  /// Format date for display
  String get formattedDate {
    if (createdAt == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt!.month - 1]} ${createdAt!.day}, ${createdAt!.year}';
  }

  RatingModel copyWith({
    String? id,
    String? userId,
    RatingType? ratingType,
    String? productId,
    double? rating,
    String? comment,
    String? orderId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProductData? productData,
  }) {
    return RatingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ratingType: ratingType ?? this.ratingType,
      productId: productId ?? this.productId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productData: productData ?? this.productData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        ratingType,
        productId,
        rating,
        comment,
        orderId,
        createdAt,
        updatedAt,
        productData,
      ];
}

/// Product data for food, restaurant, or driver
class ProductData extends Equatable {
  final String? id;
  final String name;
  final String? imageUrl;
  final String? description;
  final double? price;
  final double? avgRating;
  final String? restaurantName; // For food items
  final String? phone; // For drivers

  const ProductData({
    this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.price,
    this.avgRating,
    this.restaurantName,
    this.phone,
  });

  factory ProductData.fromJson(Map<String, dynamic> json, RatingType type) {
    switch (type) {
      case RatingType.food:
        return ProductData(
          id: json['_id']?.toString(),
          name: json['title']?.toString() ?? json['name']?.toString() ?? 'Unknown Food',
          imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
          description: json['description']?.toString(),
          price: (json['price'] is num) ? json['price'].toDouble() : null,
          avgRating: (json['rating'] is num) ? json['rating'].toDouble() : null,
          restaurantName: json['restaurant']?['title']?.toString(),
        );
      case RatingType.restaurant:
        return ProductData(
          id: json['_id']?.toString(),
          name: json['title']?.toString() ?? json['name']?.toString() ?? 'Unknown Restaurant',
          imageUrl: json['imageUrl']?.toString() ?? json['logoUrl']?.toString(),
          description: json['address']?.toString(),
          avgRating: (json['rating'] is num) ? json['rating'].toDouble() : null,
        );
      case RatingType.driver:
        return ProductData(
          id: json['_id']?.toString(),
          name: json['name']?.toString() ?? json['username']?.toString() ?? 'Unknown Driver',
          imageUrl: json['profile']?.toString() ?? json['imageUrl']?.toString(),
          phone: json['phone']?.toString(),
          avgRating: (json['rating'] is num) ? json['rating'].toDouble() : null,
        );
    }
  }

  @override
  List<Object?> get props => [id, name, imageUrl, description, price, avgRating, restaurantName, phone];
}

/// Rating statistics
class RatingStats extends Equatable {
  final int totalRatings;
  final double avgRating;
  final int foodCount;
  final int restaurantCount;
  final int driverCount;

  const RatingStats({
    this.totalRatings = 0,
    this.avgRating = 0.0,
    this.foodCount = 0,
    this.restaurantCount = 0,
    this.driverCount = 0,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    return RatingStats(
      totalRatings: json['totalRatings'] ?? 0,
      avgRating: (json['avgRating'] is num) ? json['avgRating'].toDouble() : 0.0,
      foodCount: json['foodCount'] ?? 0,
      restaurantCount: json['restaurantCount'] ?? 0,
      driverCount: json['driverCount'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [totalRatings, avgRating, foodCount, restaurantCount, driverCount];
}
