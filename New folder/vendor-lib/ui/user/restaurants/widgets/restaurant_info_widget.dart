import 'package:latlong2/latlong.dart' as latlong;

import 'widgets.dart';

class RestaurantInfoSection extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantInfoSection({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        12.spMin,
        AppSizes.paddingLg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            restaurant.title ?? 'Restaurant',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.spMin),

          // Address + Rating row
          Row(
            children: [
              if (restaurant.coords?.address != null) ...[
                Icon(
                  Icons.location_on,
                  size: 18.spMin,
                  color: colors.primary,
                ),
                SizedBox(width: 4.spMin),
                Expanded(
                  child: Text(
                    restaurant.coords!.address!,
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.spMin),
              ],
              Icon(
                Icons.star_rounded,
                size: 18.spMin,
                color: Colors.amber,
              ),
              SizedBox(width: 2.spMin),
              Text(
                (restaurant.rating ?? 0).toStringAsFixed(1),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              if (restaurant.ratingCount != null) ...[
                SizedBox(width: 4.spMin),
                Text(
                  '(${restaurant.ratingCount})',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.spMin),

          // Info row — value on top, label below
          _buildInfoRow(context, colors),

          // Delivery / Pickup badges
          if (restaurant.delivery == true || restaurant.pickup == true) ...[
            SizedBox(height: 10.spMin),
            Row(
              children: [
                if (restaurant.delivery == true)
                  BadgeChip(
                    icon: Icons.check_circle_outline,
                    label: 'Delivery',
                    color: colors.success,
                  ),
                if (restaurant.delivery == true && restaurant.pickup == true)
                  SizedBox(width: 8.spMin),
                if (restaurant.pickup == true)
                  BadgeChip(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Pickup',
                    color: colors.info,
                  ),
              ],
            ),
          ],
          SizedBox(height: 16.spMin),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, ThemeColors colors) {
    // Calculate distance
    final userAddress = SessionManager().displayAddress;
    double? distanceKm;
    if (userAddress?.latitude != null &&
        userAddress?.longitude != null &&
        restaurant.coords?.latitude != null &&
        restaurant.coords?.longitude != null) {
      final distance = const latlong.Distance();
      distanceKm = distance.as(
        latlong.LengthUnit.Kilometer,
        latlong.LatLng(userAddress!.latitude!, userAddress.longitude!),
        latlong.LatLng(
          restaurant.coords!.latitude!,
          restaurant.coords!.longitude!,
        ),
      );
    }
    // Est. delivery time (~3 min per km, minimum 10 min)
    final estMinutes =
        distanceKm != null ? (distanceKm * 3).ceil().clamp(10, 120) : null;

    // Distance display
    final distanceText = distanceKm != null
        ? (distanceKm < 1
            ? '${(distanceKm * 1000).toInt()} m'
            : '${distanceKm.toStringAsFixed(1)} km')
        : '--';

    // Delivery fee display
    final feeText = restaurant.deliveryFee != null
        ? (restaurant.deliveryFee == 0
            ? 'Free'
            : formatPrice(restaurant.deliveryFee!))
        : '--';

    // Est. delivery time display
    final timeText = estMinutes != null ? '$estMinutes min' : '--';

    // Opening hours display
    final hoursText = restaurant.openingTime != null
        ? '${restaurant.openingTime}${restaurant.closingTime != null ? ' - ${restaurant.closingTime}' : ''}'
        : '--';

    final items = [
      InfoColumnData(value: timeText, label: 'Delivery time'),
      InfoColumnData(value: feeText, label: 'Delivery fee'),
      InfoColumnData(value: distanceText, label: 'Distance'),
      InfoColumnData(value: hoursText, label: 'Hours'),
    ];

    return IntrinsicHeight(
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: InfoColumn(data: items[i])),
          ],
        ],
      ),
    );
  }
}
