import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/loaders_utils.dart';
import '../config.dart';

class ResturentCard extends StatelessWidget {
  final String imageUrl;
  final String logoUrl;
  final String name;
  final String rating;
  final String? timing;
  final bool isOpen;

  const ResturentCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.logoUrl,
    this.timing,
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      color: colors.card,
      child: Container(
        width: 220.spMin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          color: colors.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusCard),
                    ),
                    child: SizedBox(
                      height: 130.spMin,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusCard),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: appLoader()),
                              errorWidget: (context, url, error) => Icon(
                                Icons.restaurant,
                                size: 50.spMin,
                                color: colors.iconSecondary,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12.spMin,
                            left: 12.spMin,
                            child: RatingsContiner(rating: rating),
                          ),
                          Positioned(
                            top: 12.spMin,
                            right: 12.spMin,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusCircular,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusCircular,
                                    ),
                                    border: Border.all(color: colors.primary),
                                    color: colors.card.withValues(alpha: .9),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusCircular,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: logoUrl,
                                      width: 30.h,
                                      height: 30.h,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          Center(child: appLoader()),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                            Icons.restaurant,
                                            size: 50.spMin,
                                            color: colors.iconSecondary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingXs.spMin),
              child: Column(
                spacing: 3.spMin,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.spMin,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.spMin,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: 4.spMin),
                            Flexible(
                              child: Text(
                                timing ?? "9:00 am - 11:00 pm",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.spMin),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.spMin,
                          vertical: 2.spMin,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen ? colors.success : colors.error,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusRound,
                          ),
                        ),
                        child: Text(
                          isOpen ? "Open" : "Closed",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textOnPrimary,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }
}

class RatingsContiner extends StatelessWidget {
  const RatingsContiner({super.key, required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.spMin, vertical: 3.spMin),
          color: colors.card.withValues(alpha: .9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 2.w,
            children: [
              Icon(Icons.star_rounded, size: 12.spMin, color: colors.star),
              Text(
                double.parse(rating).toStringAsFixed(1),
                style: AppTextStyles.buttonMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
