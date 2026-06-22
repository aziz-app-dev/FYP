// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food/bloc/user/order/order_bloc.dart';

import '../../../../bloc/user/order/order_event.dart';
import '../../../../bloc/user/order/order_state.dart';
import '../../../../config/config.dart';
import '../../../../config/widgets/order_Card.dart';
import '../../../../model/order/order_model.dart';
import '../../../../services/session/session_manger.dart';
import '../../../../utils/loaders_utils.dart';
import '../../profile/widgets/order_empty_widget.dart';
import '../view/order_deatils_page.dart';

Widget orderHistoryList(
  ThemeColors colors,
  OrderState state,
  BuildContext context,
) {
  final SessionManager _sessionManager = SessionManager();
  if (state.orderHistory.isEmpty) {
    return orderEmptyWidget(colors);
  }

  return AppRefreshIndicator(
    pageIcon: AppIcons.refreshOrderHistory,
    onRefresh: () async {
      context.read<OrderBloc>().add(const LoadOrderHistoryEvent(refresh: true));
      await Future.delayed(const Duration(milliseconds: 500));
    },
    child: AnimationLimiter(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 100.h),
        itemCount:
            state.orderHistory.length + (state.canLoadMoreHistory ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.orderHistory.length) {
            return _buildLoadMoreIndicator(context);
          }

          final order = state.orderHistory[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: HistoryOrderCard(
                  order: order,
                  currencySymbol: _sessionManager.currencySymbol,
                  style: OrderCardStyle.bordered,
                  onTap: () => showOrderDetails(order, context),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildLoadMoreIndicator(BuildContext context) {
  // Trigger load more when this widget becomes visible
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<OrderBloc>().add(const LoadMoreOrderHistoryEvent());
  });

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    child: Center(child: appLoader()),
  );
}

void showOrderDetails(OrderModel order, BuildContext context) {
  final SessionManager _sessionManager = SessionManager();

  final colors = context.colors;
  final currencySymbol = _sessionManager.currencySymbol;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => OrderDetailsSheet(
        order: order,
        currencySymbol: currencySymbol,
        scrollController: scrollController,
      ),
    ),
  );
}
