import 'dart:convert';

/// Available card styles for food detail sections
enum CardStyleType {
  /// Detailed card with circle checkbox, title, subtitle, description, price
  style1,

  /// Compact chip with gradient fill, inline title + price + check
  style2,

  /// Pill chip with circle check + title
  style3,

  /// Image row card - horizontal with image/check + title + price
  style4,

  /// Grid image card - vertical with image on top, title + price below
  style5,

  /// Outlined tag - minimal pill with filled primary on select
  style6,
}

/// Sections in food details that support card style switching
enum FoodDetailSection {
  size,
  customizations,
  spiceLevel,
  sugarLevel,
  sauces,
  drinks,
  desserts,
  priceVariants,
  extras,
}

/// Settings model for card styles per food detail section
class CardStyleSettings {
  final Map<FoodDetailSection, CardStyleType> sectionStyles;

  const CardStyleSettings({required this.sectionStyles});

  /// Default settings - each section's current style
  factory CardStyleSettings.defaults() {
    return const CardStyleSettings(
      sectionStyles: {
        FoodDetailSection.size: CardStyleType.style1,
        FoodDetailSection.customizations: CardStyleType.style2,
        FoodDetailSection.spiceLevel: CardStyleType.style1,
        FoodDetailSection.sugarLevel: CardStyleType.style2,
        FoodDetailSection.sauces: CardStyleType.style2,
        FoodDetailSection.drinks: CardStyleType.style2,
        FoodDetailSection.desserts: CardStyleType.style2,
        FoodDetailSection.priceVariants: CardStyleType.style2,
        FoodDetailSection.extras: CardStyleType.style3,
      },
    );
  }

  CardStyleType getStyle(FoodDetailSection section) {
    return sectionStyles[section] ?? CardStyleType.style1;
  }

  CardStyleSettings copyWith({
    FoodDetailSection? section,
    CardStyleType? style,
  }) {
    if (section == null || style == null) return this;
    final newStyles = Map<FoodDetailSection, CardStyleType>.from(sectionStyles);
    newStyles[section] = style;
    return CardStyleSettings(sectionStyles: newStyles);
  }

  /// Serialize to JSON string for storage
  String toJsonString() {
    final map = <String, String>{};
    for (final entry in sectionStyles.entries) {
      map[entry.key.name] = entry.value.name;
    }
    return jsonEncode(map);
  }

  /// Deserialize from JSON string
  factory CardStyleSettings.fromJsonString(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final styles = <FoodDetailSection, CardStyleType>{};
      for (final entry in map.entries) {
        final section = FoodDetailSection.values.firstWhere(
          (s) => s.name == entry.key,
          orElse: () => FoodDetailSection.size,
        );
        final style = CardStyleType.values.firstWhere(
          (s) => s.name == entry.value,
          orElse: () => CardStyleType.style1,
        );
        styles[section] = style;
      }
      // Fill in any missing sections with defaults
      final defaults = CardStyleSettings.defaults();
      for (final section in FoodDetailSection.values) {
        styles.putIfAbsent(section, () => defaults.getStyle(section));
      }
      return CardStyleSettings(sectionStyles: styles);
    } catch (_) {
      return CardStyleSettings.defaults();
    }
  }

  /// Display name for a section
  static String sectionDisplayName(FoodDetailSection section) {
    switch (section) {
      case FoodDetailSection.size:
        return 'Choose Size';
      case FoodDetailSection.customizations:
        return 'Customizations';
      case FoodDetailSection.spiceLevel:
        return 'Spice Level';
      case FoodDetailSection.sugarLevel:
        return 'Sugar Level';
      case FoodDetailSection.sauces:
        return 'Sauces';
      case FoodDetailSection.drinks:
        return 'Drinks';
      case FoodDetailSection.desserts:
        return 'Desserts';
      case FoodDetailSection.priceVariants:
        return 'Price Variants';
      case FoodDetailSection.extras:
        return 'Extras';
    }
  }

  /// Display name for a card style
  static String styleDisplayName(CardStyleType style) {
    switch (style) {
      case CardStyleType.style1:
        return 'Detailed Card';
      case CardStyleType.style2:
        return 'Compact Chip';
      case CardStyleType.style3:
        return 'Pill Chip';
      case CardStyleType.style4:
        return 'Image Row';
      case CardStyleType.style5:
        return 'Grid Image';
      case CardStyleType.style6:
        return 'Outlined Tag';
    }
  }
}
