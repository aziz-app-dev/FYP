// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/widgets/app_network_image.dart';

import '../../model/order/order_model.dart';
import '../config.dart';

enum OrderCardStyle { modern, minimal, elevated, bordered }

class ActiveOrderCard extends StatelessWidget {
  final OrderModel order;
  final String currencySymbol;
  final VoidCallback onTap;
  final OrderCardStyle style;

  const ActiveOrderCard({
    super.key,
    required this.order,
    required this.currencySymbol,
    required this.onTap,
    this.style = OrderCardStyle.modern,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    switch (style) {
      case OrderCardStyle.modern:
        return _buildModern(colors);
      case OrderCardStyle.minimal:
        return _buildMinimal(colors);
      case OrderCardStyle.elevated:
        return _buildElevated(colors);
      case OrderCardStyle.bordered:
        return _buildBordered(colors);
    }
  }

  Widget _buildModern(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(colors, isModern: true),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildRestaurantInfo(colors),
                    SizedBox(height: 16.h),
                    _buildProgressIndicator(colors),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimal(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            _buildRestaurantInfo(colors, minimalLayout: true),
            SizedBox(height: 12.h),
            _buildProgressIndicator(colors, minimalist: true),
            SizedBox(height: 12.h),
            _buildTopSection(colors, isModern: false),
          ],
        ),
      ),
    );
  }

  Widget _buildElevated(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .15),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTopSection(colors, isModern: false),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(color: colors.divider, height: 1),
            ),
            _buildRestaurantInfo(colors),
            SizedBox(height: 16.h),
            _buildProgressIndicator(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildBordered(ThemeColors colors) {
    final statusColor = _getStatusColor(colors);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colors.primary.withValues(alpha: .2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .04),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .05),
                  border: Border(
                    bottom: BorderSide(
                      color: colors.primary.withValues(alpha: .1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 18.spMin,
                          color: statusColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          order.orderStatus.value.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: .2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14.spMin,
                            color: colors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _getEstimatedTime(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildRestaurantInfo(colors),
                    SizedBox(height: 16.h),
                    _buildProgressIndicator(colors, isBordered: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(ThemeColors colors, {required bool isModern}) {
    final statusColor = _getStatusColor(colors);
    return Container(
      padding: isModern
          ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
          : EdgeInsets.zero,
      decoration: isModern
          ? BoxDecoration(
              color: statusColor.withValues(alpha: .08),
              border: Border(
                bottom: BorderSide(color: statusColor.withValues(alpha: .1)),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(_getStatusIcon(), size: 16.spMin, color: statusColor),
              SizedBox(width: 6.w),
              Text(
                order.orderStatus.value.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: isModern ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14.spMin,
                  color: statusColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  _getEstimatedTime(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo(
    ThemeColors colors, {
    bool minimalLayout = false,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(minimalLayout ? 8.r : 16.r),
          child: AppNetworkImage(
            imageUrl: order.restaurant?.imageUrl ?? '',
            width: minimalLayout ? 40.w : 56.w,
            height: minimalLayout ? 40.w : 56.w,
            fit: BoxFit.cover,
            placeholder: Container(
              width: 56.w,
              height: 56.w,
              color: colors.surfaceVariant,
              child: Icon(Icons.restaurant, color: colors.textTertiary),
            ),
            errorWidget: Container(
              width: 56.w,
              height: 56.w,
              color: colors.surfaceVariant,
              child: Icon(Icons.restaurant, color: colors.textTertiary),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.restaurant?.title ?? 'Restaurant',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                '${order.totalItems} items',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$currencySymbol${order.grandTotal.toStringAsFixed(2)}',
              style: AppTextStyles.titleMedium.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 4.h),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.spMin,
              color: colors.textTertiary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(
    ThemeColors colors, {
    bool minimalist = false,
    bool isBordered = false,
  }) {
    final progress = _getProgressValue();
    final statusColor = _getStatusColor(colors);

    if (minimalist) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMinimalStep(colors, 'Placed', progress >= 0.25, isBordered),
              _buildMinimalStep(
                colors,
                'Preparing',
                progress >= 0.5,
                isBordered,
              ),
              _buildMinimalStep(
                colors,
                'Delivery',
                progress >= 0.75,
                isBordered,
              ),
              _buildMinimalStep(colors, 'Done', progress >= 1.0, isBordered),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(statusColor),
              minHeight: 2.h,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isBordered
                ? colors.primary.withValues(alpha: .1)
                : colors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(statusColor),
            minHeight: isBordered ? 6.h : 8.h,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProgressStep(colors, 'Confirmed', progress >= 0.25),
            _buildProgressStep(colors, 'Preparing', progress >= 0.5),
            _buildProgressStep(colors, 'On the way', progress >= 0.75),
            _buildProgressStep(colors, 'Delivered', progress >= 1.0),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep(ThemeColors colors, String label, bool isActive) {
    return Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: isActive ? _getStatusColor(colors) : colors.textTertiary,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontSize: 10.spMin,
      ),
    );
  }

  Widget _buildMinimalStep(
    ThemeColors colors,
    String label,
    bool isActive,
    bool isBordered,
  ) {
    return Row(
      children: [
        Icon(
          isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 10.spMin,
          color: isActive
              ? (isBordered ? colors.primary : _getStatusColor(colors))
              : colors.textTertiary,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isActive ? colors.textPrimary : colors.textTertiary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 10.spMin,
          ),
        ),
      ],
    );
  }

  double _getProgressValue() {
    switch (order.orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return 0.25;
      case OrderStatus.preparing:
        return 0.5;
      case OrderStatus.ready:
        return 0.625;
      case OrderStatus.outForDelivery:
        return 0.75;
      case OrderStatus.delivery:
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _getStatusColor(ThemeColors colors) {
    switch (order.orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return colors.warning;
      case OrderStatus.preparing:
        return colors.info;
      case OrderStatus.ready:
        return colors.success;
      case OrderStatus.outForDelivery:
        return colors.primary;
      default:
        return colors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (order.orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return Icons.hourglass_bottom_rounded;
      case OrderStatus.preparing:
        return Icons.outdoor_grill_rounded;
      case OrderStatus.ready:
        return Icons.check_circle_rounded;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _getEstimatedTime() {
    if (order.estimatedDeliveryTime != null) {
      final diff = order.estimatedDeliveryTime!.difference(DateTime.now());
      if (diff.inMinutes > 0) {
        return '${diff.inMinutes} min';
      }
    }
    switch (order.orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return '30-45 min';
      case OrderStatus.preparing:
        return '20-30 min';
      case OrderStatus.ready:
        return '15-20 min';
      case OrderStatus.outForDelivery:
        return '10-15 min';
      default:
        return '--';
    }
  }
}

class HistoryOrderCard extends StatelessWidget {
  final OrderModel order;
  final String currencySymbol;
  final VoidCallback onTap;
  final OrderCardStyle style;

  const HistoryOrderCard({
    super.key,
    required this.order,
    required this.currencySymbol,
    required this.onTap,
    this.style = OrderCardStyle.modern,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    switch (style) {
      case OrderCardStyle.modern:
        return _buildModern(colors);
      case OrderCardStyle.minimal:
        return _buildMinimal(colors);
      case OrderCardStyle.elevated:
        return _buildElevated(colors);
      case OrderCardStyle.bordered:
        return _buildBordered(colors);
    }
  }

  Widget _buildModern(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6.w,
                decoration: BoxDecoration(
                  color: order.orderStatus.isCancelled
                      ? colors.error
                      : colors.success,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16.r),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      _buildImage(colors, 50.w),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildInfo(colors)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimal(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _buildImage(colors, 44.w, circular: true),
            SizedBox(width: 12.w),
            Expanded(child: _buildInfo(colors)),
            _buildStatusIcon(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildElevated(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildImage(colors, 56.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.restaurant?.title ?? 'Restaurant',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusChip(colors),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order.totalItems} items',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        '$currencySymbol${order.grandTotal.toStringAsFixed(2)}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(order.createdAt ?? order.orderDate),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBordered(ThemeColors colors) {
    final isCancelled = order.orderStatus.isCancelled;
    final statusColor = isCancelled ? colors.error : colors.success;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.primary.withValues(alpha: .15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildImage(colors, 52.w),
                  Positioned(
                    right: -4.w,
                    bottom: -4.w,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.primary.withValues(alpha: .1),
                        ),
                      ),
                      child: Icon(
                        isCancelled ? Icons.close_rounded : Icons.check_rounded,
                        color: statusColor,
                        size: 12.spMin,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(child: _buildInfo(colors)),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.spMin,
                color: colors.primary.withValues(alpha: .5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeColors colors, double size, {bool circular = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular ? size / 2 : 12.r),
      child: AppNetworkImage(
        imageUrl: order.restaurant?.imageUrl ?? '',
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: _placeholder(colors, size),
        errorWidget: _placeholder(colors, size),
      ),
    );
  }

  Widget _placeholder(ThemeColors colors, double size) {
    return Container(
      width: size,
      height: size,
      color: colors.surfaceVariant,
      child: Icon(
        Icons.restaurant,
        color: colors.textTertiary,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildInfo(ThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                order.restaurant?.title ?? 'Restaurant',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${order.totalItems} items',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              '$currencySymbol${order.grandTotal.toStringAsFixed(2)}',
              style: AppTextStyles.labelMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          _formatDate(order.createdAt ?? order.orderDate),
          style: AppTextStyles.labelSmall.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildStatusChip(ThemeColors colors) {
    final isCancelled = order.orderStatus.isCancelled;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isCancelled
            ? colors.error.withValues(alpha: .1)
            : colors.success.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isCancelled ? 'Cancelled' : 'Delivered',
        style: AppTextStyles.labelSmall.copyWith(
          color: isCancelled ? colors.error : colors.success,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ThemeColors colors) {
    final isCancelled = order.orderStatus.isCancelled;
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isCancelled
            ? colors.error.withValues(alpha: .1)
            : colors.success.withValues(alpha: .1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCancelled ? Icons.close_rounded : Icons.check_rounded,
        color: isCancelled ? colors.error : colors.success,
        size: 16.spMin,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final String currencySymbol;
  final VoidCallback onTap;
  final OrderCardStyle style;

  const OrderHistoryCard({
    super.key,
    required this.order,
    required this.currencySymbol,
    required this.onTap,
    this.style = OrderCardStyle.modern,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    switch (style) {
      case OrderCardStyle.modern:
        return _buildModern(colors);
      case OrderCardStyle.minimal:
        return _buildMinimal(colors);
      case OrderCardStyle.elevated:
        return _buildElevated(colors);
      case OrderCardStyle.bordered:
        return _buildBordered(colors);
    }
  }

  Widget _buildModern(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildHeader(colors, circularImage: true),
            ),
            Divider(height: 1, color: colors.divider.withValues(alpha: .5)),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemsPreview(colors),
                  SizedBox(height: 16.h),
                  _buildFooter(colors, modernAccent: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimal(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            _buildHeader(colors),
            SizedBox(height: 16.h),
            _buildItemsPreview(colors, minimal: true),
            SizedBox(height: 16.h),
            _buildFooter(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildElevated(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .15),
              blurRadius: 25,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(colors, largeImage: true),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(color: colors.divider),
            ),
            _buildItemsPreview(colors),
            SizedBox(height: 16.h),
            _buildFooter(colors, fillAction: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBordered(ThemeColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colors.primary.withValues(alpha: .2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .04),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildHeader(colors, circularImage: true),
            ),
            Container(height: 1, color: colors.primary.withValues(alpha: .1)),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemsPreview(colors, minimal: true),
                  SizedBox(height: 16.h),
                  _buildFooter(colors, buttonBorder: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeColors colors, {
    bool circularImage = false,
    bool largeImage = false,
  }) {
    final size = largeImage ? 64.w : 50.w;
    final isCancelled = order.orderStatus.isCancelled;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(circularImage ? size / 2 : 12.r),
          child: AppNetworkImage(
            imageUrl: order.restaurant?.imageUrl ?? '',
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: _placeholder(colors, size),
            errorWidget: _placeholder(colors, size),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.restaurant?.title ?? 'Restaurant',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                _formatDate(order.createdAt ?? order.orderDate),
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isCancelled
                ? colors.error.withValues(alpha: .1)
                : colors.success.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            isCancelled ? 'Cancelled' : 'Delivered',
            style: AppTextStyles.labelSmall.copyWith(
              color: isCancelled ? colors.error : colors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(ThemeColors colors, double size) {
    return Container(
      width: size,
      height: size,
      color: colors.surfaceVariant,
      child: Icon(
        Icons.restaurant,
        color: colors.textTertiary,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildItemsPreview(ThemeColors colors, {bool minimal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...order.orderItems
            .take(2)
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(
                          alpha: minimal ? 0 : .1,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item.food?.title ?? 'Item',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: minimal
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        if (order.orderItems.length > 2)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              '+${order.orderItems.length - 2} more items',
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter(
    ThemeColors colors, {
    bool modernAccent = false,
    bool fillAction = false,
    bool buttonBorder = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total (${order.totalItems} items)',
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              '$currencySymbol${order.grandTotal.toStringAsFixed(2)}',
              style: AppTextStyles.titleMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: fillAction
                ? colors.primary
                : (modernAccent
                      ? colors.primary.withValues(alpha: .1)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(20.r),
            border: buttonBorder ? Border.all(color: colors.primary) : null,
          ),
          child: Text(
            'View Details',
            style: AppTextStyles.labelMedium.copyWith(
              color: fillAction ? colors.textOnPrimary : colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
