import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/bloc/user/order/order_bloc.dart';
import 'package:food/ui/user/orders/widgets/order_history_list.dart';

import '../../../../bloc/user/order/order_state.dart';
import '../../../../config/config.dart';
import 'activer_order_list.dart';

Widget buildWithActiveOrders(ThemeColors colors, TabController? controller) {
  return Column(
    children: [
      // Header with tabs
      Container(
        padding: EdgeInsets.fromLTRB(20.spMin, 16.h, 20.spMin, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: AppTextStyles.headlineMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            // Tab bar
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: controller,
                indicator: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: colors.textOnPrimary,
                unselectedLabelColor: colors.textSecondary,
                labelStyle: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.all(4.w),
                tabs: [
                  Tab(
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_rounded, size: 18.spMin),
                            SizedBox(width: 8.w),
                            const Text('Active'),
                            if (state.activeOrders.isNotEmpty) ...[
                              SizedBox(width: 4.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.textOnPrimary.withValues(
                                    alpha: .2,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  '${state.activeOrders.length}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 18.spMin),
                        SizedBox(width: 8.w),
                        const Text('History'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      // Tab content
      Expanded(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return TabBarView(
              controller: controller,
              children: [
                // Active orders tab
                buildActiveOrdersList(colors, state, context),
                // History tab
                orderHistoryList(colors, state, context),
              ],
            );
          },
        ),
      ),
    ],
  );
}
