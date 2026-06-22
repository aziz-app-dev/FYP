import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/vendor/vendor_order_model.dart';
import '../../../repo/vendor/vendor_analytics_repo.dart';
import '../../../repo/vendor/vendor_order_repo.dart';
import 'vendor_dashboard_event.dart';
import 'vendor_dashboard_state.dart';

class VendorDashboardBloc
    extends Bloc<VendorDashboardEvent, VendorDashboardState> {
  final VendorAnalyticsRepo analyticsRepo;
  final VendorOrderRepo orderRepo;

  VendorDashboardBloc({
    required this.analyticsRepo,
    required this.orderRepo,
  }) : super(const VendorDashboardState()) {
    on<LoadDashboard>(_onLoad);
    on<RefreshDashboard>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadDashboard event,
    Emitter<VendorDashboardState> emit,
  ) async {
    emit(state.copyWith(status: VendorDashboardStatus.loading));
    await _fetchDashboard(event.restaurantId, emit);
  }

  Future<void> _onRefresh(
    RefreshDashboard event,
    Emitter<VendorDashboardState> emit,
  ) async {
    await _fetchDashboard(event.restaurantId, emit);
  }

  Future<void> _fetchDashboard(
    String restaurantId,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      final results = await Future.wait([
        analyticsRepo.getDashboardSummary(restaurantId),
        orderRepo
            .getOrders(restaurantId, status: 'Pending', limit: 5)
            .then((r) => r.orders),
        analyticsRepo.getTopItems(restaurantId, limit: 5),
      ]);

      emit(state.copyWith(
        status: VendorDashboardStatus.success,
        summary: results[0] as dynamic,
        recentOrders: results[1] as List<VendorOrder>,
        topItems: results[2] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorDashboardStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
