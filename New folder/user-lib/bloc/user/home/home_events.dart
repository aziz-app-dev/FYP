import 'package:equatable/equatable.dart';

abstract class HomeEvents extends Equatable {
  const HomeEvents();

  @override
  List<Object> get props => [];
}

class FetchHomeData extends HomeEvents {}
