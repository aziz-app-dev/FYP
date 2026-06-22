import 'dart:math' as math show Random;
import 'widgets.dart';

/// Restaurant info card with location and distance
class RestaurantInfoCard extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantInfoCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final coords = restaurant.coords;
    final hasLocation = coords?.latitude != null && coords?.longitude != null;

    return GestureDetector(
      onTap: () {
        if (restaurant.id != null) {
          Navigator.pushNamed(
            context,
            RouteName.restaurantDetails,
            arguments: restaurant.id!,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.spMin),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //! Restaurant logo
                if (restaurant.logoUrl != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colors.surface,
                      border: Border.all(color: colors.secondary),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.logoUrl!,
                        width: 50.spMin,
                        height: 50.spMin,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: colors.shimmerBase,
                          child: Icon(
                            Icons.restaurant,
                            size: 20.spMin,
                            color: colors.iconSecondary,
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: colors.surfaceVariant,
                          child: Icon(
                            Icons.restaurant,
                            size: 20.spMin,
                            color: colors.iconSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 40.spMin,
                    height: 40.spMin,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      size: 20.spMin,
                      color: colors.primary,
                    ),
                  ),
                SizedBox(width: 12.spMin),
                Expanded(
                  child: Column(
                    spacing: 5.spMin,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.title ?? 'Restaurant',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        spacing: 8.spMin,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (restaurant.rating != null) ...[
                            Row(
                              spacing: 4.spMin,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: colors.star,
                                  size: 14.spMin,
                                ),
                                Text(
                                  restaurant.rating!.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 12.spMin,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (restaurant.ratingCount != null) ...[
                            Text(
                              ' (${restaurant.ratingCount})',
                              style: TextStyle(
                                fontSize: 11.spMin,
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                          // Distance (placeholder - would need user location)
                          if (hasLocation) ...[
                            Row(
                              spacing: 4.spMin,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_outlined,
                                  size: 14.spMin,
                                  color: colors.secondary,
                                ),
                                Text(
                                  _calculateDistanceText(
                                    coords!.latitude!,
                                    coords.longitude!,
                                  ),
                                  style: TextStyle(
                                    fontSize: 13.spMin,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.spMin),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateDistanceText(double lat, double lng) {
    final randomDistance = (math.Random().nextDouble() * 5 + 0.5);
    return '${randomDistance.toStringAsFixed(1)} km away';
  }
}

/// Restaurant info card with location and distance
class RestaurantInfoCard2 extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantInfoCard2({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rating = restaurant.rating ?? 0.0;

    return Container(
      padding: EdgeInsets.all(12.spMin),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6.spMin,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Restaurant logo
                if (restaurant.logoUrl != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colors.surface,
                      border: Border.all(color: colors.secondary),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.logoUrl!,
                        width: 50.spMin,
                        height: 50.spMin,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: colors.shimmerBase,
                          child: Icon(
                            Icons.restaurant,
                            size: 20.spMin,
                            color: colors.iconSecondary,
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: colors.surfaceVariant,
                          child: Icon(
                            Icons.restaurant,
                            size: 20.spMin,
                            color: colors.iconSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 40.spMin,
                    height: 40.spMin,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      size: 20.spMin,
                      color: colors.primary,
                    ),
                  ),
                SizedBox(width: 12.spMin),
                Expanded(
                  child: Column(
                    spacing: 5.spMin,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.title ?? 'Restaurant',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        spacing: 5.spMin,
                        children: [
                          Row(
                            spacing: 4.spMin,
                            children: [
                              Icon(
                                Icons.star,
                                color: colors.star,
                                size: 14.spMin,
                              ),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12.spMin,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '(${restaurant.ratingCount ?? 0})',
                            style: TextStyle(
                              fontSize: 11.spMin,
                              color: colors.textTertiary,
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
          InkWell(
            onTap: () {
              if (restaurant.id != null) {
                Navigator.pushNamed(
                  context,
                  RouteName.restaurantDetails,
                  arguments: restaurant.id!,
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.spMin,
                vertical: 10.spMin,
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                "Restaurant",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Style 3: Modern card with shadow, no border, gradient accent
class RestaurantInfoCard3 extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantInfoCard3({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rating = restaurant.rating ?? 0.0;

    return Container(
      padding: EdgeInsets.all(14.spMin),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          if (restaurant.logoUrl != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.primary.withValues(alpha: .2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: restaurant.logoUrl!,
                  width: 60.spMin,
                  height: 60.spMin,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: colors.shimmerBase,
                    width: 60.spMin,
                    height: 60.spMin,
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: colors.surfaceVariant,
                    width: 60.spMin,
                    height: 60.spMin,
                    child: Icon(Icons.restaurant, color: colors.iconSecondary),
                  ),
                ),
              ),
            )
          else
            Container(
              width: 60.spMin,
              height: 60.spMin,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.restaurant,
                size: 28.spMin,
                color: colors.primary,
              ),
            ),
          SizedBox(width: 14.spMin),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.title ?? 'Restaurant',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 6.spMin),
                Row(
                  spacing: 8.spMin,
                  children: [
                    // Rating badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.spMin,
                        vertical: 3.spMin,
                      ),
                      decoration: BoxDecoration(
                        color: colors.star.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 3.spMin,
                        children: [
                          Icon(Icons.star, color: colors.star, size: 12.spMin),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11.spMin,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (restaurant.ratingCount != null)
                      Text(
                        '(${restaurant.ratingCount})',
                        style: TextStyle(
                          fontSize: 11.spMin,
                          color: colors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // View Menu button
          TextButton.icon(
            onPressed: () {
              if (restaurant.id != null) {
                Navigator.pushNamed(
                  context,
                  RouteName.restaurantDetails,
                  arguments: restaurant.id!,
                );
              }
            },
            icon: Icon(Icons.arrow_forward_ios, size: 12.spMin),
            label: Text('Menu', style: TextStyle(fontSize: 12.spMin)),
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              padding: EdgeInsets.symmetric(horizontal: 8.spMin),
            ),
          ),
        ],
      ),
    );
  }
}

/// Style 4: Minimal inline - single row, no border, no background
class RestaurantInfoCard4 extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantInfoCard4({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rating = restaurant.rating ?? 0.0;

    return InkWell(
      onTap: () {
        if (restaurant.id != null) {
          Navigator.pushNamed(
            context,
            RouteName.restaurantDetails,
            arguments: restaurant.id!,
          );
        }
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.spMin),
        child: Row(
          children: [
            // Small logo
            if (restaurant.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: restaurant.logoUrl!,
                  width: 36.spMin,
                  height: 36.spMin,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 36.spMin,
                    height: 36.spMin,
                    color: colors.shimmerBase,
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 36.spMin,
                    height: 36.spMin,
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant,
                      size: 16.spMin,
                      color: colors.iconSecondary,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 36.spMin,
                height: 36.spMin,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 16.spMin,
                  color: colors.primary,
                ),
              ),
            SizedBox(width: 10.spMin),
            // Title
            Expanded(
              child: Text(
                restaurant.title ?? 'Restaurant',
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Rating
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3.spMin,
              children: [
                Icon(Icons.star, color: colors.star, size: 14.spMin),
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12.spMin,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 4.spMin),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.spMin,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
