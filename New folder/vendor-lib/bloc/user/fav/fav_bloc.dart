import 'package:bloc/bloc.dart';

import '../../../model/fav_model.dart';
import '../../../repo/user/fav/fav_repo.dart';
import 'fav_events.dart';
import 'fav_state.dart';

class FavBloc extends Bloc<FavEvents, FavState> {
  FavRepo favRepo;
  FavBloc(this.favRepo) : super(FavState()) {
    on<FetchFavListEvent>(_fetchFavList);
    on<MakeFavEvent>(_makeFav);
    on<SelectEvent>(_sleteItme);
    on<UnSelectEvent>(_unSleteItme);
    on<DeleteItemsList>(_deleteItme);
  }

  void _deleteItme(DeleteItemsList event, Emitter<FavState> emit) {
    final List<FavoriteItem> tempFavList = List.from(state.tempFavItems);
    final List<FavoriteItem> favList = List.from(state.favItems);
    for (var i = 0; i < tempFavList.length; i++) {
      favList.remove(tempFavList[i]);
    }
    tempFavList.clear();

    emit(state.copyWith(favItems: favList, tempFavItems: tempFavList));
  }

  void _sleteItme(SelectEvent event, Emitter<FavState> emit) {
    final List<FavoriteItem> tempList = List.from(state.tempFavItems);
    tempList.add(event.item);
    emit(state.copyWith(tempFavItems: tempList));
  }

  void _unSleteItme(UnSelectEvent event, Emitter<FavState> emit) {
    final List<FavoriteItem> tempList = List.from(state.tempFavItems);
    tempList.remove(event.item);
    emit(state.copyWith(tempFavItems: tempList));
  }

  Future<void> _fetchFavList(
    FetchFavListEvent event,
    Emitter<FavState> emit,
  ) async {
    final favList = await favRepo.fatchItems();
    return emit(
      state.copyWith(
        favItems: favList,
        // favItems: List.from(favList),
        listStatus: ListStatus.success,
      ),
    );
  }

  void _makeFav(MakeFavEvent event, Emitter<FavState> emit) {
    final List<FavoriteItem> favList = List.from(state.favItems);
    final index = favList.indexWhere(
      (element) => element.id == event.favItme.id,
    );
    favList[index] = event.favItme;
    emit(state.copyWith(favItems: favList, listStatus: ListStatus.success));
  }
}
