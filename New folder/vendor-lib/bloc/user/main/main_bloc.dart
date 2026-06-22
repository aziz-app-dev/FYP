import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/main/main_state.dart';

import 'main_event.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<IndexChangeEvent>(_indexChangeEvent);
    on<ScrollEvent>(_scrollEvent);
    on<ResetHeaderEvent>(_resetHeaderEvent);
  }

  void _indexChangeEvent(IndexChangeEvent event, Emitter<MainState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _scrollEvent(ScrollEvent event, Emitter<MainState> emit) {
    if (!event.enableScrollHideHeader) return;

    final currentOffset = event.currentOffset;
    final lastOffset = state.lastScrollOffset;
    final delta = currentOffset - lastOffset;

    bool newShowHeader = state.showHeader;

    if (delta > 0 && currentOffset > 80) {
      // Scrolling down → hide header
      newShowHeader = false;
    } else if (delta < 0 || currentOffset < 40) {
      // Scrolling up or near top → show header
      newShowHeader = true;
    }

    if (newShowHeader != state.showHeader || lastOffset != currentOffset) {
      emit(state.copyWith(
        showHeader: newShowHeader,
        lastScrollOffset: currentOffset,
      ));
    }
  }

  void _resetHeaderEvent(ResetHeaderEvent event, Emitter<MainState> emit) {
    emit(state.copyWith(showHeader: true, lastScrollOffset: 0));
  }
}
