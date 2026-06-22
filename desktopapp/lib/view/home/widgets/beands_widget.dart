import 'dart:io';

import 'package:desktopapp/res/assets/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/brand_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/app_icon.dart';
import '../../../res/components/app_text_widgrt.dart';
import '../../../utils/app_sizes.dart';
import '../../brands/brand_products_view.dart';

Widget buildBrandsCarousel(
  BuildContext context,
  List<Brand> brands,
  WidgetRef ref,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  int crossAxisCount;
  double childAspectRatio;

  if (AppSizes.isMobile(context)) {
    // Mobile
    crossAxisCount = 3;
    childAspectRatio = 1.spMin;
  } else if (AppSizes.isTablet(context)) {
    // Tablet
    crossAxisCount = 5;
    childAspectRatio = 0.99.spMin;
  } else {
    // Desktop
    crossAxisCount = 7;
    childAspectRatio = 0.99.spMin;
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 6.w,
      mainAxisSpacing: 6.h,
      childAspectRatio: childAspectRatio,
    ),
    itemCount: brands.length,
    itemBuilder: (context, index) {
      final brand = brands[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrandProductsView(brand: brand),
            ),
          );
        },
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
            children: [
              // Brand Logo
              brand.imageUrl != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 4.h),
                      width: double.infinity,
                      height: 70.h,
                      child: Image.file(
                        File(brand.imageUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                            ),
                            child: AppIcon(
                              win11IconPath: ImageAssets.win11Brand,
                              defaultIcon: Icons.branding_watermark,
                              size: 30.spMin,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  : Container(
                    width: double.infinity,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                    ),
                    child: AppIcon(
                      win11IconPath: ImageAssets.win11Brand,
                      defaultIcon: Icons.branding_watermark,
                      size: 30.spMin,
                      color: AppColors.primary,
                    ),
                  ),
              SizedBox(height: 8.h),
              // Brand Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: smTextBold(
                  text: brand.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
