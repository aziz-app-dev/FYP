import 'package:flutter/services.dart';

import '../../../../config/widgets/price_widget.dart';
import 'widgets.dart';

class Extras extends StatelessWidget {
  final List<FoodAdditive> additives;
  final Set<int> selectedIndices;

  const Extras({
    super.key,
    required this.additives,
    required this.selectedIndices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(additives.length, (index) {
        final additive = additives[index];
        final isSelected = selectedIndices.contains(index);

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.read<FoodDetailsBloc>().add(ToggleAdditiveEvent(index));
          },
          child: _AdditiveRowCard(additive: additive, isSelected: isSelected),
        );
      }),
    );
  }
}

class ExtrasGrid extends StatelessWidget {
  final List<FoodAdditive> additives;
  final Set<int> selectedIndices;

  const ExtrasGrid({
    super.key,
    required this.additives,
    required this.selectedIndices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(additives.length, (index) {
        final additive = additives[index];
        final isSelected = selectedIndices.contains(index);

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.read<FoodDetailsBloc>().add(ToggleAdditiveEvent(index));
          },
          child: _AdditiveRowCard(additive: additive, isSelected: isSelected),
        );
      }),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                             ADDITIVE ROW CARD                               */
/* -------------------------------------------------------------------------- */

class _AdditiveRowCard extends StatelessWidget {
  final FoodAdditive additive;
  final bool isSelected;

  const _AdditiveRowCard({required this.additive, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.spMin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Check box + Title
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 24.spMin,
                height: 24.spMin,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.border,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 16.spMin)
                    : null,
              ),
              SizedBox(width: 10.spMin),
              Text(
                additive.title ?? '',
                style: TextStyle(
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          // Price
          PriceText(
            price: additive.price ?? 0,
            fontSize: 14.spMin,
            color: colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
