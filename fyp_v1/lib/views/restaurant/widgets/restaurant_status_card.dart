import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../models/restaurant/restaurant_model.dart';

/// High-level "dashboard" card showing the restaurant's live status
/// in one glance: Open/Closed indicator, verification chip, and the
/// three key metrics (prep time, rating, location code).
///
/// Takes a live [RestaurantModel] and returns a polished rounded card
/// styled to match the app's teal + orange palette.
class RestaurantStatusCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantStatusCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final isOpen = restaurant.isAvailable;
    final isVerified = restaurant.verification == 'Verified';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOpen
              ? const [Color(0xFF30b9b2), Color(0xFF40F3EA)]
              : const [Color(0xFF83829A), Color(0xFFC1C0C8)],
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isOpen ? kPrimary : kGray).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: status dot + label + verification chip
          Row(
            children: [
              _StatusDot(isOpen: isOpen),
              SizedBox(width: 10.w),
              ReuseableText(
                text: isOpen ? 'Shop is Open' : 'Shop is Closed',
                fontSize: 16.spMin,
                fontWeight: FontWeight.w700,
                textColor: kLightWhite,
              ),
              const Spacer(),
              _VerificationChip(
                status: restaurant.verification,
                isVerified: isVerified,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ReuseableText(
            text: isOpen
                ? 'Accepting new orders right now.'
                : isVerified
                    ? 'Tap the open-sign above to start accepting orders.'
                    : 'Awaiting admin approval before going live.',
            fontSize: 11.spMin,
            fontWeight: FontWeight.w400,
            textColor: kLightWhite,
          ),
          SizedBox(height: 14.h),

          // Metric row: prep time · rating · code
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon: Icons.schedule_rounded,
                    label: 'Prep',
                    value: restaurant.time.isEmpty ? '—' : restaurant.time,
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _Metric(
                    icon: Icons.star_rounded,
                    label: 'Rating',
                    value: restaurant.rating == 0
                        ? '—'
                        : restaurant.rating.toStringAsFixed(1),
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _Metric(
                    icon: Icons.place_rounded,
                    label: 'Code',
                    value: restaurant.code.isEmpty
                        ? '—'
                        : restaurant.code.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isOpen;
  const _StatusDot({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOpen ? const Color(0xFFB5F5A6) : Colors.white70,
        boxShadow: isOpen
            ? [
                BoxShadow(
                  color: const Color(0xFFB5F5A6).withValues(alpha: 0.8),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

class _VerificationChip extends StatelessWidget {
  final String status;
  final bool isVerified;
  const _VerificationChip({required this.status, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (status) {
      'Verified' => Icons.verified_rounded,
      'Rejected' => Icons.cancel_rounded,
      _ => Icons.hourglass_top_rounded,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.spMin, color: kLightWhite),
          SizedBox(width: 4.w),
          ReuseableText(
            text: status,
            fontSize: 10.spMin,
            fontWeight: FontWeight.w700,
            textColor: kLightWhite,
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kLightWhite, size: 20.spMin),
        SizedBox(height: 2.h),
        ReuseableText(
          text: value,
          fontSize: 13.spMin,
          fontWeight: FontWeight.w700,
          textColor: kLightWhite,
        ),
        ReuseableText(
          text: label,
          fontSize: 10.spMin,
          fontWeight: FontWeight.w400,
          textColor: kLightWhite,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36.h,
      color: Colors.white.withValues(alpha: 0.22),
    );
  }
}
