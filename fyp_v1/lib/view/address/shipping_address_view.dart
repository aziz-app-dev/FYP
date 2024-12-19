import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../models/address/address_respose_model.dart';
import '../../repository/hooks/fatch_all_address.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/reuseable_text.dart';
import '../../res/components/shimer/foodslist_shimer.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/address/address_view_model.dart';
import '../../view_models/services/address_services.dart';
import 'widgets/address_list_widget.dart';

class ShippingAddressScreen extends HookWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.put(AddressController());
    final hookResult = useFetchAddress();
    final List<AddressResponseModel> addresses = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ReuseableText(
          text: 'Addresses',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textColor: kGray,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kOffWhite,
          child: isLoading
              ? const FoodListShimmer()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: AddressListWidget(addresses: addresses),
                ),
        ),
      ),

      // !  floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await addressController.getCurrentLocationAndFetchAddress();
            // Get.to(() => AddressPage());
            Get.toNamed(RouteName.AddressPage);
          } catch (e) {
            if (e is LocationServiceError) {
              Get.snackbar(
                'Location',
                e.message.toString(),
                colorText: Colors.white,
                backgroundColor: Colors.blue,
                icon: const Icon(Ionicons.fast_food_outline),
              );
              Get.back();
            }
            // else {
            //   print(e);
            // }
          }
        },
        backgroundColor: kPrimary,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.spMin,
        ),
      ),
    );
  }
}
