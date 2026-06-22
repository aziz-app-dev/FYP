import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../bloc/user/reservation/reservation_bloc.dart';
import '../../../bloc/user/reservation/reservation_event.dart';
import '../../../bloc/user/reservation/reservation_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../di/service_locator.dart';
import '../../../model/reservation/reservation_model.dart';
import '../../../utils/toast_utils.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ReservationBloc>()..add(const LoadUserReservationsEvent()),
      child: const _MyReservationsView(),
    );
  }
}

class _MyReservationsView extends StatelessWidget {
  const _MyReservationsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ToastUtils.showSuccess(context, message: state.successMessage!);
        }
      },
      builder: (context, state) {
        return ScreenWrapper(
          useMobileScaffold: false,
          mobileHeader: const CustomHeader(title: 'My Reservations'),
          isLoading: state.isLoadingReservations,
          hasError: state.hasError && state.userReservations.isEmpty,
          isNetworkError: isNetworkError(state.errorMessage),
          errorTitle: 'Failed to load reservations',
          errorMessage: state.errorMessage ?? 'Something went wrong',
          isEmpty: state.isReservationsLoaded && state.userReservations.isEmpty,
          emptyTitle: 'No Reservations',
          emptyMessage: 'You haven\'t made any reservations yet',
          emptyIcon: Icons.table_restaurant_outlined,
          onRetry: () {
            context.read<ReservationBloc>().add(
              const LoadUserReservationsEvent(),
            );
          },
          mobile:
              state.isReservationsLoaded || state.userReservations.isNotEmpty
              ? _ReservationsList(state: state)
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _ReservationsList extends StatelessWidget {
  final ReservationState state;

  const _ReservationsList({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final upcoming = state.upcomingReservations;
    final past = state.pastReservations;

    return ListView(
      padding: EdgeInsets.all(AppSizes.paddingLg),
      children: [
        if (upcoming.isNotEmpty) ...[
          Text(
            'Upcoming',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 12.spMin),
          ...upcoming.map(
            (r) => _ReservationCard(reservation: r, showCancel: true),
          ),
        ],
        if (upcoming.isNotEmpty && past.isNotEmpty) SizedBox(height: 24.spMin),
        if (past.isNotEmpty) ...[
          Text(
            'Past',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 12.spMin),
          ...past.map(
            (r) => _ReservationCard(reservation: r, showCancel: false),
          ),
        ],
      ],
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final bool showCancel;

  const _ReservationCard({required this.reservation, required this.showCancel});

  Color _statusColor(ThemeColors colors) {
    switch (reservation.status) {
      case 'Pending':
        return colors.warning;
      case 'Confirmed':
        return colors.success;
      case 'Cancelled':
        return colors.error;
      case 'Completed':
        return colors.info;
      default:
        return colors.textSecondary;
    }
  }

  IconData _statusIcon() {
    switch (reservation.status) {
      case 'Pending':
        return Icons.schedule;
      case 'Confirmed':
        return Icons.check_circle;
      case 'Cancelled':
        return Icons.cancel;
      case 'Completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statusColor = _statusColor(colors);

    return Container(
      margin: EdgeInsets.only(bottom: 12.spMin),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16.spMin),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Restaurant info row
          Padding(
            padding: EdgeInsets.all(12.spMin),
            child: Row(
              children: [
                // Restaurant logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.spMin),
                  child: SizedBox(
                    width: 48.spMin,
                    height: 48.spMin,
                    child: reservation.restaurant?.logoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: reservation.restaurant!.logoUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: colors.surface,
                              child: Icon(
                                Icons.restaurant,
                                color: colors.primary,
                                size: 24.spMin,
                              ),
                            ),
                          )
                        : Container(
                            color: colors.surface,
                            child: Icon(
                              Icons.restaurant,
                              color: colors.primary,
                              size: 24.spMin,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.spMin),
                // Restaurant name + status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.restaurant?.title ?? 'Restaurant',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.spMin),
                      Row(
                        children: [
                          Icon(
                            _statusIcon(),
                            size: 14.spMin,
                            color: statusColor,
                          ),
                          SizedBox(width: 4.spMin),
                          Text(
                            reservation.status ?? 'Pending',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Type badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.spMin,
                    vertical: 4.spMin,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8.spMin),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        reservation.reservationType == 'room'
                            ? Icons.meeting_room
                            : Icons.table_restaurant,
                        size: 14.spMin,
                        color: colors.primary,
                      ),
                      SizedBox(width: 4.spMin),
                      Text(
                        reservation.reservationType == 'room'
                            ? 'Room'
                            : 'Table',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),
          // Details
          Padding(
            padding: EdgeInsets.all(12.spMin),
            child: Column(
              children: [
                Row(
                  children: [
                    _DetailItem(
                      icon: Icons.calendar_today,
                      value: reservation.date != null
                          ? DateFormat('MMM dd, yyyy').format(reservation.date!)
                          : '--',
                      colors: colors,
                    ),
                    SizedBox(width: 16.spMin),
                    _DetailItem(
                      icon: Icons.access_time,
                      value: reservation.timeSlot ?? '--',
                      colors: colors,
                    ),
                  ],
                ),
                SizedBox(height: 8.spMin),
                Row(
                  children: [
                    _DetailItem(
                      icon: Icons.people,
                      value:
                          '${reservation.numberOfGuests ?? 0} guest${(reservation.numberOfGuests ?? 0) > 1 ? 's' : ''}',
                      colors: colors,
                    ),
                    if (reservation.areaPreference != null ||
                        reservation.tableDetails?.area != null) ...[
                      SizedBox(width: 16.spMin),
                      _DetailItem(
                        icon: Icons.place,
                        value:
                            reservation.areaPreference ??
                            reservation.tableDetails?.area ??
                            '',
                        colors: colors,
                      ),
                    ],
                  ],
                ),
                // Table/Room details
                if (reservation.tableDetails != null) ...[
                  SizedBox(height: 8.spMin),
                  Row(
                    children: [
                      _DetailItem(
                        icon: Icons.tag,
                        value:
                            'Table #${reservation.tableDetails!.tableNumber}',
                        colors: colors,
                      ),
                      SizedBox(width: 16.spMin),
                      _DetailItem(
                        icon: Icons.chair,
                        value: '${reservation.tableDetails!.capacity} seats',
                        colors: colors,
                      ),
                    ],
                  ),
                ],
                if (reservation.roomDetails != null) ...[
                  SizedBox(height: 8.spMin),
                  Row(
                    children: [
                      _DetailItem(
                        icon: Icons.tag,
                        value: 'Room #${reservation.roomDetails!.roomNumber}',
                        colors: colors,
                      ),
                      SizedBox(width: 16.spMin),
                      _DetailItem(
                        icon: Icons.chair,
                        value: '${reservation.roomDetails!.capacity} capacity',
                        colors: colors,
                      ),
                    ],
                  ),
                  if (reservation.roomDetails!.amenities != null &&
                      reservation.roomDetails!.amenities!.isNotEmpty) ...[
                    SizedBox(height: 8.spMin),
                    Row(
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 14.spMin,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 4.spMin),
                        Expanded(
                          child: Text(
                            reservation.roomDetails!.amenities!.join(', '),
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
                ],
              ],
            ),
          ),
          // Cancel button
          if (showCancel && reservation.canCancel) ...[
            Divider(height: 1, color: colors.border),
            Padding(
              padding: EdgeInsets.all(12.spMin),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showCancelDialog(context, reservation.id!);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error.withValues(alpha: .3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.spMin),
                    ),
                  ),
                  child: Text(
                    'Cancel Reservation',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String reservationId) {
    final colors = context.colors;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.cardBackground,
        title: Text(
          'Cancel Reservation',
          style: AppTextStyles.titleMedium.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to cancel this reservation?',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('No', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ReservationBloc>().add(
                CancelReservationEvent(reservationId: reservationId),
              );
            },
            child: Text('Yes, Cancel', style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final ThemeColors colors;

  const _DetailItem({
    required this.icon,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14.spMin, color: colors.textSecondary),
          SizedBox(width: 6.spMin),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
