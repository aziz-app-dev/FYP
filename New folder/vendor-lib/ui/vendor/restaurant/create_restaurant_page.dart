import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_event.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_state.dart';
import '../../../model/home/home_model.dart';
import '../../../bloc/shared/img_util.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/app_btn.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/loaders_utils.dart';
import '../../../utils/toast_utils.dart';

class CreateRestaurantPage extends StatefulWidget {
  const CreateRestaurantPage({super.key});

  @override
  State<CreateRestaurantPage> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(text: '30-45 min');
  final _addressCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  final _imgUtil = ImgUtil();
  final _api = NetworkServicesApi();

  final ValueNotifier<int> _currentStep = ValueNotifier<int>(0);

  // Location state
  final ValueNotifier<bool> _isLoadingLocation = ValueNotifier<bool>(false);

  // Image upload state
  final ValueNotifier<String?> _coverImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _coverImageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isUploadingCover = ValueNotifier<bool>(false);

  final ValueNotifier<String?> _logoImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _logoImageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isUploadingLogo = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    final user = SessionManager().user;
    if (user?.phone != null && user!.phone!.isNotEmpty) {
      _phoneCtrl.text = user.phone!;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    _timeCtrl.dispose();
    _addressCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _currentStep.dispose();
    _isLoadingLocation.dispose();
    _coverImagePath.dispose();
    _coverImageUrl.dispose();
    _isUploadingCover.dispose();
    _logoImagePath.dispose();
    _logoImageUrl.dispose();
    _isUploadingLogo.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    _isLoadingLocation.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ToastUtils.showError(
            context,
            message: 'Location services are disabled',
          );
        }
        _isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ToastUtils.showError(
              context,
              message: 'Location permission denied',
            );
          }
          _isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ToastUtils.showError(
            context,
            message:
                'Location permission permanently denied. '
                'Please enable it in settings.',
          );
        }
        _isLoadingLocation.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        _latCtrl.text = position.latitude.toStringAsFixed(6);
        _lngCtrl.text = position.longitude.toStringAsFixed(6);
        _isLoadingLocation.value = false;
        ToastUtils.showSuccess(context, message: 'Location detected');
      }
    } catch (e) {
      if (mounted) {
        _isLoadingLocation.value = false;
        ToastUtils.showError(context, message: 'Failed to get location');
      }
    }
  }

  Future<void> _pickAndUploadImage({required bool isCover}) async {
    final file = await _imgUtil.galleryImg();
    if (file == null) return;

    if (isCover) {
      _coverImagePath.value = file.path;
      _isUploadingCover.value = true;
    } else {
      _logoImagePath.value = file.path;
      _isUploadingLogo.value = true;
    }

    try {
      final token = await SessionManager().getToken();
      if (token == null) throw Exception('Not authenticated');

      final url = isCover
          ? AppUrl.uploadRestaurantImageUrl
          : AppUrl.uploadRestaurantLogoUrl;
      final fieldName = isCover ? 'image' : 'logo';

      final response = await _api.postMultipartWithAuth(
        url,
        file.path,
        fieldName,
        token,
      );

      final data = response['data'] as Map<String, dynamic>?;
      final imageUrl = isCover
          ? (data?['imageUrl'] as String?)
          : (data?['logoUrl'] as String?);

      if (mounted) {
        if (isCover) {
          _coverImageUrl.value = imageUrl;
          _isUploadingCover.value = false;
        } else {
          _logoImageUrl.value = imageUrl;
          _isUploadingLogo.value = false;
        }
      }
    } catch (e) {
      if (mounted) {
        if (isCover) {
          _isUploadingCover.value = false;
          _coverImagePath.value = null;
        } else {
          _isUploadingLogo.value = false;
          _logoImagePath.value = null;
        }
        ToastUtils.showError(
          context,
          message:
              'Upload failed: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<VendorRestaurantBloc, VendorRestaurantState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ToastUtils.showSuccess(context, message: state.successMessage!);
          Navigator.pop(context);
        }
        if (state.hasError && !state.hasRestaurant) {
          ToastUtils.showError(context, message: state.errorMessage ?? 'Error');
        }
      },
      builder: (context, state) {
        // Show loading while fetching existing restaurants
        if (state.isLoading && !state.hasRestaurant) {
          return ScreenWrapper(
            mobileHeader: CustomHeader(title: 'Create Restaurant'),
            mobile: appLoader(color: colors.primary),
          );
        }

        // If user already has a restaurant request, show its status
        final existing = state.activeRestaurant;
        if (existing != null && existing.verification != 'Verified') {
          return _buildRequestStatusView(context, existing, colors, state);
        }

        return _buildCreationForm(context, colors, state);
      },
    );
  }

  Widget _buildRequestStatusView(
    BuildContext context,
    RestaurantItem restaurant,
    ThemeColors colors,
    VendorRestaurantState state,
  ) {
    final status = restaurant.verification ?? 'Pending';
    final isRejected = status == 'Rejected';
    final isInReview = status == 'In Review';
    final message = restaurant.verificationMessage;

    // Status display config
    final String statusTitle;
    final String defaultMessage;
    final Color statusColor;

    if (isRejected) {
      statusTitle = 'Application Rejected';
      defaultMessage = 'Your restaurant application has been rejected.';
      statusColor = Colors.red;
    } else if (isInReview) {
      statusTitle = 'Application In Review';
      defaultMessage =
          'Your restaurant is currently being reviewed by our team. This may take 1-3 business days.';
      statusColor = Colors.blue;
    } else {
      statusTitle = 'Application Submitted';
      defaultMessage =
          'Your restaurant application has been submitted. It will be picked up for review shortly.';
      statusColor = Colors.orange;
    }

    return ScreenWrapper(
      mobileHeader: CustomHeader(title: 'Application Status'),
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(24.spMin),
        child: Column(
          children: [
            SizedBox(height: 40.spMin),

            // Status icon / animation
            if (isRejected)
              Container(
                width: 100.spMin,
                height: 100.spMin,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 50.spMin,
                  color: Colors.red,
                ),
              )
            else
              Lottie.asset(
                'assets/lottie/Sandy Loading.json',
                width: 160.spMin,
                height: 160.spMin,
              ),
            SizedBox(height: 24.spMin),

            // Status title
            Text(
              statusTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.spMin),

            // Status message
            Text(
              message ?? defaultMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 32.spMin),

            // Restaurant info card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.spMin),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant image + name
                  Row(
                    children: [
                      if (restaurant.logoUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            restaurant.logoUrl!,
                            width: 48.spMin,
                            height: 48.spMin,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 48.spMin,
                              height: 48.spMin,
                              color: colors.divider,
                              child: Icon(
                                Icons.store,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 48.spMin,
                          height: 48.spMin,
                          decoration: BoxDecoration(
                            color: colors.divider,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.store, color: colors.textSecondary),
                        ),
                      SizedBox(width: 12.spMin),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.title ?? 'Restaurant',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (restaurant.phone != null)
                              Text(
                                restaurant.phone!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.spMin,
                          vertical: 4.spMin,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (restaurant.coords?.address != null) ...[
                    SizedBox(height: 12.spMin),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.spMin,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 6.spMin),
                        Expanded(
                          child: Text(
                            restaurant.coords!.address!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.spMin),

            // Refresh button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: state.isLoading
                    ? () {}
                    : () => context.read<VendorRestaurantBloc>().add(
                        LoadMyRestaurants(),
                      ),
                text: state.isLoading ? 'Checking...' : 'Refresh Status',
                isLoading: state.isLoading,
              ),
            ),

            // Edit & Resubmit for rejected
            if (isRejected) ...[
              SizedBox(height: 12.spMin),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Delete the rejected restaurant so user can create a new one
                    context.read<VendorRestaurantBloc>().add(
                      DeleteRestaurant(restaurantId: restaurant.id!),
                    );
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18.spMin,
                    color: colors.primary,
                  ),
                  label: Text(
                    'Delete & Resubmit New',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.spMin),
                    side: BorderSide(color: colors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreationForm(
    BuildContext context,
    ThemeColors colors,
    VendorRestaurantState blocState,
  ) {
    return ScreenWrapper(
      mobileHeader: CustomHeader(title: 'Create Restaurant'),
      mobile: AnimatedBuilder(
        animation: Listenable.merge([
          _currentStep,
          _isLoadingLocation,
          _coverImagePath,
          _coverImageUrl,
          _isUploadingCover,
          _logoImagePath,
          _logoImageUrl,
          _isUploadingLogo,
        ]),
        builder: (context, _) {
          final currentStep = _currentStep.value;
          final isLoadingLocation = _isLoadingLocation.value;
          return Stepper(
        currentStep: currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) => _currentStep.value = step,
        controlsBuilder: (context, details) {
          return Padding(
            padding: EdgeInsets.only(top: 16.spMin),
            child: Row(
              children: [
                if (currentStep < 2)
                  Expanded(
                    child: AppButton(
                      onPressed: details.onStepContinue ?? () {},
                      text: 'Continue',
                    ),
                  )
                else
                  Expanded(
                    child:
                        BlocBuilder<
                          VendorRestaurantBloc,
                          VendorRestaurantState
                        >(
                          builder: (context, state) {
                            return AppButton(
                              onPressed: state.isLoading ? () {} : _submitForm,
                              text: state.isLoading
                                  ? 'Submitting...'
                                  : 'Submit Application',
                              isLoading: state.isLoading,
                            );
                          },
                        ),
                  ),
                if (currentStep > 0) ...[
                  SizedBox(width: 12.spMin),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(
                      'Back',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Basic Info
          Step(
            title: Text(
              'Basic Info',
              style: TextStyle(color: colors.textPrimary),
            ),
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Restaurant Name', colors),
                  AppSizes.verticalSpaceXs,
                  TextFormField(
                    controller: _titleCtrl,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Enter restaurant name',
                      prefixIcon: Icon(
                        Icons.store_outlined,
                        color: colors.textSecondary,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 16.spMin),
                  _buildLabel('Phone Number', colors),
                  AppSizes.verticalSpaceXs,
                  TextFormField(
                    controller: _phoneCtrl,
                    style: AppTextStyles.bodyLarge,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: colors.textSecondary,
                      ),
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
                      hintText: 'Describe your restaurant',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 48.spMin),
                        child: Icon(
                          Icons.description_outlined,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.spMin),
                  _buildLabel('Delivery Time', colors),
                  AppSizes.verticalSpaceXs,
                  TextFormField(
                    controller: _timeCtrl,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'e.g. 30-45 min',
                      prefixIcon: Icon(
                        Icons.access_time_rounded,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Step 2: Location
          Step(
            title: Text(
              'Location',
              style: TextStyle(color: colors.textPrimary),
            ),
            isActive: currentStep >= 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Google Places autocomplete
                _buildLabel('Search Address', colors),
                AppSizes.verticalSpaceXs,
                _buildPlacesAutocomplete(colors),

                SizedBox(height: 16.spMin),

                // Current location button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isLoadingLocation ? null : _useCurrentLocation,
                    icon: isLoadingLocation
                        ? SizedBox(
                            width: 18.spMin,
                            height: 18.spMin,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.primary,
                            ),
                          )
                        : Icon(
                            Icons.my_location_rounded,
                            size: 20.spMin,
                            color: colors.primary,
                          ),
                    label: Text(
                      isLoadingLocation
                          ? 'Detecting...'
                          : 'Use Current Location',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.spMin),
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.spMin),

                // Editable lat/lng fields
                _buildLabel('Coordinates', colors),
                AppSizes.verticalSpaceXs,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latCtrl,
                        style: AppTextStyles.bodyLarge,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Latitude',
                          prefixIcon: Icon(
                            Icons.north_rounded,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.spMin),
                    Expanded(
                      child: TextFormField(
                        controller: _lngCtrl,
                        style: AppTextStyles.bodyLarge,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Longitude',
                          prefixIcon: Icon(
                            Icons.east_rounded,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Step 3: Images (Cloudinary upload)
          Step(
            title: Text('Images', style: TextStyle(color: colors.textPrimary)),
            isActive: currentStep >= 2,
            state: StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Cover Image', colors),
                AppSizes.verticalSpaceXs,
                _buildImagePicker(
                  localPath: _coverImagePath.value,
                  uploadedUrl: _coverImageUrl.value,
                  isUploading: _isUploadingCover.value,
                  height: 160.spMin,
                  icon: Icons.panorama_outlined,
                  hint: 'Tap to upload cover image',
                  onTap: () => _pickAndUploadImage(isCover: true),
                  colors: colors,
                ),
                SizedBox(height: 20.spMin),
                _buildLabel('Logo', colors),
                AppSizes.verticalSpaceXs,
                Center(
                  child: _buildImagePicker(
                    localPath: _logoImagePath.value,
                    uploadedUrl: _logoImageUrl.value,
                    isUploading: _isUploadingLogo.value,
                    height: 120.spMin,
                    width: 120.spMin,
                    borderRadius: 60,
                    icon: Icons.add_a_photo_outlined,
                    hint: 'Logo',
                    onTap: () => _pickAndUploadImage(isCover: false),
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
        },
      ),
    );
  }

  Widget _buildPlacesAutocomplete(ThemeColors colors) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: _addressCtrl,
      googleAPIKey: AppUrl.googlePlacesApiKey,
      inputDecoration: InputDecoration(
        hintText: 'Search for your restaurant address',
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: colors.textSecondary,
        ),
      ),
      textStyle: AppTextStyles.bodyLarge,
      debounceTime: 400,
      countries: const ['pk'],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        _latCtrl.text = prediction.lat?.toString() ?? '';
        _lngCtrl.text = prediction.lng?.toString() ?? '';
      },
      itemClick: (Prediction prediction) {
        _addressCtrl.text = prediction.description ?? '';
        _addressCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: _addressCtrl.text.length),
        );
      },
      seperatedBuilder: Divider(height: 1, color: colors.divider),
      itemBuilder: (context, index, Prediction prediction) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.spMin,
            vertical: 10.spMin,
          ),
          child: Row(
            children: [
              Icon(
                Icons.place_outlined,
                size: 20.spMin,
                color: colors.textSecondary,
              ),
              SizedBox(width: 10.spMin),
              Expanded(
                child: Text(
                  prediction.description ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      isCrossBtnShown: true,
    );
  }

  Widget _buildLabel(String text, ThemeColors colors) {
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
    );
  }

  Widget _buildImagePicker({
    required String? localPath,
    required String? uploadedUrl,
    required bool isUploading,
    required double height,
    double? width,
    double borderRadius = 12,
    required IconData icon,
    required String hint,
    required VoidCallback onTap,
    required ThemeColors colors,
  }) {
    final hasImage = localPath != null || uploadedUrl != null;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: hasImage ? colors.primary : colors.divider,
            width: hasImage ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: _buildImageContent(
            localPath: localPath,
            uploadedUrl: uploadedUrl,
            isUploading: isUploading,
            icon: icon,
            hint: hint,
            colors: colors,
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent({
    required String? localPath,
    required String? uploadedUrl,
    required bool isUploading,
    required IconData icon,
    required String hint,
    required ThemeColors colors,
  }) {
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
            Text(
              'Uploading...',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (localPath != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(localPath), fit: BoxFit.cover),
          if (uploadedUrl != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(4.spMin),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16.spMin),
              ),
            ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36.spMin, color: colors.textSecondary),
          SizedBox(height: 8.spMin),
          Text(
            hint,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep.value == 0 && !_formKey.currentState!.validate()) return;
    if (_currentStep.value < 2) {
      _currentStep.value = _currentStep.value + 1;
    }
  }

  void _onStepCancel() {
    if (_currentStep.value > 0) {
      _currentStep.value = _currentStep.value - 1;
    }
  }

  void _submitForm() {
    if (_isUploadingCover.value || _isUploadingLogo.value) {
      ToastUtils.showInfo(
        context,
        message: 'Please wait for images to finish uploading',
      );
      return;
    }

    final data = {
      'title': _titleCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'time': _timeCtrl.text.trim(),
      'imageUrl': _coverImageUrl.value ?? 'https://via.placeholder.com/400x200',
      'logoUrl': _logoImageUrl.value ?? 'https://via.placeholder.com/100',
      'code': 'PK',
      'coords': {
        'id': '1',
        'latitude': double.tryParse(_latCtrl.text) ?? 0.0,
        'longitude': double.tryParse(_lngCtrl.text) ?? 0.0,
        'longitudeDelta': 0.0221,
        'latitudeDelta': 0.0221,
        'address': _addressCtrl.text.trim(),
        'title': _titleCtrl.text.trim(),
      },
    };

    context.read<VendorRestaurantBloc>().add(CreateRestaurant(data: data));
  }
}
