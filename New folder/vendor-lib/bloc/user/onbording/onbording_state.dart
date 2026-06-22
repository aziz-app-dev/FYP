import 'package:equatable/equatable.dart';

class OnbordingState extends Equatable {
  final int index;

  const OnbordingState({this.index = 0});

  OnbordingState copyWith({int? index}) {
    return OnbordingState(index: index ?? this.index);
  }

  @override
  List<Object> get props => [index];
}
