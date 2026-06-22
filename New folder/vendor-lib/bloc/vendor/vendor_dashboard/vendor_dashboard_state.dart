import 'package:equatable/equatable.dart';
import '../../../model/vendor/vendor_analytics_model.dart';
import '../../../model/vendor/vendor_dashboard_model.dart';
import '../../../model/vendor/vendor_order_model.dart';

enum VendorDashboardStatus { initial, loading, success, error }

class VendorDashboardState extends Equatable {
  final VendorDashboardStatus status;
  final VendorDashboardSummary? summary;
  final List<VendorOrder> recentOrders;
  final List<TopSellingItem> topItems;
  final String? errorMessage;

  const VendorDashboardState({
    this.status = VendorDashboardStatus.initial,
    this.summary,
    this.recentOrders = const [],
    this.topItems = const [],
    this.errorMessage,
  });

  bool get isLoading => status == VendorDashboardStatus.loading;
  bool get hasError => status == VendorDashboardStatus.error;

  VendorDashboardState copyWith({
    VendorDashboardStatus? status,
    VendorDashboardSummary? summary,
    List<VendorOrder>? recentOrders,
    List<TopSellingItem>? topItems,
    String? errorMessage,
  }) {
    return VendorDashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      recentOrders: recentOrders ?? this.recentOrders,
      topItems: topItems ?? this.topItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, recentOrders, topItems, errorMessage];
}
