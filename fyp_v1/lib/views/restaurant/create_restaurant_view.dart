import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/coustom_button.dart';
import '../../common/res/components/coustom_textformfield.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/utils/utils.dart';
import '../../view models/controllers/vendor_restaurant_view_model.dart';

/// Google Places API key — used only to power the address autocomplete
/// in this form.
const String _googlePlacesApiKey =
    'AIzaSyBfQMZeoFdyicTac5B40P8Uoe9Kx0Bl3W4';

/// Minimal "new restaurant" form for vendor onboarding.
///
/// Collects the fields the backend requires (title, time, address, code,
/// lat/lng, logo URL) and POSTs them to /api/restaurant/.
class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({super.key});

  @override
  State<CreateRestaurantScreen> createState() =>
      _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen> {
  final _vendor = Get.put(VendorRestaurantController());
  final _box = GetStorage();

  final _title = TextEditingController();
  final _time = TextEditingController(text: '30 min');
  final _address = TextEditingController();
  final _code = TextEditingController(text: 'lahr');
  final _lat = TextEditingController(text: '31.5204');
  final _lng = TextEditingController(text: '74.3587');
  final _logo = TextEditingController(
      text:
          'https://cdn-icons-png.flaticon.com/512/3448/3448613.png');

  @override
  void dispose() {
    _title.dispose();
    _time.dispose();
    _address.dispose();
    _code.dispose();
    _lat.dispose();
    _lng.dispose();
    _logo.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty || _address.text.trim().isEmpty) {
      Utils.showWarning('Missing info', 'Title and address are required.');
      return;
    }
    final double? lat = double.tryParse(_lat.text.trim());
    final double? lng = double.tryParse(_lng.text.trim());
    if (lat == null || lng == null) {
      Utils.showWarning('Bad coordinates', 'Latitude / longitude must be numbers.');
      return;
    }

    final String ownerId = _box.read('userId') ?? '';
    if (ownerId.isEmpty) {
      Utils.showError('Not logged in', 'Please log in again.');
      return;
    }

    final body = {
      'title': _title.text.trim(),
      'time': _time.text.trim(),
      'owner': ownerId,
      'code': _code.text.trim(),
      'logoUrl': _logo.text.trim(),
      'imageUrl': _logo.text.trim(),
      'imagesUrl': [_logo.text.trim()],
      'isAvailable': true,
      'coords': {
        'id': ownerId,
        'latitude': lat,
        'longitude': lng,
        'latitudeDelta': 0.0221,
        'longitudeDelta': 0.0221,
        'address': _address.text.trim(),
        'title': _title.text.trim(),
      },
    };

    final ok = await _vendor.createRestaurant(body);
    if (ok && mounted) {
      Get.back(); // Back to RestaurantScreen — it'll rebuild with the new data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Restaurant Application',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Hero illustration (plain icon, no colored backdrop).
          Center(
            child: Image.asset(
              'assets/restaurant.png',
              width: 110.w,
              height: 110.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 14.h),

          // Header explaining the approval process up front.
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: kSecondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: kSecondary),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    color: kSecondary, size: 18.spMin),
                SizedBox(width: 8.w),
                Expanded(
                  child: ReuseableText(
                    text:
                        'Submit this application for admin review. Once approved you can add foods and start accepting orders.',
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w500,
                    textColor: kDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          _label('Restaurant name'),
          CustomTextFormField(
            controller: _title,
            hintText: 'e.g. Kings Foods',
            prefixIcon: const Icon(Icons.storefront_outlined, color: kGray),
          ),
          SizedBox(height: 14.h),

          _label('Prep time'),
          CustomTextFormField(
            controller: _time,
            hintText: 'e.g. 30 min',
            prefixIcon: const Icon(Icons.schedule, color: kGray),
          ),
          SizedBox(height: 14.h),

          _label('Address'),
          // Google Places autocomplete — picking a suggestion also fills
          // latitude / longitude below so the vendor doesn't type them.
          GooglePlaceAutoCompleteTextField(
            textEditingController: _address,
            googleAPIKey: _googlePlacesApiKey,
            inputDecoration: InputDecoration(
              hintText: 'Search your restaurant address',
              prefixIcon:
                  const Icon(Icons.location_on_outlined, color: kGray),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              hintStyle: TextStyle(
                fontSize: 14.spMin,
                fontWeight: FontWeight.w400,
                color: kGray,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimary, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(9.r)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimary, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(9.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimary, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(9.r)),
              ),
            ),
            debounceTime: 400,
            countries: const ['pk'],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction p) {
              if (p.lat != null) _lat.text = p.lat!;
              if (p.lng != null) _lng.text = p.lng!;
            },
            itemClick: (Prediction p) {
              _address.text = p.description ?? '';
              _address.selection = TextSelection.fromPosition(
                TextPosition(offset: _address.text.length),
              );
            },
            itemBuilder: (context, index, Prediction p) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Plain gray icon — no colored backdrop.
                    Icon(Icons.location_on_outlined,
                        color: kGray, size: 18.spMin),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        p.description ?? '',
                        style: TextStyle(
                          fontSize: 13.spMin,
                          color: kDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            seperatedBuilder:
                const Divider(height: 1, color: kOffWhite),
            isCrossBtnShown: true,
            containerHorizontalPadding: 0,
          ),
          SizedBox(height: 14.h),

          _label('Location code'),
          CustomTextFormField(
            controller: _code,
            hintText: 'e.g. lahr',
            prefixIcon: const Icon(Icons.qr_code, color: kGray),
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Latitude'),
                    CustomTextFormField(
                      controller: _lat,
                      hintText: '31.5204',
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
                    _label('Longitude'),
                    CustomTextFormField(
                      controller: _lng,
                      hintText: '74.3587',
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          _label('Logo URL'),
          CustomTextFormField(
            controller: _logo,
            hintText: 'https://...',
            prefixIcon: const Icon(Icons.image_outlined, color: kGray),
          ),
          SizedBox(height: 24.h),

          Obx(() {
            final busy = _vendor.isSaving;
            return AbsorbPointer(
              absorbing: busy,
              child: CustomButton(
                onTap: _submit,
                btnHeight: 48.h,
                radius: 10.r,
                btnColor: busy ? kSecondary : kPrimary,
                text: busy ? 'Submitting…' : 'Submit Application',
              ),
            );
          }),
          SizedBox(height: 10.h),
          ReuseableText(
            text:
                'You will be notified once the admin reviews your application.',
            fontSize: 11.spMin,
            fontWeight: FontWeight.w400,
            textColor: kGray,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: ReuseableText(
        text: text,
        fontSize: 12.spMin,
        fontWeight: FontWeight.w600,
        textColor: kDark,
      ),
    );
  }
}
