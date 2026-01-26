import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../models/category/category_model.dart';
import '../../../../res/res_imports.dart';
import '../../../../view_models/controller/category/category_view_model.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
  });

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();
    return ListTile(
      onTap: () {
        categoryController.updateCategory = category.id;
        categoryController.updateTitle = category.title;
        Get.toNamed(RouteName.categoryScreen);
      },
      leading: CircleAvatar(
        radius: 25.r,
        backgroundColor: kGrayLight,
        child: Image.network(
          category.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      title: ReuseableText(
        text: category.title,
        textColor: kGray,
        fontSize: 15,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: kGray,
        size: 15.r,
      ),
    );
  }
}
