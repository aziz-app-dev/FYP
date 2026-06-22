import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../config/config.dart';
import '../../../../model/home/home_model.dart';
import '../../../../repo/shared/paginated/offer_paginated_repo.dart';
import '../../../../routes/route_name.dart';
import '../../../../utils/loaders_utils.dart';
import '../../common/paginated_list_page.dart';

class AllOffersPage extends StatelessWidget {
  const AllOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedListPage<OfferItem>(
      title: 'Amazing Offers',
      repo: OfferPaginatedRepo(),
      crossAxisCount: 1,
      childAspectRatio: 2.3,
      itemBuilder: (offer, colors) {
        return AnimationConfiguration.staggeredList(
          position:
              0, // PaginatedListPage manages positions internally or we use a wrapper
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _OfferListCard(offer: offer, colors: colors),
            ),
          ),
        );
      },
    );
  }
}

class _OfferListCard extends StatelessWidget {
  final OfferItem offer;
  final ThemeColors colors;

  const _OfferListCard({required this.offer, required this.colors});

  Map<String, dynamic> _offerToMap() {
    return {
      'id': offer.id ?? "",
      'title': offer.title ?? "",
      'description': offer.description ?? "",
      'image': offer.bannerImageUrl ?? "",
      'discountPercentage': (offer.discountValue ?? 0).toInt(),
      'promoCode': offer.promoCode ?? "",
      'subDetails': offer.offerType ?? "",
      'expiryTime': "",
      'validUntil': "",
      'participatingRestaurants':
          offer.restaurants
              ?.map(
                (r) => {
                  'name': r.title ?? "",
                  'rating': r.rating ?? 0.0,
                  'deliveryTime': "30 min",
                  'image': r.imageUrl ?? "",
                },
              )
              .toList() ??
          [],
      'termsAndConditions': <String>[],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.offerDetails,
            arguments: _offerToMap(),
          );
        },
        child: Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: offer.bannerImageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: colors.shimmerBase,
                      child: Center(child: appLoader(size: 40.r)),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: colors.shimmerBase,
                      child: Icon(
                        Icons.local_offer,
                        color: colors.primary,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          colors.card.withValues(alpha: 0.95),
                          colors.card.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (offer.offerType != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  offer.offerType!.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            SizedBox(height: 8.h),
                            Text(
                              offer.title ?? 'Special Offer',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              offer.description ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                if (offer.discountValue != null &&
                                    offer.discountValue! > 0)
                                  _buildBadge(
                                    '${offer.discountValue!.toInt()}% OFF',
                                    colors.primary,
                                    Colors.white,
                                  ),
                                if (offer.promoCode != null &&
                                    offer.promoCode!.isNotEmpty) ...[
                                  SizedBox(width: 8.w),
                                  _buildBadge(
                                    offer.promoCode!,
                                    Colors.transparent,
                                    colors.primary,
                                    isOutlined: true,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Expanded(flex: 4, child: SizedBox.shrink()),
                    ],
                  ),
                ),
                // Floating Action Circle (Modern touch)
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.r, bottom: 15.r),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colors.primary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(
    String label,
    Color bgColor,
    Color textColor, {
    bool isOutlined = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: isOutlined ? Border.all(color: textColor, width: 1.5) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
