import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final String id;
  final String value;
  final bool isDeleted;
  final bool isFav;

  const FavoriteItem({
    required this.id,
    required this.value,
    this.isDeleted = false,
    this.isFav = false,
  });

  // CopyWith method for immutability
  FavoriteItem copyWith({
    String? id,
    String? value,
    bool? isDeleted,
    bool? isFav,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      value: value ?? this.value,
      isDeleted: isDeleted ?? this.isDeleted,
      isFav: isFav ?? this.isFav,
    );
  }

  @override
  List<Object?> get props => [id, value, isDeleted, isFav];
}
