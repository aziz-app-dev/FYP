import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/widgets/app_btn.dart';

import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/order_summary_card.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/address/address_model.dart';
import '../../../model/cart/cart_model.dart';
import '../../../model/order/order_model.dart';
import '../../../repo/user/cart/cart_repo.dart';
import '../../../repo/user/order/order_repo.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/toast_utils.dart';
import 'widgets/widgets.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double taxAmount;
  final double discount;
  final double total;
  final String paymentMethod;
  final String? addressId;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxAmount,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.addressId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final SessionManager _sessionManager = SessionManager();
  final OrderRepo _orderRepo = OrderRepo();
  final TextEditingController _notesController = TextEditingController();

  final ValueNotifier<bool> _isProcessing = ValueNotifier<bool>(false);
  final ValueNotifier<String> _selectedPaymentMethod =
      ValueNotifier<String>('cash');
  final ValueNotifier<AddressModel?> _selectedAddress =
      ValueNotifier<AddressModel?>(null);

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod.value = widget.paymentMethod;
    _loadAddress();
  }

  void _loadAddress() {
    final addresses = _sessionManager.addresses;
    if (widget.addressId != null && addresses != null) {
      _selectedAddress.value = addresses.firstWhere(
        (a) => a.id == widget.addressId,
        orElse: () => _sessionManager.displayAddress!,
      );
    } else {
      _selectedAddress.value = _sessionManager.displayAddress;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _isProcessing.dispose();
    _selectedPaymentMethod.dispose();
    _selectedAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currencySymbol = _sessionManager.currencySymbol;

    return ValueListenableBuilder<bool>(
      valueListenable: _isProcessing,
      builder: (context, processing, _) => AbsorbPointer(
        absorbing: processing,
        child: ScreenWrapper(
          useMobileScaffold: true,
          mobileHeader: const CustomHeader(title: 'Checkout'),
          mobile: _buildContent(colors, currencySymbol),
        ),
      ),
    );
  }

  // ─── Content ────────────────────────────────────────────────

  Widget _buildContent(ThemeColors colors, String currencySymbol) {
    final settings = _sessionManager.settings;
    final cashEnabled = settings?.isCashOnDeliveryEnabled ?? true;
    final onlineEnabled = settings?.isOnlinePaymentEnabled ?? false;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.spMin,
              vertical: 12.spMin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address
                _buildSectionTitle('Delivery Address', colors),
                SizedBox(height: 12.spMin),
                ValueListenableBuilder<AddressModel?>(
                  valueListenable: _selectedAddress,
                  builder: (context, addr, _) => CheckoutAddressCard(
                    selectedAddress: addr,
                    onSwap: () => AddressSelector.show(
                      context: context,
                      addresses: _sessionManager.addresses ?? [],
                      selectedAddress: addr,
                      onSelected: (address) {
                        _selectedAddress.value = address;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 24.spMin),

                // Payment Method
                _buildSectionTitle('Payment Method', colors),
                SizedBox(height: 12.spMin),
                ValueListenableBuilder<String>(
                  valueListenable: _selectedPaymentMethod,
                  builder: (context, method, _) => PaymentMethodSelector(
                    cashEnabled: cashEnabled,
                    onlineEnabled: onlineEnabled,
                    selectedMethod: method,
                    onMethodChanged: (m) {
                      _selectedPaymentMethod.value = m;
                    },
                  ),
                ),

                SizedBox(height: 24.spMin),

                // Order Items
                _buildSectionTitle(
                  'Order Items (${widget.cartItems.length})',
                  colors,
                ),
                SizedBox(height: 12.spMin),
                OrderItemsList(
                  cartItems: widget.cartItems,
                  currencySymbol: currencySymbol,
                ),

                SizedBox(height: 24.spMin),

                // Order Notes
                _buildSectionTitle('Order Notes (Optional)', colors),
                SizedBox(height: 12.spMin),
                OrderNotesField(controller: _notesController),

                SizedBox(height: 24.spMin),
              ],
            ),
          ),
        ),

        // Bottom: Order Summary + Place Order button
        SafeArea(
          top: false,
          child: OrderSummaryCard(
            title: 'Order Summary',
            subtotal: widget.subtotal,
            deliveryFee: widget.deliveryFee,
            taxAmount: widget.taxAmount,
            discount: widget.discount,
            total: widget.total,
            priceAnimation: null,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isProcessing,
              builder: (context, processing, _) => AppButton(
                text: "Place Order",
                onPressed: _placeOrder,
                isLoading: processing,
              ),
            ),
            // PlaceOrderButton(
            //   paymentMethod: _selectedPaymentMethod,
            //   currencySymbol: currencySymbol,
            //   total: widget.total,
            //   isProcessing: _isProcessing,
            //   onPressed: _placeOrder,
            // ),
          ),
        ),
      ],
    );
  }

  // ─── Section Title ──────────────────────────────────────────

  Widget _buildSectionTitle(String title, ThemeColors colors) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
    );
  }

  // ─── Place Order ────────────────────────────────────────────

  Future<void> _placeOrder() async {
    final selectedAddress = _selectedAddress.value;
    if (selectedAddress == null) {
      ToastUtils.showError(
        context,
        message: 'Please select a delivery address',
      );
      return;
    }

    _isProcessing.value = true;

    try {
      // Build order items
      final orderItems = widget.cartItems
          .map(
            (item) => OrderItem(
              foodId: item.productId,
              quantity: item.quantity,
              price: item.unitPrice,
              additives: item.additives.map((a) => a.title).toList(),
              instruction: item.instructions,
            ),
          )
          .toList();

      // Get restaurant ID from first item (assuming single restaurant order)
      final restaurantId = widget.cartItems.first.product?.restaurantId;

      // Build order
      final order = OrderModel(
        id: '',
        orderItems: orderItems,
        orderTotal: widget.subtotal,
        deliveryFee: widget.deliveryFee,
        grandTotal: widget.total,
        deliveryAddressId: selectedAddress.id,
        restaurantAddress: 'N/A',
        restaurantId: restaurantId,
        paymentMethod: _selectedPaymentMethod.value == 'cash'
            ? PaymentMethod.cash
            : PaymentMethod.card,
        orderDate: DateTime.now(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        discountAmount: widget.discount > 0 ? widget.discount : null,
        recipientCoords:
            selectedAddress.latitude != null &&
                selectedAddress.longitude != null
            ? [selectedAddress.longitude!, selectedAddress.latitude!]
            : null,
      );

      if (_selectedPaymentMethod.value == 'online') {
        _isProcessing.value = false;
        if (mounted) {
          ToastUtils.showInfo(context, message: 'Online payment coming soon!');
        }
        return;
      }

      // Place order
      final token = await _sessionManager.getToken();
      if (token == null) {
        throw Exception('Please login to place order');
      }

      final orderId = await _orderRepo.placeOrder(order.toJson(), token);

      // Clear cart after successful order
      try {
        await CartRepository().clearCart();
      } catch (_) {
        // Cart clear failure is non-critical
      }

      _isProcessing.value = false;
      if (mounted) {
        OrderSuccessDialog.show(
          context: context,
          orderId: orderId,
          total: widget.total,
        );
      }
    } catch (e) {
      _isProcessing.value = false;
      if (mounted) {
        ToastUtils.showError(context, message: 'Failed to place order: $e');
      }
    }
  }
}
