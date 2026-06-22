import 'package:equatable/equatable.dart';

class VendorOrderCustomer {
  final String id;
  final String? username;
  final String? email;
  final String? phone;
  final String? profile;

  const VendorOrderCustomer({
    required this.id,
    this.username,
    this.email,
    this.phone,
    this.profile,
  });

  factory VendorOrderCustomer.fromJson(Map<String, dynamic> json) {
    return VendorOrderCustomer(
      id: json['_id']?.toString() ?? '',
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      profile: json['profile']?.toString(),
    );
  }
}

class VendorOrderFood {
  final String? id;
  final String? title;
  final String? imageUrl;
  final double? price;

  const VendorOrderFood({this.id, this.title, this.imageUrl, this.price});

  factory VendorOrderFood.fromJson(Map<String, dynamic> json) {
    final img = json['imageUrl'];
    String? imageUrl;
    if (img is List && img.isNotEmpty) {
      imageUrl = img.first?.toString();
    } else if (img is String) {
      imageUrl = img;
    }
    return VendorOrderFood(
      id: json['_id']?.toString(),
      title: json['title']?.toString(),
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

class VendorOrderItem {
  final VendorOrderFood? food;
  final int quantity;
  final double price;
  final List<dynamic>? additives;
  final String? instruction;

  const VendorOrderItem({
    this.food,
    required this.quantity,
    required this.price,
    this.additives,
    this.instruction,
  });

  factory VendorOrderItem.fromJson(Map<String, dynamic> json) {
    return VendorOrderItem(
      food: json['foodId'] is Map<String, dynamic>
          ? VendorOrderFood.fromJson(json['foodId'])
          : null,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      additives: json['additives'] as List<dynamic>?,
      instruction: json['instruction']?.toString(),
    );
  }
}

class VendorOrderAddress {
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? postalCode;

  const VendorOrderAddress({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postalCode,
  });

  factory VendorOrderAddress.fromJson(Map<String, dynamic> json) {
    return VendorOrderAddress(
      addressLine1: json['addressLine1']?.toString(),
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString(),
      postalCode: json['postalCode']?.toString(),
    );
  }
}

class VendorOrder extends Equatable {
  final String id;
  final VendorOrderCustomer? customer;
  final List<VendorOrderItem> items;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final VendorOrderAddress? deliveryAddress;
  final DateTime? createdAt;
  final String? notes;
  final String? promoCode;
  final double? discountAmount;

  const VendorOrder({
    required this.id,
    this.customer,
    required this.items,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    this.deliveryAddress,
    this.createdAt,
    this.notes,
    this.promoCode,
    this.discountAmount,
  });

  factory VendorOrder.fromJson(Map<String, dynamic> json) {
    return VendorOrder(
      id: json['_id']?.toString() ?? '',
      customer: json['userId'] is Map<String, dynamic>
          ? VendorOrderCustomer.fromJson(json['userId'])
          : null,
      items: json['orderItems'] == null
          ? []
          : (json['orderItems'] as List)
              .map((e) => VendorOrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      orderTotal: (json['orderTotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
      orderStatus: json['orderStatus']?.toString() ?? 'Pending',
      paymentMethod: json['paymentMethod']?.toString() ?? 'Cash',
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      deliveryAddress: json['deliveryAddress'] is Map<String, dynamic>
          ? VendorOrderAddress.fromJson(json['deliveryAddress'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      notes: json['notes']?.toString(),
      promoCode: json['promoCode']?.toString(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
    );
  }

  /// Get list of valid next statuses for vendor
  List<String> get nextStatuses {
    switch (orderStatus) {
      case 'Pending':
        return ['Placed', 'Cancelled'];
      case 'Placed':
        return ['Preparing', 'Cancelled'];
      case 'Preparing':
        return ['Ready', 'Cancelled'];
      case 'Ready':
        return ['Out For Delivery', 'Delivery'];
      case 'Out For Delivery':
        return ['Delivery'];
      default:
        return [];
    }
  }

  bool get isActive =>
      ['Pending', 'Placed', 'Preparing', 'Ready', 'Out For Delivery']
          .contains(orderStatus);

  @override
  List<Object?> get props => [id, orderStatus];
}
