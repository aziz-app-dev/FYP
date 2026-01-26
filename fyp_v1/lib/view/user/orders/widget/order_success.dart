import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../../res/res_imports.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 0, 20, 18),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(RouteName.mainScreen);
              },
              child: const Icon(AntDesign.closecircle),
            ),
          )
        ],
      ),
      body: BackGroundContainer(
          child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: height * 0.3.h,
              width: width * -40,
              decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.all(Radius.circular(20.r))),
              child: Padding(
                padding: EdgeInsets.all(8.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    const ReuseableText(
                      text: "Order Successful",
                      fontSize: 13,
                      textColor: kGray,
                      fontWeight: FontWeight.normal,
                    ),
                    const Divider(
                      thickness: .2,
                      color: kGray,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Table(
                        children: const [
                          TableRow(children: [
                            ReuseableText(
                              text: "Order ID",
                              fontSize: 13,
                              textColor: kGray,
                              fontWeight: FontWeight.normal,
                            ),
                            ReuseableText(
                              text: "Order ID",
                              fontSize: 13,
                              textColor: kGray,
                              fontWeight: FontWeight.normal,
                            ),
                          ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
