import '../../../model/fav_model.dart';

class FavRepo {
  Future<List<FavoriteItem>> fatchItems() async {
    await Future.delayed(Duration(seconds: 3));
    return List.of(_generatedItems);
  }

  final List<FavoriteItem> _generatedItems = List.generate(
    10,
    (index) => FavoriteItem(
      id: 'item_${index + 1}',
      value: 'Item ${index + 1}',
      isDeleted: false,
      isFav: index % 2 == 0, // mark every even index as favorite
    ),
  );
}
