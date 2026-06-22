import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/vendor/vendor_menu_repo.dart';
import 'vendor_menu_event.dart';
import 'vendor_menu_state.dart';

class VendorMenuBloc extends Bloc<VendorMenuEvent, VendorMenuState> {
  final VendorMenuRepo menuRepo;

  VendorMenuBloc({required this.menuRepo}) : super(const VendorMenuState()) {
    on<LoadMenuItems>(_onLoad);
    on<CreateMenuItem>(_onCreate);
    on<UpdateMenuItem>(_onUpdate);
    on<DeleteMenuItem>(_onDelete);
    on<ToggleMenuItemAvailability>(_onToggle);
  }

  String? _currentRestaurantId;

  Future<void> _onLoad(
    LoadMenuItems event,
    Emitter<VendorMenuState> emit,
  ) async {
    _currentRestaurantId = event.restaurantId;
    emit(state.copyWith(status: VendorMenuStatus.loading));
    try {
      final items = await menuRepo.getMenuItems(event.restaurantId);
      emit(state.copyWith(
        status: VendorMenuStatus.success,
        menuItems: items,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorMenuStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onCreate(
    CreateMenuItem event,
    Emitter<VendorMenuState> emit,
  ) async {
    emit(state.copyWith(status: VendorMenuStatus.loading));
    try {
      await menuRepo.createItem(event.data);
      // Reload menu items
      final items = await menuRepo.getMenuItems(event.restaurantId);
      emit(state.copyWith(
        status: VendorMenuStatus.success,
        menuItems: items,
        successMessage: 'Item created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorMenuStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onUpdate(
    UpdateMenuItem event,
    Emitter<VendorMenuState> emit,
  ) async {
    emit(state.copyWith(status: VendorMenuStatus.loading));
    try {
      await menuRepo.updateItem(event.foodId, event.data);
      final items = await menuRepo.getMenuItems(event.restaurantId);
      emit(state.copyWith(
        status: VendorMenuStatus.success,
        menuItems: items,
        successMessage: 'Item updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorMenuStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onDelete(
    DeleteMenuItem event,
    Emitter<VendorMenuState> emit,
  ) async {
    try {
      await menuRepo.deleteItem(event.foodId);
      final items =
          state.menuItems.where((i) => i.id != event.foodId).toList();
      emit(state.copyWith(
        status: VendorMenuStatus.success,
        menuItems: items,
        successMessage: 'Item deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VendorMenuStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onToggle(
    ToggleMenuItemAvailability event,
    Emitter<VendorMenuState> emit,
  ) async {
    try {
      await menuRepo.toggleAvailability(event.foodId);
      if (_currentRestaurantId != null) {
        add(LoadMenuItems(restaurantId: _currentRestaurantId!));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VendorMenuStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
