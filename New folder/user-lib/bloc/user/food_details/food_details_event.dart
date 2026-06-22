import 'package:equatable/equatable.dart';

abstract class FoodDetailsEvent extends Equatable {
  const FoodDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFoodDetailsEvent extends FoodDetailsEvent {
  final String foodId;

  const LoadFoodDetailsEvent({required this.foodId});

  @override
  List<Object?> get props => [foodId];
}

class SelectSizeEvent extends FoodDetailsEvent {
  final int index;

  const SelectSizeEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event for selecting a price variant (size, weight, scoop, custom)
class SelectVariantEvent extends FoodDetailsEvent {
  final int index;

  const SelectVariantEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event for toggling a customization option
class ToggleCustomizationEvent extends FoodDetailsEvent {
  final int groupIndex;
  final int optionIndex;

  const ToggleCustomizationEvent({
    required this.groupIndex,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [groupIndex, optionIndex];
}

class ToggleAdditiveEvent extends FoodDetailsEvent {
  final int index;

  const ToggleAdditiveEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleSauceEvent extends FoodDetailsEvent {
  final int index;

  const ToggleSauceEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SelectDrinkEvent extends FoodDetailsEvent {
  final int? index;

  const SelectDrinkEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleDessertEvent extends FoodDetailsEvent {
  final int index;

  const ToggleDessertEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SelectSpiceLevelEvent extends FoodDetailsEvent {
  final int index;

  const SelectSpiceLevelEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SelectSugarLevelEvent extends FoodDetailsEvent {
  final int index;

  const SelectSugarLevelEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateQuantityEvent extends FoodDetailsEvent {
  final int quantity;

  const UpdateQuantityEvent(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class IncrementQuantityEvent extends FoodDetailsEvent {
  const IncrementQuantityEvent();
}

class DecrementQuantityEvent extends FoodDetailsEvent {
  const DecrementQuantityEvent();
}

class AddToCartEvent extends FoodDetailsEvent {
  const AddToCartEvent();
}
