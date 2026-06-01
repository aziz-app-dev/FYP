import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../models/food/food_model.dart';
import 'food_edit_view.dart';

/// Read-only detail view for a food item. Shown when the vendor taps
/// a tile on the Foods list. An Edit icon in the AppBar jumps to the
/// FoodEditScreen.
class FoodDetailsScreen extends StatelessWidget {
  final FoodModel food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Food Details',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
        actions: [
          IconButton(
            tooltip: 'Edit food',
            icon: Icon(Icons.edit_outlined,
                color: kLightWhite, size: 22.spMin),
            onPressed: () => Get.to(
              () => FoodEditScreen(food: food),
              transition: Transition.rightToLeft,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(14.r),
        children: [
          // Hero image.
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: AppNetworkImage(
                imageUrl: food.imageUrl.isEmpty ? null : food.imageUrl.first,
                fallbackIcon: Icons.fastfood,
                backgroundColor: kOffWhite,
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Title + price + availability chip.
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: kOffWhite),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ReuseableText(
                        text: food.title,
                        fontSize: 18.spMin,
                        fontWeight: FontWeight.w800,
                        textColor: kDark,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: food.isAvailable ? kPrimary : kGray,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: ReuseableText(
                        text: food.isAvailable ? 'Live' : 'Off',
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: kLightWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ReuseableText(
                  text: '\$${food.price.toStringAsFixed(2)}',
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kPrimary,
                ),
                if (food.description.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  ReuseableText(
                    text: food.description,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w400,
                    textColor: kGray,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Meta.
          _metaCard(
            rows: [
              _MetaRow(icon: Icons.schedule, label: 'Prep time', value: food.time),
              _MetaRow(
                icon: Icons.category_outlined,
                label: 'Category',
                value: food.category,
              ),
              _MetaRow(
                icon: Icons.qr_code,
                label: 'Code',
                value: food.code,
              ),
              _MetaRow(
                icon: Icons.star_rounded,
                label: 'Rating',
                value: food.rating == 0 ? '—' : food.rating.toString(),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Food types (Lunch/Dinner/etc.).
          if (food.foodType.isNotEmpty) ...[
            _sectionLabel('Food types'),
            _chipRow(food.foodType, kPrimary),
            SizedBox(height: 12.h),
          ],

          // Tags.
          if (food.foodTags.isNotEmpty) ...[
            _sectionLabel('Tags'),
            _chipRow(food.foodTags, kSecondary),
            SizedBox(height: 12.h),
          ],

          // Additives.
          if (food.additives.isNotEmpty) ...[
            _sectionLabel('Additives'),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: kOffWhite),
              ),
              child: Column(
                children: food.additives.map((a) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReuseableText(
                          text: a.title,
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w500,
                          textColor: kDark,
                        ),
                        ReuseableText(
                          text: '\$${a.price}',
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w700,
                          textColor: kPrimary,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metaCard({required List<_MetaRow> rows}) => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: kOffWhite),
        ),
        child: Column(
          children: rows
              .map((r) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Icon(r.icon, color: kPrimary, size: 16.spMin),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: ReuseableText(
                            text: r.label,
                            fontSize: 12.spMin,
                            fontWeight: FontWeight.w500,
                            textColor: kGray,
                          ),
                        ),
                        ReuseableText(
                          text: r.value.isEmpty ? '—' : r.value,
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w700,
                          textColor: kDark,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );

  Widget _sectionLabel(String s) => Padding(
        padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
        child: ReuseableText(
          text: s,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w700,
          textColor: kGray,
        ),
      );

  Widget _chipRow(List<String> items, Color accent) => Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: items
            .map((t) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ReuseableText(
                    text: t,
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w600,
                    textColor: accent,
                  ),
                ))
            .toList(),
      );
}

class _MetaRow {
  final IconData icon;
  final String label;
  final String value;
  _MetaRow({required this.icon, required this.label, required this.value});
}
