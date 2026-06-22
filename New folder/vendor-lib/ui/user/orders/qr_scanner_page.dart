import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../bloc/user/order/order_bloc.dart';
import '../../../bloc/user/order/order_event.dart';
import '../../../bloc/user/order/order_state.dart';
import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../model/order/order_model.dart';
import '../../../repo/user/order/order_repo.dart';
import '../../../services/socket/socket_service.dart';
import '../../../services/notification/notification_service.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  final ValueNotifier<bool> _hasScanned = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _scannerController.dispose();
    _hasScanned.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned.value) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final code = barcode.rawValue!;
    if (!code.startsWith('ORD-')) return;

    _hasScanned.value = true;
    _scannerController.stop();
    context.read<OrderBloc>().add(VerifyOrderByCodeEvent(code));
  }

  void _resetScanner() {
    _hasScanned.value = false;
    context.read<OrderBloc>().add(const ClearVerifiedOrderEvent());
    _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider(
      create: (_) => OrderBloc(
        orderRepo: getIt<OrderRepo>(),
        socketService: getIt<SocketService>(),
        notificationService: getIt<NotificationService>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              title: Text(
                'Scan Order QR',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              backgroundColor: colors.scaffoldBackground,
              elevation: 0,
              iconTheme: IconThemeData(color: colors.textPrimary),
            ),
            body: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.status == OrderLoadingStatus.loading) {
                  return _buildLoading(colors);
                }

                if (state.verifiedOrder != null) {
                  return _buildVerifiedResult(
                    context,
                    state.verifiedOrder!,
                    colors,
                  );
                }

                if (state.status == OrderLoadingStatus.failure && _hasScanned.value) {
                  return _buildError(
                    context,
                    state.errorMessage ?? 'Order not found',
                    colors,
                  );
                }

                return _buildScanner(colors);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanner(ThemeColors colors) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              MobileScanner(
                controller: _scannerController,
                onDetect: _onDetect,
              ),
              // Overlay with cutout
              Center(
                child: Container(
                  width: 250.spMin,
                  height: 250.spMin,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary, width: 3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(24.spMin),
          color: colors.scaffoldBackground,
          child: Text(
            'Point your camera at the order QR code. Only your own orders can be verified.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(ThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.primary),
          SizedBox(height: 16.h),
          Text(
            'Verifying order...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedResult(
    BuildContext context,
    OrderModel order,
    ThemeColors colors,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.spMin),
      child: Column(
        children: [
          // Success icon
          Container(
            padding: EdgeInsets.all(20.spMin),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 64.spMin,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Order Verified',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              order.verificationCode ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textOnPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Order details card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.spMin),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          order.orderStatus,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        order.orderStatus.value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _statusColor(order.orderStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(color: colors.divider),
                SizedBox(height: 12.h),

                // Restaurant
                if (order.restaurant != null) ...[
                  Text(
                    'Restaurant',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    order.restaurant!.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Items
                Text(
                  'Items',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                ...order.orderItems.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.food?.title ?? 'Item'}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          item.price.toStringAsFixed(2),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Divider(color: colors.divider),
                SizedBox(height: 12.h),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.grandTotal.toStringAsFixed(2),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Scan another button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetScanner,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan Another'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, ThemeColors colors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.spMin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 64.spMin,
            ),
            SizedBox(height: 16.h),
            Text(
              'Verification Failed',
              style: AppTextStyles.headlineSmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: _resetScanner,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary),
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.teal;
      case OrderStatus.outForDelivery:
        return Colors.deepPurple;
      case OrderStatus.delivery:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.manual:
        return Colors.grey;
    }
  }
}
