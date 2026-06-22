import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ImgPickerState extends Equatable {
  final XFile? path;

  const ImgPickerState({this.path});

  ImgPickerState copyWith({XFile? path}) {
    return ImgPickerState(path: path ?? this.path);
  }

  @override
  List<Object?> get props => [path];
}
