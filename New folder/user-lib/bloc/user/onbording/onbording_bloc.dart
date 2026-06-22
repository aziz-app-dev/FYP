import 'package:bloc/bloc.dart';
import '../../../bloc/user/onbording/onbording_event.dart';

import 'onbording_state.dart';

class OnbordingBloc extends Bloc<OnbordingEvent, OnbordingState> {
  OnbordingBloc() : super(OnbordingState()) {
    on<IndexChage>(_indexChage);
  }
  void _indexChage(IndexChage event, Emitter<OnbordingState> emit) {
    emit(state.copyWith(index: event.index));
  }
}
