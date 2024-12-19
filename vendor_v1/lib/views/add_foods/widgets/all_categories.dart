import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../common/utils/uid.dart';
import '../../../view models/controllers/food_view_model.dart';

class ChooseCategory extends HookWidget {
  const ChooseCategory({
    super.key,
    required this.next,
  });
  final Function() next;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());
    return SizedBox(
      height: height,
      child: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 8.w, top: 12.h, bottom: 12.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReuseableText(
                      text: 'Pick Category',
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.w600),
                  ReuseableText(
                      text:
                          'You are to pick a category to continue adding a food item',
                      fontSize: 11.spMin,
                      fontWeight: FontWeight.normal),
                ],
              )),
          SizedBox(
            height: height,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  onTap: () {
                    controller.setCategory = category['_id'];
                    next();
                  },
                  leading: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: kPrimary,
                      child: category['imageUrl'] != null
                          ? Image.network(
                              category['imageUrl'],
                              fit: BoxFit.contain,
                            )
                          : const Icon(Icons.food_bank_rounded)),
                  title: ReuseableText(
                      text: category['title'],
                      fontSize: 12.spMin,
                      textColor: kGray,
                      fontWeight: FontWeight.normal),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kGray,
                    size: 15.spMin,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
