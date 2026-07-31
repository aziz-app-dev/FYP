import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../models/category/category_model.dart';
import '../../../../res/res_imports.dart';
import '../../../../view_models/controller/category/category_view_model.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.categore,
  });

  final CategoryModel categore;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return GestureDetector(
      onTap: () {
        if (controller.categoryValue == categore.id) {
          // Deselect the category if it's already selected
          controller.updateCategory = '';
          controller.updateTitle = '';
        } else {
          // Select a new category
          controller.updateCategory = categore.id;
          controller.updateTitle = categore.title;
        }
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(right: 5.w),
          padding: EdgeInsets.only(top: 6.h),
          width: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: controller.categoryValue == categore.id
                  ? kSecondary
                  : kOffWhite,
              width: .5.w,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
                child: categore.imageUrl.isNotEmpty
                    ? Image.network(
                        categore.imageUrl,
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.image_not_supported),
              ),
              Text(
                categore.title,
                style: TextStyle(
                  fontSize: 12.spMin,
                  color: kDark,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
