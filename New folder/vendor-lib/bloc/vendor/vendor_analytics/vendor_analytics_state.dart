import 'package:equatable/equatable.dart';
import '../../../model/vendor/vendor_analytics_model.dart';

enum VendorAnalyticsStatus { initial, loading, success, error }

class VendorAnalyticsState extends Equatable {
  final VendorAnalyticsStatus status;
  final RevenueData? revenueData;
  final List<TopSellingItem> topItems;
  final String selectedPeriod;
  final String? errorMessage;

  const VendorAnalyticsState({
    this.status = VendorAnalyticsStatus.initial,
    this.revenueData,
    this.topItems = const [],
    this.selectedPeriod = 'daily',
    this.errorMessage,
  });

  bool get isLoading => status == VendorAnalyticsStatus.loading;
  bool get hasError => status == VendorAnalyticsStatus.error;

  VendorAnalyticsState copyWith({
    VendorAnalyticsStatus? status,
    RevenueData? revenueData,
    List<TopSellingItem>? topItems,
    String? selectedPeriod,
    String? errorMessage,
  }) {
    return VendorAnalyticsState(
      status: status ?? this.status,
      revenueData: revenueData ?? this.revenueData,
      topItems: topItems ?? this.topItems,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, revenueData, topItems, selectedPeriod, errorMessage];
}
