import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_bloc.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_event.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_state.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/shared/img_util.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/app_btn.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../di/service_locator.dart';
import '../../../model/home/home_model.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/toast_utils.dart';

class CreateMenuItemPage extends StatelessWidget {
  final FoodItem? existingItem;
  const CreateMenuItemPage({super.key, this.existingItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorMenuBloc>(),
      child: _MenuItemForm(existingItem: existingItem),
    );
  }
}

class _MenuItemForm extends StatefulWidget {
  final FoodItem? existingItem;
  const _MenuItemForm({this.existingItem});

  @override
  State<_MenuItemForm> createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<_MenuItemForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _timeCtrl;

  final _imgUtil = ImgUtil();
  final _api = NetworkServicesApi();

  // Image upload state
  final ValueNotifier<String?> _imagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _imageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isUploadingImage = ValueNotifier<bool>(false);

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _titleCtrl = TextEditingController(text: item?.title);
    _descCtrl = TextEditingController(text: item?.description);
    _priceCtrl = TextEditingController(text: item?.price?.toString());
    _categoryCtrl = TextEditingController(text: item?.category);
    _timeCtrl = TextEditingController(text: item?.time ?? '15-20 min');
    // Pre-fill existing image URL
    if (item?.imageUrl != null && item!.imageUrl!.isNotEmpty) {
      _imageUrl.value = item.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _timeCtrl.dispose();
    _imagePath.dispose();
    _imageUrl.dispose();
    _isUploadingImage.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final file = await _imgUtil.galleryImg();
    if (file == null) return;

    _imagePath.value = file.path;
    _isUploadingImage.value = true;

    try {
      final token = await SessionManager().getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await _api.postMultipartWithAuth(
        AppUrl.uploadFoodImagesUrl,
        file.path,
        'images',
        token,
      );

      final data = response['data'] as Map<String, dynamic>?;
      final urls = data?['imageUrls'] as List?;
      final uploadedUrl = urls?.isNotEmpty == true ? urls!.first as String : null;

      if (mounted) {
        _imageUrl.value = uploadedUrl;
        _isUploadingImage.value = false;
      }
    } catch (e) {
      if (mounted) {
        _isUploadingImage.value = false;
        _imagePath.value = null;
        ToastUtils.showError(context,
            message:
                'Upload failed: ${e.toString().replaceAll('Exception: ', '')}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<VendorMenuBloc, VendorMenuState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ToastUtils.showSuccess(context, message: state.successMessage!);
          Navigator.pop(context);
        }
        if (state.hasError) {
          ToastUtils.showError(context,
              message: state.errorMessage ?? 'Error');
        }
      },
      child: ScreenWrapper(
        mobileHeader:
            CustomHeader(title: isEditing ? 'Edit Item' : 'Add Menu Item'),
        mobile: SingleChildScrollView(
          padding: AppSizes.paddingAllMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                _buildLabel('Item Image', colors),
                AppSizes.verticalSpaceXs,
                _buildImagePicker(colors),

                SizedBox(height: 20.spMin),
                _buildLabel('Item Name', colors),
                AppSizes.verticalSpaceXs,
                TextFormField(
                  controller: _titleCtrl,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Enter item name',
                    prefixIcon: Icon(Icons.restaurant_menu_outlined,
                        color: colors.textSecondary),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 16.spMin),
                _buildLabel('Description', colors),
                AppSizes.verticalSpaceXs,
                TextFormField(
                  controller: _descCtrl,
                  style: AppTextStyles.bodyLarge,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe this item',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 48.spMin),
                      child: Icon(Icons.description_outlined,
                          color: colors.textSecondary),
                    ),
                  ),
                ),

                SizedBox(height: 16.spMin),
                _buildLabel('Price', colors),
                AppSizes.verticalSpaceXs,
                TextFormField(
                  controller: _priceCtrl,
                  style: AppTextStyles.bodyLarge,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter price',
                    prefixIcon: Icon(Icons.attach_money_rounded,
                        color: colors.textSecondary),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 16.spMin),
                _buildLabel('Category', colors),
                AppSizes.verticalSpaceXs,
                TextFormField(
                  controller: _categoryCtrl,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Enter category',
                    prefixIcon: Icon(Icons.category_outlined,
                        color: colors.textSecondary),
                  ),
                ),

                SizedBox(height: 16.spMin),
                _buildLabel('Preparation Time', colors),
                AppSizes.verticalSpaceXs,
                TextFormField(
                  controller: _timeCtrl,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'e.g. 15-20 min',
                    prefixIcon: Icon(Icons.access_time_rounded,
                        color: colors.textSecondary),
                  ),
                ),

