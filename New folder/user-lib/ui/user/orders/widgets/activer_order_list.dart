import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../bloc/user/order/order_bloc.dart';

import '../../../../bloc/user/order/order_event.dart';
import '../../../../bloc/user/order/order_state.dart';
import '../../../../config/config.dart';
import '../../../../config/widgets/order_Card.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

Widget buildActiveOrdersList(
  ThemeColors colors,
  OrderState state,
  BuildContext context,
) {
  final SessionManager sessionManager = SessionManager();

  return AppRefreshIndicator(
    pageIcon: AppIcons.refreshOrders,
    onRefresh: () async {
      context.read<OrderBloc>().add(const RefreshOrdersEvent());
      await Future.delayed(const Duration(milliseconds: 500));
    },
    child: AnimationLimiter(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.spMin, 0, 20.w, 100.h),
        itemCount: state.activeOrders.length,
        itemBuilder: (context, index) {
          final order = state.activeOrders[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ActiveOrderCard(
                  order: order,
                  currencySymbol: sessionManager.currencySymbol,
                  style: OrderCardStyle.bordered,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteName.orderTracking,
                    arguments: order,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
