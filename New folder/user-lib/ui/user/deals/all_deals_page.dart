import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../model/home/home_model.dart';
import '../../../repo/shared/paginated/deal_paginated_repo.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';
import '../common/paginated_list_page.dart';

class AllDealsPage extends StatelessWidget {
  const AllDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedListPage<DealItem>(
      title: 'All Deals',
      repo: DealPaginatedRepo(),
      crossAxisCount: 1,
      childAspectRatio: 2.2,
      itemBuilder: (deal, colors) => _DealListCard(deal: deal, colors: colors),
    );
  }
}

class _DealListCard extends StatelessWidget {
  final DealItem deal;
  final ThemeColors colors;

  const _DealListCard({required this.deal, required this.colors});

  Map<String, dynamic> _dealToMap() {
    return {
      'id': deal.id ?? "",
      'title': deal.title ?? "",
      'restaurantName': deal.restaurant?.title ?? "",
      'restaurantId': deal.restaurant?.id ?? "",
      'image': deal.imageUrl ?? "",
      'discountPercentage': (deal.discountPercentage ?? 0).toInt(),
      'originalPrice': deal.originalPrice ?? 0.0,
      'discountedPrice': deal.dealPrice ?? 0.0,
      'validUntil': "",
      'itemsIncluded':
          deal.items
              ?.map(
                (item) => {
                  'name': item.food?.title ?? "",
                  'foodId': item.food?.id ?? "",
                  'price': item.food?.price ?? 0.0,
                  'quantity': item.quantity ?? 1,
                  'icon': '🍽️',
                },
              )
              .toList() ??
          [],
      'dealPrice': deal.dealPrice ?? 0.0,
      'description': deal.description ?? "",
      'termsAndConditions': "",
      'category': deal.dealType ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.dealDetails,
          arguments: _dealToMap(),
        );
      },
      child: Card(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        elevation: 2,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppSizes.radiusCard),
              ),
              child: CachedNetworkImage(
                imageUrl: deal.imageUrl ?? '',
                width: 120.spMin,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 120.spMin,
                  color: colors.shimmerBase,
                  child: Center(child: appLoader(size: 20)),
                ),
                errorWidget: (_, _, _) => Container(
                  width: 120.spMin,
                  color: colors.shimmerBase,
                  child: Icon(
                    Icons.local_offer,
                    color: colors.primary,
                    size: 40.spMin,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.title ?? '',
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.spMin),
                        if (deal.restaurant?.title != null)
                          Text(
                            deal.restaurant!.title!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        if (deal.discountPercentage != null &&
                            deal.discountPercentage! > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.spMin,
                              vertical: 4.spMin,
                            ),
                            decoration: BoxDecoration(
                              color: colors.error,
                              borderRadius: BorderRadius.circular(4.spMin),
                            ),
                            child: Text(
                              '${deal.discountPercentage!.toInt()}% OFF',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (deal.originalPrice != null)
                          PriceText(
                            price: deal.originalPrice!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textHint,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),

                        SizedBox(width: 8.spMin),
                        PriceText(
                          price: deal.dealPrice ?? 0,
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
