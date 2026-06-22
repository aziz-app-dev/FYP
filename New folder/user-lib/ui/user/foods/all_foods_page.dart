import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../model/home/home_model.dart';
import '../../../repo/shared/paginated/food_paginated_repo.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';
import '../common/paginated_list_page.dart';

class TopRatedFoodsPage extends StatelessWidget {
  const TopRatedFoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedListPage<FoodItem>(
      title: 'Top Rated Foods',
      repo: TopRatedFoodsRepo(),
      childAspectRatio: 0.75,
      itemBuilder: (food, colors) => _FoodGridCard(food: food, colors: colors),
    );
  }
}

class AllFoodsPage extends StatelessWidget {
  const AllFoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedListPage<FoodItem>(
      title: 'All Foods',
      repo: AllFoodsRepo(),
      childAspectRatio: 0.75,
      itemBuilder: (food, colors) => _FoodGridCard(food: food, colors: colors),
    );
  }
}

class _FoodGridCard extends StatelessWidget {
  final FoodItem food;
  final ThemeColors colors;

  const _FoodGridCard({required this.food, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.foodDetails2,
          arguments: food.id ?? '',
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
                      imageUrl: food.imageUrl ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: colors.shimmerBase,
                        child: Center(child: appLoader(size: 20)),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: colors.shimmerBase,
                        child: Icon(
                          Icons.fastfood,
                          color: colors.primary,
                          size: 40.spMin,
                        ),
                      ),
                    ),
                  ),
                  if (food.rating != null && food.rating! > 0)
                    Positioned(
                      top: 8.spMin,
                      left: 8.spMin,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.spMin,
                          vertical: 4.spMin,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(12.spMin),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12.spMin,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2.spMin),
                            Text(
                              food.rating!.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                      food.title ?? '',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceText(price: food.price ?? 0),

                        if (food.restaurant?.title != null)
                          Flexible(
                            child: Text(
                              food.restaurant!.title!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
