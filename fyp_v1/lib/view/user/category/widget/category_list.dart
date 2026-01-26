import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/category/category_model.dart';
import '../../../../repository/hooks/fatch_all_category.dart';
import '../../../../res/res_imports.dart';

import 'categroy_widget.dart';

class CategoryList extends StatefulHookWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCategory();
    final categoryList = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return Container(
      height: 90.h,
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 2),
      child: isLoading
          ? const CategoriesShimmer()
          : (error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : (categoryList != null && categoryList.isNotEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        categoryList.take(6).length,
                        (i) {
                          CategoryModel category = categoryList[i];
                          return CategoryWidget(categore: category);
                        },
                      ),
                    )
                  : const Center(child: Text('No categories available')))),
    );
  }
}
