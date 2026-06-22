import 'package:equatable/equatable.dart';

abstract class VendorDashboardEvent extends Equatable {
  const VendorDashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends VendorDashboardEvent {
  final String restaurantId;
  const LoadDashboard({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}

class RefreshDashboard extends VendorDashboardEvent {
  final String restaurantId;
  const RefreshDashboard({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}
