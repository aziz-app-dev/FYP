class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String? profile;
  final String vehicleType;
  final String? vehicleNumber;
  final bool isOnline;
  final bool isAvailable;
  final bool isVerified;
  final double rating;
  final int totalDeliveries;
  final double totalEarnings;
  final String? token;

  const DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.profile,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.isOnline,
    required this.isAvailable,
    required this.isVerified,
    required this.rating,
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.token,
  });

  factory DriverModel.fromJson(
    Map<String, dynamic> json, {
    String? token,
  }) {
    return DriverModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: (json['userType']?.toString().isNotEmpty ?? false)
          ? json['userType'].toString()
          : 'driver',
      profile: json['profile']?.toString(),
      vehicleType: json['vehicleType']?.toString() ?? 'bike',
      vehicleNumber: json['vehicleNumber']?.toString(),
      isOnline: json['isOnline'] == true,
      isAvailable: json['isAvailable'] == true,
      isVerified: json['isVerified'] == true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0,
      token: token,
    );
  }

  Map<String, dynamic> toUserSessionJson() {
    return {
      '_id': id,
      'username': name,
      'email': email,
      'phone': phone,
      'verification': isVerified,
      'phoneVerification': true,
      'userType': 'driver',
      'profile': profile,
      'userToken': token,
    };
  }
}

class DriverStatsModel {
  final int totalDeliveries;
  final int completedDeliveries;
  final int cancelledDeliveries;
  final double rating;
  final int totalRatings;
  final double totalEarnings;
  final double completionRate;

  const DriverStatsModel({
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.cancelledDeliveries,
    required this.rating,
    required this.totalRatings,
    required this.totalEarnings,
    required this.completionRate,
  });

  factory DriverStatsModel.fromJson(Map<String, dynamic> json) {
    return DriverStatsModel(
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      completedDeliveries: (json['completedDeliveries'] as num?)?.toInt() ?? 0,
      cancelledDeliveries: (json['cancelledDeliveries'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0,
      completionRate: double.tryParse(json['completionRate']?.toString() ?? '') ??
          (json['completionRate'] as num?)?.toDouble() ??
          0,
    );
  }
}

class DriverRatingModel {
  final String id;
  final String? userName;
  final double rating;
  final String? review;
  final DateTime? createdAt;

  const DriverRatingModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory DriverRatingModel.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'];
    String? userName;
    if (userObj is Map<String, dynamic>) {
      userName = userObj['username']?.toString();
    }

    return DriverRatingModel(
      id: json['_id']?.toString() ?? '',
      userName: userName,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      review: json['review']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

enum DriverTaskStatus { available, accepted, pickedUp, delivered }

class DriverTaskModel {
  final String id;
  final String orderCode;
  final String customerName;
  final String pickupAddress;
  final String dropAddress;
  final double amount;
  final int etaMins;
  final DriverTaskStatus status;

  const DriverTaskModel({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.pickupAddress,
    required this.dropAddress,
    required this.amount,
    required this.etaMins,
    required this.status,
  });

  DriverTaskModel copyWith({
    DriverTaskStatus? status,
  }) {
    return DriverTaskModel(
      id: id,
      orderCode: orderCode,
      customerName: customerName,
      pickupAddress: pickupAddress,
      dropAddress: dropAddress,
      amount: amount,
      etaMins: etaMins,
      status: status ?? this.status,
    );
  }
}
