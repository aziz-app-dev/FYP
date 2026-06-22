import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/cart/cart_model.dart';
import '../../cart/widgets/items_widget.dart';

class OrderItemsList extends StatelessWidget {
  final List<CartItem> cartItems;
  final String currencySymbol;

  const OrderItemsList({
    super.key,
    required this.cartItems,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cartItems
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(
                bottom: cartItems.last != item ? 6.spMin : 0,
              ),
              child: CartItemWidget(
                item: item,
                currencySymbol: currencySymbol,
                showQuantityControls: false,
              ),
            ),
          )
          .toList(),
    );
  }
}
