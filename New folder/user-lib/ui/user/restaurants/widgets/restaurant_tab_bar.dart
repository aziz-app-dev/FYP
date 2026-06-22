import 'widgets.dart';

class RestaurantTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  RestaurantTabBarDelegate({
    required this.tabBar,
    required this.backgroundColor,
  });

  @override
  double get minExtent => tabBar.preferredSize.height + 8.spMin;

  @override
  double get maxExtent => tabBar.preferredSize.height + 8.spMin;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = context.colors;
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.spMin, vertical: 8.spMin),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: colors.border),
        ),
        child: tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant RestaurantTabBarDelegate oldDelegate) => false;
}

/// Builds a styled TabBar for the restaurant details page.
TabBar buildRestaurantTabBar({
  required TabController controller,
  required List<Widget> tabs,
  required ThemeColors colors,
}) {
  return TabBar(
    controller: controller,
    dividerColor: Colors.transparent,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      color: colors.primary,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
    ),
    labelColor: colors.textOnPrimary,
    unselectedLabelColor: colors.textSecondary,
    labelStyle: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
    unselectedLabelStyle: AppTextStyles.bodyMedium,
    padding: EdgeInsets.all(4.spMin),
    tabs: tabs,
  );
}
