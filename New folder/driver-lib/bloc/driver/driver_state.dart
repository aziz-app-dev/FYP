import 'package:equatable/equatable.dart';

import '../../model/driver/driver_model.dart';
import '../../model/order/order_model.dart';

class DriverState extends Equatable {
  final bool loading;
  final String? error;
  final DriverModel? profile;
  final DriverStatsModel? stats;
  final List<DriverRatingModel> ratings;
  final List<OrderModel> availableOrders;
  final List<OrderModel> activeOrders;
  final List<OrderModel> orderHistory;
  final bool online;
  final bool available;

  const DriverState({
    this.loading = false,
    this.error,
    this.profile,
    this.stats,
    this.ratings = const [],
    this.availableOrders = const [],
    this.activeOrders = const [],
    this.orderHistory = const [],
    this.online = false,
    this.available = false,
  });

  DriverState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    DriverModel? profile,
    DriverStatsModel? stats,
    List<DriverRatingModel>? ratings,
    List<OrderModel>? availableOrders,
    List<OrderModel>? activeOrders,
    List<OrderModel>? orderHistory,
    bool? online,
    bool? available,
  }) {
    return DriverState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      ratings: ratings ?? this.ratings,
      availableOrders: availableOrders ?? this.availableOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      orderHistory: orderHistory ?? this.orderHistory,
      online: online ?? this.online,
      available: available ?? this.available,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    profile,
    stats,
    ratings,
    availableOrders,
    activeOrders,
    orderHistory,
    online,
    available,
  ];
}
