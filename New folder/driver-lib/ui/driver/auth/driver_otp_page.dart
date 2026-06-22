import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../repo/driver/driver_repo.dart';
import '../../../routes/route_name.dart';
import '../../../utils/toast_utils.dart';

class DriverOtpPage extends StatefulWidget {
  final String email;

  const DriverOtpPage({super.key, required this.email});

  @override
  State<DriverOtpPage> createState() => _DriverOtpPageState();
}

class _DriverOtpPageState extends State<DriverOtpPage> {
  final _otpController = TextEditingController();
  final ValueNotifier<int> _seconds = ValueNotifier<int>(60);
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _seconds.dispose();
    _loading.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds.value <= 0) {
        timer.cancel();
      } else {
        _seconds.value -= 1;
      }
    });
  }

  Future<void> _verify() async {
    if (_otpController.text.trim().length != 6) {
      ToastUtils.showError(context, message: 'Enter 6-digit OTP');
      return;
    }
    _loading.value = true;
    try {
      await getIt<DriverRepo>().verifyOtp(
        email: widget.email,
        otp: _otpController.text.trim(),
      );
      if (!mounted) return;
      ToastUtils.showSuccess(context, message: 'Driver verified. Please login.');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ToastUtils.showError(context, message: e.toString());
    } finally {
      if (mounted) _loading.value = false;
    }
  }

  Future<void> _resend() async {
    if (_seconds.value > 0) return;
    try {
      await getIt<DriverRepo>().resendOtp(email: widget.email);
      if (!mounted) return;
      ToastUtils.showInfo(context, message: 'OTP resent successfully');
      _startTimer();
    } catch (e) {
      if (!mounted) return;
      ToastUtils.showError(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter OTP sent to ${widget.email}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<bool>(
                valueListenable: _loading,
                builder: (context, loading, _) => FilledButton(
                  onPressed: loading ? null : _verify,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify OTP'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<int>(
              valueListenable: _seconds,
              builder: (context, seconds, _) => TextButton(
                onPressed: seconds == 0 ? _resend : null,
                child: Text(seconds == 0 ? 'Resend OTP' : 'Resend in ${seconds}s'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
