import 'package:food/config/widgets/app_network_image.dart';
import 'package:food/ui/user/profile/view/0_all_profile_view.dart';
import '../../../../config/widgets/order_qr_widget.dart';
import '../../../../bloc/user/main/main_bloc.dart';
import '../../../../bloc/user/main/main_event.dart';
import '../../../../di/service_locator.dart';
import '../../../../model/cart/cart_model.dart';
import '../../../../repo/user/cart/cart_repo.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrderModel order;
  final String currencySymbol;
  final ScrollController scrollController;

  const OrderDetailsSheet({
    super.key,
    required this.order,
    required this.currencySymbol,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Details',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(colors),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Order #${order.id.substring(order.id.length - 8).toUpperCase()}',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),

          SizedBox(height: 20.h),

          // Content
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                // Restaurant info
                _buildRestaurantInfo(colors),
                SizedBox(height: 16.h),

                // Order items
                _buildOrderItems(colors),
                SizedBox(height: 16.h),

                // Payment summary
                _buildPaymentSummary(colors),
                if (order.verificationCode != null) ...[
                  SizedBox(height: 24.h),
                  OrderQrWidget(verificationCode: order.verificationCode!),
                ],
                SizedBox(height: 32.h),
              ],
            ),
          ),

          // Reorder button
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handleReorder(context);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reorder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReorder(BuildContext context) async {
    final itemsToReorder = order.orderItems
        .where((item) => item.foodId != null && item.foodId!.isNotEmpty)
        .toList();

    if (itemsToReorder.isEmpty) {
      Navigator.pop(context);
      ToastUtils.showError(
        context,
        message: 'This order has no valid items to reorder.',
      );
      return;
    }

    Navigator.pop(context);

    try {
      final cartRepo = getIt<CartRepository>();
      await cartRepo.clearCart();

      for (final item in itemsToReorder) {
        final request = AddToCartRequest(
          productId: item.foodId!,
          quantity: item.quantity,
          totalPrice: item.price * item.quantity,
          additives: item.additives
              .map((name) => Additive(title: name, price: 0))
              .toList(),
          instructions: item.instruction,
        );
        await cartRepo.addToCart(request);
      }

      if (context.mounted) {
        try {
          context.read<MainBloc>().add(IndexChangeEvent(index: 2));
        } catch (_) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.mainScreen,
            (route) => false,
          );
        }
        ToastUtils.showSuccess(context, message: 'Items added to cart');
      }
    } catch (e) {
      if (context.mounted) {
        ToastUtils.showError(context, message: 'Failed to reorder: $e');
      }
    }
  }

  Widget _buildStatusChip(ThemeColors colors) {
    final isCancelled = order.orderStatus.isCancelled;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isCancelled
            ? colors.error.withValues(alpha: .1)
            : colors.success.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        order.orderStatus.value,
        style: AppTextStyles.labelMedium.copyWith(
          color: isCancelled ? colors.error : colors.success,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(ThemeColors colors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: AppNetworkImage(
              imageUrl: order.restaurant?.imageUrl ?? '',
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
              placeholder: Container(
                width: 50.w,
                height: 50.w,
                color: colors.surfaceVariant,
                child: Icon(
                  Icons.restaurant_rounded,
                  color: colors.textTertiary,
                ),
              ),
              errorWidget: Container(
                width: 50.w,
                height: 50.w,
                color: colors.surfaceVariant,
                child: Icon(
                  Icons.restaurant_rounded,
                  color: colors.textTertiary,
                ),
              ),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (order.restaurant?.address != null)
                  Text(
                    order.restaurant!.address!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(ThemeColors colors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fastfood_rounded,
                size: 18.spMin,
                color: colors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Items',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...order.orderItems.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${item.quantity}x',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.food?.title ?? 'Item',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '$currencySymbol${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(ThemeColors colors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildSummaryRow(colors, 'Subtotal', order.orderTotal),
          _buildSummaryRow(colors, 'Delivery Fee', order.deliveryFee),
          if (order.discountAmount != null && order.discountAmount! > 0)
            _buildSummaryRow(
              colors,
              'Discount',
              -order.discountAmount!,
              isDiscount: true,
            ),
          Divider(height: 16.h, color: colors.divider),
          _buildSummaryRow(colors, 'Total', order.grandTotal, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeColors colors,
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                (isTotal ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                    .copyWith(
                      color: colors.textPrimary,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    ),
          ),
          Text(
            '${isDiscount ? '-' : ''}$currencySymbol${amount.abs().toStringAsFixed(2)}',
            style:
                (isTotal ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                    .copyWith(
                      color: isDiscount ? colors.success : colors.textPrimary,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    ),
          ),
        ],
      ),
    );
  }
}
