import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/res_imports.dart';

import '../../../models/category/category_model.dart';
import '../../../repository/hooks/fatch_all_category.dart';
import '../../../view_models/controller/category/category_view_model.dart';
import 'widget/category_tile.dart';

class AllCategoriesScreen extends HookWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    final hookResult = useFetchCategory();
    List<CategoryModel>? categoryList = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
        backgroundColor: kOffWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              categoryController.categoryValue == '';
              categoryController.title == '';
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: BackGroundContainer(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(top: 10.h, left: 12.w),
            height: height,
            child: isLoading
                ? const FoodListShimmer()
                : (error != null
                    ? Center(child: Text('Error: ${error.toString()}'))
                    : SizedBox(
                        height: 120.h, // Adjust as needed
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: List.generate(
                            categoryList!.length,
                            (i) {
                              CategoryModel category = categoryList[i];
                              return SizedBox(
                                width: 100.0, // Adjust width as needed
                                child: CategoryTile(category: category),
                              );
                            },
                          ),
                        ),
                      )),
          )),
    );
  }
}
