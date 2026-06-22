import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/user/change_password/change_password_bloc.dart';
import '../../../../bloc/user/change_password/change_password_events.dart';
import '../../../../bloc/user/change_password/change_password_state.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/enums.dart';

class ChangePasswordModal extends StatefulWidget {
  final String userToken;

  const ChangePasswordModal({super.key, required this.userToken});

  static Future<bool?> show(BuildContext context, String userToken) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangePasswordModal(userToken: userToken),
    );
  }

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordBloc>(),
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state.apiStatus == Status.error) {
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.error,
              flushbarPosition: FlushbarPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.error_outline, color: Colors.white),
            ).show(context);
          } else if (state.apiStatus == Status.success && state.isSuccess) {
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.success,
              flushbarPosition: FlushbarPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            ).show(context);

            // Close modal after success
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            });
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Header
                    _buildHeader(),
                    SizedBox(height: 24.h),
                    // Current Password Field
                    _buildPasswordField(
                      context: context,
                      controller: _currentPasswordController,
                      label: 'Current Password',
                      hint: 'Enter your current password',
                      isVisible: state.isCurrentPasswordVisible,
                      onVisibilityToggle: () {
                        context.read<ChangePasswordBloc>().add(
                          ToggleCurrentPasswordVisibilityEvent(),
                        );
                      },
                      onChanged: (value) {
                        context.read<ChangePasswordBloc>().add(
                          CurrentPasswordChangedEvent(value),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // New Password Field
                    _buildPasswordField(
                      context: context,
                      controller: _newPasswordController,
                      label: 'New Password',
                      hint: 'Enter your new password',
                      isVisible: state.isNewPasswordVisible,
                      onVisibilityToggle: () {
                        context.read<ChangePasswordBloc>().add(
                          ToggleNewPasswordVisibilityEvent(),
                        );
                      },
                      onChanged: (value) {
                        context.read<ChangePasswordBloc>().add(
                          NewPasswordChangedEvent(value),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Confirm Password Field
                    _buildPasswordField(
                      context: context,
                      controller: _confirmPasswordController,
                      label: 'Confirm New Password',
                      hint: 'Confirm your new password',
                      isVisible: state.isConfirmPasswordVisible,
                      onVisibilityToggle: () {
                        context.read<ChangePasswordBloc>().add(
                          ToggleConfirmPasswordVisibilityEvent(),
                        );
                      },
                      onChanged: (value) {
                        context.read<ChangePasswordBloc>().add(
                          ConfirmPasswordChangedEvent(value),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    // Submit Button
                    _buildSubmitButton(context, state),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.lock_outline,
            color: AppColors.primary,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Update your password for security',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required ValueChanged<String> onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          style: AppTextStyles.bodyLarge,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              onPressed: onVisibilityToggle,
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, ChangePasswordState state) {
    final isLoading = state.apiStatus == Status.loading;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<ChangePasswordBloc>().add(
                    SubmitChangePasswordEvent(widget.userToken),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Update Password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
