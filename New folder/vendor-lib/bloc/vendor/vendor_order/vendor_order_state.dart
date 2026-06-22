import 'package:equatable/equatable.dart';
import '../../../model/vendor/vendor_dashboard_model.dart';
import '../../../model/vendor/vendor_order_model.dart';

enum VendorOrderStatus { initial, loading, success, error }

class VendorOrderState extends Equatable {
  final VendorOrderStatus status;
  final List<VendorOrder> orders;
  final VendorOrder? selectedOrder;
  final VendorQuickStats? quickStats;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String? statusFilter;
  final String? errorMessage;
  final String? successMessage;

  const VendorOrderState({
    this.status = VendorOrderStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.quickStats,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.statusFilter,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == VendorOrderStatus.loading;
  bool get hasError => status == VendorOrderStatus.error;

  List<VendorOrder> get activeOrders =>
      orders.where((o) => o.isActive).toList();

  VendorOrderState copyWith({
    VendorOrderStatus? status,
    List<VendorOrder>? orders,
    VendorOrder? selectedOrder,
    VendorQuickStats? quickStats,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? statusFilter,
    String? errorMessage,
    String? successMessage,
  }) {
    return VendorOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      quickStats: quickStats ?? this.quickStats,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      statusFilter: statusFilter ?? this.statusFilter,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        selectedOrder,
        quickStats,
        currentPage,
        totalPages,
        totalItems,
        statusFilter,
        errorMessage,
        successMessage,
      ];
}
