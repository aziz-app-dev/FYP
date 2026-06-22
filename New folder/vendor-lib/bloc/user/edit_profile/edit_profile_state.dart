import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/auth/user_model.dart';

enum EditProfileStatus {
  initial,
  loading,
  loaded,
  imageUploading,
  imageUploadSuccess,
  imageUploadError,
  saving,
  saveSuccess,
  saveError,
}

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final UserModel? user;
  final XFile? selectedImage;
  final String? errorMessage;
  final String? successMessage;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.user,
    this.selectedImage,
    this.errorMessage,
    this.successMessage,
  });

  bool get isImageUploading => status == EditProfileStatus.imageUploading;
  bool get isSaving => status == EditProfileStatus.saving;
  bool get hasSelectedImage => selectedImage != null;
  String? get profileImageUrl => user?.profile;

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserModel? user,
    XFile? selectedImage,
    bool clearSelectedImage = false,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      selectedImage: clearSelectedImage ? null : (selectedImage ?? this.selectedImage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        selectedImage,
        errorMessage,
        successMessage,
      ];
}
