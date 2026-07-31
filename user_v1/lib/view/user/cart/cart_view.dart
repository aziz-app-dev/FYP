import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../res/res_imports.dart';
import '../../../models/cart/cart_response_model.dart';
import '../../../models/login/login_respose_model.dart';
import '../../../repository/hooks/fetch_cart.dart';
import '../../../utils/utils.dart';
import '../../../view_models/controller/login/login_view_model.dart';
import '../../../view_models/controller/orders/order_view_model.dart';
import '../auth/login/login_redirect.dart';
import '../auth/varification/varification_view.dart';
import 'cart_checkout_view.dart';
import 'widget/cart_tile.dart';

class CartScreen extends HookWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final hookResult = useFetchCart();
    final List<CartResponseModel> carts = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;
    final controller = Get.put(LoginController());
    final orderController = Get.put(OrderController());

    LoginResponseModel? user;
    String? token = box.read('token');
    if (token != null) {
      user = controller.getUserInfo();
    }
    if (token == null) {
      return const LoginRedirect();
    }
    if (user != null && user.verification == false) {
      return const VerificationScreen();
    }

    // Subtotal across all cart items
    final double subtotal =
        carts.fold<double>(0, (sum, c) => sum + c.totalPrice);

    void goToCheckout() {
      if (carts.isEmpty) {
        Utils.showWarning('Cart is empty', 'Add something before ordering');
        return;
      }
      if (user == null) {
        Get.toNamed(RouteName.LoginScreen);
        return;
      }
      if (user.phoneVerification == false) {
        showVerificationSheet(context);
        return;
      }
      final hasAddress = box.read('defultAddress') == true;
      if (!hasAddress) {
        showAddressSheet(context);
        return;
      }
      Get.to(
        () => CartCheckoutScreen(
          carts: carts,
          onOrdered: () => refetch?.call(),
        ),
        transition: Transition.rightToLeft,
      );
    }

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        centerTitle: true,
        title: const ReuseableText(
          text: 'Cart',
          fontSize: 14,
          textColor: kGray,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
        backgroundColor: kOffWhite,
      ),
      body: SafeArea(
        child: isLoading
            ? const FoodListShimmer()
            : (carts.isEmpty
                ? const Center(
                    child: ReuseableText(
                      text: 'Your cart is empty',
                      fontSize: 14,
                      textColor: kGray,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 180.h),
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final cart = carts[index];
                        return CartTile(cart: cart, refresh: refetch);
                      },
                    ),
                  )),
      ),
      bottomNavigationBar: carts.isEmpty
          ? null
          : Obx(() {
              final busy = orderController.isLoading;
              return SafeArea(
                child: Container(
                  color: kOffWhite,
                  // bottom padding leaves room for the main screen's
                  // BottomNavigationBar that sits on top of this page
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 70.h),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ReuseableText(
                            text: 'Subtotal',
                            fontSize: 11,
                            textColor: kGray,
                            fontWeight: FontWeight.w500,
                          ),
                          ReuseableText(
                            text: '\$ ${subtotal.toStringAsFixed(2)}',
                            fontSize: 16,
                            textColor: kPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: busy,
                          child: CustomButton(
                            btnColor: busy ? kSecondary : kPrimary,
                            btnHeight: 44.h,
                            radius: 10.r,
                            onTap: goToCheckout,
                            child: Center(
                              child: busy
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child:
                                          const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimary),
                                      ),
                                    )
                                  : const ReuseableText(
                                      text: 'Place Order',
                                      fontSize: 15,
                                      textColor: kLightWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
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
