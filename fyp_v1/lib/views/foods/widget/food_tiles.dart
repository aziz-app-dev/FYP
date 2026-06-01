import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/app_network_image.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../models/food/food_model.dart';

/// Vendor-side food tile. Displays the food + three action chips:
/// availability toggle, edit, and delete.
///
/// Tapping the tile body (not the action chips) triggers [onTap],
/// which the caller uses to open the food details page.
class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    required this.food,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  final FoodModel food;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: kOffWhite,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            // Tile body — tappable for details.
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Row(
                children: [
                  AppNetworkImage(
                    imageUrl:
                        food.imageUrl.isEmpty ? null : food.imageUrl.first,
                    width: 62.w,
                    height: 62.h,
                    borderRadius: BorderRadius.circular(10.r),
                    fallbackIcon: Icons.fastfood,
                    backgroundColor: kWhite,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          text: food.title,
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                        ),
                        ReuseableText(
                          text:
                              '${food.time} · ${food.category} · \$${food.price.toStringAsFixed(2)}',
                          fontSize: 10.spMin,
                          fontWeight: FontWeight.w400,
                          textColor: kGray,
                        ),
                        if (food.foodType.isNotEmpty)
                          ReuseableText(
                            text: food.foodType.join(' · '),
                            fontSize: 9.spMin,
                            fontWeight: FontWeight.w400,
                            textColor: kGray,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: food.isAvailable ? kPrimary : kGray,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: ReuseableText(
                      text: food.isAvailable ? 'Live' : 'Off',
                      fontSize: 10.spMin,
                      fontWeight: FontWeight.w600,
                      textColor: kLightWhite,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                // Toggle availability — takes most of the row.
                Expanded(
                  child: GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: kSecondary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: ReuseableText(
                        text: food.isAvailable
                            ? 'Set Unavailable'
                            : 'Set Available',
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w600,
                        textColor: kPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Edit.
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.edit_outlined,
                        color: kLightWhite, size: 16.spMin),
                  ),
                ),
                SizedBox(width: 8.w),
                // Delete.
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      color: kRed,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.delete_outline,
                        color: kLightWhite, size: 18.spMin),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
