// ignore_for_file: unused_local_variable
import '../../../../model/settings/card_style_settings.dart';
import 'widgets.dart';

class SizeSelector extends StatelessWidget {
  final List<FoodSize> sizes;
  final int selectedIndex;
  final double? firstSizePrice;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    this.firstSizePrice,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.size,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(sizes.length, (index) {
          final size = sizes[index];
          final isSelected = selectedIndex == index;
          void onTap() {
            context.read<FoodDetailsBloc>().add(SelectSizeEvent(index));
          }

          final priceValue = _getPriceValue(size, index);
          final pricePrefix = index == 0 ? '' : '+';

          if (cardStyle == CardStyleType.style3) {
            return Padding(
              padding: EdgeInsets.only(left: 6.spMin),
              child: SelectableOptionChip(
                title: size.name ?? '',
                isSelected: isSelected,
                onTap: onTap,
              ),
            );
          }

          if (cardStyle == CardStyleType.style2) {
            return Padding(
              padding: EdgeInsets.only(left: 6.spMin),
              child: SelectableOptionCard2(
                title: size.name ?? '',
                price: priceValue,
                prefix: pricePrefix,
                isSelected: isSelected,
                onTap: onTap,
              ),
            );
          }

          return SelectableOptionCard(
            title: size.name ?? '',
            description: size.weight ?? '',
            price: priceValue,
            prefix: pricePrefix,
            isSelected: isSelected,
            onTap: onTap,
          );
        }),
      ),
    );
  }

  double _getPriceValue(FoodSize size, int index) {
    if (index == 0 && firstSizePrice != null) {
      return firstSizePrice!;
    }
    return (size.price ?? 0).toDouble();
  }
}

class SizeSelector2 extends StatelessWidget {
  final List<FoodSize> sizes;
  final FoodDetails? food;
  final int selectedIndex;
  final double? firstSizePrice;

  const SizeSelector2({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    this.firstSizePrice,
    this.food,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = SessionManager().cardStyleSettings.getStyle(
      FoodDetailSection.size,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(sizes.length, (index) {
        final isSelected = selectedIndex == index;
        final chipSize = isSelected ? 90.r : 74.r;
        // Offset unselected circles down so ALL centers align at curveMidY
        final centerOffset = (90.r - chipSize) / 2;

        return GestureDetector(
          onTap: () =>
              context.read<FoodDetailsBloc>().add(SelectSizeEvent(index)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: centerOffset),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: chipSize,
                  height: chipSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white38,
                      width: isSelected ? 3.5.w : 1.5.w,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: food?.imageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(color: Colors.grey[850]),
                      errorWidget: (_, _, _) => Container(
                        color: Colors.grey[850],
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  sizes[index].name ?? '',
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.grey.shade600,
                    fontSize: 13.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: EdgeInsets.only(top: 3.h),
                    width: 30.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
