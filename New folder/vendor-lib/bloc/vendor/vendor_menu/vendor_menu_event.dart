import 'package:equatable/equatable.dart';

abstract class VendorMenuEvent extends Equatable {
  const VendorMenuEvent();
  @override
  List<Object?> get props => [];
}

class LoadMenuItems extends VendorMenuEvent {
  final String restaurantId;
  const LoadMenuItems({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}

class CreateMenuItem extends VendorMenuEvent {
  final Map<String, dynamic> data;
  final String restaurantId;
  const CreateMenuItem({required this.data, required this.restaurantId});
  @override
  List<Object?> get props => [data, restaurantId];
}

class UpdateMenuItem extends VendorMenuEvent {
  final String foodId;
  final Map<String, dynamic> data;
  final String restaurantId;
  const UpdateMenuItem({
    required this.foodId,
    required this.data,
    required this.restaurantId,
  });
  @override
  List<Object?> get props => [foodId, data, restaurantId];
}

class DeleteMenuItem extends VendorMenuEvent {
  final String foodId;
  const DeleteMenuItem({required this.foodId});
  @override
  List<Object?> get props => [foodId];
}

class ToggleMenuItemAvailability extends VendorMenuEvent {
  final String foodId;
  const ToggleMenuItemAvailability({required this.foodId});
  @override
  List<Object?> get props => [foodId];
}
