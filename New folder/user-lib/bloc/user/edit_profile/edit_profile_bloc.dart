import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/exceptions/api_error_response.dart';
import '../../../repo/user/profile/profile_repo.dart';
import '../../../services/session/session_manger.dart';
import '../../shared/img_util.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final SessionManager _sessionManager = SessionManager();
  final ProfileRepo _profileRepo;
  final ImgUtil _imgUtil = ImgUtil();

  EditProfileBloc({required ProfileRepo profileRepo})
      : _profileRepo = profileRepo,
        super(const EditProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<PickImageFromCameraEvent>(_onPickImageFromCamera);
    on<PickImageFromGalleryEvent>(_onPickImageFromGallery);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
    on<ClearSelectedImageEvent>(_onClearSelectedImage);
    on<UpdateProfileDataEvent>(_onUpdateProfileData);
    on<ResetEditProfileEvent>(_onReset);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EditProfileStatus.loading));

    try {
      await _sessionManager.loadSession();
      final user = _sessionManager.user;

      emit(state.copyWith(
        status: EditProfileStatus.loaded,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.loaded,
        errorMessage: 'Failed to load profile',
      ));
    }
  }

  Future<void> _onPickImageFromCamera(
    PickImageFromCameraEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      final XFile? file = await _imgUtil.cameraImg();
      if (file != null) {
        emit(state.copyWith(selectedImage: file));
        // Automatically upload the image
        add(UploadProfileImageEvent(imagePath: file.path));
      }
    } catch (e) {
      debugPrint('EditProfileBloc: Error picking image from camera: $e');
    }
  }

  Future<void> _onPickImageFromGallery(
    PickImageFromGalleryEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      final XFile? file = await _imgUtil.galleryImg();
      if (file != null) {
        emit(state.copyWith(selectedImage: file));
        // Automatically upload the image
        add(UploadProfileImageEvent(imagePath: file.path));
      }
    } catch (e) {
      debugPrint('EditProfileBloc: Error picking image from gallery: $e');
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: EditProfileStatus.imageUploading,
      clearError: true,
    ));

    try {
      final token = await _sessionManager.getToken();
      if (token == null) {
        throw ApiErrorResponse(status: false, message: 'Not authenticated');
      }

      final updatedUser = await _profileRepo.updateProfileImage(
        imagePath: event.imagePath,
        token: token,
      );

      // Update local storage with new user data
      await _sessionManager.updateUser(updatedUser);

      emit(state.copyWith(
        status: EditProfileStatus.imageUploadSuccess,
        user: updatedUser,
        clearSelectedImage: true,
        successMessage: 'Profile image updated successfully',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.imageUploadError,
        errorMessage: e.message,
        clearSelectedImage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.imageUploadError,
        errorMessage: 'Failed to upload image: $e',
        clearSelectedImage: true,
      ));
    }
  }

  void _onClearSelectedImage(
    ClearSelectedImageEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(clearSelectedImage: true));
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileDataEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: EditProfileStatus.saving,
      clearError: true,
    ));

    try {
      final token = await _sessionManager.getToken();
      if (token == null) {
        throw ApiErrorResponse(status: false, message: 'Not authenticated');
      }

      final Map<String, dynamic> data = {};
      if (event.username != null) data['username'] = event.username;
      if (event.phone != null) data['phone'] = event.phone;

      await _profileRepo.updateUser(data: data, token: token);

      // Update local user data
      final currentUser = _sessionManager.user;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          username: event.username ?? currentUser.username,
          phone: event.phone ?? currentUser.phone,
        );
        await _sessionManager.updateUser(updatedUser);

        emit(state.copyWith(
          status: EditProfileStatus.saveSuccess,
          user: updatedUser,
          successMessage: 'Profile updated successfully',
        ));
      } else {
        emit(state.copyWith(
          status: EditProfileStatus.saveSuccess,
          successMessage: 'Profile updated successfully',
        ));
      }
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.saveError,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.saveError,
        errorMessage: 'Failed to save profile: $e',
      ));
    }
  }

  void _onReset(
    ResetEditProfileEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(const EditProfileState());
  }
}
