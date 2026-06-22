import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../ui/user/home/widgets/section_title.dart';

import '../../../../config/config.dart';
import '../../../../routes/route_name.dart';
import '../../../../utils/loaders_utils.dart';
import '../../../../model/settings/common_config.dart';

class CategoriesSection extends StatelessWidget {
  final List<Map<String, Object>> categories;
  final bool isbgBlack;
  final CategoryStyle? styleConfig;

  CategoriesSection({
    super.key,
    required this.categories,
    this.isbgBlack = false,
    this.styleConfig,
  });

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final config =
        styleConfig ??
        CategoryStyle(style: 'style1', layout: 'horizontal', columns: 2);
    final isVertical = config.layout == 'vertical';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          "Categories",
          context: context,
          onTap: () => Navigator.pushNamed(context, RouteName.categories),
        ),
        SizedBox(height: 10.h),
        if (isVertical)
          _buildGridView(config)
        else
          _buildHorizontalList(config),
      ],
    );
  }

  Widget _buildHorizontalList(CategoryStyle config) {
    return SizedBox(
      height: _getSectionHeight(config),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) => _buildCategoryItem(context, index, config),
      ),
    );
  }

  Widget _buildGridView(CategoryStyle config) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.columns ?? 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: _getSectionHeight(config),
      ),
      itemBuilder: (context, index) => _buildCategoryItem(context, index, config),
    );
  }

  double _getSectionHeight(CategoryStyle config) {
    switch (config.style) {
      case 'style2':
        return 45.h;
      case 'style3':
        return 120.h;
      default:
        return 100.h;
    }
  }

  Widget _buildCategoryItem(BuildContext context, int index, CategoryStyle config) {
    final category = categories[index];
    final colors = context.colors;

    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, selectedIndex, _) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            _selectedIndex.value = index;
            Navigator.pushNamed(
              context,
              RouteName.categoryFoods,
              arguments: {
                'categoryId': category['id'],
                'categoryName': category['label'],
              },
            );
          },
          child: _renderStyle(category, isSelected, config, colors),
        );
      },
    );
  }

  Widget _renderStyle(
    Map<String, Object> category,
    bool isSelected,
    CategoryStyle config,
    ThemeColors colors,
  ) {
    switch (config.style) {
      case 'style2':
        return _buildStyle2(category, isSelected, colors);
      case 'style3':
        return _buildStyle3(category, isSelected, colors);
      default:
        return _buildStyle1(category, isSelected, colors);
    }
  }

  // Style 1: Round icon with label below
  Widget _buildStyle1(
    Map<String, Object> category,
    bool isSelected,
    ThemeColors colors,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 60.h,
          width: 60.h,
          padding: EdgeInsets.all(isSelected ? 4.spMin : 2.spMin),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colors.primary : colors.card,
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.border.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category["image"].toString(),
                fit: BoxFit.cover,
                placeholder: (_, _) => appLoader(size: 20),
                errorWidget: (_, _, _) => Icon(
                  Icons.fastfood,
                  color: isSelected ? Colors.white : colors.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          category['label'] as String,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? colors.primary : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Style 2: Pill shape with icon + label side-by-side
  Widget _buildStyle2(
    Map<String, Object> category,
    bool isSelected,
    ThemeColors colors,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.card,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: isSelected
              ? colors.primary
              : colors.border.withValues(alpha: 0.5),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: SizedBox(
              height: 20.h,
              width: 20.h,
              child: CachedNetworkImage(
                imageUrl: category["image"].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            category['label'] as String,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? Colors.white : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Style 3: Square modern card with glassmorphism preview
  Widget _buildStyle3(
    Map<String, Object> category,
    bool isSelected,
    ThemeColors colors,
  ) {
    return Container(
      width: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: category["image"].toString(),
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 8.h,
              left: 8.w,
              right: 8.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category['label'] as String,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      height: 2.h,
                      width: 20.w,
                      color: colors.primary,
                    ),
                ],
              ),
            ),
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Icon(
                  Icons.check_circle,
                  color: colors.primary,
                  size: 18.spMin,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
