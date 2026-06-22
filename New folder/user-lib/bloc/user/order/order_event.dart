import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Load all user orders
class LoadOrdersEvent extends OrderEvent {
  const LoadOrdersEvent();
}

/// Load active orders only
class LoadActiveOrdersEvent extends OrderEvent {
  const LoadActiveOrdersEvent();
}

/// Load order history with pagination
class LoadOrderHistoryEvent extends OrderEvent {
  final int page;
  final int limit;
  final bool refresh;

  const LoadOrderHistoryEvent({
    this.page = 1,
    this.limit = 10,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [page, limit, refresh];
}

/// Load more order history (pagination)
class LoadMoreOrderHistoryEvent extends OrderEvent {
  const LoadMoreOrderHistoryEvent();
}

/// Load single order by ID
class LoadOrderByIdEvent extends OrderEvent {
  final String orderId;

  const LoadOrderByIdEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Cancel an order
class CancelOrderEvent extends OrderEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Refresh orders
class RefreshOrdersEvent extends OrderEvent {
  const RefreshOrdersEvent();
}

/// Select an order for tracking
class SelectOrderForTrackingEvent extends OrderEvent {
  final String orderId;

  const SelectOrderForTrackingEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Clear selected order
class ClearSelectedOrderEvent extends OrderEvent {
  const ClearSelectedOrderEvent();
}

/// Verify order by QR code
class VerifyOrderByCodeEvent extends OrderEvent {
  final String verificationCode;

  const VerifyOrderByCodeEvent(this.verificationCode);

  @override
  List<Object?> get props => [verificationCode];
}

/// Clear verified order
class ClearVerifiedOrderEvent extends OrderEvent {
  const ClearVerifiedOrderEvent();
}
