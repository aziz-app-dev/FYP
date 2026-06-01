import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/coustom_button.dart';
import '../../common/res/components/coustom_textformfield.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/routes/routes_name.dart';
import '../../common/utils/utils.dart';
import '../../view models/controllers/uploader_view_model.dart';
import '../../view models/controllers/vendor_analytics_view_model.dart';
import '../../view models/controllers/vendor_restaurant_view_model.dart';
import 'widgets/cancelled_orders_card.dart';
import 'widgets/restaurant_cover_header.dart';
import 'widgets/sales_bar_chart.dart';
import 'widgets/stats_cards.dart';
import 'widgets/top_sellers_card.dart';
import 'widgets/verification_banner.dart';

/// Restaurant management: view active restaurant, toggle availability,
/// edit title/time, or create a new restaurant if the vendor has none.
class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final _vendor = Get.put(VendorRestaurantController());
  final _analytics = Get.put(VendorAnalyticsController());
  final _uploader = Get.put(UploaderController());

  // Edit form fields — all optional except title & time.
  final _title = TextEditingController();
  final _time = TextEditingController();
  final _address = TextEditingController();
  final _code = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();
  final _logo = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _vendor.fetchMine();
    // Analytics are only meaningful once we know the restaurant
    // is verified — fetch them in that case so the dashboard is ready.
    if (_vendor.isVerified) {
      _analytics.fetch();
    }
  }

  void _startEdit() {
    final r = _vendor.active;
    if (r == null) return;
    _title.text = r.title;
    _time.text = r.time;
    _address.text = r.coords.address;
    _code.text = r.code;
    _lat.text = r.coords.latitude.toString();
    _lng.text = r.coords.longitude.toString();
    _logo.text = r.logoUrl;
    // Seed the uploader with the current logo so the Obx reflects it.
    _uploader.setLogoUrl = r.logoUrl;
    setState(() => _editing = true);
  }

  Future<void> _saveEdit() async {
    final r = _vendor.active;
    if (r == null) return;
    if (_title.text.trim().isEmpty || _time.text.trim().isEmpty) {
      Utils.showWarning('Missing', 'Title and time are required.');
      return;
    }
    final lat = double.tryParse(_lat.text.trim());
    final lng = double.tryParse(_lng.text.trim());
    if (lat == null || lng == null) {
      Utils.showWarning(
          'Bad coordinates', 'Latitude/longitude must be numbers.');
      return;
    }

    // Prefer a freshly-uploaded logo if the vendor picked a new one,
    // otherwise fall back to whatever they typed/kept in the text field.
    final logoUrl = _uploader.logoUrl.isNotEmpty
        ? _uploader.logoUrl
        : _logo.text.trim();

    final ok = await _vendor.updateRestaurant(r.id, {
      'title': _title.text.trim(),
      'time': _time.text.trim(),
      'code': _code.text.trim(),
      'logoUrl': logoUrl,
      'imageUrl': logoUrl, // backend uses imageUrl as the cover
      'coords': {
        'id': r.owner,
        'latitude': lat,
        'longitude': lng,
        'latitudeDelta': 0.0221,
        'longitudeDelta': 0.0221,
        'address': _address.text.trim(),
        'title': _title.text.trim(),
      },
    });
    if (ok && mounted) setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'My Restaurant',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
        actions: [
          // Edit action — only visible when a restaurant is loaded and
          // we're not already in edit mode.
          Obx(() {
            final r = _vendor.active;
            if (r == null || _editing) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Edit restaurant',
              icon: Icon(Icons.edit_outlined,
                  color: kLightWhite, size: 22.spMin),
              onPressed: _startEdit,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_vendor.isLoading) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }
        final r = _vendor.active;
        if (r == null) {
          return _empty(context);
        }
        return ListView(
          padding: EdgeInsets.all(14.r),
          children: [
            // Only show the verification banner when the restaurant is
            // NOT yet verified. Once verified, the cover header's green
            // check badge communicates the status on its own — the
            // "under review" banner was staying visible because the
            // backend never overwrote `verificationMessage`.
            if (r.verification != 'Verified') ...[
              VerificationBanner(
                status: r.verification,
                message: r.verificationMessage,
              ),
              SizedBox(height: 14.h),
            ],

            // Redesigned cover header — banner + overlapping logo +
            // verified badge + quick stats row. The open-sign image
            // on the cover is tappable and now doubles as the
            // Open/Closed toggle (replaces the old status card).
            RestaurantCoverHeader(restaurant: r),
            SizedBox(height: 14.h),

            // Old compact identity card removed — the cover header now
            // surfaces all of that info at a larger scale.
            Offstage(
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: kOffWhite),
                ),
                child: Row(
                  children: [
                    AppNetworkAvatar(
                      imageUrl: r.logoUrl,
                      radius: 28.r,
                      backgroundColor: kOffWhite,
                      fallbackIcon: Icons.storefront,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseableText(
                            text: r.title,
                            fontSize: 15.spMin,
                            fontWeight: FontWeight.w700,
                            textColor: kDark,
                          ),
                          SizedBox(height: 2.h),
                          ReuseableText(
                            text: r.coords.address,
                            fontSize: 11.spMin,
                            fontWeight: FontWeight.w400,
                            textColor: kGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // End of the legacy identity card (kept offstage).

            // Analytics dashboard — Verified restaurants only.
            if (r.verification == 'Verified') ...[
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, left: 2.w),
                child: ReuseableText(
                  text: 'Dashboard',
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kGray,
                ),
              ),
              const StatsCards(),
              SizedBox(height: 12.h),
              const SalesBarChart(),
              SizedBox(height: 12.h),
              const TopSellersCard(),
              SizedBox(height: 12.h),
              const CancelledOrdersCard(),
              SizedBox(height: 14.h),
            ],

            // Edit form
            if (_editing) ...[
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: kOffWhite),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReuseableText(
                      text: 'Edit Restaurant',
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: kDark,
                    ),
                    SizedBox(height: 12.h),

                    // Logo picker — tap to upload a new image via
                    // Cloudinary (UploaderController).
                    Center(
                      child: GestureDetector(
                        onTap: () => _uploader.pickImage('logo'),
                        child: Obx(() {
                          final busy = _uploader.isLoading.value;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              AppNetworkAvatar(
                                imageUrl: _uploader.logoUrl,
                                radius: 44.r,
                                backgroundColor: kOffWhite,
                                fallbackIcon: Icons.add_photo_alternate,
                              ),
                              if (busy)
                                SizedBox(
                                  width: 32.w,
                                  height: 32.w,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              kPrimary)),
                                ),
                              if (!busy)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: kPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.camera_alt_outlined,
                                        color: kLightWhite,
                                        size: 14.spMin),
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
                        text: 'Tap to change logo',
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _label('Restaurant name'),
                    CustomTextFormField(
                        hintText: 'e.g. Kings Foods', controller: _title),
                    SizedBox(height: 12.h),

                    _label('Prep time'),
                    CustomTextFormField(
                        hintText: 'e.g. 30 min', controller: _time),
                    SizedBox(height: 12.h),

                    _label('Address'),
                    CustomTextFormField(
                      hintText: 'Street, City, Country',
                      controller: _address,
                      prefixIcon:
                          const Icon(Icons.location_on_outlined, color: kGray),
                    ),
                    SizedBox(height: 12.h),

                    _label('Location code'),
                    CustomTextFormField(
                        hintText: 'e.g. lahr', controller: _code),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Latitude'),
                              CustomTextFormField(
                                hintText: '31.5204',
                                controller: _lat,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
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
                                hintText: '74.3587',
                                controller: _lng,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () => setState(() => _editing = false),
                            btnHeight: 44.h,
                            radius: 9.r,
                            btnColor: kGray,
                            text: 'Cancel',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Obx(() => CustomButton(
                                onTap:
                                    _vendor.isSaving ? null : _saveEdit,
                                btnHeight: 44.h,
                                radius: 9.r,
                                btnColor: _vendor.isSaving
                                    ? kSecondary
                                    : kPrimary,
                                text: _vendor.isSaving ? 'Saving…' : 'Save',
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else if (r.verification == 'Verified') ...[
              // Open/Close toggle moved to the open-sign image on the
              // cover header. Edit moved to the AppBar action. No
              // bottom action row needed here anymore.
              const SizedBox.shrink(),
            ] else ...[
              // Pending or Rejected: no controls, just a disabled-looking card
              // explaining why the shop isn't accepting orders yet.
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      r.verification == 'Rejected'
                          ? Icons.cancel_rounded
                          : Icons.hourglass_top_rounded,
                      color: r.verification == 'Rejected' ? kRed : kSecondary,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseableText(
                            text: r.verification == 'Rejected'
                                ? 'Application rejected'
                                : 'Waiting for admin approval',
                            fontSize: 12.spMin,
                            fontWeight: FontWeight.w700,
                            textColor: kDark,
                          ),
                          SizedBox(height: 2.h),
                          ReuseableText(
                            text: r.verification == 'Rejected'
                                ? 'You will not be able to manage this restaurant until a new application is approved.'
                                : 'Shop controls unlock once your restaurant is verified.',
                            fontSize: 10.spMin,
                            fontWeight: FontWeight.w400,
                            textColor: kGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Logout was moved to the Profile screen — not duplicated here.
            SizedBox(height: 20.h),
          ],
        );
      }),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/restaurant.png',
              width: 120.w,
              height: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.h),
            ReuseableText(
              text: 'No restaurant yet',
              fontSize: 18.spMin,
              fontWeight: FontWeight.w700,
              textColor: kDark,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            ReuseableText(
              text: 'Create your restaurant to start accepting orders.',
              fontSize: 12.spMin,
              fontWeight: FontWeight.w400,
              textColor: kGray,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onTap: () => Get.toNamed(RouteName.createRestaurant),
                btnHeight: 46.h,
                radius: 10.r,
                btnColor: kPrimary,
                text: 'Create Restaurant',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: ReuseableText(
        text: text,
        fontSize: 12.spMin,
        fontWeight: FontWeight.w600,
        textColor: kDark,
      ),
    );
  }
}
