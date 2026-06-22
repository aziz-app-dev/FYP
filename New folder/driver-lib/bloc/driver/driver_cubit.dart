import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../../model/driver/driver_model.dart';
import '../../model/order/order_model.dart';
import '../../repo/driver/driver_repo.dart';
import '../../services/session/session_manger.dart';
import 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepo repo;
  final SessionManager session;
  Timer? _locationTimer;

  DriverCubit({
    required this.repo,
    required this.session,
  }) : super(const DriverState());

  Future<void> bootstrap() async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final results = await Future.wait([
        repo.getProfile(token),
        repo.getStats(token),
        repo.getRatings(token),
        repo.getAvailableOrders(token),
        repo.getActiveOrders(token),
        repo.getOrderHistory(token),
      ]);

      final profile = results[0] as DriverModel;
      final stats = results[1] as DriverStatsModel;
      final ratings = results[2] as List<DriverRatingModel>;
      final availableOrders = results[3] as List<OrderModel>;
      final activeOrders = results[4] as List<OrderModel>;
      final orderHistory = results[5] as List<OrderModel>;

      emit(
        state.copyWith(
          loading: false,
          profile: profile,
          stats: stats,
          ratings: ratings,
          availableOrders: availableOrders,
          activeOrders: activeOrders,
          orderHistory: orderHistory,
          online: profile.isOnline,
          available: profile.isAvailable,
        ),
      );
      _syncCurrentLocationAndActiveOrder();
      _startLocationTrackingIfNeeded();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> toggleOnline(bool value) async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    final prev = state.online;
    emit(state.copyWith(online: value, clearError: true));
    try {
      await repo.updateOnlineStatus(token: token, isOnline: value);
      if (!value) {
        emit(state.copyWith(available: false));
        _stopLocationTracking();
      } else {
        _startLocationTrackingIfNeeded();
      }
    } catch (e) {
      emit(state.copyWith(online: prev, error: e.toString()));
    }
  }

  Future<void> toggleAvailable(bool value) async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    final prev = state.available;
    emit(state.copyWith(available: value, clearError: true));
    try {
      await repo.updateAvailability(token: token, isAvailable: value);
    } catch (e) {
      emit(state.copyWith(available: prev, error: e.toString()));
    }
  }

  Future<void> syncLocation() async {
    await _syncCurrentLocationAndActiveOrder();
  }

  Future<void> _syncCurrentLocationAndActiveOrder() async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission granted = permission;
      if (granted == LocationPermission.denied) {
        granted = await Geolocator.requestPermission();
      }
      if (granted == LocationPermission.denied ||
          granted == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await repo.updateLocation(
        token: token,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      for (final order in state.activeOrders) {
        await repo.updateOrderDriverLocation(
          token: token,
          orderId: order.id,
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      }
    } catch (_) {}
  }

  void _startLocationTrackingIfNeeded() {
    _locationTimer?.cancel();
    if (!state.online) return;
    _locationTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _syncCurrentLocationAndActiveOrder();
    });
  }

  void _stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  Future<void> acceptOrder(String orderId) async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await repo.acceptOrder(token: token, orderId: orderId);
      await bootstrap();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> completeOrder(String orderId, String verificationCode) async {
    final token = session.token;
    if (token == null || token.isEmpty) return;
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await repo.completeOrder(
        token: token,
        orderId: orderId,
        verificationCode: verificationCode,
      );
      await bootstrap();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _stopLocationTracking();
    return super.close();
  }
}
