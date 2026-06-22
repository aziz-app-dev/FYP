import 'package:cached_network_image/cached_network_image.dart';
import '../../config/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/user/wishlist/wishlist_bloc.dart';
import '../../bloc/user/wishlist/wishlist_state.dart';
import '../../config/theme/app_sizes.dart';
import '../../config/theme/theme_colors.dart';

import '../../bloc/user/wishlist/wishlist_event.dart';
import '../../model/home/home_model.dart';
import '../../utils/loaders_utils.dart';
import '../theme/app_colors.dart' show AppColors;
import '../theme/app_text_styles.dart';

class FavCard extends StatelessWidget {
  final FoodItem food;
  const FavCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusMd),
                  ),
                  child: food.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: food.imageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: colors.border,
                            child: Center(child: appLoader(size: 30)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colors.border,
                            child: Icon(
                              Icons.fastfood,
                              color: colors.textSecondary,
                            ),
                          ),
                        )
                      : Container(
                          color: colors.border,
                          child: Icon(
                            Icons.fastfood,
                            color: colors.textSecondary,
                          ),
                        ),
                ),
                Positioned(
                  top: 8.spMin,
                  right: 8.spMin,
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          if (food.id != null) {
                            context.read<WishlistBloc>().add(
                              RemoveFromWishlistEvent(food.id!),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.spMin),
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow.withValues(alpha: .1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 18.spMin,
                            color: colors.error,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.spMin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title ?? 'Unknown',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (food.restaurant?.title != null) ...[
                    SizedBox(height: 2.spMin),
                    Text(
                      food.restaurant!.title!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(price: food.price ?? 0),

                      Container(
                        padding: EdgeInsets.all(6.spMin),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16.spMin,
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
    );
  }
}
