import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/category/category_model.dart';
import '../../../../res/res_imports.dart';

import 'categroy_widget.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel>? categories;
  final bool isLoading;
  final Exception? error;

  const CategoryList({
    super.key,
    required this.categories,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 2),
      child: isLoading
          ? const CategoriesShimmer()
          : (error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : (categories != null && categories!.isNotEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        categories!.take(6).length,
                        (i) {
                          CategoryModel category = categories![i];
                          return CategoryWidget(categore: category);
                        },
                      ),
                    )
                  : const Center(child: Text('No categories available')))),
    );
  }
}
