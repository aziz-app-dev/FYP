import 'package:equatable/equatable.dart';

import '../../../model/fav_model.dart';

enum ListStatus { loading, success, falid }

class FavState extends Equatable {
  final List<FavoriteItem> favItems;
  final List<FavoriteItem> tempFavItems;
  final ListStatus listStatus;
  const FavState({
    this.favItems = const [],
    this.tempFavItems = const [],
    this.listStatus = ListStatus.loading,
  });

  FavState copyWith({
    List<FavoriteItem>? favItems,
    List<FavoriteItem>? tempFavItems,
    ListStatus? listStatus,
  }) {
    return FavState(
      favItems: favItems ?? this.favItems,
      listStatus: listStatus ?? this.listStatus,
      tempFavItems: tempFavItems ?? this.tempFavItems,
    );
  }

  @override
  List<Object?> get props => [favItems, listStatus, tempFavItems];
}
