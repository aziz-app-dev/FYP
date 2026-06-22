// ignore_for_file: unrelated_type_equality_checks

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/user/forgot_password/forgot_password_bloc.dart';
import '../../../../bloc/user/forgot_password/forgot_password_state.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/enums.dart';
import '../widgets/auth_header.dart';
import 'widgets/btn_widget.dart';
import 'widgets/email_widget.dart';
import 'widgets/illstration_widget.dart';
import 'widgets/success_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailNode = FocusNode();
  final _btnNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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
    _emailController.dispose();
    _btnNode.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  void _resetAnimationForSuccess() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: Scaffold(
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
                        child:
                            BlocConsumer<
                              ForgotPasswordBloc,
                              ForgotPasswordState
                            >(
                              listener: (context, state) {
                                if (state.forgotPasswordResponse.status ==
                                    Status.error) {
                                  Flushbar(
                                    message:
                                        state.forgotPasswordResponse.message,
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: AppColors.error,
                                    flushbarPosition: FlushbarPosition.TOP,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: BorderRadius.circular(12),
                                    icon: const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                  ).show(context);
                                } else if (state
                                        .forgotPasswordResponse
                                        .status ==
                                    Status.success) {
                                  _resetAnimationForSuccess();
                                }
                              },
                              builder: (context, state) {
                                if (state.forgotPasswordResponse.status ==
                                    Status.success) {
                                  return _buildSuccessCard();
                                }
                                return _buildFormCard();
                              },
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40.spMin,
        height: 40.spMin,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: colors.border),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppSizes.iconSm,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFormCard() {
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
          _buildBackButton(),
          buildHeader(
            'Forgot Password?',
            "Enter your email and we'll send you a new password.",
            Icons.lock_reset,
            context,
          ),
          AppSizes.verticalSpaceXs,
          // buildIllustration(context),
          buildEmailForm(
            _emailNode,
            _btnNode,
            _emailController,
            _formKey,
            context,
          ),
          buildSendButton(_btnNode, _formKey),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: EdgeInsets.all(25.spMin),
      decoration: BoxDecoration(
        color: AppColors.bootomNav,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: buildSuccessContent(_emailController, _scaleAnimation, context),
    );
  }
}
