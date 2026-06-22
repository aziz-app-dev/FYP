import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/cart/cart_model.dart';
import '../../../repo/user/cart/cart_repo.dart';
import '../../../repo/user/food/food_repo.dart';
import 'food_details_event.dart';
import 'food_details_state.dart';

class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final FoodRepo foodRepo;
  final CartRepository cartRepo;

  FoodDetailsBloc({required this.foodRepo, required this.cartRepo})
      : super(const FoodDetailsState()) {
    on<LoadFoodDetailsEvent>(_onLoadFoodDetails);
    on<SelectSizeEvent>(_onSelectSize);
    on<SelectVariantEvent>(_onSelectVariant);
    on<ToggleAdditiveEvent>(_onToggleAdditive);
    on<ToggleSauceEvent>(_onToggleSauce);
    on<SelectDrinkEvent>(_onSelectDrink);
    on<ToggleDessertEvent>(_onToggleDessert);
    on<ToggleCustomizationEvent>(_onToggleCustomization);
    on<SelectSpiceLevelEvent>(_onSelectSpiceLevel);
    on<SelectSugarLevelEvent>(_onSelectSugarLevel);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onLoadFoodDetails(
    LoadFoodDetailsEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    emit(state.copyWith(
      status: FoodDetailsStatus.loading,
      foodId: event.foodId,
    ));

    try {
      final foodDetails = await foodRepo.fetchFoodDetails(event.foodId);

      // Set default variant index based on food data
      int defaultVariantIndex = 0;
      if (foodDetails.hasVariantPricing) {
        defaultVariantIndex = foodDetails.defaultVariantIndex;
      }

      // Set default customization selections
      Map<int, Set<int>> defaultCustomizations = {};
      if (foodDetails.customizations != null) {
        for (int i = 0; i < foodDetails.customizations!.length; i++) {
          final group = foodDetails.customizations![i];
          final defaults = <int>{};
          for (int j = 0; j < group.options.length; j++) {
            if (group.options[j].isDefault) {
              defaults.add(j);
            }
          }
          if (defaults.isNotEmpty) {
            defaultCustomizations[i] = defaults;
          }
        }
      }

      // Set default spice and sugar level indices
      int defaultSpiceIndex = foodDetails.hasSpiceLevelOptions
          ? foodDetails.defaultSpiceLevelIndex
          : 0;
      int defaultSugarIndex = foodDetails.hasSugarLevelOptions
          ? foodDetails.defaultSugarLevelIndex
          : 0;

      emit(state.copyWith(
        status: FoodDetailsStatus.success,
        foodDetails: foodDetails,
        selectedVariantIndex: defaultVariantIndex,
        selectedCustomizations: defaultCustomizations,
        selectedSpiceLevelIndex: defaultSpiceIndex,
        selectedSugarLevelIndex: defaultSugarIndex,
        quantity: foodDetails.minQuantity,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FoodDetailsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onSelectSize(
    SelectSizeEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    emit(state.copyWith(selectedVariantIndex: event.index));
  }

  void _onSelectVariant(
    SelectVariantEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    emit(state.copyWith(selectedVariantIndex: event.index));
  }

  void _onToggleAdditive(
    ToggleAdditiveEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    final newSet = Set<int>.from(state.selectedAdditives);
    if (newSet.contains(event.index)) {
      newSet.remove(event.index);
    } else {
      newSet.add(event.index);
    }
    emit(state.copyWith(selectedAdditives: newSet));
  }

  void _onToggleSauce(
    ToggleSauceEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    final newSet = Set<int>.from(state.selectedSauces);
    if (newSet.contains(event.index)) {
      newSet.remove(event.index);
    } else {
      newSet.add(event.index);
    }
    emit(state.copyWith(selectedSauces: newSet));
  }

  void _onSelectDrink(
    SelectDrinkEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    if (event.index == null || state.selectedDrinkIndex == event.index) {
      // Deselect if tapping same drink or null
      emit(state.copyWith(clearDrink: true));
    } else {
      emit(state.copyWith(selectedDrinkIndex: event.index));
    }
  }

  void _onToggleDessert(
    ToggleDessertEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    final newSet = Set<int>.from(state.selectedDesserts);
    if (newSet.contains(event.index)) {
      newSet.remove(event.index);
    } else {
      newSet.add(event.index);
    }
    emit(state.copyWith(selectedDesserts: newSet));
  }

  void _onToggleCustomization(
    ToggleCustomizationEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    if (event.groupIndex >= state.customizations.length) return;

    final group = state.customizations[event.groupIndex];
    final newMap = Map<int, Set<int>>.from(state.selectedCustomizations);
    final currentSet = Set<int>.from(newMap[event.groupIndex] ?? {});

    if (group.multiSelect) {
      // Multi-select: toggle the option
      if (currentSet.contains(event.optionIndex)) {
        currentSet.remove(event.optionIndex);
      } else {
        // Check max selections if defined
        if (group.maxSelections == null ||
            currentSet.length < group.maxSelections!) {
          currentSet.add(event.optionIndex);
        }
      }
    } else {
      // Single-select: replace selection
      if (currentSet.contains(event.optionIndex)) {
        currentSet.clear();
      } else {
        currentSet.clear();
        currentSet.add(event.optionIndex);
      }
    }

    if (currentSet.isEmpty) {
      newMap.remove(event.groupIndex);
    } else {
      newMap[event.groupIndex] = currentSet;
    }

    emit(state.copyWith(selectedCustomizations: newMap));
  }

  void _onSelectSpiceLevel(
    SelectSpiceLevelEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    emit(state.copyWith(selectedSpiceLevelIndex: event.index));
  }

  void _onSelectSugarLevel(
    SelectSugarLevelEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    emit(state.copyWith(selectedSugarLevelIndex: event.index));
  }

  void _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    final minQty = state.minQuantity;
    final maxQty = state.maxQuantity;
    final newQuantity = event.quantity.clamp(minQty, maxQty);
    emit(state.copyWith(quantity: newQuantity));
  }

  void _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    if (state.quantity < state.maxQuantity) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) {
    if (state.quantity > state.minQuantity) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state.foodDetails == null || state.foodId == null) return;

    emit(state.copyWith(status: FoodDetailsStatus.loading));

    try {
      // Collect all selected add-ons as Additive objects
      final List<Additive> allAdditives = [];

      for (var index in state.selectedAdditives) {
        if (index < state.additives.length) {
          final a = state.additives[index];
          allAdditives.add(Additive(
            title: a.title ?? '',
            price: a.price ?? 0,
          ));
        }
      }

      for (var index in state.selectedSauces) {
        if (index < state.sauces.length) {
          final s = state.sauces[index];
          allAdditives.add(Additive(
            title: s.name ?? '',
            price: s.price ?? 0,
          ));
        }
      }

      if (state.selectedDrinkIndex != null &&
          state.selectedDrinkIndex! < state.drinks.length) {
        final d = state.drinks[state.selectedDrinkIndex!];
        allAdditives.add(Additive(
          title: d.name ?? '',
          price: d.price ?? 0,
        ));
      }

      for (var index in state.selectedDesserts) {
        if (index < state.desserts.length) {
          final d = state.desserts[index];
          allAdditives.add(Additive(
            title: d.name ?? '',
            price: d.price ?? 0,
          ));
        }
      }

      final request = AddToCartRequest(
        productId: state.foodId!,
        quantity: state.quantity,
        totalPrice: state.totalPrice,
        additives: allAdditives,
      );

      await cartRepo.addToCart(request);

      emit(state.copyWith(status: FoodDetailsStatus.addedToCart));
    } catch (e) {
      emit(state.copyWith(
        status: FoodDetailsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
