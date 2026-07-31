import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../res/res_imports.dart';
import '../../../models/address/address_respose_model.dart';
import '../../../models/cart/cart_response_model.dart';
import '../../../models/distance_time.dart';
import '../../../models/order/order_request_model.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../view_models/controller/cart/cart_view_model.dart';
import '../../../view_models/controller/orders/order_view_model.dart';
import '../../../view_models/services/distance.dart';
import '../orders/orders_view.dart';
import '../orders/widget/order_success_dialog.dart';

/// Order confirmation screen for items coming from the Cart.
/// Loads restaurant + default address, shows a full bill breakdown,
/// and only posts the order after the user confirms.
class CartCheckoutScreen extends StatefulWidget {
  final List<CartResponseModel> carts;
  final VoidCallback? onOrdered;

  const CartCheckoutScreen({
    super.key,
    required this.carts,
    this.onOrdered,
  });

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  final box = GetStorage();
  final orderController = Get.put(OrderController());
  final cartController = Get.put(CartController());

  bool _loading = true;
  String? _loadError;
  RestaurantModel? _restaurant;
  AddressResponseModel? _address;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String? token = box.read('token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final restaurantId = widget.carts.first.productId.restaurant;

      final results = await Future.wait([
        http.get(Uri.parse('${AppUrl.baseUrl}/api/restaurant/byId/$restaurantId')),
        http.get(
          Uri.parse('${AppUrl.baseUrl}/api/address/default'),
          headers: headers,
        ),
      ]);

      if (!mounted) return;

      if (results[0].statusCode != 200) {
        setState(() {
          _loading = false;
          _loadError = 'Restaurant unavailable';
        });
        return;
      }
      if (results[1].statusCode != 200) {
        setState(() {
          _loading = false;
          _loadError = 'No delivery address found';
        });
        return;
      }

      setState(() {
        _restaurant =
            RestaurantModel.fromJson(jsonDecode(results[0].body));
        _address =
            AddressResponseModel.fromJson(jsonDecode(results[1].body));
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Failed to load checkout: $e';
      });
    }
  }

  Future<void> _confirmOrder({
    required double subtotal,
    required double deliveryFee,
    required double grandTotal,
  }) async {
    final items = widget.carts
        .map((c) => OrderItem(
              foodId: c.productId.id,
              quantity: c.quantity,
              price: c.totalPrice,
              additives: c.additives,
              instruction: c.instructions,
            ))
        .toList();

    final order = OrderRequestModel(
      orderItems: items,
      orderTotal: subtotal,
      deliveryFee: deliveryFee,
      grandTotal: grandTotal,
      deliveryAddress: _address!.id,
      restaurantAddress: _restaurant!.coords.address,
      restaurantCoords: [
        _restaurant!.coords.latitude,
        _restaurant!.coords.longitude,
      ],
      recipientCoords: [_address!.latitude, _address!.longitude],
      restaurantId: _restaurant!.id,
      orderStatus: 'Pending',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
      rating: 3.0,
    );

    final orderId =
        await orderController.createOrder(orderRequestModelToJson(order));

    if (orderId == null) {
      // Error already surfaced by orderController via toast; just stay here.
      return;
    }

    // Clear cart on the backend, then refresh UI state.
    final String? token = box.read('token');
    try {
      await http.delete(
        Uri.parse('${AppUrl.baseUrl}/api/cart/clear'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {
      // Non-fatal: order is already placed, user will just see stale cart
      // until next fetch. Badge count still updates below.
    }
    widget.onOrdered?.call();
    cartController.setCount = 0;
    cartController.fetchCartCount();

    if (!mounted) return;

    // Show the confirmation dialog with the order summary.
    await showOrderSuccessDialog(
      orderId: orderId,
      itemCount: items.length,
      grandTotal: grandTotal,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimary)),
      );
    }

    if (_loadError != null || _restaurant == null || _address == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: const ReuseableText(
            text: 'Checkout',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textColor: kLightWhite,
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: ReuseableText(
              text: _loadError ?? 'Unable to load checkout',
              fontSize: 14,
              textColor: kGray,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final DistanceTime dt = Distance().calculateDistanceTimePrice(
      _restaurant!.coords.latitude,
      _restaurant!.coords.longitude,
      _address!.latitude,
      _address!.longitude,
      10,
      2,
    );

    final double subtotal =
        widget.carts.fold<double>(0, (sum, c) => sum + c.totalPrice);
    final int totalItems =
        widget.carts.fold<int>(0, (sum, c) => sum + c.quantity);
    final double grandTotal = subtotal + dt.price;

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimary,
        title: const ReuseableText(
          text: 'Confirm Your Order',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          textColor: kLightWhite,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 200.h),
        children: [
          // Restaurant block
          _section(
            title: 'Restaurant',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: kPrimary,
                  backgroundImage: NetworkImage(_restaurant!.logoUrl),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: _restaurant!.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        textColor: kDark,
                      ),
                      SizedBox(height: 2.h),
                      ReuseableText(
                        text: _restaurant!.coords.address,
                        fontSize: 11,
                        textColor: kGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Delivery address block
          _section(
            title: 'Delivery Address',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: _address!.addressLine1,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  textColor: kDark,
                ),
                SizedBox(height: 4.h),
                ReuseableText(
                  text:
                      '${_address!.city}, ${_address!.province}, ${_address!.country}',
                  fontSize: 11,
                  textColor: kGray,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Items block
          _section(
            title: 'Items ($totalItems)',
            child: Column(
              children: widget.carts
                  .map((c) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: SizedBox(
                                width: 36.w,
                                height: 36.w,
                                child: Image.network(
                                  c.productId.imageUrl.isNotEmpty
                                      ? c.productId.imageUrl.first
                                      : '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: kOffWhite,
                                    child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        color: kGray),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReuseableText(
                                    text: c.productId.title,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    textColor: kDark,
                                  ),
                                  ReuseableText(
                                    text: 'Qty: ${c.quantity}',
                                    fontSize: 10,
                                    textColor: kGray,
                                  ),
                                ],
                              ),
                            ),
                            ReuseableText(
                              text: '\$ ${c.totalPrice.toStringAsFixed(2)}',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              textColor: kPrimary,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 10.h),

          // Bill breakdown
          _section(
            title: 'Bill Details',
            child: Column(
              children: [
                RowText(
                    first: 'Subtotal',
                    second: '\$ ${subtotal.toStringAsFixed(2)}'),
                SizedBox(height: 6.h),
                RowText(
                    first: 'Distance',
                    second: '${dt.distance.toStringAsFixed(2)} km'),
                SizedBox(height: 6.h),
                RowText(
                    first: 'Delivery Fee',
                    second: '\$ ${dt.price.toStringAsFixed(2)}'),
                SizedBox(height: 6.h),
                const RowText(
                    first: 'Payment Method', second: 'Cash on delivery'),
                Divider(height: 20.h),
                RowText(
                    first: 'Grand Total',
                    second: '\$ ${grandTotal.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final busy = orderController.isLoading;
        return SafeArea(
          child: Container(
            color: kOffWhite,
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 70.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ReuseableText(
                      text: 'Total',
                      fontSize: 11,
                      textColor: kGray,
                      fontWeight: FontWeight.w500,
                    ),
                    ReuseableText(
                      text: '\$ ${grandTotal.toStringAsFixed(2)}',
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
                      onTap: () => _confirmOrder(
                        subtotal: subtotal,
                        deliveryFee: dt.price,
                        grandTotal: grandTotal,
                      ),
                      child: Center(
                        child: busy
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(kPrimary),
                                ),
                              )
                            : const ReuseableText(
                                text: 'Confirm & Place Order',
                                fontSize: 14,
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

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseableText(
            text: title,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            textColor: kGray,
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}
