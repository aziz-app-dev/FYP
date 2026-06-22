import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/rating/rating_bloc.dart';
import '../../../../bloc/user/rating/rating_state.dart';
import '../../../../config/config.dart';

Widget buildTabBar(ThemeColors colors, TabController? controller) {
  final List<_TabItem> tabs = const [
    _TabItem(title: 'Food', icon: Icons.fastfood_rounded),
    _TabItem(title: 'Restaurants', icon: Icons.restaurant_rounded),
    _TabItem(title: 'Drivers', icon: Icons.delivery_dining_rounded),
  ];
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12.spMin),
    decoration: BoxDecoration(
      color: colors.cardBackground,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      border: Border.all(color: colors.border),
    ),
    child: TabBar(
      controller: controller,
      indicator: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm - 3),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelColor: Colors.white,

      unselectedLabelColor: colors.textSecondary,
      labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: AppTextStyles.bodySmall,
      padding: EdgeInsets.all(6.spMin),
      tabs: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        // final count = state.getTabCount(index);
        return Tab(
          height: 35.spMin,

          iconMargin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon, size: 18.spMin),
              SizedBox(width: 8.spMin),
              Flexible(
                child: BlocBuilder<RatingBloc, RatingState>(
                  builder: (context, state) {
                    final count = state.getTabCount(index);
                    return Text(
                      '${tab.title}${count > 0 ? ' ($count)' : ''}',
                      style: AppTextStyles.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

class _TabItem {
  final String title;
  final IconData icon;

  const _TabItem({required this.title, required this.icon});
}
