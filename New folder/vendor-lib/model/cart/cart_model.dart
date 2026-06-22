import 'package:equatable/equatable.dart';

/// Additive model for cart items
class Additive extends Equatable {
  final String? id;
  final String title;
  final double price;

  const Additive({
    this.id,
    required this.title,
    required this.price,
  });

  factory Additive.fromJson(Map<String, dynamic> json) {
    return Additive(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
      };

  @override
  List<Object?> get props => [id, title, price];
}

/// Product info (populated from productId reference)
class CartProductInfo extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final double? rating;
  final String? ratingCount;
  final double price;
  final String? restaurantId;
  final String? time;
  final int maxQuantity;

  const CartProductInfo({
    required this.id,
    required this.title,
    this.imageUrl,
    this.rating,
    this.ratingCount,
    required this.price,
    this.restaurantId,
    this.time,
    this.maxQuantity = 10,
  });

  factory CartProductInfo.fromJson(Map<String, dynamic> json) {
    // Handle imageUrl which can be String or List
    String? imageUrl;
    final imgValue = json['imageUrl'];
    if (imgValue is List && imgValue.isNotEmpty) {
      imageUrl = imgValue.first?.toString();
    } else if (imgValue != null) {
      imageUrl = imgValue.toString();
    }

    return CartProductInfo(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: imageUrl,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: json['ratingCount']?.toString(),
      price: (json['price'] ?? 0).toDouble(),
      restaurantId: json['restaurant']?.toString(),
      time: json['time']?.toString(),
      maxQuantity: json['maxQuantity'] ?? 10,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, imageUrl, rating, ratingCount, price, restaurantId, time, maxQuantity];
}

/// Cart item model
class CartItem extends Equatable {
  final String id;
  final String? userId;
  final String productId;
  final CartProductInfo? product;
  final List<Additive> additives;
  final String instructions;
  final int quantity;
  final double totalPrice;

  const CartItem({
    required this.id,
    this.userId,
    required this.productId,
    this.product,
    this.additives = const [],
    this.instructions = '',
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Handle populated productId
    CartProductInfo? product;
    String productIdStr;

    if (json['productId'] != null) {
      if (json['productId'] is Map) {
        product = CartProductInfo.fromJson(json['productId']);
        productIdStr = json['productId']['_id']?.toString() ?? '';
      } else {
        productIdStr = json['productId'].toString();
      }
    } else {
      productIdStr = '';
    }

    return CartItem(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString(),
      productId: productIdStr,
      product: product,
      additives: (json['additives'] as List<dynamic>?)
              ?.map((e) => e is Map<String, dynamic>
                  ? Additive.fromJson(e)
                  : Additive(title: e.toString(), price: 0))
              .toList() ??
          [],
      instructions: json['instructions'] ?? '',
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'additives': additives.map((e) => e.toJson()).toList(),
        'instructions': instructions,
      };

  /// Get unit price
  double get unitPrice => quantity > 0 ? totalPrice / quantity : 0;

  /// Get display name
  String get displayName => product?.title ?? 'Unknown Product';

  /// Get display image
  String? get displayImage => product?.imageUrl;

  /// Get max allowed quantity (from product settings, default 10)
  int get maxQuantity => product?.maxQuantity ?? 10;

  /// Check if quantity is at max limit
  bool get isAtMaxQuantity => quantity >= maxQuantity;

  /// Create a copy with updated quantity
  CartItem copyWithQuantity(int newQuantity) {
    final unitPx = unitPrice;
    return CartItem(
      id: id,
      userId: userId,
      productId: productId,
      product: product,
      additives: additives,
      instructions: instructions,
      quantity: newQuantity,
      totalPrice: unitPx * newQuantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        product,
        additives,
        instructions,
        quantity,
        totalPrice,
      ];
}

/// Cart summary model
class CartSummary extends Equatable {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double taxAmount;
  final double discount;
  final double total;
  final String? promoCode;

  const CartSummary({
    this.items = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.taxAmount = 0,
    this.discount = 0,
    this.total = 0,
    this.promoCode,
  });

  factory CartSummary.calculate({
    required List<CartItem> items,
    required double deliveryFee,
    required double taxRate,
    double discount = 0,
    String? promoCode,
  }) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final taxAmount = subtotal * (taxRate / 100);
    final total = subtotal + deliveryFee + taxAmount - discount;

    return CartSummary(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      taxAmount: taxAmount,
      discount: discount,
      total: total > 0 ? total : 0,
      promoCode: promoCode,
    );
  }

  /// Get total item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get unique restaurant IDs in cart
  Set<String?> get restaurantIds =>
      items.map((e) => e.product?.restaurantId).toSet();

  /// Check if cart has items from multiple restaurants
  bool get hasMultipleRestaurants => restaurantIds.length > 1;

  CartSummary copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? taxAmount,
    double? discount,
    double? total,
    String? promoCode,
  }) {
    return CartSummary(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxAmount: taxAmount ?? this.taxAmount,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  @override
  List<Object?> get props => [
        items,
        subtotal,
        deliveryFee,
        taxAmount,
        discount,
        total,
        promoCode,
      ];
}

/// Add to cart request model
class AddToCartRequest {
  final String productId;
  final int quantity;
  final double totalPrice;
  final List<Additive> additives;
  final String instructions;

  const AddToCartRequest({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    this.additives = const [],
    this.instructions = '',
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'additives': additives.map((e) => e.toJson()).toList(),
        'instructions': instructions,
      };
}
