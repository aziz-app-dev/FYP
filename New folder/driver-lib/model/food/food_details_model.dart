import 'dart:convert';

import '../home/home_model.dart';

FoodDetailsResponse foodDetailsResponseFromJson(String str) =>
    FoodDetailsResponse.fromJson(json.decode(str));

class FoodDetailsResponse {
  final bool? status;
  final String? message;
  final FoodDetails? data;

  FoodDetailsResponse({this.status, this.message, this.data});

  factory FoodDetailsResponse.fromJson(Map<String, dynamic> json) =>
      FoodDetailsResponse(
        status: json["status"],
        message: json["message"]?.toString(),
        data:
            json["data"] == null ? null : FoodDetails.fromJson(json["data"]),
      );
}

/// Pricing type enum matching backend
enum PricingType {
  simple,
  size,
  weight,
  scoop,
  custom;

  static PricingType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'size':
        return PricingType.size;
      case 'weight':
        return PricingType.weight;
      case 'scoop':
        return PricingType.scoop;
      case 'custom':
        return PricingType.custom;
      default:
        return PricingType.simple;
    }
  }
}

/// Price variant for size/weight/scoop/custom pricing
class PriceVariant {
  final String? id;
  final String? name;
  final double? price;
  final String? description;
  final bool isDefault;

  PriceVariant({
    this.id,
    this.name,
    this.price,
    this.description,
    this.isDefault = false,
  });

  factory PriceVariant.fromJson(Map<String, dynamic> json) => PriceVariant(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        description: json["description"]?.toString(),
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "description": description,
        "isDefault": isDefault,
      };
}

/// Customization option (individual option within a customization group)
class CustomizationOption {
  final String? id;
  final String? name;
  final double price;
  final bool isDefault;

  CustomizationOption({
    this.id,
    this.name,
    this.price = 0.0,
    this.isDefault = false,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) =>
      CustomizationOption(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "isDefault": isDefault,
      };
}

/// Customization group (e.g., "Toppings", "Extras", "Sauce")
class FoodCustomization {
  final String? id;
  final String? name;
  final bool required;
  final bool multiSelect;
  final int? maxSelections;
  final List<CustomizationOption> options;

  FoodCustomization({
    this.id,
    this.name,
    this.required = false,
    this.multiSelect = true,
    this.maxSelections,
    this.options = const [],
  });

