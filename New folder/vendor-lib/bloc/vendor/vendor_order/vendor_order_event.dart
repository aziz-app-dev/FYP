import 'package:equatable/equatable.dart';

abstract class VendorOrderEvent extends Equatable {
  const VendorOrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadVendorOrders extends VendorOrderEvent {
  final String restaurantId;
  final String? statusFilter;
  final int page;

  const LoadVendorOrders({
    required this.restaurantId,
    this.statusFilter,
    this.page = 1,
  });

  @override
  List<Object?> get props => [restaurantId, statusFilter, page];
}

class UpdateVendorOrderStatus extends VendorOrderEvent {
  final String orderId;
  final String newStatus;

  const UpdateVendorOrderStatus({
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [orderId, newStatus];
}

class LoadVendorOrderDetails extends VendorOrderEvent {
  final String orderId;
  const LoadVendorOrderDetails({required this.orderId});
  @override
  List<Object?> get props => [orderId];
}

class LoadQuickStats extends VendorOrderEvent {
  final String restaurantId;
  const LoadQuickStats({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}
