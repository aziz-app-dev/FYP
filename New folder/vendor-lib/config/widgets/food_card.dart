import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/config/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:food/config/widgets/resturnt_card.dart';
import 'package:food/utils/loaders_utils.dart';

import '../config.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;
  final double price;
  final String? time;
  final bool freeDelivery;
  final VoidCallback? onAddPressed;
  final VoidCallback? onTap;
  final double? width;
  final String? description;
  final List<String>? foodType;
  final String? restaurantName;
  final String? restaurantLogo;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  const FoodCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    this.time,
    this.freeDelivery = false,
    this.onAddPressed,
    this.onTap,
    this.width,
    this.description,
    this.foodType,
    this.restaurantName,
    this.restaurantLogo,
    this.isFavorite = false,
    this.onFavoritePressed,
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
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: appLoader()),
                          errorWidget: (context, url, error) => Icon(
                            Icons.fastfood,
                            size: 50.spMin,
                            color: colors.iconSecondary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.spMin,
                      left: 8.spMin,
                      child: RatingsContiner(rating: rating),
                    ),
                    // Food type badges
                    // if (foodType != null && foodType!.isNotEmpty)
                    //   Positioned(
                    //     top: 8.spMin,
                    //     right: 8.spMin,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: foodType!.take(2).map((type) {
                    //         return Padding(
                    //           padding: EdgeInsets.only(bottom: 4.spMin),
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: 6.spMin,
                    //               vertical: 2.spMin,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               color: Colors.black54,
                    //               borderRadius: BorderRadius.circular(4),
                    //             ),
                    //             child: Text(
                    //               type,
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 10.spMin,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // Favorite heart icon
                    if (onFavoritePressed != null)
                      Positioned(
                        top: 8.spMin,
                        right: 8.spMin,
                        child: GestureDetector(
                          onTap: onFavoritePressed,
                          child: Container(
                            padding: EdgeInsets.all(6.spMin),
                            decoration: BoxDecoration(
                              color: colors.card,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 18.spMin,
                              color: isFavorite
                                  ? AppColors.error
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSizes.paddingXs.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.spMin,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.spMin),
                        PriceText(price: price, fontSize: 15.spMin),
                      ],
                    ),
                    SizedBox(height: 4.spMin),

                    // Description
                    // if (description != null && description!.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.only(bottom: 4.spMin),
                    //     child: Text(
                    //       description!,
                    //       style: AppTextStyles.bodySmall.copyWith(
                    //         color: colors.textSecondary,
                    //         fontSize: 11.spMin,
                    //       ),
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ),

                    // Time + Restaurant info
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13.spMin,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 3.spMin),
                        Text(
                          time ?? "15-20 min",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                            fontSize: 11.spMin,
                          ),
                        ),
                        if (restaurantName != null) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.spMin),
                            child: Icon(
                              Icons.circle,
                              size: 3.spMin,
                              color: colors.textSecondary,
                            ),
                          ),
                          if (restaurantLogo != null)
                            Padding(
                              padding: EdgeInsets.only(right: 4.spMin),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: restaurantLogo!,
                                  width: 14.spMin,
                                  height: 14.spMin,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => Icon(
                                    TablerIcons.building_store,
                                    size: 12.spMin,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          Flexible(
                            child: Text(
                              restaurantName!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                                fontSize: 11.spMin,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (freeDelivery) ...[
                          SizedBox(width: 6.spMin),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.spMin,
                              vertical: 1.spMin,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusRound,
                              ),
                            ),
                            child: Text(
                              "Free",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textOnPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.spMin,
                              ),
                            ),
                          ),
                        ],
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
