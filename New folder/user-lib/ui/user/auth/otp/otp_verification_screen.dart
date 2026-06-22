import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../bloc/user/otp_verification/otp_verification_bloc.dart';
import '../../../../bloc/user/otp_verification/otp_verification_events.dart';
import '../../../../bloc/user/otp_verification/otp_verification_state.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../../../../repo/user/auth/verification_repo.dart';
import '../../../../services/session/session_manger.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/toast_utils.dart';
import '../widgets/auth_header.dart';
import 'widgets/pin_widget.dart';
import 'widgets/otp_illustration_widget.dart';
import 'widgets/resend_widget.dart';
import 'widgets/success_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String? phoneNumber;
  final String? email;
  final String? verificationType;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber,
    this.email,
    this.verificationType,
  });

  @override
  Widget build(BuildContext context) {
    // Determine verification type from arguments
    final VerificationType type = verificationType == 'phone'
        ? VerificationType.phone
        : VerificationType.email;

    return BlocProvider(
      create: (context) => OtpVerificationBloc(
        verificationRepo: getIt<VerificationRepo>(),
        sessionManager: SessionManager(),
        phoneNumber: phoneNumber,
        email: email,
        verificationType: type,
      ),
      child: const _OtpVerificationView(),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  const _OtpVerificationView();

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
      buildWhen: (previous, current) =>
          previous.verificationResponse.status !=
          current.verificationResponse.status,
      listener: (context, state) {
        if (state.verificationResponse.status == Status.error) {
          ToastUtils.showError(
            context,
            message: state.verificationResponse.message ?? "",
          );
        } else if (state.isVerified) {
          ToastUtils.showOtpVerified(context);
          _animationController.reset();
          _animationController.forward();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.card,
          body: BgContainer(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth < 600
                      ? 20.w
                      : constraints.maxWidth < 900
                      ? 48.w
                      : 120.w;
                  return Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                        vertical: 24.h,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: state.isVerified
                              ? _buildSuccessCard(state)
                              : _buildOtpCard(state),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpCard(OtpVerificationState state) {
    return Container(
      padding: EdgeInsets.all(25.spMin),
      decoration: BoxDecoration(
        color: AppColors.bootomNav,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.spacingXl,
        children: [
          buildHeader(
            state.verificationType == VerificationType.phone
                ? 'Phone Verification'
                : 'Email Verification',
            "Enter the 6-digit code sent to\n${state.contactInfo}",
            state.verificationType == VerificationType.phone
                ? Icons.phone_outlined
                : Icons.email_outlined,
            context,
          ),
          buildOtpIllustration(),
          buildPinInput(_pinController, _focusNode),
          buildResendSection(),
          _buildVerifyButton(state),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(OtpVerificationState state) {
    return Container(
      padding: EdgeInsets.all(25.spMin),
      decoration: BoxDecoration(
        color: AppColors.bootomNav,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: buildSuccessContent(_scaleAnimation, context),
    );
  }

  Widget _buildVerifyButton(OtpVerificationState state) {
    final isLoading = state.verificationResponse.status == Status.loading;

    return AppButton(
      text: 'Verify OTP',
      isLoading: isLoading,
      onPressed: isLoading
          ? () {}
          : () {
              if (_pinController.text.length == 6) {
                context.read<OtpVerificationBloc>().add(VerifyOtpEvent());
              } else {
                ToastUtils.showError(
                  context,
                  message: 'Please enter complete 6-digit code',
                );
              }
            },
    );
  }
}
