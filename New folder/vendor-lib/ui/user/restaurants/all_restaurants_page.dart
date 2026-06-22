import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/config.dart';
import '../../../model/home/home_model.dart';
import '../../../repo/shared/paginated/restaurant_paginated_repo.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';
import '../common/paginated_list_page.dart';

class AllRestaurantsPage extends StatelessWidget {
  const AllRestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedListPage<RestaurantItem>(
      title: 'All Restaurants',
      repo: RestaurantPaginatedRepo(),
      childAspectRatio: 0.85,
      itemBuilder: (restaurant, colors) =>
          _RestaurantGridCard(restaurant: restaurant, colors: colors),
    );
  }
}

class _RestaurantGridCard extends StatelessWidget {
  final RestaurantItem restaurant;
  final ThemeColors colors;

  const _RestaurantGridCard({required this.restaurant, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.restaurantDetails,
          arguments: restaurant.id ?? '',
        );
      },
      child: Card(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusCard),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.imageUrl ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: colors.shimmerBase,
                        child: Center(child: appLoader(size: 20)),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: colors.shimmerBase,
                        child: Icon(
                          Icons.restaurant,
                          color: colors.primary,
                          size: 40.spMin,
                        ),
                      ),
                    ),
                  ),
                  if (restaurant.logoUrl != null &&
                      restaurant.logoUrl!.isNotEmpty)
                    Positioned(
                      bottom: 8.spMin,
                      left: 8.spMin,
                      child: Container(
                        width: 40.spMin,
                        height: 40.spMin,
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(8.spMin),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.spMin),
                          child: CachedNetworkImage(
                            imageUrl: restaurant.logoUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Icon(
                              Icons.restaurant,
                              color: colors.primary,
                              size: 20.spMin,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.title ?? '',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.spMin, color: Colors.amber),
                        SizedBox(width: 4.spMin),
                        Text(
                          (restaurant.rating ?? 0).toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time,
                          size: 14.spMin,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 4.spMin),
                        Text(
                          restaurant.time ?? '',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
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
