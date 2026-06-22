import 'package:equatable/equatable.dart';

/// Order status enum matching backend values
enum OrderStatus {
  pending('Pending'),
  placed('Placed'),
  preparing('Preparing'),
  ready('Ready'),
  outForDelivery('Out For Delivery'),
  delivery('Delivery'),
  cancelled('Cancelled'),
  manual('Manual');

  final String value;
  const OrderStatus(this.value);

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  bool get isActive => [
        OrderStatus.pending,
        OrderStatus.placed,
        OrderStatus.preparing,
        OrderStatus.ready,
        OrderStatus.outForDelivery,
      ].contains(this);

  bool get isCompleted => this == OrderStatus.delivery;
  bool get isCancelled => this == OrderStatus.cancelled;

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivery:
        return 4;
      default:
        return 0;
    }
  }
}

/// Payment status enum
enum PaymentStatus {
  pending('Pending'),
  completed('Completed'),
  failed('Failed');

  final String value;
  const PaymentStatus(this.value);

  static PaymentStatus fromString(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => PaymentStatus.pending,
    );
  }
}

/// Payment method enum
enum PaymentMethod {
  cash('Cash'),
  card('Card'),
  jazzCash('JazzCash');

  final String value;
  const PaymentMethod(this.value);

  static PaymentMethod fromString(String method) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value.toLowerCase() == method.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Order item model
class OrderItem extends Equatable {
  final String? id;
  final String? foodId;
  final FoodInfo? food;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instruction;

