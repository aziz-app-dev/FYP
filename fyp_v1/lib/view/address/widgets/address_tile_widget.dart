import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../../models/address/address_respose_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text_2.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.addresses,
  });

  final AddressResponseModel addresses;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      visualDensity: VisualDensity.compact,
      leading: Icon(
        SimpleLineIcons.location_pin,
        color: kPrimary,
        size: 28.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: ReuseableText2(
          textAlign: TextAlign.start,
          overflow: TextOverflow.fade,
          text: addresses.addressLine1,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          textColor: kDark),
      // ReuseableText(
      //   text: addresses.addressLine1,
      //   overflow: TextOverflow.fade,
      //   fontSize: 11,
      //   textColor: kGray,
      //   fontWeight: FontWeight.w500,
      // ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ReuseableText(
          //   text: addresses.postalCode,
          //   overflow: TextOverflow.fade,
          //   fontSize: 11,
          //   textColor: kGray,
          // ),
          ReuseableText2(
              overflow: TextOverflow.fade,
              text: addresses.postalCode,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              textColor: kGray),
          const ReuseableText2(
              text: 'Tap to set address as default',
              overflow: TextOverflow.fade,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              textColor: kGray),
        ],
      ),
    );
  }
}
