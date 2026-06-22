import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

/// Customization options grid
class CustomizationOptionsGrid extends StatelessWidget {
  final int groupIndex;
  final List<CustomizationOption> options;
  final Set<int> selectedIndices;
  final bool multiSelect;

  const CustomizationOptionsGrid({
    super.key,
    required this.groupIndex,
    required this.options,
    required this.selectedIndices,
    required this.multiSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.customizations,
    );

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(options.length, (index) {
        final option = options[index];
        final isSelected = selectedIndices.contains(index);
        void onTap() {
          context.read<FoodDetailsBloc>().add(
            ToggleCustomizationEvent(
              groupIndex: groupIndex,
              optionIndex: index,
            ),
          );
        }

        if (cardStyle == CardStyleType.style3) {
          return SelectableOptionChip(
            title: option.name ?? '',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        if (cardStyle == CardStyleType.style1) {
          return SelectableOptionCard(
            title: option.name ?? '',
            price: option.price,
            prefix: '+',
            isSelected: isSelected,
            onTap: onTap,
          );
        }

        return SelectableOptionCard2(
          title: option.name ?? '',
          price: option.price,
          prefix: '+',
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }
}
