import 'package:equatable/equatable.dart';

abstract class ImgPickerEvent extends Equatable {
  const ImgPickerEvent();
  @override
  List<Object> get props => [];
}

class GalleryImgEvent extends ImgPickerEvent {}

class CameraImgEvent extends ImgPickerEvent {}
