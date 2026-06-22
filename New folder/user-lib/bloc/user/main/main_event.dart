import 'package:equatable/equatable.dart';

class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class IndexChangeEvent extends MainEvent {
  final int index;

  IndexChangeEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class ScrollEvent extends MainEvent {
  final double currentOffset;
  final bool enableScrollHideHeader;

  ScrollEvent({
    required this.currentOffset,
    this.enableScrollHideHeader = true,
  });

  @override
  List<Object> get props => [currentOffset, enableScrollHideHeader];
}

class ResetHeaderEvent extends MainEvent {}
