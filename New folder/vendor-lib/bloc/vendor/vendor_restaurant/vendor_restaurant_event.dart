import 'package:equatable/equatable.dart';

abstract class VendorRestaurantEvent extends Equatable {
  const VendorRestaurantEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyRestaurants extends VendorRestaurantEvent {}

class CreateRestaurant extends VendorRestaurantEvent {
  final Map<String, dynamic> data;
  const CreateRestaurant({required this.data});
  @override
  List<Object?> get props => [data];
}

class UpdateRestaurant extends VendorRestaurantEvent {
  final String restaurantId;
  final Map<String, dynamic> data;
  const UpdateRestaurant({required this.restaurantId, required this.data});
  @override
  List<Object?> get props => [restaurantId, data];
}

class ToggleRestaurantAvailability extends VendorRestaurantEvent {
  final String restaurantId;
  const ToggleRestaurantAvailability({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}

class DeleteRestaurant extends VendorRestaurantEvent {
  final String restaurantId;
  const DeleteRestaurant({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}

class SelectRestaurant extends VendorRestaurantEvent {
  final String restaurantId;
  const SelectRestaurant({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}