                SizedBox(height: 28.spMin),
                BlocBuilder<VendorMenuBloc, VendorMenuState>(
                  builder: (context, state) {
                    return AppButton(
                      width: double.infinity,
                      onPressed: state.isLoading ? () {} : _submit,
                      text: state.isLoading
                          ? 'Saving...'
                          : isEditing
                              ? 'Update Item'
                              : 'Create Item',
                      isLoading: state.isLoading,
                    );
                  },
                ),
                SizedBox(height: 40.spMin),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeColors colors) {
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
    );
  }

  Widget _buildImagePicker(ThemeColors colors) {
    return AnimatedBuilder(
      animation: Listenable.merge([_imagePath, _imageUrl, _isUploadingImage]),
      builder: (context, _) {
        final imagePath = _imagePath.value;
        final imageUrl = _imageUrl.value;
        final isUploading = _isUploadingImage.value;
        final hasImage = imagePath != null || imageUrl != null;

        return GestureDetector(
          onTap: isUploading ? null : _pickAndUploadImage,
          child: Container(
            height: 180.spMin,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasImage ? colors.primary : colors.divider,
                width: hasImage ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: _buildImageContent(colors, imagePath, imageUrl, isUploading),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContent(
    ThemeColors colors,
    String? imagePath,
    String? imageUrl,
    bool isUploading,
  ) {
    if (isUploading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 28.spMin,
              height: 28.spMin,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 8.spMin),
            Text('Uploading...',
                style: AppTextStyles.bodySmall
                    .copyWith(color: colors.textSecondary)),
          ],
        ),
      );
    }

    if (imagePath != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(imagePath), fit: BoxFit.cover),
          if (imageUrl != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(4.spMin),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.check, color: Colors.white, size: 16.spMin),
              ),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(8.spMin),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 18.spMin),
            ),
          ),
        ],
      );
    }

    // Show existing image URL (for editing)
    if (imageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildPlaceholder(colors)),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(8.spMin),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 18.spMin),
            ),
          ),
        ],
      );
    }

    return _buildPlaceholder(colors);
  }

  Widget _buildPlaceholder(ThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 40.spMin, color: colors.textSecondary),
          SizedBox(height: 8.spMin),
          Text('Tap to upload image',
              style: AppTextStyles.bodySmall
                  .copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_isUploadingImage.value) {
      ToastUtils.showInfo(context,
          message: 'Please wait for image to finish uploading');
      return;
    }

    final restState = context.read<VendorRestaurantBloc>().state;
    final restaurantId = restState.activeRestaurant?.id;
    if (restaurantId == null) return;

    final data = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'price': double.tryParse(_priceCtrl.text) ?? 0,
      'pricingType': 'simple',
      'category': _categoryCtrl.text.trim(),
      'time': _timeCtrl.text.trim(),
      'imageUrl': _imageUrl.value != null ? [_imageUrl.value] : [],
      'restaurant': restaurantId,
      'code': 'PK',
    };

    if (isEditing) {
      context.read<VendorMenuBloc>().add(UpdateMenuItem(
            foodId: widget.existingItem!.id!,
            data: data,
            restaurantId: restaurantId,
          ));
    } else {
      context.read<VendorMenuBloc>().add(CreateMenuItem(
            data: data,
            restaurantId: restaurantId,
          ));
    }
  }
}
