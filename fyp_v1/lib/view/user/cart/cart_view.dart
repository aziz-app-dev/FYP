import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../res/res_imports.dart';
import '../../../models/cart/cart_response_model.dart';
import '../../../models/login/login_respose_model.dart';
import '../../../repository/hooks/fetch_cart.dart';
import '../../../view_models/controller/login/login_view_model.dart';
import '../auth/login/login_redirect.dart';
import '../auth/varification/varification_view.dart';
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
    LoginResponseModel? user;
    // final foodById = useFetchFoodById();
    // ignore: unused_local_variable
    // final FoodModel? food = foodById.data;
    // print("-----:${food}");

    final controller = Get.put(LoginController());

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

    // print("--------${carts}");
    // print("=======:${hookResult.data}");

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
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: kOffWhite,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      var cart = carts[index];
                      return CartTile(
                        cart: cart,
                        refresh: refetch,
                        // food: food,
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
