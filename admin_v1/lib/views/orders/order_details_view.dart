import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/components/round_button.dart';
import '../../common/res/components/status_chip.dart';
import '../../models/order/admin_order_model.dart';
import '../../view models/controllers/admin_order_view_model.dart';

/// Full order detail with customer / restaurant / items breakdown and
/// an admin status override.
class OrderDetailsView extends StatefulWidget {
  final AdminOrder order;
  final AdminOrderController controller;

  const OrderDetailsView({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  late String _selectedStatus;
  bool _saving = false;

  static final _date = DateFormat('EEE dd MMM yyyy, hh:mm a');

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.orderStatus;
  }

  Future<void> _applyStatus() async {
    if (_selectedStatus == widget.order.orderStatus) return;
    setState(() => _saving = true);
    final ok =
        await widget.controller.updateStatus(widget.order.id, _selectedStatus);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0.5,
        title: ReuseableText(
          text:
              'Order #${order.id.length > 6 ? order.id.substring(order.id.length - 6) : order.id}',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          textColor: kDark,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard(order),
          const SizedBox(height: 16),
          _partyCard(
            title: 'Customer',
            icon: Icons.person_outline,
            name: order.user.username.isEmpty ? '—' : order.user.username,
            lines: [
              if (order.user.email.isNotEmpty) order.user.email,
              if (order.user.phone.isNotEmpty) order.user.phone,
            ],
            imageUrl: order.user.profile,
          ),
          const SizedBox(height: 16),
          _partyCard(
            title: 'Restaurant',
            icon: Icons.storefront_outlined,
            name: order.restaurant.title.isEmpty ? '—' : order.restaurant.title,
            lines: [
              if (order.restaurantAddress.isNotEmpty) order.restaurantAddress,
            ],
            imageUrl: order.restaurant.logoUrl,
          ),
          const SizedBox(height: 16),
          _itemsCard(order),
          const SizedBox(height: 16),
          _totalsCard(order),
          const SizedBox(height: 16),
          _statusCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _headerCard(AdminOrder order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(label: order.orderStatus),
              const SizedBox(width: 8),
              StatusChip(label: order.paymentStatus),
              const Spacer(),
              ReuseableText(
                text: order.paymentMethod,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: kGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: kGrayLight),
              const SizedBox(width: 6),
              ReuseableText(
                text: order.createdAt == null
                    ? 'Unknown date'
                    : _date.format(order.createdAt!.toLocal()),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            ],
          ),
          if (order.deliveryAddress.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: kGrayLight),
                const SizedBox(width: 6),
                Expanded(
                  child: ReuseableText(
                    text: order.deliveryAddress,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: kGray,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _partyCard({
    required String title,
    required IconData icon,
    required String name,
    required List<String> lines,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 48,
              height: 48,
              child: imageUrl.isEmpty
                  ? Container(
                      color: kOffWhite,
                      child: Icon(icon, color: kGrayLight),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: kOffWhite,
                        child: Icon(icon, color: kGrayLight),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: title,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: kGrayLight,
                ),
                const SizedBox(height: 2),
                ReuseableText(
                  text: name,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: kDark,
                  overflow: TextOverflow.ellipsis,
                ),
                for (final line in lines) ...[
                  const SizedBox(height: 2),
                  ReuseableText(
                    text: line,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: kGray,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemsCard(AdminOrder order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReuseableText(
            text: 'Items',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: kDark,
          ),
          const SizedBox(height: 12),
          if (order.orderItems.isEmpty)
            const ReuseableText(
              text: 'No items on this order',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: kGray,
            ),
          for (final item in order.orderItems)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: item.foodImageUrl.isEmpty
                          ? Container(
                              color: kOffWhite,
                              child: const Icon(Icons.fastfood_rounded,
                                  color: kGrayLight, size: 20),
                            )
                          : CachedNetworkImage(
                              imageUrl: item.foodImageUrl.first,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: kOffWhite,
                                child: const Icon(Icons.fastfood_rounded,
                                    color: kGrayLight, size: 20),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          text: item.foodTitle.isEmpty
                              ? 'Item ${item.foodId}'
                              : item.foodTitle,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.additives.isNotEmpty)
                          ReuseableText(
                            text: item.additives.join(', '),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            textColor: kGray,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (item.instruction.isNotEmpty)
                          ReuseableText(
                            text: 'Note: ${item.instruction}',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            textColor: kSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ReuseableText(
                        text: 'x${item.quantity}',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: kGray,
                      ),
                      ReuseableText(
                        text: 'Rs ${(item.price * item.quantity).toStringAsFixed(0)}',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        textColor: kDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _totalsCard(AdminOrder order) {
    Widget row(String label, String value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReuseableText(
              text: label,
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              textColor: bold ? kDark : kGray,
            ),
            ReuseableText(
              text: value,
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              textColor: bold ? kPrimary : kDark,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row('Subtotal', 'Rs ${order.orderTotal.toStringAsFixed(0)}'),
          row('Delivery fee', 'Rs ${order.deliveryFee.toStringAsFixed(0)}'),
          const Divider(height: 16),
          row('Grand total', 'Rs ${order.grandTotal.toStringAsFixed(0)}',
              bold: true),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReuseableText(
            text: 'Change status',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: kDark,
          ),
          const SizedBox(height: 4),
          const ReuseableText(
            text:
                'As super admin you can move this order to any state, including cancelling it at any stage.',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textColor: kGray,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: OrderStatus.settable.map((status) {
              final selected = _selectedStatus == status;
              final color = StatusChip.colorFor(status);
              return ChoiceChip(
                label: Text(status),
                selected: selected,
                onSelected: (_) => setState(() => _selectedStatus = status),
                labelStyle: TextStyle(
                  color: selected ? kWhite : color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                selectedColor: color,
                backgroundColor: color.withValues(alpha: 0.1),
                side: BorderSide(color: color.withValues(alpha: 0.4)),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          RoundButton(
            title: _selectedStatus == widget.order.orderStatus
                ? 'Status unchanged'
                : 'Apply "$_selectedStatus"',
            loading: _saving,
            color: _selectedStatus == widget.order.orderStatus
                ? kGrayLight
                : kPrimary,
            onPress: _applyStatus,
          ),
        ],
      ),
    );
  }
}
