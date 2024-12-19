import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/address/address_models.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/coustom_button.dart';
import '../../res/components/reuseable_text.dart';
import '../../view_models/controller/address/address_view_model.dart';
import 'widgets/text_field.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final addressController = Get.put(AddressController());
  final _formKey = GlobalKey<FormState>();

  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController deliveryInstructionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.getCurrentLocationAndFetchAddress().then((_) {
      setState(() {
        addressLine1Controller.text =
            addressController.address['addressLine1'] ?? '';
        cityController.text = addressController.address['city'] ?? '';
        districtController.text = addressController.address['district'] ?? '';
        provinceController.text = addressController.address['province'] ?? '';
        postalCodeController.text =
            addressController.address['postalCode'] ?? '';
        countryController.text = addressController.address['country'] ?? '';
        deliveryInstructionController.text = 'Leave at the door';
      });
    });
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    cityController.dispose();
    districtController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    deliveryInstructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ReuseableText(
          text: 'Shipping Address',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(12.h),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                AddressFormField(
                  controller: addressLine1Controller,
                  validatorText: 'Please enter your address',
                  hintText: 'Enter your address',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: cityController,
                  validatorText: 'Please enter your city',
                  hintText: 'Enter your city',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: districtController,
                  validatorText: 'Please enter your district',
                  hintText: 'Enter your district',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: provinceController,
                  validatorText: 'Please enter your province',
                  hintText: 'Enter your province',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: postalCodeController,
                  validatorText: 'Please enter your postal code',
                  hintText: 'Enter your postal code',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: countryController,
                  validatorText: 'Please enter your country',
                  hintText: 'Please enter your country',
                ),
                const SizedBox(height: 20),
                AddressFormField(
                  controller: deliveryInstructionController,
                  validatorText: 'Please delivery instructions',
                  hintText: 'Delivery Instructions',
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ReuseableText(
                        text: 'Set address as default',
                        fontSize: 13,
                        textColor: kDark,
                        fontWeight: FontWeight.w600,
                      ),
                      Obx(() => Switch(
                            activeColor: kPrimary,
                            value: addressController.isDefault,
                            onChanged: (value) {
                              addressController.setIsDefault = value;
                            },
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  btnHeight: 40.h,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      AddressModel model = AddressModel(
                          addressLine1: addressLine1Controller.text,
                          city: cityController.text,
                          district: districtController.text,
                          province: provinceController.text,
                          postalCode: postalCodeController.text,
                          country: countryController.text,
                          deliveryInstruction:
                              deliveryInstructionController.text,
                          addressModelDefault: addressController.isDefault,
                          latitude: addressController.latitude,
                          longitude: addressController.longitude
                          // ??
                          // true
                          );
                      // print(addressController.latitude);
                      // print(addressController.longitude);
                      // Map<String, String> addressData = {
                      //   "addressLine1": addressLine1Controller.text,
                      //   "city": cityController.text,
                      //   "district": districtController.text,
                      //   "province": provinceController.text,
                      //   "postalCode": postalCodeController.text,
                      //   "country": countryController.text,
                      //   "deliveryInstruction":
                      //       deliveryInstructionController.text,
                      // };
                      String data = addressModelToJson(model);
                      addressController.uploadAddress(data);
                      Get.back();
                    }
                  },
                  child: const Center(
                    child: ReuseableText(
                      text: 'S U B M I T',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
