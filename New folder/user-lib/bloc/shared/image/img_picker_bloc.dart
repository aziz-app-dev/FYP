import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../img_util.dart';
import 'img_picker_event.dart';
import 'img_picker_state.dart';

class ImgPickerBloc extends Bloc<ImgPickerEvent, ImgPickerState> {
  final ImgUtil imgUtil;
  ImgPickerBloc(this.imgUtil) : super(ImgPickerState()) {
    on<CameraImgEvent>(_cameraImg);
    on<GalleryImgEvent>(_galleryImg);
  }

  Future<void> _cameraImg(
    CameraImgEvent event,
    Emitter<ImgPickerState> emit,
  ) async {
    XFile? file = await imgUtil.cameraImg();
    emit(state.copyWith(path: file));
  }

  Future<void> _galleryImg(
    GalleryImgEvent event,
    Emitter<ImgPickerState> emit,
  ) async {
    XFile? file = await imgUtil.galleryImg();
    emit(state.copyWith(path: file));
  }
}
