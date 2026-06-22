import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/config.dart';
import '../../../../model/home/home_model.dart';

class RecentReservationsSectionWidget extends StatelessWidget {
  final List<RecentReservationItem> reservations;
  final String title;
  final VoidCallback? onViewAll;

  const RecentReservationsSectionWidget({
    super.key,
    required this.reservations,
    this.title = "Upcoming Reservations",
    this.onViewAll,
  });

  Color _statusColor(ThemeColors colors, String? status) {
    switch (status) {
      case 'Confirmed':
        return colors.success;
      case 'Pending':
        return colors.warning;
      case 'Cancelled':
        return colors.error;
      case 'Completed':
        return colors.textSecondary;
      default:
        return colors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  "View All",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.spMin),
        // Horizontal list of reservation cards
        SizedBox(
          height: 130.spMin,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: reservations.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.spMin),
            itemBuilder: (context, index) {
              return _RecentReservationCard(
                reservation: reservations[index],
                statusColor: _statusColor(colors, reservations[index].status),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentReservationCard extends StatelessWidget {
  final RecentReservationItem reservation;
  final Color statusColor;

  const _RecentReservationCard({
    required this.reservation,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final restaurant = reservation.restaurant;

    return Container(
      width: 220.spMin,
      padding: EdgeInsets.all(10.spMin),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant info row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.spMin),
                child: SizedBox(
                  width: 32.spMin,
                  height: 32.spMin,
                  child: restaurant?.logoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: restaurant!.logoUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            color: colors.surface,
                            child: Icon(
                              Icons.restaurant,
                              size: 16.spMin,
                              color: colors.primary,
                            ),
                          ),
                        )
                      : Container(
                          color: colors.surface,
                          child: Icon(
                            Icons.restaurant,
                            size: 16.spMin,
                            color: colors.primary,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 8.spMin),
              Expanded(
                child: Text(
                  restaurant?.title ?? "Restaurant",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.spMin,
                  vertical: 2.spMin,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(6.spMin),
                ),
                child: Text(
                  reservation.status ?? 'Pending',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.spMin,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.spMin),
          // Date & time row
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14.spMin,
                color: colors.primary,
              ),
              SizedBox(width: 6.spMin),
              Text(
                reservation.date != null
                    ? DateFormat('MMM dd, yyyy').format(reservation.date!)
                    : '--',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12.spMin),
              Icon(
                Icons.access_time_rounded,
                size: 14.spMin,
                color: colors.primary,
              ),
              SizedBox(width: 4.spMin),
              Expanded(
                child: Text(
                  reservation.timeSlot ?? '--',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Bottom row: guests + type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 14.spMin,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: 4.spMin),
                  Text(
                    '${reservation.numberOfGuests ?? 0} guest${(reservation.numberOfGuests ?? 0) > 1 ? 's' : ''}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    reservation.reservationType == 'room'
                        ? Icons.meeting_room_outlined
                        : Icons.table_restaurant_outlined,
                    size: 14.spMin,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: 4.spMin),
                  Text(
                    reservation.reservationType == 'room' ? 'Room' : 'Table',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
