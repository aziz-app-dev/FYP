import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/components/reuseable_text.dart';

/// Elegant verification-status banner shown at the top of the
/// vendor's restaurant screen.
///
/// Colors, icon, and headline change based on one of three states
/// returned by the backend: "Pending", "Verified", "Rejected".
class VerificationBanner extends StatelessWidget {
  final String status;
  final String message;

  const VerificationBanner({
    super.key,
    required this.status,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradient,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: style.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: Icon(style.icon, color: Colors.white, size: 24.spMin),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ReuseableText(
                      text: style.title,
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ReuseableText(
                        text: status.toUpperCase(),
                        fontSize: 9.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                ReuseableText(
                  text: message,
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _BannerStyle _styleFor(String status) {
    switch (status) {
      case 'Verified':
        return _BannerStyle(
          title: 'Verified',
          icon: Icons.verified_rounded,
          gradient: const [Color(0xFF30b9b2), Color(0xFF40F3EA)],
          shadow: const Color(0x4030b9b2),
        );
      case 'Rejected':
        return _BannerStyle(
          title: 'Rejected',
          icon: Icons.cancel_rounded,
          gradient: const [Color(0xFFfe104d), Color(0xFFff5a86)],
          shadow: const Color(0x40fe104d),
        );
      case 'Pending':
      default:
        return _BannerStyle(
          title: 'Under Review',
          icon: Icons.hourglass_top_rounded,
          gradient: const [Color(0xFFffa44f), Color(0xFFffc37a)],
          shadow: const Color(0x40ffa44f),
        );
    }
  }
}

class _BannerStyle {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final Color shadow;
  _BannerStyle({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.shadow,
  });
}
