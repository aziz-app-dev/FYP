import 'package:equatable/equatable.dart';

import '../../../model/food/food_details_model.dart';

enum FoodDetailsStatus { initial, loading, success, error, addedToCart }

class FoodDetailsState extends Equatable {
  final FoodDetailsStatus status;
  final String? foodId;
  final FoodDetails? foodDetails;
  final String? errorMessage;
  final int selectedVariantIndex;
  final Set<int> selectedAdditives;
  final Set<int> selectedSauces;
  final int? selectedDrinkIndex;
  final Set<int> selectedDesserts;
  final int quantity;
  final int selectedSpiceLevelIndex;
  final int selectedSugarLevelIndex;
  // Map of customization group index -> Set of selected option indices
  final Map<int, Set<int>> selectedCustomizations;

  const FoodDetailsState({
    this.status = FoodDetailsStatus.initial,
    this.foodId,
    this.foodDetails,
    this.errorMessage,
    this.selectedVariantIndex = 0,
    this.selectedAdditives = const {},
    this.selectedSauces = const {},
    this.selectedDrinkIndex,
    this.selectedDesserts = const {},
    this.quantity = 1,
    this.selectedSpiceLevelIndex = 0,
    this.selectedSugarLevelIndex = 0,
    this.selectedCustomizations = const {},
  });

  // Pricing type from food details
  PricingType get pricingType =>
      foodDetails?.pricingType ?? PricingType.simple;

  // Check if food has variant pricing
  bool get hasVariantPricing => foodDetails?.hasVariantPricing ?? false;

  // Get price variants
  List<PriceVariant> get priceVariants => foodDetails?.priceVariants ?? [];

  // Get the base price based on pricing type
  double get basePrice {
    if (foodDetails == null) return 0.0;

    switch (pricingType) {
      case PricingType.simple:
        return foodDetails!.price ?? 0.0;
      case PricingType.size:
      case PricingType.weight:
      case PricingType.custom:
        if (priceVariants.isNotEmpty &&
            selectedVariantIndex < priceVariants.length) {
          return priceVariants[selectedVariantIndex].price ?? 0.0;
        }
        return foodDetails!.price ?? 0.0;
      case PricingType.scoop:
        if (priceVariants.isNotEmpty &&
            selectedVariantIndex < priceVariants.length) {
          return priceVariants[selectedVariantIndex].price ?? 0.0;
        }
        // For scoop pricing, price is based on number of scoops
        return foodDetails!.pricePerScoop ?? 0.0;
    }
  }

  // Get scoop info if applicable
  int? get maxScoops => foodDetails?.maxScoops;
  double? get pricePerScoop => foodDetails?.pricePerScoop;
  String? get weightUnit => foodDetails?.weightUnit;

  // Get min/max quantity constraints
  int get minQuantity => foodDetails?.minQuantity ?? 1;
  int get maxQuantity => foodDetails?.maxQuantity ?? 10;

  // Legacy sizes support (for backwards compatibility)
  List<FoodSize> get sizes =>
      foodDetails?.sizes ?? FoodDetails.defaultSizes;

  // Convenience getter for selected size (maps to variant)
  int get selectedSizeIndex => selectedVariantIndex;

  List<FoodAdditive> get additives =>
      foodDetails?.additives ?? FoodDetails.defaultAdditives;

  List<FoodSauce> get sauces =>
      foodDetails?.sauces ?? FoodDetails.defaultSauces;

  List<DrinkItem> get drinks => foodDetails?.drinks ?? [];

  List<DessertItem> get desserts => foodDetails?.desserts ?? [];

  List<FoodCustomization> get customizations =>
      foodDetails?.customizations ?? [];

  // Spice level options
  bool get hasSpiceLevelOptions => foodDetails?.hasSpiceLevelOptions ?? false;
  List<String> get spiceLevelOptions => foodDetails?.spiceLevelOptions ?? [];
  List<SpiceLevelVariant> get spiceLevelVariants =>
      foodDetails?.spiceLevelVariants ?? [];
  bool get hasSpiceLevelVariants => spiceLevelVariants.isNotEmpty;

  // Sugar level options
  bool get hasSugarLevelOptions => foodDetails?.hasSugarLevelOptions ?? false;
  List<String> get sugarLevelOptions => foodDetails?.sugarLevelOptions ?? [];
  List<SugarLevelVariant> get sugarLevelVariants =>
      foodDetails?.sugarLevelVariants ?? [];
  bool get hasSugarLevelVariants => sugarLevelVariants.isNotEmpty;

