import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

class SaucesChips extends StatelessWidget {
  final List<FoodSauce> sauces;
  final Set<int> selectedIndices;

  const SaucesChips({
    super.key,
    required this.sauces,
    required this.selectedIndices,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.sauces,
    );

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(sauces.length, (index) {
        final sauce = sauces[index];
        final isSelected = selectedIndices.contains(index);
        void onTap() {
          context.read<FoodDetailsBloc>().add(ToggleSauceEvent(index));
        }

        if (cardStyle == CardStyleType.style3) {
          return SelectableOptionChip(
            title: sauce.name ?? '',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        if (cardStyle == CardStyleType.style1) {
          return SelectableOptionCard(
            title: sauce.name ?? '',
            price: sauce.price ?? 0,
            prefix: '+',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        return SelectableOptionCard2(
          title: sauce.name ?? "",
          price: sauce.price ?? 0,
          prefix: '+',
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }
}
