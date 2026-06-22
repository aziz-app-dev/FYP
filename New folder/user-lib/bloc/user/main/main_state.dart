import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final int selectedIndex;
  final bool showHeader;
  final double lastScrollOffset;

  const MainState({
    this.selectedIndex = 0,
    this.showHeader = true,
    this.lastScrollOffset = 0,
  });

  MainState copyWith({
    int? selectedIndex,
    bool? showHeader,
    double? lastScrollOffset,
  }) {
    return MainState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      showHeader: showHeader ?? this.showHeader,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
    );
  }

  @override
  List<Object> get props => [selectedIndex, showHeader, lastScrollOffset];
}
