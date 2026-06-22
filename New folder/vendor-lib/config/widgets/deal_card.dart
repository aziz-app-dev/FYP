import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/config/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:food/utils/loaders_utils.dart';

import '../../../config/config.dart';

class DealCard extends StatelessWidget {
  final String title;
  final String restaurantName;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final String validUntil;
  final VoidCallback? onTap;

  const DealCard({
    super.key,
    required this.title,
    required this.restaurantName,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.validUntil,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colors.card,
        child: Container(
          width: 250.spMin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            color: colors.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusCard),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 140.spMin,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: appLoader()),
                        errorWidget: (context, url, error) => Icon(
                          Icons.local_offer_rounded,
                          size: 50.spMin,
                          color: colors.iconSecondary,
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    top: 10.h,
                    left: 10.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.spMin,
                        vertical: 2.spMin,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors.secondary, colors.secondaryDark],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.spMin,
                            color: colors.textOnPrimary,
                          ),
                          SizedBox(width: 4.spMin),
                          Text(
                            'Until $validUntil',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textOnPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Details Section
              Padding(
                padding: EdgeInsets.all(AppSizes.paddingXs.spMin),
                child: Column(
                  spacing: 5.spMin,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 15.spMin,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            title,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.spMin,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PriceText(price: discountedPrice),
                      ],
                    ),

                    // Restaurant Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 15.spMin,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant_rounded,
                                size: 14.spMin,
                                color: colors.textSecondary,
                              ),
                              SizedBox(width: 4.spMin),
                              Expanded(
                                child: Text(
                                  restaurantName,
                                  style: AppTextStyles.chipText.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.spMin,
                            vertical: 2.spMin,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryLight,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusRound,
                            ),
                          ),
                          child: Row(
                            spacing: 4.spMin,
                            children: [
                              Icon(
                                TablerIcons.truck_delivery,
                                size: 16.spMin,
                                color: colors.textOnPrimary,
                              ),
                              Text(
                                "Free delivery",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textOnPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
