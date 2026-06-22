// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../config/config.dart';
import '../../../../config/widgets/price_widget.dart';
import '../../../../config/widgets/resturnt_card.dart';
import '../../../../repo/user/offer/offer_repo.dart';
import '../../../../routes/route_name.dart';
import '../../../../utils/toast_utils.dart';

class OfferDetailsPage extends StatefulWidget {
  final Map<String, dynamic> offer;

  const OfferDetailsPage({super.key, required this.offer});

  @override
  State<OfferDetailsPage> createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  final ValueNotifier<bool> _isCopied = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isApplying = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isCopied.dispose();
    _isApplying.dispose();
    super.dispose();
  }

  Future<void> _useOfferNow() async {
    final promoCode = widget.offer['promoCode']?.toString() ?? '';
    if (promoCode.isEmpty) {
      ToastUtils.showError(context, message: 'This offer has no promo code');
      return;
    }

    _isApplying.value = true;

    try {
      // Validate the promo code first
      await OfferRepo().validatePromoCode(
        promoCode: promoCode,
        orderAmount: 0, // Will be recalculated in cart
      );

      if (mounted) {
        // Copy to clipboard
        await Clipboard.setData(ClipboardData(text: promoCode));
        ToastUtils.showSuccess(
          context,
          message: 'Promo code applied! Redirecting to cart...',
        );

        // Navigate to main screen (which has cart tab)
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) _isApplying.value = false;
    }
  }

  void _copyPromoCode() {
    Clipboard.setData(ClipboardData(text: widget.offer['promoCode'] ?? ""));
    _isCopied.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _isCopied.value = false;
    });
  }

  final List<Map<String, dynamic>> _dummyFoods = [
    {
      'name': 'Cheese Burger',
      'rating': 4.9,
      'price': 12.50,
      'image': 'https://loremflickr.com/320/240/burger',
    },
    {
      'name': 'Pepperoni Pizza',
      'rating': 4.8,
      'price': 15.00,
      'image': 'https://loremflickr.com/320/240/pizza',
    },
    {
      'name': 'Sushi Platter',
      'rating': 4.7,
      'price': 22.00,
      'image': 'https://loremflickr.com/320/240/sushi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final restaurants =
        widget.offer['participatingRestaurants'] as List<dynamic>? ?? [];
    final terms = widget.offer['termsAndConditions'] as List<dynamic>? ?? [];
    return Scaffold(
      /// BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE + OFFER CARD STACK
            Stack(
              clipBehavior: Clip.none,
              children: [
                /// HEADER IMAGE WITH ROUNDED BOTTOM
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r),
                  ),
                  child: Image.network(
                    widget.offer['image'],
                    height: 280.spMin,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// BACK BUTTON
                Positioned(
                  top: 60.h,
                  left: 16.h,
                  child: _circleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                /// SHARE BUTTON
                Positioned(
                  top: 60.h,
                  right: 16.h,
                  child: _circleButton(icon: Icons.ios_share, onTap: () {}),
                ),

                /// OFFER CARD (OVERLAPPING)
                Positioned(
                  bottom: -90.spMin,
                  left: 20.spMin,
                  right: 20.spMin,
                  child: CustomPaint(
                    painter: TicketPainter(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.spMin,
                        horizontal: 12.spMin,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 15.spMin,
                        children: [
                          Text(
                            "${widget.offer['discountPercentage']}% OFF",
                            style: AppTextStyles.displayLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            widget.offer['subDetails'] ?? "",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelLarge.copyWith(),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black54),
                              children: [
                                const TextSpan(text: "Ends in "),
                                TextSpan(
                                  text: widget.offer['expiryTime'] ?? "",
                                  style: const TextStyle(
                                    color: AppColors.primary,
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
                ),
              ],
            ),

            /// SPACE FOR OVERLAP
            SizedBox(height: 120.spMin),

            /// PAGE CONTENT
            Padding(
              padding: AppSizes.paddingHorizontalMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROMO CODE TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Promo Code",
                        style: AppTextStyles.titleLarge.copyWith(),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isCopied,
                        builder: (context, isCopied, _) => isCopied
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16.spMin,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Copied!",
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  AppSizes.verticalSpaceMd,

                  /// PROMO CODE BOX
                  Container(
                    padding: EdgeInsets.only(left: 12.spMin),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.offer['promoCode'] ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _copyPromoCode,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.spMin,
                              vertical: 8.spMin,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd - 1,
                              ),
                            ),
                            child: Text(
                              "Copy",
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// TERMS & CONDITIONS
                  ...terms.map(
                    (term) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        spacing: 6.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.h,
                            width: 6.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.radiusCircular),
                              ),
                            ),
                          ),
                          // Text(
                          //   "• ",
                          //   style: AppTextStyles.titleMedium.copyWith(
                          //     color: AppColors.primary,
                          //   ),
                          // ),
                          Expanded(
                            child: Text(
                              term.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// RESTAURANTS
                  if (restaurants.isNotEmpty) ...[
                    Text(
                      "Participating Restaurants",
                      style: AppTextStyles.titleLarge,
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 190.spMin,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        separatorBuilder: (_, _) => SizedBox(width: 12.w),
                        itemBuilder: (_, index) {
                          final rest = restaurants[index];
                          return ResturentCard(
                            name: rest['name'] ?? '',
                            rating: (rest['rating'] ?? 0.0).toString(),
                            logoUrl: rest['image'] ?? '',
                            imageUrl: rest['image'] ?? '',
                            timing: rest['timing']?.toString(),
                            isOpen: rest['isOpen'] ?? true,
                          );
                        },
                      ),
                    ),
                  ],

                  /// FOODS
                  if (_dummyFoods.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Text("Applicable Foods", style: AppTextStyles.titleLarge),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 220.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dummyFoods.length,
                        separatorBuilder: (_, _) => SizedBox(width: 12.w),
                        itemBuilder: (_, index) {
                          final food = _dummyFoods[index];
                          return FoodCard(
                            name: food['name'],
                            image: food['image'],
                            price: food['price'],
                            rating: food['rating'],
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteName.foodDetails2,
                                arguments:
                                    food['_id']?.toString() ??
                                    food['id']?.toString() ??
                                    '',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 140),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM CTA BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<bool>(
          valueListenable: _isApplying,
          builder: (context, isApplying, _) => AppButton(
            text: isApplying ? "Validating..." : "Use Offer Now",
            onPressed: isApplying ? () {} : _useOfferNow,
          ),
        ),
      ),
    );
  }

  /// CIRCLE ICON BUTTON
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

/// SIMPLE TICKET PAINTER (PLACEHOLDER)
class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.secondaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint dashPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    const double radius = 15;
    const double punchRadius = 15;

    // ───────── TOP ─────────
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // ───────── RIGHT (PUNCH) ─────────
    path.lineTo(size.width, (size.height / 2) - punchRadius);
    path.arcToPoint(
      Offset(size.width, (size.height / 2) + punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    // ───────── BOTTOM ─────────
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // ───────── LEFT (PUNCH) ─────────
    path.lineTo(0, (size.height / 2) + punchRadius);
    path.arcToPoint(
      Offset(0, (size.height / 2) - punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();

    // ───────── SHADOW ─────────
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.1), 10, true);

    // ───────── FILL ─────────
    canvas.drawPath(path, fillPaint);

    // ───────── DOTTED BORDER ─────────
    _drawDashedPath(canvas, path, borderPaint);

    // ───────── CLIP TO TICKET ─────────
    canvas.save();
    canvas.clipPath(path);

    // ───────── CENTER DASHED DIVIDER (INSIDE ONLY) ─────────
    const double dashWidth = 5;
    const double dashSpace = 3;
    const double horizontalPadding = 24; // avoids punch curves

    double startX = horizontalPadding;
    final centerY = size.height / 2;
    final endX = size.width - horizontalPadding;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, centerY),
        Offset(startX + dashWidth, centerY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }

    canvas.restore();
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dashLength = 6;
    const double gapLength = 4;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FoodCard extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final double rating;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.network(
                image,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(rating.toString(), style: AppTextStyles.labelMedium),
                      const Spacer(),
                      PriceText(price: price),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
