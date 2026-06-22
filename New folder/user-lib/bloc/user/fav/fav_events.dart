import 'package:equatable/equatable.dart';

import '../../../model/fav_model.dart';

abstract class FavEvents extends Equatable {
  const FavEvents();
  @override
  List<Object> get props => [];
}

class FetchFavListEvent extends FavEvents {}

class MakeFavEvent extends FavEvents {
  final FavoriteItem favItme;

  const MakeFavEvent({required this.favItme});

  @override
  List<Object> get props => [favItme];
}

class SelectEvent extends FavEvents {
  final FavoriteItem item;
  const SelectEvent({required this.item});
}

class UnSelectEvent extends FavEvents {
  final FavoriteItem item;
  const UnSelectEvent({required this.item});
}

class DeleteItemsList extends FavEvents {}
