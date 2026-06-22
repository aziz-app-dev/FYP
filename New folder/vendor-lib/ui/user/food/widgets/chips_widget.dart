import 'package:food/config/widgets/price_widget.dart';

import 'widgets.dart';

Widget infoChipWidget(String label, {IconData? icon}) {
  return Builder(
    builder: (context) {
      final colors = context.colors;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.spMin, vertical: 4.spMin),
        decoration: BoxDecoration(
          color: colors.chipBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: 12.spMin, color: colors.iconSecondary),
            SizedBox(width: 4.spMin),
            Text(
              label,
              style: TextStyle(fontSize: 12.spMin, color: colors.textSecondary),
            ),
          ],
        ),
      );
    },
  );
}

Widget tagsWidget(List<String> foodTags) {
  return Builder(
    builder: (context) {
      final colors = context.colors;
      return Wrap(
        spacing: 6.spMin,
        runSpacing: 6.spMin,
        children: foodTags
            .map(
              (tag) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.spMin,
                  vertical: 4.spMin,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget tagsWidget2(List<String> foodTags) {
  return Builder(
    builder: (context) {
      final colors = context.colors;
      return Wrap(
        spacing: 6.spMin,
        runSpacing: 6.spMin,
        children: foodTags
            .map(
              (tag) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.spMin,
                  vertical: 4.spMin,
                ),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

class SelectableOptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final double? price;
  final String? prefix;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionCard({
    super.key,
    required this.title,
    this.description,
    this.price,
    this.prefix,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = isSelected ? colors.primary : colors.border;

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.only(left: 6.spMin),
          padding: EdgeInsets.symmetric(
            horizontal: 12.spMin,
            vertical: 10.spMin,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.05)
                : colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Stack(
            children: [
              /// Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(3.spMin),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? null
                            : Border.all(color: colors.border, width: 1.5),
                      ),
                      child: Icon(
                        isSelected ? Icons.check : Icons.circle_outlined,
                        size: 12.spMin,
                        color: isSelected ? colors.surface : Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.spMin),
                  Padding(
                    padding: EdgeInsets.only(right: 16.spMin),
                    child: Column(
                      spacing: 4.spMin,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 4.spMin,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14.spMin,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            description == null
                                ? const SizedBox.shrink()
                                : Text(
                                    "($description)",
                                    style: TextStyle(
                                      fontSize: 11.spMin,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                          ],
                        ),

                        if (subtitle != null)
                          Text(
                            subtitle ?? "",
                            style: TextStyle(
                              fontSize: 11.spMin,
                              color: colors.textSecondary,
                            ),
                          ),
                        if (price != null && price! > 0)
                          PriceText(
                            price: price!,
                            prefix: prefix ?? '',
                            fontSize: 13.spMin,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableOptionCard2 extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? prefix;
  final double price;
  final bool isSelected;

  final VoidCallback onTap;

  const SelectableOptionCard2({
    super.key,
    required this.title,
    this.description,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 8.spMin),
        decoration: BoxDecoration(
          gradient: isSelected ? colors.gradient9 : null,
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: isSelected ? null : Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.textOnPrimary : colors.textPrimary,
                fontSize: 13.spMin,
              ),
            ),
            SizedBox(width: 10.spMin),
            PriceText(
              price: price,
              prefix: prefix ?? "+",
              fontSize: 13.spMin,
              color: isSelected ? AppColors.white : colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableOptionChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 8.spMin),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          spacing: 15.spMin,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 20.spMin,
              height: 20.spMin,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 14.spMin,
                fontWeight: FontWeight.w500,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Style 4: Image Row Card - horizontal with image/check + title + price
class SelectableOptionCard4 extends StatelessWidget {
  final String title;
  final String? description;
  final double? price;
  final String? prefix;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionCard4({
    super.key,
    required this.title,
    this.description,
    this.price,
    this.prefix,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(10.spMin),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.06)
              : colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Image or check circle
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 48.spMin,
                  height: 48.spMin,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 48.spMin,
                    height: 48.spMin,
                    color: colors.shimmerBase,
                  ),
                  errorWidget: (_, _, _) => _buildCheck(colors),
                ),
              )
            else
              _buildCheck(colors),
            SizedBox(width: 12.spMin),
            // Title + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 11.spMin,
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Price
            if (price != null && price! > 0)
              PriceText(
                price: price!,
                prefix: prefix ?? '+',
                fontSize: 13.spMin,
                color: colors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheck(ThemeColors colors) {
    return AnimatedContainer(
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
    );
  }
}

/// Style 5: Grid Image Card - vertical with image on top, title + price below
class SelectableOptionCard5 extends StatelessWidget {
  final String title;
  final double? price;
  final String? prefix;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionCard5({
    super.key,
    required this.title,
    this.price,
    this.prefix,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110.spMin,
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.06)
              : colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusMd - 1),
              ),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: double.infinity,
                      height: 80.spMin,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        height: 80.spMin,
                        color: colors.shimmerBase,
                        child: Icon(
                          Icons.image_outlined,
                          size: 24.spMin,
                          color: colors.iconSecondary,
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        height: 80.spMin,
                        color: colors.surfaceVariant,
                        child: Icon(
                          Icons.image_outlined,
                          size: 24.spMin,
                          color: colors.iconSecondary,
                        ),
                      ),
                    )
                  : Container(
                      height: 80.spMin,
                      color: colors.surfaceVariant,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 28.spMin,
                          color: colors.iconSecondary,
                        ),
                      ),
                    ),
            ),
            // Title + price
            Padding(
              padding: EdgeInsets.all(8.spMin),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? colors.primary : colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null && price! > 0) ...[
                    SizedBox(height: 2.spMin),
                    PriceText(
                      price: price!,
                      prefix: prefix ?? '+',
                      fontSize: 11.spMin,
                      color: colors.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Style 6: Outlined Tag - minimal pill, filled primary on select
class SelectableOptionTag extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionTag({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 16.spMin,
          vertical: 8.spMin,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.spMin,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