  List<FoodIngredient> get ingredients => foodDetails?.ingredients ?? [];

  // Food tags and type for display
  List<String> get foodTags => foodDetails?.foodTags ?? [];
  List<String> get foodType => foodDetails?.foodType ?? [];
  String? get category => foodDetails?.category;
  String? get code => foodDetails?.code;

  double get totalPrice {
    double total = basePrice;

    // For simple pricing with sizes, add size price
    if (pricingType == PricingType.simple &&
        selectedVariantIndex < sizes.length) {
      total += sizes[selectedVariantIndex].price ?? 0.0;
    }

    // Add selected additives
    for (var index in selectedAdditives) {
      if (index < additives.length) {
        total += additives[index].price ?? 0.0;
      }
    }

    // Add selected sauces
    for (var index in selectedSauces) {
      if (index < sauces.length) {
        total += sauces[index].price ?? 0.0;
      }
    }

    // Add selected drink
    if (selectedDrinkIndex != null && selectedDrinkIndex! < drinks.length) {
      total += drinks[selectedDrinkIndex!].price ?? 0.0;
    }

    // Add selected desserts
    for (var index in selectedDesserts) {
      if (index < desserts.length) {
        total += desserts[index].price ?? 0.0;
      }
    }

    // Add spice level price if variants have prices
    if (hasSpiceLevelVariants &&
        selectedSpiceLevelIndex < spiceLevelVariants.length) {
      total += spiceLevelVariants[selectedSpiceLevelIndex].price;
    }

    // Add sugar level price if variants have prices
    if (hasSugarLevelVariants &&
        selectedSugarLevelIndex < sugarLevelVariants.length) {
      total += sugarLevelVariants[selectedSugarLevelIndex].price;
    }

    // Add customization prices
    selectedCustomizations.forEach((groupIndex, optionIndices) {
      if (groupIndex < customizations.length) {
        final group = customizations[groupIndex];
        for (var optionIndex in optionIndices) {
          if (optionIndex < group.options.length) {
            total += group.options[optionIndex].price;
          }
        }
      }
    });

    return total * quantity;
  }

  bool get isLoading => status == FoodDetailsStatus.loading;
  bool get hasError => status == FoodDetailsStatus.error;
  bool get isSuccess => status == FoodDetailsStatus.success;

  // Check if all required customizations are selected
  bool get hasAllRequiredCustomizations {
    for (int i = 0; i < customizations.length; i++) {
      final group = customizations[i];
      if (group.required) {
        final selected = selectedCustomizations[i] ?? {};
        if (selected.isEmpty) return false;
      }
    }
    return true;
  }

  FoodDetailsState copyWith({
    FoodDetailsStatus? status,
    String? foodId,
    FoodDetails? foodDetails,
    String? errorMessage,
    int? selectedVariantIndex,
    Set<int>? selectedAdditives,
    Set<int>? selectedSauces,
    int? selectedDrinkIndex,
    bool clearDrink = false,
    Set<int>? selectedDesserts,
    int? quantity,
    int? selectedSpiceLevelIndex,
    int? selectedSugarLevelIndex,
    Map<int, Set<int>>? selectedCustomizations,
  }) {
    return FoodDetailsState(
      status: status ?? this.status,
      foodId: foodId ?? this.foodId,
      foodDetails: foodDetails ?? this.foodDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedVariantIndex: selectedVariantIndex ?? this.selectedVariantIndex,
      selectedAdditives: selectedAdditives ?? this.selectedAdditives,
      selectedSauces: selectedSauces ?? this.selectedSauces,
      selectedDrinkIndex:
          clearDrink ? null : (selectedDrinkIndex ?? this.selectedDrinkIndex),
      selectedDesserts: selectedDesserts ?? this.selectedDesserts,
      quantity: quantity ?? this.quantity,
      selectedSpiceLevelIndex:
          selectedSpiceLevelIndex ?? this.selectedSpiceLevelIndex,
      selectedSugarLevelIndex:
          selectedSugarLevelIndex ?? this.selectedSugarLevelIndex,
      selectedCustomizations:
          selectedCustomizations ?? this.selectedCustomizations,
    );
  }

  @override
  List<Object?> get props => [
        status,
        foodId,
        foodDetails,
        errorMessage,
        selectedVariantIndex,
        selectedAdditives,
        selectedSauces,
        selectedDrinkIndex,
        selectedDesserts,
        quantity,
        selectedSpiceLevelIndex,
        selectedSugarLevelIndex,
        selectedCustomizations,
      ];
}
