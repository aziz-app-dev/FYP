import 'dart:io';

import 'package:desktopapp/res/components/app_text_widgrt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/category_model.dart';
import '../../../res/assets/image_assets.dart';
import '../../../res/components/app_icon.dart';
import '../../../utils/app_sizes.dart';
import '../../../view_models/providers/home_page_provider.dart';
import 'cat_items_View.dart';

Widget buildCategoriesCarousel(
  BuildContext context,
  List<Category> categories,
  WidgetRef ref,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  int crossAxisCount;
  double childAspectRatio;

  if (AppSizes.isMobile(context)) {
    // Mobile
    crossAxisCount = 3;
    childAspectRatio = 0.99.spMin;
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
      crossAxisCount: crossAxisCount, // 4 columns
      crossAxisSpacing: 6.w,
      mainAxisSpacing: 6.h,

      childAspectRatio: childAspectRatio, // Square cards
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final category = categories[index];
      return GestureDetector(
        onTap: () async {
          // Navigate to category products view
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryProductsView(category: category),
            ),
          );
          // Check if widget is still mounted before using ref
          if (context.mounted) {
            ref.read(homePageProvider.notifier).refreshProducts();
          }
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
              // Category Icon
              category.imageUrl != null
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
                        File(category.imageUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                            ),
                            child: AppIcon(
                              win11IconPath: ImageAssets.win11Category,
                              defaultIcon: Icons.category,
                              size: 30.spMin,
                              color: Colors.purple,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  : Container(
                    width: double.infinity,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                    ),
                    child: AppIcon(
                      win11IconPath: ImageAssets.win11Category,
                      defaultIcon: Icons.category,
                      size: 30.spMin,
                      color: Colors.purple,
                    ),
                  ),
              SizedBox(height: 8.h),
              // Category Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: smTextBold(
                  text: category.name,
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
