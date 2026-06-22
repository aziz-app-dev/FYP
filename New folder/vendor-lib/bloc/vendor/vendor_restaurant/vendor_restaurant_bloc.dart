import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/vendor/vendor_restaurant_repo.dart';
import '../../../services/socket/socket_service.dart';
import 'vendor_restaurant_event.dart';
import 'vendor_restaurant_state.dart';

class VendorRestaurantBloc
    extends Bloc<VendorRestaurantEvent, VendorRestaurantState> {
  final VendorRestaurantRepo restaurantRepo;
  final SocketService socketService;
  StreamSubscription<Map<String, dynamic>>? _restaurantStatusSub;

  VendorRestaurantBloc({
    required this.restaurantRepo,
    required this.socketService,
  })
      : super(const VendorRestaurantState()) {
    on<LoadMyRestaurants>(_onLoadMyRestaurants);
    on<CreateRestaurant>(_onCreateRestaurant);
    on<UpdateRestaurant>(_onUpdateRestaurant);
    on<ToggleRestaurantAvailability>(_onToggleAvailability);
    on<DeleteRestaurant>(_onDeleteRestaurant);
    on<SelectRestaurant>(_onSelectRestaurant);

    _restaurantStatusSub = socketService.restaurantStatusUpdates.listen((_) {
      add(LoadMyRestaurants());
    });
  }

  Future<void> _onLoadMyRestaurants(
    LoadMyRestaurants event,
    Emitter<VendorRestaurantState> emit,
  ) async {
    emit(state.copyWith(status: VendorRestaurantStatus.loading));
    try {
      final restaurants = await restaurantRepo.getMyRestaurants();
      emit(state.copyWith(
        status: VendorRestaurantStatus.success,
        restaurants: restaurants,
        selectedRestaurant:
            restaurants.isNotEmpty ? restaurants.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorRestaurantStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onCreateRestaurant(
    CreateRestaurant event,
    Emitter<VendorRestaurantState> emit,
  ) async {
    emit(state.copyWith(status: VendorRestaurantStatus.loading));
    try {
      await restaurantRepo.createRestaurant(event.data);
      final restaurants = await restaurantRepo.getMyRestaurants();
      emit(state.copyWith(
        status: VendorRestaurantStatus.success,
        restaurants: restaurants,
        selectedRestaurant:
            restaurants.isNotEmpty ? restaurants.first : null,
        successMessage: 'Restaurant created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorRestaurantStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onUpdateRestaurant(
    UpdateRestaurant event,
    Emitter<VendorRestaurantState> emit,
  ) async {
    emit(state.copyWith(status: VendorRestaurantStatus.loading));
    try {
      final updated = await restaurantRepo.updateRestaurant(
        event.restaurantId,
        event.data,
      );
      final restaurants = state.restaurants
          .map((r) => r.id == event.restaurantId ? updated : r)
          .toList();
      emit(state.copyWith(
        status: VendorRestaurantStatus.success,
        restaurants: restaurants,
        selectedRestaurant:
            state.selectedRestaurant?.id == event.restaurantId
                ? updated
                : state.selectedRestaurant,
        successMessage: 'Restaurant updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorRestaurantStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onToggleAvailability(
    ToggleRestaurantAvailability event,
    Emitter<VendorRestaurantState> emit,
  ) async {
    try {
      await restaurantRepo.toggleAvailability(event.restaurantId);
      // Reload to get updated state
      add(LoadMyRestaurants());
    } catch (e) {
      emit(state.copyWith(
        status: VendorRestaurantStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onDeleteRestaurant(
    DeleteRestaurant event,
    Emitter<VendorRestaurantState> emit,
  ) async {
    emit(state.copyWith(status: VendorRestaurantStatus.loading));
    try {
      await restaurantRepo.deleteRestaurant(event.restaurantId);
      final restaurants =
          state.restaurants.where((r) => r.id != event.restaurantId).toList();
      emit(state.copyWith(
        status: VendorRestaurantStatus.success,
        restaurants: restaurants,
        selectedRestaurant: restaurants.isNotEmpty ? restaurants.first : null,
        successMessage: 'Restaurant deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorRestaurantStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onSelectRestaurant(
    SelectRestaurant event,
    Emitter<VendorRestaurantState> emit,
  ) {
    final selected = state.restaurants.firstWhere(
      (r) => r.id == event.restaurantId,
      orElse: () => state.restaurants.first,
    );
    emit(state.copyWith(selectedRestaurant: selected));
  }

  @override
  Future<void> close() async {
    await _restaurantStatusSub?.cancel();
    return super.close();
  }
}
