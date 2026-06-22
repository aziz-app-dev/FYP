import '../../../../model/settings/card_style_settings.dart';
import '../../../../model/settings/food_details_config.dart';
import 'widgets.dart';

class FoodDetailSectionBuilder extends StatelessWidget {
  final FoodDetailsState state;
  final FoodDetailsConfig config;

  const FoodDetailSectionBuilder({
    super.key,
    required this.state,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final food = state.foodDetails;
    if (food == null) return const SizedBox.shrink();

    final colors = context.colors;
    final spacing = SizedBox(height: config.sectionSpacing.spMin);

    final sections = <Widget>[];

    for (final sectionKey in config.sectionOrder) {
      if (!config.isSectionVisible(sectionKey)) continue;

      final widget = _buildSection(context, sectionKey, food, colors, spacing);
      if (widget != null) {
        sections.add(widget);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _sectionTitle(
    String title,
    String sectionKey, {
    bool isRequired = false,
  }) {
    final titleStyle = config.getTitleStyle(sectionKey);
    if (titleStyle == 'title2') {
      return SectionTitle2(title, isRequired: isRequired);
    }
    return SectionTitle1(title, isRequired: isRequired);
  }

  Widget? _buildSection(
    BuildContext context,
    String sectionKey,
    FoodDetails food,
    ThemeColors colors,
    Widget spacing,
  ) {
    switch (sectionKey) {
      case 'foodTags':
        if (state.foodTags.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tagsWidget(state.foodTags),
            SizedBox(height: 10.spMin),
          ],
        );

      case 'availability':
        if (food.isAvailable != false) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.spMin,
                vertical: 6.spMin,
              ),
              decoration: BoxDecoration(
                color: colors.errorLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Text(
                'Currently Unavailable',
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.spMin,
                ),
              ),
            ),
            SizedBox(height: 12.spMin),
          ],
        );

      case 'title':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    food.title ?? 'Food Item',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: colors.textPrimary,
                      fontSize: 20.spMin,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                QuantitySelectorWidget(
                  colors: colors,
                  isAtMinQuantity: state.quantity <= state.minQuantity,
                  quantity: state.quantity,
                  isAtMaxQuantity: state.quantity >= state.maxQuantity,
                ),
              ],
            ),
            SizedBox(height: 15.spMin),
          ],
        );

      case 'description':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.description ?? 'Delicious and freshly prepared',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            spacing,
          ],
        );

      case 'foodInfo':
        final style = config.foodInfoStyle;
        Widget infoWidget;
        if (style == 'style3') {
          infoWidget = FoodInfoRow3(food: food);
        } else if (style == 'style2') {
          infoWidget = FoodInfoRow2(food: food);
        } else {
          infoWidget = FoodInfoRow(food: food);
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.spMin),
              child: infoWidget,
            ),
          ],
        );

      case 'restaurantInfo':
        if (food.restaurant == null) return null;
        final style = config.restaurantInfoStyle;
        Widget card;
        if (style == 'style4') {
          card = RestaurantInfoCard4(restaurant: food.restaurant!);
        } else if (style == 'style3') {
          card = RestaurantInfoCard3(restaurant: food.restaurant!);
        } else if (style == 'style2') {
          card = RestaurantInfoCard2(restaurant: food.restaurant!);
        } else {
          card = RestaurantInfoCard(restaurant: food.restaurant!);
        }
        return Column(children: [spacing, card]);

      case 'ingredients':
        if (state.ingredients.isEmpty) return null;
        final style = config.ingredientsStyle;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Ingredients', sectionKey),
            style == 'style2'
                ? IngredientsSection2(ingredients: state.ingredients)
                : IngredientsSection(ingredients: state.ingredients),
          ],
        );

      case 'priceVariants':
        if (!state.hasVariantPricing || state.priceVariants.isEmpty) {
          return null;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle(food.pricingLabel, sectionKey),
            PriceVariantSelector(
              variants: state.priceVariants,
              selectedIndex: state.selectedVariantIndex,
              pricingType: state.pricingType,
              weightUnit: state.weightUnit,
            ),
          ],
        );

      case 'sizes':
        if (state.hasVariantPricing) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Choose Size', sectionKey),
            SizeSelector(
              sizes: state.sizes,
              selectedIndex: state.selectedSizeIndex,
              firstSizePrice: state.basePrice,
            ),
          ],
        );

      case 'customizations':
        if (state.customizations.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...state.customizations.asMap().entries.map((entry) {
              final groupIndex = entry.key;
              final group = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spacing,
                  _sectionTitle(
                    group.name ?? 'Options',
                    sectionKey,
                    isRequired: group.required,
                  ),
                  AppSizes.verticalSpaceXs,
                  CustomizationOptionsGrid(
                    groupIndex: groupIndex,
                    options: group.options,
                    selectedIndices:
                        state.selectedCustomizations[groupIndex] ?? {},
                    multiSelect: group.multiSelect,
                  ),
                ],
              );
            }),
          ],
        );

      case 'spiceLevel':
        if (!state.hasSpiceLevelOptions) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Spice Level', sectionKey),
            SpiceLevelSelector(
              options: state.spiceLevelOptions,
              variants: state.spiceLevelVariants,
              selectedIndex: state.selectedSpiceLevelIndex,
              onSelect: (i) =>
                  context.read<FoodDetailsBloc>().add(SelectSpiceLevelEvent(i)),
            ),
          ],
        );

      case 'sugarLevel':
        if (!state.hasSugarLevelOptions) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Sugar Level', sectionKey),
            SpiceLevelSelector(
              options: state.sugarLevelOptions,
              variants: state.sugarLevelVariants,
              selectedIndex: state.selectedSugarLevelIndex,
              section: FoodDetailSection.sugarLevel,
              onSelect: (i) =>
                  context.read<FoodDetailsBloc>().add(SelectSugarLevelEvent(i)),
            ),
          ],
        );

      case 'extras':
        if (state.additives.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Add Extras', sectionKey),
            ExtrasGrid(
              additives: state.additives,
              selectedIndices: state.selectedAdditives,
            ),
          ],
        );

      case 'sauces':
        if (state.sauces.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Sauces', sectionKey),
            SaucesChips(
              sauces: state.sauces,
              selectedIndices: state.selectedSauces,
            ),
          ],
        );

      case 'drinks':
        if (state.drinks.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Add a Drink', sectionKey),
            DrinksSelector(
              drinks: state.drinks,
              selectedIndex: state.selectedDrinkIndex,
            ),
          ],
        );

      case 'desserts':
        if (state.desserts.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing,
            _sectionTitle('Add Dessert', sectionKey),
            DessertsSelector(
              desserts: state.desserts,
              selectedIndices: state.selectedDesserts,
            ),
          ],
        );

      default:
        return null;
    }
  }
}
