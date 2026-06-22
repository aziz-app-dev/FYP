import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

/// Load wishlist
class LoadWishlistEvent extends WishlistEvent {}

/// Add food to wishlist
class AddToWishlistEvent extends WishlistEvent {
  final String foodId;

  const AddToWishlistEvent(this.foodId);

  @override
  List<Object> get props => [foodId];
}

/// Remove food from wishlist
class RemoveFromWishlistEvent extends WishlistEvent {
  final String foodId;

  const RemoveFromWishlistEvent(this.foodId);

  @override
  List<Object> get props => [foodId];
}

/// Toggle food in wishlist (add if not present, remove if present)
class ToggleWishlistEvent extends WishlistEvent {
  final String foodId;

  const ToggleWishlistEvent(this.foodId);

  @override
  List<Object> get props => [foodId];
}

/// Check if food is in wishlist
class CheckWishlistStatusEvent extends WishlistEvent {
  final String foodId;

  const CheckWishlistStatusEvent(this.foodId);

  @override
  List<Object> get props => [foodId];
}

/// Reset wishlist state
class ResetWishlistStateEvent extends WishlistEvent {}
