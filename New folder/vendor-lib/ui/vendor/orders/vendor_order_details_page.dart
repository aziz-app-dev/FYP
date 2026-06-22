import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_bloc.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_event.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../di/service_locator.dart';
import '../../../utils/toast_utils.dart';

class VendorOrderDetailsPage extends StatelessWidget {
  final String orderId;
  const VendorOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorOrderBloc>()
        ..add(LoadVendorOrderDetails(orderId: orderId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: BlocConsumer<VendorOrderBloc, VendorOrderState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ToastUtils.showSuccess(context, message: state.successMessage!);
            }
            if (state.hasError) {
              ToastUtils.showError(context, message: state.errorMessage ?? 'Error');
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.selectedOrder == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final order = state.selectedOrder;
            if (order == null) {
              return const Center(child: Text('Order not found'));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.spMin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id.substring(order.id.length - 6)}',
                        style: TextStyle(
                          fontSize: 18.spMin,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(label: Text(order.orderStatus)),
                    ],
                  ),
                  SizedBox(height: 16.spMin),

                  // Customer
                  if (order.customer != null) ...[
                    Text('Customer', style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.spMin),
                    Text(order.customer!.username ?? 'N/A'),
                    if (order.customer!.phone != null)
                      Text(order.customer!.phone!),
                    SizedBox(height: 16.spMin),
                  ],

                  // Items
                  Text('Items', style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.spMin),
                  ...order.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 8.spMin),
                      child: Row(
                        children: [
                          if (item.food?.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item.food!.imageUrl!,
                                width: 48.spMin,
                                height: 48.spMin,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              width: 48.spMin,
                              height: 48.spMin,
                              color: Colors.grey[200],
                              child: const Icon(Icons.fastfood),
                            ),
                          SizedBox(width: 12.spMin),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.food?.title ?? 'Item'),
                                Text(
                                  'x${item.quantity}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12.spMin),
                                ),
                              ],
                            ),
                          ),
                          Text(formatPrice(item.price * item.quantity)),
                        ],
                      ),
                    ),
                  ),

                  Divider(height: 24.spMin),

                  // Pricing
                  _PriceRow(label: 'Subtotal', value: order.orderTotal),
                  _PriceRow(label: 'Delivery Fee', value: order.deliveryFee),
                  if (order.discountAmount != null && order.discountAmount! > 0)
                    _PriceRow(label: 'Discount', value: -order.discountAmount!),
                  SizedBox(height: 8.spMin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.spMin)),
                      Text(formatPrice(order.grandTotal),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.spMin)),
                    ],
                  ),
                  SizedBox(height: 8.spMin),
                  Text('Payment: ${order.paymentMethod} (${order.paymentStatus})',
                      style: TextStyle(fontSize: 12.spMin, color: Colors.grey)),

                  // Delivery address
                  if (order.deliveryAddress != null) ...[
                    SizedBox(height: 16.spMin),
                    Text('Delivery Address',
                        style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.spMin),
                    Text(
                      [
                        order.deliveryAddress!.addressLine1,
                        order.deliveryAddress!.city,
                        order.deliveryAddress!.postalCode,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                    ),
                  ],

                  // Actions
                  if (order.nextStatuses.isNotEmpty) ...[
                    SizedBox(height: 24.spMin),
                    Row(
                      children: order.nextStatuses.map((s) {
                        final isCancel = s == 'Cancelled';
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.spMin),
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<VendorOrderBloc>().add(
                                      UpdateVendorOrderStatus(
                                        orderId: order.id,
                                        newStatus: s,
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCancel ? Colors.red : context.colors.primary,
                              ),
                              child: Text(isCancel ? 'Cancel' : s),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.spMin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13.spMin)),
          Text(formatPrice(value), style: TextStyle(fontSize: 13.spMin)),
        ],
      ),
    );
  }
}
