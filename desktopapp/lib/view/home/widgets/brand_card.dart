import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/components/app_icon.dart';
import '../../../res/components/app_text_widgrt.dart';
import '../../../utils/app_sizes.dart';

/// A generic card used on the home page for both brands and categories.
///
/// It renders an image (loaded from a local file path) with a colored
/// icon fallback, plus a centered title underneath.
class BrandCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Color accentColor;
  final IconData fallbackIcon;
  final String fallbackWin11Icon;
  final VoidCallback onTap;

  const BrandCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.accentColor,
    required this.fallbackIcon,
    required this.fallbackWin11Icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd.r),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 70.h,
                child: _buildImage(),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: smTextBold(
                text: title,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null) {
      return _fallback();
    }
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Image.file(
        File(imageUrl!),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: AppIcon(
        win11IconPath: fallbackWin11Icon,
        defaultIcon: fallbackIcon,
        size: 30.spMin,
        color: accentColor,
      ),
    );
  }
}

/// Shared grid layout for the brand / category carousels so both sections
/// stay visually identical.
class HomeCardGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const HomeCardGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount;
    if (AppSizes.isMobile(context)) {
      crossAxisCount = 3;
    } else if (AppSizes.isTablet(context)) {
      crossAxisCount = 5;
    } else {
      crossAxisCount = 7;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
        childAspectRatio: 0.99.spMin,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
