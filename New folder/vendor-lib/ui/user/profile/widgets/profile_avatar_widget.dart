import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/edit_profile/edit_profile_bloc.dart';
import '../../../../bloc/user/edit_profile/edit_profile_event.dart';
import '../../../../bloc/user/edit_profile/edit_profile_state.dart';
import '../../../../config/config.dart';
import '../../../../utils/toast_utils.dart';

/// A reusable profile avatar widget with edit functionality.
///
/// This widget displays the user's profile image and provides
/// an edit button to change the image. It uses EditProfileBloc
/// for image picking and uploading.
///
/// Can be used in both ProfilePage and EditProfilePage.
class ProfileAvatarWidget extends StatelessWidget {
  /// Size of the avatar (radius will be half of this)
  final double size;

  /// Whether to show the edit button
  final bool showEditButton;

  /// Whether to show the glow effect around the avatar
  final bool showGlow;

  /// Custom callback when image is tapped (optional)
  final VoidCallback? onTap;

  const ProfileAvatarWidget({
    super.key,
    this.size = 120,
    this.showEditButton = true,
    this.showGlow = true,
    this.onTap,
  });

  void _showImagePickerOptions(BuildContext context) {
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Profile Photo',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      context.read<EditProfileBloc>().add(
                        PickImageFromCameraEvent(),
                      );
                    },
                    colors: colors,
                  ),
                  _buildImagePickerOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      context.read<EditProfileBloc>().add(
                        PickImageFromGalleryEvent(),
                      );
                    },
                    colors: colors,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeColors colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primary, size: 32.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = size / 2;
    final innerRadius = radius - 10;
    final editButtonSize = size * 0.25;

    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // Show success message
        if (state.status == EditProfileStatus.imageUploadSuccess &&
            state.successMessage != null) {
          ToastUtils.showSuccess(context, message: state.successMessage!);
        }
        // Show error message
        if (state.status == EditProfileStatus.imageUploadError &&
            state.errorMessage != null) {
          ToastUtils.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        final profileImage = state.user?.profile;
        final selectedImage = state.selectedImage;
        final isUploading = state.isImageUploading;

        return GestureDetector(
          onTap:
              onTap ??
              (showEditButton && !isUploading
                  ? () => _showImagePickerOptions(context)
                  : null),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (showGlow)
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: .1),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: .2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

              // Avatar container with gradient border
              Container(
                padding: EdgeInsets.all(4.spMin),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: colors.primaryGradient,
                  boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10)],
                ),
                child: ClipOval(
                  child: Container(
                    width: innerRadius * 2,
                    height: innerRadius * 2,
                    color: colors.card,
                    child: _buildAvatarContent(
                      context,
                      colors,
                      profileImage,
                      selectedImage,
                      innerRadius,
                    ),
                  ),
                ),
              ),

              // Loading overlay
              if (isUploading)
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: .5),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ),

              // Edit button
              if (showEditButton && !isUploading)
                Positioned(
                  bottom: showGlow ? 0 : 4,
                  right: showGlow ? 10 : 4,
                  child: GestureDetector(
                    onTap: () => _showImagePickerOptions(context),
                    child: Container(
                      width: editButtonSize,
                      height: editButtonSize,
                      decoration: BoxDecoration(
                        gradient: colors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: .3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: editButtonSize * 0.6,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarContent(
    BuildContext context,
    ThemeColors colors,
    String? profileImage,
    dynamic selectedImage,
    double radius,
  ) {
    // Show selected local image if available
    if (selectedImage != null) {
      return Image.file(
        File(selectedImage.path),
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
      );
    }

    // Show network image if available
    if (profileImage != null && profileImage.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profileImage,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: colors.primary,
            strokeWidth: 2,
          ),
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.person, size: radius, color: colors.primary),
      );
    }

    // Show default icon
    return Icon(Icons.person, size: radius, color: colors.primary);
  }
}
