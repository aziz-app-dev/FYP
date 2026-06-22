import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/user/order/order_repo.dart';
import '../../../services/session/session_manger.dart';
import '../../../services/socket/socket_service.dart';
import '../../../services/notification/notification_service.dart';
import 'order_event.dart';
import 'order_state.dart';
import 'dart:async';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepo _orderRepo;
  final SocketService _socketService;
  final NotificationService _notificationService;
  final SessionManager _sessionManager = SessionManager();
  StreamSubscription? _socketSubscription;

  OrderBloc({
    required OrderRepo orderRepo,
    required SocketService socketService,
    required NotificationService notificationService,
  }) : _orderRepo = orderRepo,
       _socketService = socketService,
       _notificationService = notificationService,
       super(const OrderState()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadActiveOrdersEvent>(_onLoadActiveOrders);
    on<LoadOrderHistoryEvent>(_onLoadOrderHistory);
    on<LoadMoreOrderHistoryEvent>(_onLoadMoreOrderHistory);
    on<LoadOrderByIdEvent>(_onLoadOrderById);
    on<CancelOrderEvent>(_onCancelOrder);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<SelectOrderForTrackingEvent>(_onSelectOrderForTracking);
    on<ClearSelectedOrderEvent>(_onClearSelectedOrder);
    on<VerifyOrderByCodeEvent>(_onVerifyOrderByCode);
    on<ClearVerifiedOrderEvent>(_onClearVerifiedOrder);

    _initSocketListener();
  }

  void _initSocketListener() {
    _socketSubscription = _socketService.statusUpdates.listen((data) {
      debugPrint('OrderBloc: Received socket update: $data');

      // Trigger notification
      _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: data['title'] ?? 'Order Update',
        body: data['body'] ?? 'Your order status has been updated.',
      );

      // Refresh orders to update UI
      add(const RefreshOrdersEvent());
    });
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }

  Future<String?> _getToken() async {
    return await _sessionManager.getToken();
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderLoadingStatus.loading, clearError: true));

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Please login to view orders',
          ),
        );
        return;
      }

      final orders = await _orderRepo.getUserOrders(token);
      emit(
        state.copyWith(status: OrderLoadingStatus.success, allOrders: orders),
      );
    } catch (e) {
      debugPrint('Error loading orders: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadActiveOrders(
    LoadActiveOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderLoadingStatus.loading, clearError: true));

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Please login to view orders',
          ),
        );
        return;
      }

      final activeOrders = await _orderRepo.getActiveOrders(token);
      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          activeOrders: activeOrders,
        ),
      );
    } catch (e) {
      debugPrint('Error loading active orders: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistoryEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (event.refresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(
        state.copyWith(status: OrderLoadingStatus.loading, clearError: true),
      );
    }

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            isRefreshing: false,
            errorMessage: 'Please login to view order history',
          ),
        );
        return;
      }

      final response = await _orderRepo.getOrderHistory(
        token,
        page: event.page,
        limit: event.limit,
      );

      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          orderHistory: response.orders,
          historyPagination: response.pagination,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      debugPrint('Error loading order history: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          isRefreshing: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreOrderHistory(
    LoadMoreOrderHistoryEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (!state.canLoadMoreHistory ||
        state.status == OrderLoadingStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: OrderLoadingStatus.loadingMore));

    try {
      final token = await _getToken();
      if (token == null) return;

      final nextPage = state.currentHistoryPage + 1;
      final response = await _orderRepo.getOrderHistory(token, page: nextPage);

      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          orderHistory: [...state.orderHistory, ...response.orders],
          historyPagination: response.pagination,
        ),
      );
    } catch (e) {
      debugPrint('Error loading more order history: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadOrderById(
    LoadOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderLoadingStatus.loading, clearError: true));

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Please login to view order details',
          ),
        );
        return;
      }

      final order = await _orderRepo.getOrderById(event.orderId, token);
      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          selectedOrder: order,
        ),
      );
    } catch (e) {
      debugPrint('Error loading order: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderLoadingStatus.loading));

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Please login to cancel order',
          ),
        );
        return;
      }

      final success = await _orderRepo.cancelOrder(event.orderId, token);
      if (success) {
        // Refresh active orders after cancellation
        final activeOrders = await _orderRepo.getActiveOrders(token);
        emit(
          state.copyWith(
            status: OrderLoadingStatus.success,
            activeOrders: activeOrders,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Failed to cancel order',
          ),
        );
      }
    } catch (e) {
      debugPrint('Error cancelling order: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    // Show loading spinner on initial load (empty lists), pull-to-refresh indicator otherwise
    final isInitialLoad =
        state.activeOrders.isEmpty && state.orderHistory.isEmpty;
    if (isInitialLoad) {
      emit(
        state.copyWith(status: OrderLoadingStatus.loading, clearError: true),
      );
    } else {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    }

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            isRefreshing: false,
            errorMessage: 'Please login to view orders',
          ),
        );
        return;
      }

      final activeOrders = await _orderRepo.getActiveOrders(token);
      final historyResponse = await _orderRepo.getOrderHistory(token);

      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          activeOrders: activeOrders,
          orderHistory: historyResponse.orders,
          historyPagination: historyResponse.pagination,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      debugPrint('Error refreshing orders: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          isRefreshing: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSelectOrderForTracking(
    SelectOrderForTrackingEvent event,
    Emitter<OrderState> emit,
  ) async {
    // First check if order is in active orders
    final order = state.activeOrders.firstWhere(
      (o) => o.id == event.orderId,
      orElse: () => state.allOrders.firstWhere(
        (o) => o.id == event.orderId,
        orElse: () => throw Exception('Order not found'),
      ),
    );

    emit(state.copyWith(selectedOrder: order));
  }

  void _onClearSelectedOrder(
    ClearSelectedOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(clearSelectedOrder: true));
  }

  Future<void> _onVerifyOrderByCode(
    VerifyOrderByCodeEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderLoadingStatus.loading,
        clearError: true,
        clearVerifiedOrder: true,
      ),
    );

    try {
      final token = await _getToken();
      if (token == null) {
        emit(
          state.copyWith(
            status: OrderLoadingStatus.failure,
            errorMessage: 'Please login to verify orders',
          ),
        );
        return;
      }

      final order = await _orderRepo.verifyOrderByCode(
        event.verificationCode,
        token,
      );
      emit(
        state.copyWith(
          status: OrderLoadingStatus.success,
          verifiedOrder: order,
        ),
      );
    } catch (e) {
      debugPrint('Error verifying order: $e');
      emit(
        state.copyWith(
          status: OrderLoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearVerifiedOrder(
    ClearVerifiedOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(clearVerifiedOrder: true));
  }
}
