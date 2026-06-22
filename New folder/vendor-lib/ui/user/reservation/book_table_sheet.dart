import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../bloc/user/reservation/reservation_bloc.dart';
import '../../../bloc/user/reservation/reservation_event.dart';
import '../../../bloc/user/reservation/reservation_state.dart';
import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../model/reservation/reservation_model.dart';
import '../../../utils/toast_utils.dart';

class BookTableSheet extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const BookTableSheet({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ReservationBloc>()
            ..add(LoadReservationInfoEvent(restaurantId: restaurantId)),
      child: _BookTableContent(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
      ),
    );
  }
}

class _BookTableContent extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const _BookTableContent({
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<_BookTableContent> createState() => _BookTableContentState();
}

class _BookTableContentState extends State<_BookTableContent> {
  final _specialRequestsController = TextEditingController();

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  void _loadSlots(BuildContext context) {
    final state = context.read<ReservationBloc>().state;
    if (state.selectedDate == null) return;

    context.read<ReservationBloc>().add(
      LoadAvailableSlotsEvent(
        restaurantId: widget.restaurantId,
        date: DateFormat('yyyy-MM-dd').format(state.selectedDate!),
        guests: state.selectedGuests,
        area: state.selectedArea,
        type: state.selectedType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state.isSubmitSuccess) {
          Navigator.pop(context, true);
          ToastUtils.showSuccess(context, message: state.successMessage ?? 'Reservation created!');
        }
        if (state.hasError && state.errorMessage != null) {
          ToastUtils.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.spMin),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 12.spMin),
                    width: 40.spMin,
                    height: 4.spMin,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.all(AppSizes.paddingLg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reserve a Table',
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.spMin),
                              Text(
                                widget.restaurantName,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: colors.border),

                  // Content
                  Expanded(
                    child: state.isLoadingInfo
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            controller: scrollController,
                            padding: EdgeInsets.all(AppSizes.paddingLg),
                            children: [
                              // Type selector (Table / Room)
                              if (state.restaurantInfo != null &&
                                  state.restaurantInfo!.totalRooms > 0) ...[
                                _SectionLabel(
                                  label: 'Reservation Type',
                                  colors: colors,
                                ),
                                SizedBox(height: 8.spMin),
                                _TypeSelector(state: state, colors: colors),
                                SizedBox(height: 20.spMin),
                              ],

                              // Restaurant info summary
                              if (state.restaurantInfo != null) ...[
                                _RestaurantInfoSummary(
                                  info: state.restaurantInfo!,
                                  type: state.selectedType,
                                  colors: colors,
                                ),
                                SizedBox(height: 20.spMin),
                              ],

                              // Guest count
                              _SectionLabel(
                                label: 'Number of Guests',
                                colors: colors,
                              ),
                              SizedBox(height: 8.spMin),
                              _GuestSelector(
                                guests: state.selectedGuests,
                                maxCapacity: state.selectedType == 'room'
                                    ? (state.restaurantInfo?.maxRoomCapacity ??
                                          20)
                                    : (state.restaurantInfo?.maxTableCapacity ??
                                          10),
                                colors: colors,
                                onChanged: (guests) {
                                  context.read<ReservationBloc>().add(
                                    SelectGuestsEvent(guests: guests),
                                  );
                                },
                              ),
                              SizedBox(height: 20.spMin),

                              // Area selector
                              if (state.restaurantInfo != null &&
                                  state
                                      .restaurantInfo!
                                      .seatingAreas
                                      .isNotEmpty) ...[
                                _SectionLabel(
                                  label: 'Preferred Area',
                                  colors: colors,
                                ),
                                SizedBox(height: 8.spMin),
                                _AreaSelector(
                                  areas: state.restaurantInfo!.seatingAreas,
                                  selectedArea: state.selectedArea,
                                  colors: colors,
                                  onSelected: (area) {
                                    context.read<ReservationBloc>().add(
                                      SelectAreaEvent(area: area),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.spMin),
                              ],

                              // Date picker
                              _SectionLabel(
                                label: 'Select Date',
                                colors: colors,
                              ),
                              SizedBox(height: 8.spMin),
                              _DateSelector(
                                selectedDate: state.selectedDate,
                                colors: colors,
                                onSelected: (date) {
                                  context.read<ReservationBloc>().add(
                                    SelectDateEvent(date: date),
                                  );
                                  // Auto-load slots when date is selected
                                  context.read<ReservationBloc>().add(
                                    LoadAvailableSlotsEvent(
                                      restaurantId: widget.restaurantId,
                                      date: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(date),
                                      guests: state.selectedGuests,
                                      area: state.selectedArea,
                                      type: state.selectedType,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.spMin),

                              // Time slots
                              if (state.selectedDate != null) ...[
                                _SectionLabel(
                                  label: 'Available Time Slots',
                                  colors: colors,
                                ),
                                SizedBox(height: 8.spMin),
                                if (state.isLoadingSlots)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.spMin,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (state.availableSlots.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.spMin,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No slots available for this date',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: colors.textSecondary,
                                            ),
                                      ),
                                    ),
                                  )
                                else
                                  _TimeSlotGrid(
                                    slots: state.availableSlots,
                                    selectedSlot: state.selectedTimeSlot,
                                    colors: colors,
                                    onSelected: (slot) {
                                      context.read<ReservationBloc>().add(
                                        SelectTimeSlotEvent(timeSlot: slot),
                                      );
                                    },
                                  ),
                                SizedBox(height: 20.spMin),
                              ],

                              // Special requests
                              _SectionLabel(
                                label: 'Special Requests (Optional)',
                                colors: colors,
                              ),
                              SizedBox(height: 8.spMin),
                              TextField(
                                controller: _specialRequestsController,
                                maxLines: 3,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Any special requests or preferences...',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: colors.textSecondary.withValues(
                                      alpha: .5,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: colors.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.spMin,
                                    ),
                                    borderSide: BorderSide(
                                      color: colors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.spMin,
                                    ),
                                    borderSide: BorderSide(
                                      color: colors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.spMin,
                                    ),
                                    borderSide: BorderSide(
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.spMin),
                            ],
                          ),
                  ),

                  // Book button
                  Container(
                    padding: EdgeInsets.all(AppSizes.paddingLg),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      border: Border(top: BorderSide(color: colors.border)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.spMin,
                        child: ElevatedButton(
                          onPressed: state.canSubmit && !state.isSubmitting
                              ? () {
                                  context.read<ReservationBloc>().add(
                                    CreateReservationEvent(
                                      restaurantId: widget.restaurantId,
                                      specialRequests:
                                          _specialRequestsController.text,
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.textOnPrimary,
                            disabledBackgroundColor: colors.border,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.spMin),
                            ),
                          ),
                          child: state.isSubmitting
                              ? SizedBox(
                                  width: 24.spMin,
                                  height: 24.spMin,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.textOnPrimary,
                                  ),
                                )
                              : Text(
                                  'Book Now',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: state.canSubmit
                                        ? colors.textOnPrimary
                                        : colors.textSecondary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ThemeColors colors;

  const _SectionLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.titleSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final ReservationState state;
  final ThemeColors colors;

  const _TypeSelector({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeChip(
          label: 'Table',
          icon: Icons.table_restaurant_outlined,
          isSelected: state.selectedType == 'table',
          colors: colors,
          onTap: () => context.read<ReservationBloc>().add(
            const SelectTypeEvent(type: 'table'),
          ),
        ),
        SizedBox(width: 12.spMin),
        _TypeChip(
          label: 'Room',
          icon: Icons.meeting_room_outlined,
          isSelected: state.selectedType == 'room',
          colors: colors,
          onTap: () => context.read<ReservationBloc>().add(
            const SelectTypeEvent(type: 'room'),
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final ThemeColors colors;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.spMin),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: .1)
                : colors.surface,
            borderRadius: BorderRadius.circular(12.spMin),
            border: Border.all(
              color: isSelected ? colors.primary : colors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.spMin,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              SizedBox(width: 8.spMin),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantInfoSummary extends StatelessWidget {
  final ReservationRestaurantInfo info;
  final String type;
  final ThemeColors colors;

  const _RestaurantInfoSummary({
    required this.info,
    required this.type,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.spMin),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.spMin),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(
            icon: Icons.table_restaurant,
            value: '${info.totalTables}',
            label: 'Tables',
            colors: colors,
          ),
          if (info.totalRooms > 0)
            _InfoItem(
              icon: Icons.meeting_room,
              value: '${info.totalRooms}',
              label: 'Rooms',
              colors: colors,
            ),
          _InfoItem(
            icon: Icons.people,
            value: '${info.totalSeatingCapacity}',
            label: 'Seats',
            colors: colors,
          ),
          _InfoItem(
            icon: Icons.group,
            value:
                '${type == "room" ? info.maxRoomCapacity : info.maxTableCapacity}',
            label: 'Max/Unit',
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final ThemeColors colors;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22.spMin, color: colors.primary),
        SizedBox(height: 4.spMin),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _GuestSelector extends StatelessWidget {
  final int guests;
  final int maxCapacity;
  final ThemeColors colors;
  final ValueChanged<int> onChanged;

  const _GuestSelector({
    required this.guests,
    required this.maxCapacity,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.remove,
          colors: colors,
          onTap: guests > 1 ? () => onChanged(guests - 1) : null,
        ),
        SizedBox(width: 20.spMin),
        Text(
          '$guests',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(width: 20.spMin),
        _CircleButton(
          icon: Icons.add,
          colors: colors,
          onTap: guests < maxCapacity ? () => onChanged(guests + 1) : null,
        ),
        SizedBox(width: 16.spMin),
        Text(
          'guest${guests > 1 ? 's' : ''}',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final ThemeColors colors;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, required this.colors, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.spMin,
        height: 36.spMin,
        decoration: BoxDecoration(
          color: enabled
              ? colors.primary.withValues(alpha: .1)
              : colors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? colors.primary : colors.border),
        ),
        child: Icon(
          icon,
          size: 18.spMin,
          color: enabled
              ? colors.primary
              : colors.textSecondary.withValues(alpha: .3),
        ),
      ),
    );
  }
}

class _AreaSelector extends StatelessWidget {
  final List<String> areas;
  final String? selectedArea;
  final ThemeColors colors;
  final ValueChanged<String?> onSelected;

  const _AreaSelector({
    required this.areas,
    required this.selectedArea,
    required this.colors,
    required this.onSelected,
  });

  IconData _areaIcon(String area) {
    switch (area.toLowerCase()) {
      case 'outdoor':
        return Icons.park_outlined;
      case 'rooftop':
        return Icons.roofing_outlined;
      case 'garden':
        return Icons.local_florist_outlined;
      case 'window':
        return Icons.window_outlined;
      case 'balcony':
        return Icons.balcony_outlined;
      case 'vip':
        return Icons.star_outline;
      case 'private':
        return Icons.lock_outline;
      default:
        return Icons.restaurant_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: [
        // "Any" option
        _AreaChip(
          label: 'Any',
          icon: Icons.all_inclusive,
          isSelected: selectedArea == null,
          colors: colors,
          onTap: () => onSelected(null),
        ),
        ...areas.map(
          (area) => _AreaChip(
            label: area,
            icon: _areaIcon(area),
            isSelected: selectedArea == area,
            colors: colors,
            onTap: () => onSelected(area == selectedArea ? null : area),
          ),
        ),
      ],
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final ThemeColors colors;
  final VoidCallback onTap;

  const _AreaChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 8.spMin),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: .1)
              : colors.surface,
          borderRadius: BorderRadius.circular(20.spMin),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.spMin,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            SizedBox(width: 6.spMin),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ThemeColors colors;
  final ValueChanged<DateTime> onSelected;

  const _DateSelector({
    required this.selectedDate,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(14, (i) => today.add(Duration(days: i)));

    return SizedBox(
      height: 80.spMin,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.spMin),
        itemBuilder: (_, index) {
          final date = dates[index];
          final isSelected =
              selectedDate != null &&
              date.year == selectedDate!.year &&
              date.month == selectedDate!.month &&
              date.day == selectedDate!.day;

          return GestureDetector(
            onTap: () => onSelected(date),
            child: Container(
              width: 56.spMin,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(12.spMin),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 3),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? colors.textOnPrimary
                          : colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.spMin),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? colors.textOnPrimary
                          : colors.textPrimary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.spMin,
                      color: isSelected
                          ? colors.textOnPrimary.withValues(alpha: .8)
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  final List<TimeSlotInfo> slots;
  final String? selectedSlot;
  final ThemeColors colors;
  final ValueChanged<String> onSelected;

  const _TimeSlotGrid({
    required this.slots,
    required this.selectedSlot,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: slots.map((slot) {
        final isSelected = selectedSlot == slot.timeSlot;
        final isDisabled = !slot.isAvailable;

        return GestureDetector(
          onTap: isDisabled ? null : () => onSelected(slot.timeSlot),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.spMin,
              vertical: 10.spMin,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary
                  : isDisabled
                  ? colors.surface.withValues(alpha: .5)
                  : colors.surface,
              borderRadius: BorderRadius.circular(10.spMin),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : isDisabled
                    ? colors.border.withValues(alpha: .3)
                    : colors.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  slot.timeSlot,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? colors.textOnPrimary
                        : isDisabled
                        ? colors.textSecondary.withValues(alpha: .4)
                        : colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.spMin),
                Text(
                  '${slot.available} left',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10.spMin,
                    color: isSelected
                        ? colors.textOnPrimary.withValues(alpha: .8)
                        : isDisabled
                        ? colors.error.withValues(alpha: .5)
                        : colors.success,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
