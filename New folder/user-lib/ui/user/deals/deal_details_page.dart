import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../model/cart/cart_model.dart';
import '../../../repo/user/cart/cart_repo.dart';
import '../../../utils/toast_utils.dart';

class DealDetailsPage extends StatefulWidget {
  final Map<String, dynamic> deal;

  const DealDetailsPage({super.key, required this.deal});

  @override
  State<DealDetailsPage> createState() => _DealDetailsPageState();
}

class _DealDetailsPageState extends State<DealDetailsPage> {
  final ValueNotifier<bool> _termsExpanded = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isClaiming = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _termsExpanded.dispose();
    _isClaiming.dispose();
    super.dispose();
  }

  Future<void> _claimDeal() async {
    final items =
        widget.deal['itemsIncluded'] as List<Map<String, dynamic>>? ?? [];
    if (items.isEmpty) {
      ToastUtils.showError(context, message: 'No items in this deal');
      return;
    }

    _isClaiming.value = true;

    try {
      final cartRepo = CartRepository();
      final dealPrice = (widget.deal['dealPrice'] as num?)?.toDouble() ??
          (widget.deal['discountedPrice'] as num?)?.toDouble() ??
          0.0;

      // Calculate price per item proportionally
      final totalOriginalPrice = items.fold<double>(
        0,
        (sum, item) =>
            sum +
            ((item['price'] as num?)?.toDouble() ?? 0) *
                ((item['quantity'] as num?)?.toInt() ?? 1),
      );
      final ratio =
          totalOriginalPrice > 0 ? dealPrice / totalOriginalPrice : 1.0;

      for (final item in items) {
        final foodId = item['foodId']?.toString() ?? '';
        if (foodId.isEmpty) continue;

        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        final originalPrice = (item['price'] as num?)?.toDouble() ?? 0;
        final itemPrice = originalPrice * ratio * qty;

        await cartRepo.addToCart(AddToCartRequest(
          productId: foodId,
          quantity: qty,
          totalPrice: itemPrice,
        ));
      }

      if (mounted) {
        ToastUtils.showSuccess(context, message: 'Deal added to cart!');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) _isClaiming.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final validUntil = widget.deal['validUntil'] as String;
    final itemsIncluded =
        widget.deal['itemsIncluded'] as List<Map<String, dynamic>>?;

    return Scaffold(
      backgroundColor: context.colors.scaffoldBackground,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.background,
                    const Color(0xFFFDFBF7),
                    AppColors.primary.withValues(alpha: .05),
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 300.h,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 20.sp),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.deal['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.local_offer, size: 80.sp),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deal Information
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Deal Title & Restaurant
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.deal['title'] as String,
                              style: AppTextStyles.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            GestureDetector(
                              onTap: () {
                                // Navigate to restaurant details
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: .1,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.restaurant_rounded,
                                      size: 18.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      widget.deal['restaurantName'] as String,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12.sp,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // What's Included Section
                      if (itemsIncluded != null && itemsIncluded.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: .05),
                                AppColors.primaryLight.withValues(alpha: .02),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: .1),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.restaurant_menu_rounded,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    "What's Included",
                                    style: AppTextStyles.titleLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              // Items Grid
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                      childAspectRatio: 2.5,
                                    ),
                                itemCount: itemsIncluded.length,
                                itemBuilder: (context, index) {
                                  final item = itemsIncluded[index];
                                  return Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: .03,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          item['icon'] as String,
                                          style: TextStyle(fontSize: 24.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${item['quantity']}x',
                                                style: AppTextStyles.labelSmall
                                                    .copyWith(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                item['name'] as String,
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16.h),

                      // Price Card
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Original Price',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 4.spMin),
                                PriceText(
                                  price: (widget.deal['originalPrice'] as num)
                                      .toDouble(),
                                  style: AppTextStyles.titleLarge.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Deal Price',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                PriceText(
                                  price: (widget.deal['dealPrice'] as num)
                                      .toDouble(),
                                  fontSize: 16.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Valid Until & Category
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.success.withValues(
                                    alpha: .3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 20.sp,
                                    color: AppColors.success,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Valid Until',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.success,
                                              ),
                                        ),
                                        Text(
                                          validUntil,
                                          style: AppTextStyles.titleSmall
                                              .copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoLight,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.info.withValues(alpha: .3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.category_rounded,
                                  color: AppColors.info,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  widget.deal['category'] as String? ?? 'Food',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.info,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Description Section
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  color: AppColors.primary,
                                  size: 22.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'About This Deal',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              widget.deal['description'] as String,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Terms & Conditions
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _termsExpanded,
                          builder: (context, termsExpanded, _) => Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _termsExpanded.value = !termsExpanded;
                                },
                                borderRadius: BorderRadius.circular(20.r),
                                child: Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.rule_rounded,
                                        color: AppColors.warning,
                                        size: 22.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          'Terms & Conditions',
                                          style: AppTextStyles.titleLarge
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Icon(
                                        termsExpanded
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.textSecondary,
                                        size: 28.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (termsExpanded)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    20.w,
                                    0,
                                    20.w,
                                    20.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 1,
                                        color: AppColors.divider,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        widget.deal['termsAndConditions']
                                            as String,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom spacing for button
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Claim Deal Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isClaiming,
                builder: (context, isClaiming, _) => GestureDetector(
                  onTap: isClaiming ? null : _claimDeal,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: isClaiming
                        ? SizedBox(
                            height: 26.sp,
                            width: 26.sp,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_rounded,
                                color: Colors.white,
                                size: 26.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Claim This Deal',
                                style: AppTextStyles.buttonLarge.copyWith(
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
