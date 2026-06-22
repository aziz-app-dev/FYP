import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/vendor/vendor_order_repo.dart';
import 'vendor_order_event.dart';
import 'vendor_order_state.dart';

class VendorOrderBloc extends Bloc<VendorOrderEvent, VendorOrderState> {
  final VendorOrderRepo orderRepo;

  VendorOrderBloc({required this.orderRepo})
      : super(const VendorOrderState()) {
    on<LoadVendorOrders>(_onLoadOrders);
    on<UpdateVendorOrderStatus>(_onUpdateStatus);
    on<LoadVendorOrderDetails>(_onLoadDetails);
    on<LoadQuickStats>(_onLoadStats);
  }

  Future<void> _onLoadOrders(
    LoadVendorOrders event,
    Emitter<VendorOrderState> emit,
  ) async {
    emit(state.copyWith(
      status: VendorOrderStatus.loading,
      statusFilter: event.statusFilter,
    ));

    try {
      final result = await orderRepo.getOrders(
        event.restaurantId,
        status: event.statusFilter,
        page: event.page,
      );
      emit(state.copyWith(
        status: VendorOrderStatus.success,
        orders: result.orders,
        currentPage: event.page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorOrderStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateVendorOrderStatus event,
    Emitter<VendorOrderState> emit,
  ) async {
    try {
      final updated = await orderRepo.updateOrderStatus(
        event.orderId,
        event.newStatus,
      );
      final orders = state.orders
          .map((o) => o.id == event.orderId ? updated : o)
          .toList();
      emit(state.copyWith(
        status: VendorOrderStatus.success,
        orders: orders,
        selectedOrder:
            state.selectedOrder?.id == event.orderId ? updated : null,
        successMessage: 'Order status updated to ${event.newStatus}',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorOrderStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onLoadDetails(
    LoadVendorOrderDetails event,
    Emitter<VendorOrderState> emit,
  ) async {
    emit(state.copyWith(status: VendorOrderStatus.loading));
    try {
      final order = await orderRepo.getOrderById(event.orderId);
      emit(state.copyWith(
        status: VendorOrderStatus.success,
        selectedOrder: order,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorOrderStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onLoadStats(
    LoadQuickStats event,
    Emitter<VendorOrderState> emit,
  ) async {
    try {
      final stats = await orderRepo.getQuickStats(event.restaurantId);
      emit(state.copyWith(quickStats: stats));
    } catch (e) {
      // Non-critical, don't switch to error state
    }
  }
}
