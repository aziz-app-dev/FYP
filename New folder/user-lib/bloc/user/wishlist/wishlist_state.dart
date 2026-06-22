import 'package:equatable/equatable.dart';
import '../../../model/home/home_model.dart';
import '../../../model/wishlist/wishlist_model.dart';

enum WishlistStatus {
  initial,
  loading,
  loaded,
  adding,
  addSuccess,
  removing,
  removeSuccess,
  error,
}

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistItem> items;
  final Set<String> wishlistFoodIds; // For quick lookup
  final String? errorMessage;
  final String? successMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.wishlistFoodIds = const {},
    this.errorMessage,
    this.successMessage,
  });

  factory WishlistState.initial() {
    return const WishlistState();
  }

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItem>? items,
    Set<String>? wishlistFoodIds,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      wishlistFoodIds: wishlistFoodIds ?? this.wishlistFoodIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  /// Check if loading
  bool get isLoading => status == WishlistStatus.loading;

  /// Check if adding
  bool get isAdding => status == WishlistStatus.adding;

  /// Check if removing
  bool get isRemoving => status == WishlistStatus.removing;

  /// Check if any operation is in progress
  bool get isBusy => isLoading || isAdding || isRemoving;

  /// Check if has items
  bool get hasItems => items.isNotEmpty;

  /// Get count
  int get itemCount => items.length;

  /// Check if food is in wishlist
  bool isFavorite(String foodId) => wishlistFoodIds.contains(foodId);

  /// Get food items from wishlist
  List<FoodItem> get foods => items
      .where((item) => item.food != null)
      .map((item) => item.food!)
      .toList();

  @override
  List<Object?> get props => [
        status,
        items,
        wishlistFoodIds,
        errorMessage,
        successMessage,
      ];
}
