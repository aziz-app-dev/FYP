import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

class DessertsSelector extends StatelessWidget {
  final List<DessertItem> desserts;
  final Set<int> selectedIndices;

  const DessertsSelector({
    super.key,
    required this.desserts,
    required this.selectedIndices,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.desserts,
    );

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(desserts.length, (index) {
        final dessert = desserts[index];
        final isSelected = selectedIndices.contains(index);
        void onTap() {
          context.read<FoodDetailsBloc>().add(ToggleDessertEvent(index));
        }

        if (cardStyle == CardStyleType.style3) {
          return SelectableOptionChip(
            title: dessert.name ?? '',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        if (cardStyle == CardStyleType.style2) {
          return SelectableOptionCard2(
            title: dessert.name ?? '',
            price: dessert.price ?? 0,
            prefix: '+',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        return SelectableOptionCard(
          title: dessert.name ?? '',
          price: dessert.price ?? 0,
          prefix: '+',
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }
}
