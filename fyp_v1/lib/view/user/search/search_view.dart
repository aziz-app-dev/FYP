import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../res/res_imports.dart';
import '../../../view_models/controller/search/search_view_model.dart';
import 'search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = Get.put(FoodSearchController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 74.h,
              automaticallyImplyLeading: false,
              backgroundColor: kOffWhite,
              title: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: CustomTextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  hintText: 'Search for foods',
                  suffixIcon: GestureDetector(
                      onTap: () {
                        if (searchController.searchFoodList.isEmpty) {
                          searchController
                              .searchSearchApi(_searchController.text);
                        } else {
                          searchController.searchFoodList.clear();
                          _searchController.clear();
                        }
                      },
                      child: searchController.searchFoodList.isEmpty
                          ? Icon(
                              Ionicons.search_circle,
                              color: kPrimary,
                              size: 40.spMin,
                            )
                          : Icon(
                              Ionicons.close_circle,
                              color: kRed,
                              size: 40.spMin,
                            )),
                ),
              ),
            ),
            body: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r)),
                    child: Container(
                        color: kOffWhite,
                        width: double.infinity,
                        child: SingleChildScrollView(
                            child: searchController.isLoading
                                ? const FoodListShimmer()
                                : searchController.searchFoodList.isEmpty
                                    ? const LoadingWidget()
                                    : const SearchResult()))),
              ),
            ),
          );
        },
      ),
    );
  }
}
