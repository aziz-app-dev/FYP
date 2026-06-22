import 'package:equatable/equatable.dart';
import '../../../model/order/order_model.dart';

enum OrderLoadingStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

class OrderState extends Equatable {
  final OrderLoadingStatus status;
  final List<OrderModel> allOrders;
  final List<OrderModel> activeOrders;
  final List<OrderModel> orderHistory;
  final OrderModel? selectedOrder;
  final OrderPagination? historyPagination;
  final String? errorMessage;
  final bool isRefreshing;
  final OrderModel? verifiedOrder;

  const OrderState({
    this.status = OrderLoadingStatus.initial,
    this.allOrders = const [],
    this.activeOrders = const [],
    this.orderHistory = const [],
    this.selectedOrder,
    this.historyPagination,
    this.errorMessage,
    this.isRefreshing = false,
    this.verifiedOrder,
  });

  /// Check if there are any active orders
  bool get hasActiveOrders => activeOrders.isNotEmpty;

  /// Get the most recent active order (for tracking)
  OrderModel? get currentTrackingOrder =>
      activeOrders.isNotEmpty ? activeOrders.first : null;

  /// Check if can load more history
  bool get canLoadMoreHistory =>
      historyPagination != null && historyPagination!.hasMore;

  /// Get the current history page
  int get currentHistoryPage => historyPagination?.page ?? 1;

  OrderState copyWith({
    OrderLoadingStatus? status,
    List<OrderModel>? allOrders,
    List<OrderModel>? activeOrders,
    List<OrderModel>? orderHistory,
    OrderModel? selectedOrder,
    OrderPagination? historyPagination,
    String? errorMessage,
    bool? isRefreshing,
    OrderModel? verifiedOrder,
    bool clearSelectedOrder = false,
    bool clearError = false,
    bool clearVerifiedOrder = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      allOrders: allOrders ?? this.allOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      orderHistory: orderHistory ?? this.orderHistory,
      selectedOrder:
          clearSelectedOrder ? null : (selectedOrder ?? this.selectedOrder),
      historyPagination: historyPagination ?? this.historyPagination,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      verifiedOrder:
          clearVerifiedOrder ? null : (verifiedOrder ?? this.verifiedOrder),
    );
  }

  @override
  List<Object?> get props => [
        status,
        allOrders,
        activeOrders,
        orderHistory,
        selectedOrder,
        historyPagination,
        errorMessage,
        isRefreshing,
        verifiedOrder,
      ];
}
