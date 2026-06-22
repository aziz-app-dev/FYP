import 'package:equatable/equatable.dart';

abstract class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDetailsEvent extends RestaurantDetailsEvent {
  final String restaurantId;

  const LoadRestaurantDetailsEvent({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}
