import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

class PriceVariantSelector extends StatelessWidget {
  final List<PriceVariant> variants;
  final int selectedIndex;
  final PricingType pricingType;
  final String? weightUnit;

  const PriceVariantSelector({
    super.key,
    required this.variants,
    required this.selectedIndex,
    required this.pricingType,
    this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.priceVariants,
    );

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(variants.length, (index) {
        final variant = variants[index];
        final isSelected = selectedIndex == index;
        void onTap() {
          context.read<FoodDetailsBloc>().add(SelectVariantEvent(index));
        }

        if (cardStyle == CardStyleType.style3) {
          return SelectableOptionChip(
            title: variant.name ?? '',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        if (cardStyle == CardStyleType.style2) {
          return SelectableOptionCard2(
            title: variant.name ?? '',
            price: variant.price ?? 0,
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        return SelectableOptionCard(
          title: variant.name ?? '',
          description: variant.description,
          price: variant.price ?? 0,
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }
}
