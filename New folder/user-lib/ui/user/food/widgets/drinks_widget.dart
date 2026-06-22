import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

class DrinksSelector extends StatelessWidget {
  final List<DrinkItem> drinks;
  final int? selectedIndex;

  const DrinksSelector({
    super.key,
    required this.drinks,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.drinks,
    );

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(drinks.length, (index) {
        final drink = drinks[index];
        final isSelected = selectedIndex == index;
        void onTap() {
          context.read<FoodDetailsBloc>().add(SelectDrinkEvent(index));
        }

        if (cardStyle == CardStyleType.style3) {
          return SelectableOptionChip(
            title: drink.name ?? '',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        if (cardStyle == CardStyleType.style2) {
          return SelectableOptionCard2(
            title: drink.name ?? '',
            price: drink.price ?? 0,
            prefix: '+',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        return SelectableOptionCard(
          title: drink.name ?? '',
          price: drink.price ?? 0,
          prefix: '+',
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }
}
