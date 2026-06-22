import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../repo/user/restaurant/restaurant_http_repo.dart';
import '../../../routes/route_name.dart';

class RestaurantQrScannerPage extends StatefulWidget {
  const RestaurantQrScannerPage({super.key});

  @override
  State<RestaurantQrScannerPage> createState() =>
      _RestaurantQrScannerPageState();
}

class _RestaurantQrScannerPageState extends State<RestaurantQrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  final ValueNotifier<bool> _busy = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _torchOn = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _scannerController.dispose();
    _busy.dispose();
    _error.dispose();
    _torchOn.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy.value) return;

    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null || raw.isEmpty) return;

    _busy.value = true;
    _error.value = null;
    await _scannerController.stop();

    try {
      final repo = getIt<RestaurantHttpRepo>();
      final restaurant = await repo.fetchRestaurantByQr(raw);

      if (!mounted) return;
      // Replace the scanner with the restaurant detail page
      Navigator.pushReplacementNamed(
        context,
        RouteName.restaurantDetails,
        arguments: restaurant.id,
      );
    } catch (e) {
      if (!mounted) return;
      _error.value = e.toString().replaceFirst('Exception: ', '');
      _busy.value = false;
    }
  }

  Future<void> _resetScanner() async {
    _error.value = null;
    _busy.value = false;
    await _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scan Restaurant QR',
          style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _torchOn,
            builder: (context, on, _) {
              return IconButton(
                icon: Icon(
                  on ? Icons.flash_on : Icons.flash_off_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _scannerController.toggleTorch();
                  _torchOn.value = !_torchOn.value;
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Cutout overlay
          Center(
            child: Container(
              width: 270.spMin,
              height: 270.spMin,
              decoration: BoxDecoration(
                border: Border.all(color: colors.primary, width: 3),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          // Top hint
          Positioned(
            top: 24.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: colors.primary,
                      size: 16.spMin,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Point camera at restaurant QR',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading / error overlay
          ValueListenableBuilder<bool>(
            valueListenable: _busy,
            builder: (context, busy, _) {
              if (!busy) return const SizedBox.shrink();
              return Container(
                color: Colors.black.withValues(alpha: 0.55),
                child: Center(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: _error,
                    builder: (context, err, _) {
                      if (err != null) {
                        return _ErrorCard(
                          message: err,
                          onRetry: _resetScanner,
                          onClose: () => Navigator.of(context).pop(),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: colors.primary),
                          SizedBox(height: 12.h),
                          Text(
                            'Looking up restaurant…',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const _ErrorCard({
    required this.message,
    required this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.all(20.spMin),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 44.spMin,
            color: colors.error,
          ),
          SizedBox(height: 10.h),
          Text(
            'Scan failed',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClose,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
