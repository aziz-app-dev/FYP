import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
  @override
  List<Object?> get props => [];
}

/// Load initial profile data
class LoadProfileEvent extends EditProfileEvent {}

/// Pick image from camera
class PickImageFromCameraEvent extends EditProfileEvent {}

/// Pick image from gallery
class PickImageFromGalleryEvent extends EditProfileEvent {}

/// Upload the selected profile image
class UploadProfileImageEvent extends EditProfileEvent {
  final String imagePath;
  const UploadProfileImageEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Clear the selected image (cancel before upload)
class ClearSelectedImageEvent extends EditProfileEvent {}

/// Update profile data (username, phone, etc.)
class UpdateProfileDataEvent extends EditProfileEvent {
  final String? username;
  final String? phone;

  const UpdateProfileDataEvent({
    this.username,
    this.phone,
  });

  @override
  List<Object?> get props => [username, phone];
}

/// Reset the bloc state
class ResetEditProfileEvent extends EditProfileEvent {}
