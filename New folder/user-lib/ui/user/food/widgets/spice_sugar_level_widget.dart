import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

/// Generic level selector for spice/sugar - supports both simple options and priced variants
class SpiceLevelSelector extends StatelessWidget {
  final List<String> options;
  final List<dynamic> variants;
  final int selectedIndex;
  final FoodDetailSection section;
  final void Function(int index) onSelect;

  const SpiceLevelSelector({
    super.key,
    required this.options,
    required this.variants,
    required this.selectedIndex,
    this.section = FoodDetailSection.spiceLevel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final hasVariants = variants.isNotEmpty;
    final itemCount = hasVariants ? variants.length : options.length;
    SessionManager().cardStyleSettings.getStyle(section);

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: List.generate(itemCount, (index) {
        final isSelected = selectedIndex == index;
        final rawLevel = hasVariants
            ? (variants[index].level ?? '')
            : options[index];
        final label = _formatLevel(rawLevel);
        void onTap() => onSelect(index);

        return SelectableOptionChip(
          title: label,
          isSelected: isSelected,
          onTap: onTap,
        );
      }),
    );
  }

  String _formatLevel(String level) {
    if (level.isEmpty) return level;
    return level
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
