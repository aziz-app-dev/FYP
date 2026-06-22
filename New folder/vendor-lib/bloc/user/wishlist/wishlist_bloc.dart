import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../data/exceptions/app_exception.dart';
import '../../../repo/user/wishlist/wishlist_repo.dart';
import '../../../services/session/session_manger.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepo wishlistRepo;
  final SessionManager sessionManager;

  WishlistBloc({
    required this.wishlistRepo,
    required this.sessionManager,
  }) : super(WishlistState.initial()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<ResetWishlistStateEvent>(_onResetState);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStatus.loading, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: WishlistStatus.error,
          errorMessage: 'Please login to view your wishlist',
        ));
        return;
      }

      final items = await wishlistRepo.getWishlist(token);

      // Build set of food IDs for quick lookup
      final foodIds = items
          .where((item) => item.foodId != null)
          .map((item) => item.foodId!)
          .toSet();

      emit(state.copyWith(
        status: WishlistStatus.loaded,
        items: items,
        wishlistFoodIds: foodIds,
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: e.message,
      ));
    } on NoInternetException {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: 'No internet connection',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: 'Failed to load wishlist',
      ));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStatus.adding, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: WishlistStatus.error,
          errorMessage: 'Please login to add to wishlist',
        ));
        return;
      }

      final newItem = await wishlistRepo.addToWishlist(event.foodId, token);

      // Update state
      final updatedItems = [...state.items, newItem];
      final updatedIds = {...state.wishlistFoodIds, event.foodId};

      emit(state.copyWith(
        status: WishlistStatus.addSuccess,
        items: updatedItems,
        wishlistFoodIds: updatedIds,
        successMessage: 'Added to favorites',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: 'Failed to add to wishlist',
      ));
    }
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStatus.removing, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: WishlistStatus.error,
          errorMessage: 'Please login',
        ));
        return;
      }

      await wishlistRepo.removeFromWishlist(event.foodId, token);

      // Update state
      final updatedItems = state.items
          .where((item) => item.foodId != event.foodId)
          .toList();
      final updatedIds = state.wishlistFoodIds
          .where((id) => id != event.foodId)
          .toSet();

      emit(state.copyWith(
        status: WishlistStatus.removeSuccess,
        items: updatedItems,
        wishlistFoodIds: updatedIds,
        successMessage: 'Removed from favorites',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: 'Failed to remove from wishlist',
      ));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final isCurrentlyFavorite = state.isFavorite(event.foodId);

    if (isCurrentlyFavorite) {
      add(RemoveFromWishlistEvent(event.foodId));
    } else {
      add(AddToWishlistEvent(event.foodId));
    }
  }

  void _onResetState(
    ResetWishlistStateEvent event,
    Emitter<WishlistState> emit,
  ) {
    emit(WishlistState.initial());
  }
}
