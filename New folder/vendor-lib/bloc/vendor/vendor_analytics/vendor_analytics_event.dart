import 'package:equatable/equatable.dart';

abstract class VendorAnalyticsEvent extends Equatable {
  const VendorAnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends VendorAnalyticsEvent {
  final String restaurantId;
  final String period;

  const LoadAnalytics({required this.restaurantId, this.period = 'daily'});

  @override
  List<Object?> get props => [restaurantId, period];
}

class ChangePeriod extends VendorAnalyticsEvent {
  final String restaurantId;
  final String period;

  const ChangePeriod({required this.restaurantId, required this.period});

  @override
  List<Object?> get props => [restaurantId, period];
}
