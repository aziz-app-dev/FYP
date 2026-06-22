class FoodDetailsConfig {
  final String pageLayout;
  final List<String> sectionOrder;
  final Map<String, bool> sectionVisibility;
  final Map<String, String> sectionCardStyles;
  final Map<String, String> sectionTitleStyles;
  final String restaurantInfoStyle;
  final String foodInfoStyle;
  final String ingredientsStyle;
  final double sectionSpacing;
  final double cardBorderRadius;
  final double cardBorderWidth;
  final String? cardBorderColor;
  final String? selectedCardBorderColor;
  final String? selectedCardFillColor;

  const FoodDetailsConfig({
    this.pageLayout = 'page1',
    this.sectionOrder = _defaultSectionOrder,
    this.sectionVisibility = const {},
    this.sectionCardStyles = const {},
    this.sectionTitleStyles = const {},
    this.restaurantInfoStyle = 'style1',
    this.foodInfoStyle = 'style1',
    this.ingredientsStyle = 'style1',
    this.sectionSpacing = 25,
    this.cardBorderRadius = 10,
    this.cardBorderWidth = 1.5,
    this.cardBorderColor,
    this.selectedCardBorderColor,
    this.selectedCardFillColor,
  });

  static const List<String> _defaultSectionOrder = [
    'heroImage', 'foodTags', 'availability', 'title', 'description',
    'foodInfo', 'restaurantInfo', 'ingredients', 'priceVariants', 'sizes',
    'customizations', 'spiceLevel', 'sugarLevel', 'extras', 'sauces',
    'drinks', 'desserts',
  ];

  static const List<String> allSections = _defaultSectionOrder;

  factory FoodDetailsConfig.defaults() => const FoodDetailsConfig();

  factory FoodDetailsConfig.fromJson(Map<String, dynamic> json) {
    return FoodDetailsConfig(
      pageLayout: json['pageLayout'] as String? ?? 'page1',
      sectionOrder: json['sectionOrder'] != null
          ? List<String>.from(json['sectionOrder'])
          : _defaultSectionOrder,
      sectionVisibility: json['sectionVisibility'] != null
          ? Map<String, bool>.from(json['sectionVisibility'])
          : const {},
      sectionCardStyles: json['sectionCardStyles'] != null
          ? Map<String, String>.from(json['sectionCardStyles'])
          : const {},
      sectionTitleStyles: json['sectionTitleStyles'] != null
          ? Map<String, String>.from(json['sectionTitleStyles'])
          : const {},
      restaurantInfoStyle: json['restaurantInfoStyle'] as String? ?? 'style1',
      foodInfoStyle: json['foodInfoStyle'] as String? ?? 'style1',
      ingredientsStyle: json['ingredientsStyle'] as String? ?? 'style1',
      sectionSpacing: (json['sectionSpacing'] as num?)?.toDouble() ?? 25,
      cardBorderRadius: (json['cardBorderRadius'] as num?)?.toDouble() ?? 10,
      cardBorderWidth: (json['cardBorderWidth'] as num?)?.toDouble() ?? 1.5,
      cardBorderColor: json['cardBorderColor'] as String?,
      selectedCardBorderColor: json['selectedCardBorderColor'] as String?,
      selectedCardFillColor: json['selectedCardFillColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'pageLayout': pageLayout,
    'sectionOrder': sectionOrder,
    'sectionVisibility': sectionVisibility,
    'sectionCardStyles': sectionCardStyles,
    'sectionTitleStyles': sectionTitleStyles,
    'restaurantInfoStyle': restaurantInfoStyle,
    'foodInfoStyle': foodInfoStyle,
    'ingredientsStyle': ingredientsStyle,
    'sectionSpacing': sectionSpacing,
    'cardBorderRadius': cardBorderRadius,
    'cardBorderWidth': cardBorderWidth,
    'cardBorderColor': cardBorderColor,
    'selectedCardBorderColor': selectedCardBorderColor,
    'selectedCardFillColor': selectedCardFillColor,
  };

  bool isSectionVisible(String section) {
    return sectionVisibility[section] ?? true;
  }

  String getCardStyle(String section) {
    return sectionCardStyles[section] ?? 'style1';
  }

  String getTitleStyle(String section) {
    return sectionTitleStyles[section] ?? 'title1';
  }

  FoodDetailsConfig copyWith({
    String? pageLayout,
    List<String>? sectionOrder,
    Map<String, bool>? sectionVisibility,
    Map<String, String>? sectionCardStyles,
    Map<String, String>? sectionTitleStyles,
    String? restaurantInfoStyle,
    String? foodInfoStyle,
    String? ingredientsStyle,
    double? sectionSpacing,
    double? cardBorderRadius,
    double? cardBorderWidth,
    String? cardBorderColor,
    String? selectedCardBorderColor,
    String? selectedCardFillColor,
  }) {
    return FoodDetailsConfig(
      pageLayout: pageLayout ?? this.pageLayout,
      sectionOrder: sectionOrder ?? this.sectionOrder,
      sectionVisibility: sectionVisibility ?? this.sectionVisibility,
      sectionCardStyles: sectionCardStyles ?? this.sectionCardStyles,
      sectionTitleStyles: sectionTitleStyles ?? this.sectionTitleStyles,
      restaurantInfoStyle: restaurantInfoStyle ?? this.restaurantInfoStyle,
      foodInfoStyle: foodInfoStyle ?? this.foodInfoStyle,
      ingredientsStyle: ingredientsStyle ?? this.ingredientsStyle,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      cardBorderWidth: cardBorderWidth ?? this.cardBorderWidth,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      selectedCardBorderColor: selectedCardBorderColor ?? this.selectedCardBorderColor,
      selectedCardFillColor: selectedCardFillColor ?? this.selectedCardFillColor,
    );
  }
}