  const OrderItem({
    this.id,
    this.foodId,
    this.food,
    required this.quantity,
    required this.price,
    this.additives = const [],
    this.instruction = '',
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle populated foodId
    FoodInfo? food;
    String? foodIdStr;

    if (json['foodId'] != null) {
      if (json['foodId'] is Map) {
        food = FoodInfo.fromJson(json['foodId']);
        foodIdStr = json['foodId']['_id']?.toString();
      } else {
        foodIdStr = json['foodId'].toString();
      }
    }

    return OrderItem(
      id: json['_id']?.toString(),
      foodId: foodIdStr,
      food: food,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      additives: (json['additives'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      instruction: json['instruction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'quantity': quantity,
        'price': price,
        'additives': additives,
        'instruction': instruction,
      };

  @override
  List<Object?> get props =>
      [id, foodId, food, quantity, price, additives, instruction];
}

/// Food info model (populated from food reference)
class FoodInfo extends Equatable {
  final String id;
  final String title;
  final String? time;
  final double? rating;
  final String? imageUrl;
  final double? price;

  const FoodInfo({
    required this.id,
    required this.title,
    this.time,
    this.rating,
    this.imageUrl,
    this.price,
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    // imageUrl can be a String or a List of Strings from the backend
    final rawImage = json['imageUrl'];
    final String? imageUrl = rawImage is List
        ? (rawImage.isNotEmpty ? rawImage.first?.toString() : null)
        : rawImage?.toString();

    return FoodInfo(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      time: json['time'],
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: imageUrl,
      price: json['price']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, title, time, rating, imageUrl, price];
}

/// Restaurant info model (populated from restaurant reference)
class RestaurantInfo extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final List<double>? coords;
  final String? address;
  final String? phone;

  const RestaurantInfo({
    required this.id,
    required this.title,
    this.imageUrl,
    this.coords,
    this.address,
    this.phone,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    // coords can be an object {latitude, longitude} or a list [lng, lat]
    List<double>? parsedCoords;
    final rawCoords = json['coords'];
    if (rawCoords is List) {
      parsedCoords = rawCoords.map((e) => (e as num).toDouble()).toList();
    } else if (rawCoords is Map) {
      final lat = rawCoords['latitude'];
      final lng = rawCoords['longitude'];
      if (lat != null && lng != null) {
        parsedCoords = [(lng as num).toDouble(), (lat as num).toDouble()];
      }
    }

    // imageUrl can be a String or a List of Strings from the backend
    final rawImage = json['imageUrl'];
    final String? imageUrl = rawImage is List
        ? (rawImage.isNotEmpty ? rawImage.first?.toString() : null)
        : rawImage?.toString();

    return RestaurantInfo(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: imageUrl,
      coords: parsedCoords,
      address: rawCoords is Map
          ? rawCoords['address']?.toString() ?? json['address']
          : json['address'],
      phone: json['phone'],
    );
  }

  @override
  List<Object?> get props => [id, title, imageUrl, coords, address, phone];
}

/// Delivery address info model
class DeliveryAddressInfo extends Equatable {
  final String? id;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  const DeliveryAddressInfo({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  factory DeliveryAddressInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressInfo(
      id: json['_id']?.toString(),
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      postalCode: json['postalCode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (addressLine1 != null && addressLine1!.isNotEmpty) {
      parts.add(addressLine1!);
    }
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    return parts.join(', ');
  }

  @override
  List<Object?> get props =>
      [id, addressLine1, addressLine2, city, postalCode, latitude, longitude];
}

/// Driver info model
class DriverInfo extends Equatable {
  final String? name;
  final String? phone;
  final String? image;
  final String? vehicleType;
  final String? vehicleNumber;

  const DriverInfo({
    this.name,
    this.phone,
    this.image,
    this.vehicleType,
    this.vehicleNumber,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      vehicleType: json['vehicleType'],
      vehicleNumber: json['vehicleNumber'],
    );
  }

  @override
  List<Object?> get props => [name, phone, image, vehicleType, vehicleNumber];
}

/// Driver location model
class DriverLocation extends Equatable {
  final String type;
  final List<double> coordinates;

  const DriverLocation({
    this.type = 'Point',
    this.coordinates = const [0, 0],
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [0, 0],
    );
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0;

  @override
  List<Object?> get props => [type, coordinates];
}

/// Main Order model
class OrderModel extends Equatable {
  final String id;
  final String? userId;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String? deliveryAddressId;
  final DeliveryAddressInfo? deliveryAddress;
  final String restaurantAddress;
  final List<double>? restaurantCoords;
  final List<double>? recipientCoords;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final String? restaurantId;
  final RestaurantInfo? restaurant;
  final String? driverId;
  final DriverInfo? driverInfo;
  final DriverLocation? driverLocation;
  final DateTime? driverLocationUpdatedAt;
  final DateTime? estimatedDeliveryTime;
  final double rating;
  final String? feedBack;
  final String? promoCode;
  final double? discountAmount;
  final String? notes;
  final String? verificationCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    required this.id,
    this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    this.deliveryAddressId,
    this.deliveryAddress,
    required this.restaurantAddress,
    this.restaurantCoords,
    this.recipientCoords,
    this.paymentMethod = PaymentMethod.cash,
    this.paymentStatus = PaymentStatus.pending,
    this.orderStatus = OrderStatus.pending,
    required this.orderDate,
    this.restaurantId,
    this.restaurant,
    this.driverId,
    this.driverInfo,
    this.driverLocation,
    this.driverLocationUpdatedAt,
    this.estimatedDeliveryTime,
    this.rating = 3,
    this.feedBack,
    this.promoCode,
    this.discountAmount,
    this.notes,
    this.verificationCode,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle populated restaurant
    RestaurantInfo? restaurant;
    String? restaurantIdStr;
    if (json['restaurantId'] != null) {
      if (json['restaurantId'] is Map) {
        restaurant = RestaurantInfo.fromJson(json['restaurantId']);
        restaurantIdStr = json['restaurantId']['_id']?.toString();
      } else {
        restaurantIdStr = json['restaurantId'].toString();
      }
    }

    // Handle populated delivery address
    DeliveryAddressInfo? deliveryAddress;
    String? deliveryAddressId;
    if (json['deliveryAddress'] != null) {
      if (json['deliveryAddress'] is Map) {
        deliveryAddress = DeliveryAddressInfo.fromJson(json['deliveryAddress']);
        deliveryAddressId = json['deliveryAddress']['_id']?.toString();
      } else {
        deliveryAddressId = json['deliveryAddress'].toString();
      }
    }

    return OrderModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString(),
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      orderTotal: (json['orderTotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
      deliveryAddressId: deliveryAddressId,
      deliveryAddress: deliveryAddress,
      restaurantAddress: json['restaurantAddress'] ?? '',
      restaurantCoords: (json['restaurantCoords'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      recipientCoords: (json['recipientCoords'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] ?? 'Cash'),
      paymentStatus:
          PaymentStatus.fromString(json['paymentStatus'] ?? 'Pending'),
      orderStatus: OrderStatus.fromString(json['orderStatus'] ?? 'Pending'),
      orderDate:
          DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      restaurantId: restaurantIdStr,
      restaurant: restaurant,
      driverId: json['driverId'],
      driverInfo: json['driverInfo'] != null
          ? DriverInfo.fromJson(json['driverInfo'])
          : null,
      driverLocation: json['driverLocation'] != null
          ? DriverLocation.fromJson(json['driverLocation'])
          : null,
      driverLocationUpdatedAt:
          DateTime.tryParse(json['driverLocationUpdatedAt'] ?? ''),
      estimatedDeliveryTime:
          DateTime.tryParse(json['estimatedDeliveryTime'] ?? ''),
      rating: (json['rating'] ?? 3).toDouble(),
      feedBack: json['feedBack'],
      promoCode: json['promoCode'],
      discountAmount: json['discountAmount']?.toDouble(),
      notes: json['notes'],
      verificationCode: json['verificationCode'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'orderItems': orderItems.map((item) => item.toJson()).toList(),
        'orderTotal': orderTotal,
        'deliveryFee': deliveryFee,
        'grandTotal': grandTotal,
        'deliveryAddress': deliveryAddressId,
        'restaurantAddress': restaurantAddress,
        'restaurantCoords': restaurantCoords,
        'recipientCoords': recipientCoords,
        'paymentMethod': paymentMethod.value,
        'restaurantId': restaurantId,
        'promoCode': promoCode,
        'discountAmount': discountAmount,
        'notes': notes,
      };

  /// Get total items count
  int get totalItems =>
      orderItems.fold(0, (sum, item) => sum + item.quantity);

  /// Check if order can be cancelled
  bool get canCancel =>
      orderStatus != OrderStatus.outForDelivery &&
      orderStatus != OrderStatus.delivery &&
      orderStatus != OrderStatus.cancelled;

  /// Check if order is being delivered
  bool get isBeingDelivered => orderStatus == OrderStatus.outForDelivery;

  /// Get restaurant location as [lat, lng]
  List<double>? get restaurantLatLng {
    if (restaurantCoords != null && restaurantCoords!.length >= 2) {
      return [restaurantCoords![1], restaurantCoords![0]]; // Convert to lat, lng
    }
    return restaurant?.coords != null && restaurant!.coords!.length >= 2
        ? [restaurant!.coords![1], restaurant!.coords![0]]
        : null;
  }

  /// Get delivery location as [lat, lng]
  List<double>? get deliveryLatLng {
    if (recipientCoords != null && recipientCoords!.length >= 2) {
      return [recipientCoords![1], recipientCoords![0]];
    }
    if (deliveryAddress?.latitude != null && deliveryAddress?.longitude != null) {
      return [deliveryAddress!.latitude!, deliveryAddress!.longitude!];
    }
    return null;
  }

  /// Get driver location as [lat, lng]
  List<double>? get driverLatLng {
    if (driverLocation != null) {
      return [driverLocation!.latitude, driverLocation!.longitude];
    }
    return null;
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? orderItems,
    double? orderTotal,
    double? deliveryFee,
    double? grandTotal,
    String? deliveryAddressId,
    DeliveryAddressInfo? deliveryAddress,
    String? restaurantAddress,
    List<double>? restaurantCoords,
    List<double>? recipientCoords,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
    DateTime? orderDate,
    String? restaurantId,
    RestaurantInfo? restaurant,
    String? driverId,
    DriverInfo? driverInfo,
    DriverLocation? driverLocation,
    DateTime? driverLocationUpdatedAt,
    DateTime? estimatedDeliveryTime,
    double? rating,
    String? feedBack,
    String? promoCode,
    double? discountAmount,
    String? notes,
    String? verificationCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderItems: orderItems ?? this.orderItems,
      orderTotal: orderTotal ?? this.orderTotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      grandTotal: grandTotal ?? this.grandTotal,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      restaurantCoords: restaurantCoords ?? this.restaurantCoords,
      recipientCoords: recipientCoords ?? this.recipientCoords,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant ?? this.restaurant,
      driverId: driverId ?? this.driverId,
      driverInfo: driverInfo ?? this.driverInfo,
      driverLocation: driverLocation ?? this.driverLocation,
      driverLocationUpdatedAt:
          driverLocationUpdatedAt ?? this.driverLocationUpdatedAt,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      rating: rating ?? this.rating,
      feedBack: feedBack ?? this.feedBack,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      notes: notes ?? this.notes,
      verificationCode: verificationCode ?? this.verificationCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        orderItems,
        orderTotal,
        deliveryFee,
        grandTotal,
        deliveryAddressId,
        deliveryAddress,
        restaurantAddress,
        restaurantCoords,
        recipientCoords,
        paymentMethod,
        paymentStatus,
        orderStatus,
        orderDate,
        restaurantId,
        restaurant,
        driverId,
        driverInfo,
        driverLocation,
        driverLocationUpdatedAt,
        estimatedDeliveryTime,
        rating,
        feedBack,
        promoCode,
        discountAmount,
        notes,
        verificationCode,
        createdAt,
        updatedAt,
      ];
}

/// Pagination model for order history
class OrderPagination extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const OrderPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory OrderPagination.fromJson(Map<String, dynamic> json) {
    return OrderPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [page, limit, total, totalPages];
}

/// Order history response model
class OrderHistoryResponse extends Equatable {
  final List<OrderModel> orders;
  final OrderPagination pagination;

  const OrderHistoryResponse({
    required this.orders,
    required this.pagination,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    final ordersList = <OrderModel>[];
    final rawOrders = json['orders'] as List<dynamic>? ?? [];
    for (final item in rawOrders) {
      try {
        ordersList.add(OrderModel.fromJson(item));
      } catch (_) {
        // Skip orders that fail to parse
      }
    }
    return OrderHistoryResponse(
      orders: ordersList,
      pagination: OrderPagination.fromJson(json['pagination'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [orders, pagination];
}
