import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/vendor/vendor_analytics_repo.dart';
import 'vendor_analytics_event.dart';
import 'vendor_analytics_state.dart';

class VendorAnalyticsBloc
    extends Bloc<VendorAnalyticsEvent, VendorAnalyticsState> {
  final VendorAnalyticsRepo analyticsRepo;

  VendorAnalyticsBloc({required this.analyticsRepo})
      : super(const VendorAnalyticsState()) {
    on<LoadAnalytics>(_onLoad);
    on<ChangePeriod>(_onChangePeriod);
  }

  Future<void> _onLoad(
    LoadAnalytics event,
    Emitter<VendorAnalyticsState> emit,
  ) async {
    emit(state.copyWith(
      status: VendorAnalyticsStatus.loading,
      selectedPeriod: event.period,
    ));

    try {
      final results = await Future.wait([
        analyticsRepo.getRevenue(event.restaurantId, period: event.period),
        analyticsRepo.getTopItems(event.restaurantId),
      ]);

      emit(state.copyWith(
        status: VendorAnalyticsStatus.success,
        revenueData: results[0] as dynamic,
        topItems: results[1] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorAnalyticsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onChangePeriod(
    ChangePeriod event,
    Emitter<VendorAnalyticsState> emit,
  ) async {
    emit(state.copyWith(
      status: VendorAnalyticsStatus.loading,
      selectedPeriod: event.period,
    ));

    try {
      final revenue = await analyticsRepo.getRevenue(
        event.restaurantId,
        period: event.period,
      );
      emit(state.copyWith(
        status: VendorAnalyticsStatus.success,
        revenueData: revenue,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorAnalyticsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
