import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/coustom_button.dart';
import '../../common/res/components/coustom_textformfield.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/utils/utils.dart';
import '../../models/food/food_model.dart';
import '../../view models/controllers/food_crud_view_model.dart';
import '../../view models/controllers/uploader_view_model.dart';

/// Flat edit form for an existing food. Unlike AddFoodsScreen (which
/// is a 4-step wizard for onboarding a new food), this screen shows
/// every field on one page prefilled from [food] and PUTs the result
/// to /api/foods/:id.
class FoodEditScreen extends StatefulWidget {
  final FoodModel food;
  const FoodEditScreen({super.key, required this.food});

  @override
  State<FoodEditScreen> createState() => _FoodEditScreenState();
}

class _FoodEditScreenState extends State<FoodEditScreen> {
  final _crud = Get.put(FoodCrudController());
  final _uploader = Get.put(UploaderController());

  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _time;
  late final TextEditingController _category;

  @override
  void initState() {
    super.initState();
    final f = widget.food;
    _title = TextEditingController(text: f.title);
    _description = TextEditingController(text: f.description);
    _price = TextEditingController(text: f.price.toString());
    _time = TextEditingController(text: f.time);
    _category = TextEditingController(text: f.category);

    // Seed the uploader with the existing main image so the preview
    // shows it and we can swap it for a new upload.
    _uploader.setImageOneUrl =
        f.imageUrl.isNotEmpty ? f.imageUrl.first : '';
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _time.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty ||
        _description.text.trim().isEmpty ||
        _price.text.trim().isEmpty) {
      Utils.showWarning(
          'Missing info', 'Title, description and price are required.');
      return;
    }
    final parsedPrice = double.tryParse(_price.text.trim());
    if (parsedPrice == null) {
      Utils.showWarning('Bad price', 'Price must be a number.');
      return;
    }

    // Prefer a freshly-uploaded image, else keep the existing list.
    final List<String> images = _uploader.imageOneUrl.isNotEmpty
        ? [_uploader.imageOneUrl]
        : widget.food.imageUrl;

    final body = {
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'price': parsedPrice,
      'time': _time.text.trim(),
      'category': _category.text.trim(),
      'imageUrl': images,
      // Keep existing tags/types/additives/etc. — this screen doesn't
      // edit those. Backend spreads whatever we send.
      'foodTags': widget.food.foodTags,
      'foodType': widget.food.foodType,
      'code': widget.food.code,
      'restaurant': widget.food.restaurant,
      'additives':
          widget.food.additives.map((a) => a.toJson()).toList(),
    };

    final ok = await _crud.updateFood(widget.food.id, body);
    if (ok && mounted) {
      // Refresh the list behind us and pop.
      if (widget.food.restaurant.isNotEmpty) {
        _crud.fetchByRestaurant(widget.food.restaurant);
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Edit Food',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Image picker — tap to replace the main image.
          Center(
            child: GestureDetector(
              onTap: () => _uploader.pickImage('one'),
              child: Obx(() {
                final busy = _uploader.isLoading.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: SizedBox(
                        width: 160.w,
                        height: 160.w,
                        child: AppNetworkImage(
                          imageUrl: _uploader.imageOneUrl.isEmpty
                              ? null
                              : _uploader.imageOneUrl,
                          fallbackIcon: Icons.add_photo_alternate,
                          backgroundColor: kOffWhite,
                        ),
                      ),
                    ),
                    if (busy)
                      SizedBox(
                        width: 32.w,
                        height: 32.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimary),
                        ),
                      ),
                    if (!busy)
                      Positioned(
                        right: 6.r,
                        bottom: 6.r,
                        child: Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: const BoxDecoration(
                            color: kPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              color: kLightWhite, size: 14.spMin),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: ReuseableText(
              text: 'Tap to change image',
              fontSize: 11.spMin,
              fontWeight: FontWeight.w400,
              textColor: kGray,
            ),
          ),
          SizedBox(height: 20.h),

          _label('Title'),
          CustomTextFormField(
              hintText: 'Food name', controller: _title),
          SizedBox(height: 14.h),

          _label('Description'),
          CustomTextFormField(
            hintText: 'What\'s in it?',
            controller: _description,
            maxLine: 4,
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Price'),
                    CustomTextFormField(
                      hintText: '0.00',
                      controller: _price,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Prep time'),
                    CustomTextFormField(
                        hintText: '20 min', controller: _time),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          _label('Category'),
          CustomTextFormField(
              hintText: 'burger / pizza / bbq / …', controller: _category),
          SizedBox(height: 24.h),

          Obx(() {
            final busy = _crud.isSubmitting;
            return AbsorbPointer(
              absorbing: busy,
              child: CustomButton(
                onTap: _save,
                btnHeight: 46.h,
                radius: 10.r,
                btnColor: busy ? kSecondary : kPrimary,
                text: busy ? 'Saving…' : 'Save Changes',
              ),
            );
          }),
          SizedBox(height: 8.h),
          ReuseableText(
            text: 'Tags, food types, and additives stay unchanged.',
            fontSize: 11.spMin,
            fontWeight: FontWeight.w400,
            textColor: kGray,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
        child: ReuseableText(
          text: text,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w600,
          textColor: kDark,
        ),
      );
}
