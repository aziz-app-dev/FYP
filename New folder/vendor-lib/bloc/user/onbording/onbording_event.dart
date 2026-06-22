import 'package:equatable/equatable.dart';

class OnbordingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class IndexChage extends OnbordingEvent {
  final int index;

  IndexChage({required this.index});
  @override
  List<Object> get props => [index];
}