  factory FoodCustomization.fromJson(Map<String, dynamic> json) =>
      FoodCustomization(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        required: json["required"] ?? false,
        multiSelect: json["multiSelect"] ?? true,
        maxSelections: json["maxSelections"],
        options: json["options"] == null
            ? []
            : List<CustomizationOption>.from(
                json["options"]!.map((x) => CustomizationOption.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "required": required,
        "multiSelect": multiSelect,
        "maxSelections": maxSelections,
        "options": options.map((x) => x.toJson()).toList(),
      };
}

/// Spice level variant with optional price adjustment
class SpiceLevelVariant {
  final String? id;
  final String? level;
  final double price;
  final String? description;
  final bool isDefault;

  SpiceLevelVariant({
    this.id,
    this.level,
    this.price = 0.0,
    this.description,
    this.isDefault = false,
  });

  factory SpiceLevelVariant.fromJson(Map<String, dynamic> json) =>
      SpiceLevelVariant(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        level: json["level"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        description: json["description"]?.toString(),
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "level": level,
        "price": price,
        "description": description,
        "isDefault": isDefault,
      };
}

/// Sugar level variant with optional price adjustment
class SugarLevelVariant {
  final String? id;
  final String? level;
  final double price;
  final String? description;
  final bool isDefault;

  SugarLevelVariant({
    this.id,
    this.level,
    this.price = 0.0,
    this.description,
    this.isDefault = false,
  });

  factory SugarLevelVariant.fromJson(Map<String, dynamic> json) =>
      SugarLevelVariant(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        level: json["level"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        description: json["description"]?.toString(),
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "level": level,
        "price": price,
        "description": description,
        "isDefault": isDefault,
      };
}

class FoodDetails {
  final String? id;
  final String? title;
  final String? imageUrl;
  final List<String>? imageUrls;
  final double? price;
  final double? displayPrice;
  final double? rating;
  final String? ratingCount;
  final String? description;
  final List<String>? foodTags;
  final List<String>? foodType;
  final String? category;
  final String? code;
  final RestaurantItem? restaurant;
  final String? time;
  final int? calories;
  final bool? isAvailable;

  // Pricing structure
  final PricingType pricingType;
  final List<PriceVariant>? priceVariants;
  final List<String>? sizeOptions;
  final String? weightUnit;
  final int? maxScoops;
  final double? pricePerScoop;
  final int minQuantity;
  final int maxQuantity;

  // Ingredients
  final List<FoodIngredient>? ingredients;

  // Additional options
  final List<FoodAdditive>? additives;
  final List<FoodCustomization>? customizations;

  // Spice level options
  final String? spiceLevel;
  final List<String>? spiceLevelOptions;
  final List<SpiceLevelVariant>? spiceLevelVariants;

  // Sugar level options
  final String? sugarLevel;
  final List<String>? sugarLevelOptions;
  final List<SugarLevelVariant>? sugarLevelVariants;

  // Legacy fields for backwards compatibility
  final List<FoodSize>? sizes;
  final List<FoodSauce>? sauces;
  final List<DrinkItem>? drinks;
  final List<DessertItem>? desserts;

  FoodDetails({
    this.id,
    this.title,
    this.imageUrl,
    this.imageUrls,
    this.price,
    this.displayPrice,
    this.rating,
    this.ratingCount,
    this.description,
    this.foodTags,
    this.foodType,
    this.category,
    this.code,
    this.restaurant,
    this.time,
    this.calories,
    this.isAvailable,
    this.pricingType = PricingType.simple,
    this.priceVariants,
    this.sizeOptions,
    this.weightUnit,
    this.maxScoops,
    this.pricePerScoop,
    this.minQuantity = 1,
    this.maxQuantity = 10,
    this.ingredients,
    this.additives,
    this.customizations,
    this.spiceLevel,
    this.spiceLevelOptions,
    this.spiceLevelVariants,
    this.sugarLevel,
    this.sugarLevelOptions,
    this.sugarLevelVariants,
    this.sizes,
    this.sauces,
    this.drinks,
    this.desserts,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    // Handle imageUrl which can be String or List
    String? singleImageUrl;
    List<String>? allImageUrls;

    final imgValue = json["imageUrl"];
    if (imgValue is List) {
      allImageUrls = List<String>.from(imgValue.map((x) => x.toString()));
      singleImageUrl = allImageUrls.isNotEmpty ? allImageUrls.first : null;
    } else if (imgValue != null) {
      singleImageUrl = imgValue.toString();
      allImageUrls = [singleImageUrl];
    }

    // Parse pricing type
    final pricingType = PricingType.fromString(json["pricingType"]?.toString());

    // Parse price variants
    List<PriceVariant>? priceVariants;
    if (json["priceVariants"] != null) {
      priceVariants = List<PriceVariant>.from(
        json["priceVariants"]!.map((x) => PriceVariant.fromJson(x)),
      );
    }

    // Parse customizations
    List<FoodCustomization>? customizations;
    if (json["customizations"] != null) {
      customizations = List<FoodCustomization>.from(
        json["customizations"]!.map((x) => FoodCustomization.fromJson(x)),
      );
    }

    return FoodDetails(
      id: json["_id"]?.toString(),
      title: json["title"]?.toString(),
      imageUrl: singleImageUrl,
      imageUrls: allImageUrls,
      price: (json["price"] as num?)?.toDouble(),
      displayPrice: (json["displayPrice"] as num?)?.toDouble(),
      rating: (json["rating"] as num?)?.toDouble(),
      ratingCount: json["ratingCount"]?.toString(),
      description: json["description"]?.toString(),
      foodTags: json["foodTags"] == null
          ? []
          : List<String>.from(json["foodTags"]!.map((x) => x.toString())),
      foodType: json["foodType"] == null
          ? []
          : List<String>.from(json["foodType"]!.map((x) => x.toString())),
      category: json["category"]?.toString(),
      code: json["code"]?.toString(),
      restaurant: json["restaurant"] == null
          ? null
          : (json["restaurant"] is Map<String, dynamic>
              ? RestaurantItem.fromJson(json["restaurant"])
              : null),
      time: json["time"]?.toString(),
      calories: json["calories"],
      isAvailable: json["isAvailable"] ?? true,
      // Pricing fields
      pricingType: pricingType,
      priceVariants: priceVariants,
      sizeOptions: json["sizeOptions"] == null
          ? null
          : List<String>.from(json["sizeOptions"]!.map((x) => x.toString())),
      weightUnit: json["weightUnit"]?.toString(),
      maxScoops: json["maxScoops"],
      pricePerScoop: (json["pricePerScoop"] as num?)?.toDouble(),
      minQuantity: json["minQuantity"] ?? 1,
      maxQuantity: json["maxQuantity"] ?? 10,
      // Ingredients
      ingredients: json["ingredients"] == null
          ? null
          : List<FoodIngredient>.from(
              json["ingredients"]!.map((x) => FoodIngredient.fromJson(x)),
            ),
      // Additional options
      additives: json["additives"] == null
          ? null
          : List<FoodAdditive>.from(
              json["additives"]!.map((x) => FoodAdditive.fromJson(x)),
            ),
      customizations: customizations,
      // Spice level
      spiceLevel: json["spiceLevel"]?.toString(),
      spiceLevelOptions: json["spiceLevelOptions"] == null
          ? null
          : List<String>.from(
              json["spiceLevelOptions"]!.map((x) => x.toString())),
      spiceLevelVariants: json["spiceLevelVariants"] == null
          ? null
          : List<SpiceLevelVariant>.from(
              json["spiceLevelVariants"]!
                  .map((x) => SpiceLevelVariant.fromJson(x)),
            ),
      // Sugar level
      sugarLevel: json["sugarLevel"]?.toString(),
      sugarLevelOptions: json["sugarLevelOptions"] == null
          ? null
          : List<String>.from(
              json["sugarLevelOptions"]!.map((x) => x.toString())),
      sugarLevelVariants: json["sugarLevelVariants"] == null
          ? null
          : List<SugarLevelVariant>.from(
              json["sugarLevelVariants"]!
                  .map((x) => SugarLevelVariant.fromJson(x)),
            ),
      // Legacy fields
      sizes: json["sizes"] == null
          ? null
          : List<FoodSize>.from(
              json["sizes"]!.map((x) => FoodSize.fromJson(x)),
            ),
      sauces: json["sauces"] == null
          ? null
          : List<FoodSauce>.from(
              json["sauces"]!.map((x) => FoodSauce.fromJson(x)),
            ),
      drinks: json["drinks"] == null
          ? null
          : List<DrinkItem>.from(
              json["drinks"]!.map((x) => DrinkItem.fromJson(x)),
            ),
      desserts: json["desserts"] == null
          ? null
          : List<DessertItem>.from(
              json["desserts"]!.map((x) => DessertItem.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": imageUrls ?? (imageUrl != null ? [imageUrl!] : []),
        "price": price,
        "displayPrice": displayPrice,
        "rating": rating,
        "ratingCount": ratingCount,
        "description": description,
        "foodTags":
            foodTags == null ? [] : List<dynamic>.from(foodTags!.map((x) => x)),
        "foodType":
            foodType == null ? [] : List<dynamic>.from(foodType!.map((x) => x)),
        "category": category,
        "code": code,
        "restaurant": restaurant?.toJson(),
        "time": time,
        "calories": calories,
        "isAvailable": isAvailable,
        // Pricing fields
        "pricingType": pricingType.name,
        "priceVariants": priceVariants?.map((x) => x.toJson()).toList(),
        "sizeOptions": sizeOptions,
        "weightUnit": weightUnit,
        "maxScoops": maxScoops,
        "pricePerScoop": pricePerScoop,
        "minQuantity": minQuantity,
        "maxQuantity": maxQuantity,
        // Ingredients
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        // Additional options
        "additives": additives == null
            ? []
            : List<dynamic>.from(additives!.map((x) => x.toJson())),
        "customizations": customizations?.map((x) => x.toJson()).toList(),
        // Spice level
        "spiceLevel": spiceLevel,
        "spiceLevelOptions": spiceLevelOptions,
        "spiceLevelVariants":
            spiceLevelVariants?.map((x) => x.toJson()).toList(),
        // Sugar level
        "sugarLevel": sugarLevel,
        "sugarLevelOptions": sugarLevelOptions,
        "sugarLevelVariants":
            sugarLevelVariants?.map((x) => x.toJson()).toList(),
        // Legacy fields
        "sizes": sizes == null
            ? []
            : List<dynamic>.from(sizes!.map((x) => x.toJson())),
        "sauces": sauces == null
            ? []
            : List<dynamic>.from(sauces!.map((x) => x.toJson())),
        "drinks": drinks == null
            ? []
            : List<dynamic>.from(drinks!.map((x) => x.toJson())),
        "desserts": desserts == null
            ? []
            : List<dynamic>.from(desserts!.map((x) => x.toJson())),
      };

  /// Get effective price to display (from displayPrice or calculated)
  double get effectivePrice {
    if (displayPrice != null) return displayPrice!;
    if (pricingType == PricingType.simple) return price ?? 0.0;
    if (priceVariants != null && priceVariants!.isNotEmpty) {
      final defaultVariant = priceVariants!.where((v) => v.isDefault).firstOrNull;
      if (defaultVariant != null) return defaultVariant.price ?? 0.0;
      return priceVariants!.map((v) => v.price ?? 0.0).reduce((a, b) => a < b ? a : b);
    }
    if (pricingType == PricingType.scoop && pricePerScoop != null) {
      return pricePerScoop!;
    }
    return price ?? 0.0;
  }

  /// Get default variant index
  int get defaultVariantIndex {
    if (priceVariants == null || priceVariants!.isEmpty) return 0;
    final index = priceVariants!.indexWhere((v) => v.isDefault);
    return index >= 0 ? index : 0;
  }

  /// Check if this food has variant-based pricing
  bool get hasVariantPricing =>
      pricingType != PricingType.simple &&
      priceVariants != null &&
      priceVariants!.isNotEmpty;

  /// Get pricing label based on type
  String get pricingLabel {
    switch (pricingType) {
      case PricingType.size:
        return 'Choose Size';
      case PricingType.weight:
        return 'Choose Weight${weightUnit != null ? ' ($weightUnit)' : ''}';
      case PricingType.scoop:
        return 'Choose Scoops';
      case PricingType.custom:
        return 'Choose Option';
      case PricingType.simple:
        return '';
    }
  }

  /// Check if this food has spice level options (hide if only "none")
  bool get hasSpiceLevelOptions {
    if (spiceLevelVariants != null && spiceLevelVariants!.isNotEmpty) {
      // Hide if the only variant is "none"
      if (spiceLevelVariants!.length == 1 &&
          spiceLevelVariants!.first.level?.toLowerCase() == 'none') {
        return false;
      }
      return true;
    }
    if (spiceLevelOptions != null && spiceLevelOptions!.isNotEmpty) {
      // Hide if the only option is "none"
      if (spiceLevelOptions!.length == 1 &&
          spiceLevelOptions!.first.toLowerCase() == 'none') {
        return false;
      }
      return true;
    }
    return false;
  }

  /// Check if this food has sugar level options (hide if only "none")
  bool get hasSugarLevelOptions {
    if (sugarLevelVariants != null && sugarLevelVariants!.isNotEmpty) {
      // Hide if the only variant is "none"
      if (sugarLevelVariants!.length == 1 &&
          sugarLevelVariants!.first.level?.toLowerCase() == 'none') {
        return false;
      }
      return true;
    }
    if (sugarLevelOptions != null && sugarLevelOptions!.isNotEmpty) {
      // Hide if the only option is "none"
      if (sugarLevelOptions!.length == 1 &&
          sugarLevelOptions!.first.toLowerCase() == 'none') {
        return false;
      }
      return true;
    }
    return false;
  }

  /// Get default spice level index
  int get defaultSpiceLevelIndex {
    if (spiceLevelVariants != null && spiceLevelVariants!.isNotEmpty) {
      final index = spiceLevelVariants!.indexWhere((v) => v.isDefault);
      if (index >= 0) return index;
      // Fall back to matching spiceLevel
      if (spiceLevel != null) {
        final match =
            spiceLevelVariants!.indexWhere((v) => v.level == spiceLevel);
        if (match >= 0) return match;
      }
    }
    if (spiceLevelOptions != null && spiceLevelOptions!.isNotEmpty) {
      if (spiceLevel != null) {
        final match = spiceLevelOptions!.indexOf(spiceLevel!);
        if (match >= 0) return match;
      }
    }
    return 0;
  }

  /// Get default sugar level index
  int get defaultSugarLevelIndex {
    if (sugarLevelVariants != null && sugarLevelVariants!.isNotEmpty) {
      final index = sugarLevelVariants!.indexWhere((v) => v.isDefault);
      if (index >= 0) return index;
      if (sugarLevel != null) {
        final match =
            sugarLevelVariants!.indexWhere((v) => v.level == sugarLevel);
        if (match >= 0) return match;
      }
    }
    if (sugarLevelOptions != null && sugarLevelOptions!.isNotEmpty) {
      if (sugarLevel != null) {
        final match = sugarLevelOptions!.indexOf(sugarLevel!);
        if (match >= 0) return match;
      }
    }
    return 0;
  }

  // Default sizes if not provided by API
  static List<FoodSize> get defaultSizes => [
        FoodSize(id: '1', name: 'Small', weight: '150g', price: 0.0),
        FoodSize(id: '2', name: 'Medium', weight: '250g', price: 2.0),
        FoodSize(id: '3', name: 'Large', weight: '350g', price: 4.0),
        FoodSize(id: '4', name: 'Family', weight: '500g', price: 8.0),
      ];

  // Default additives if not provided by API
  static List<FoodAdditive> get defaultAdditives => [
        FoodAdditive(id: '1', title: 'Extra Cheese', price: 1.50),
        FoodAdditive(id: '2', title: 'Bacon', price: 2.00),
        FoodAdditive(id: '3', title: 'Jalapeños', price: 0.75),
        FoodAdditive(id: '4', title: 'Mushrooms', price: 1.25),
        FoodAdditive(id: '5', title: 'Onion Rings', price: 1.75),
      ];

  // Default sauces if not provided by API
  static List<FoodSauce> get defaultSauces => [
        FoodSauce(id: '1', name: 'Ketchup', price: 0.0),
        FoodSauce(id: '2', name: 'Mayonnaise', price: 0.0),
        FoodSauce(id: '3', name: 'BBQ Sauce', price: 0.50),
        FoodSauce(id: '4', name: 'Hot Sauce', price: 0.50),
        FoodSauce(id: '5', name: 'Ranch', price: 0.75),
        FoodSauce(id: '6', name: 'Garlic Aioli', price: 0.75),
      ];
}

class FoodSize {
  final String? id;
  final String? name;
  final String? weight;
  final double? price;

  FoodSize({this.id, this.name, this.weight, this.price});

  factory FoodSize.fromJson(Map<String, dynamic> json) => FoodSize(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        weight: json["weight"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "weight": weight,
        "price": price,
      };
}

/// Food ingredient with optional image
class FoodIngredient {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? quantity;
  final bool isAllergen;

  FoodIngredient({
    this.id,
    this.name,
    this.imageUrl,
    this.quantity,
    this.isAllergen = false,
  });

  factory FoodIngredient.fromJson(Map<String, dynamic> json) => FoodIngredient(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        imageUrl: json["imageUrl"]?.toString(),
        quantity: json["quantity"]?.toString(),
        isAllergen: json["isAllergen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "imageUrl": imageUrl,
        "quantity": quantity,
        "isAllergen": isAllergen,
      };
}

class FoodAdditive {
  final String? id;
  final String? title;
  final double? price;
  final String? imageUrl;

  FoodAdditive({this.id, this.title, this.price, this.imageUrl});

  factory FoodAdditive.fromJson(Map<String, dynamic> json) => FoodAdditive(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        title: json["title"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        imageUrl: json["imageUrl"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "price": price,
        "imageUrl": imageUrl,
      };
}

class FoodSauce {
  final String? id;
  final String? name;
  final double? price;

  FoodSauce({this.id, this.name, this.price});

  factory FoodSauce.fromJson(Map<String, dynamic> json) => FoodSauce(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
      };
}

class DrinkItem {
  final String? id;
  final String? name;
  final double? price;
  final List<String>? sizes;

  DrinkItem({this.id, this.name, this.price, this.sizes});

  factory DrinkItem.fromJson(Map<String, dynamic> json) => DrinkItem(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        sizes: json["sizes"] == null
            ? []
            : List<String>.from(json["sizes"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
      };
}

class DessertItem {
  final String? id;
  final String? name;
  final double? price;

  DessertItem({this.id, this.name, this.price});

  factory DessertItem.fromJson(Map<String, dynamic> json) => DessertItem(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
      };
}
