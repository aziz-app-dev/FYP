import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/utils/loaders_utils.dart';

import '../../../config/config.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int discountPercentage;
  final String validUntil;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discountPercentage,
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
          width: 220.spMin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            color: colors.card,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section with Percentage Badge
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppSizes.radiusCard),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: appLoader()),
                              errorWidget: (context, url, error) => Icon(
                                Icons.percent_rounded,
                                size: 50.spMin,
                                color: colors.iconSecondary,
                              ),
                            ),
                          ),
                        ),

                        // Percentage Badge - Centered
                        Positioned(
                          top: 10.h,
                          left: 10.h,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.spMin,
                                vertical: 2.spMin,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colors.secondary,
                                    colors.secondaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '$discountPercentage% OFF',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: colors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details Section
                  Padding(
                    padding: EdgeInsets.all(AppSizes.paddingXs.spMin),
                    child: Column(
                      spacing: 5.spMin,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.spMin,
                            height: 1,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Description
                        Text(
                          description,
                          style: AppTextStyles.bodySmall.copyWith(
                            height: 1.1,
                            color: colors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Valid Until Badge
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 16.spMin,
                              color: colors.secondary,
                            ),
                            SizedBox(width: 6.spMin),
                            Text(
                              'Valid until $validUntil',
                              style: AppTextStyles.chipText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
