import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/user/rating/rating_repo.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepo ratingRepo;

  RatingBloc({required this.ratingRepo}) : super(RatingState.initial()) {
    on<LoadUserRatingsEvent>(_onLoadUserRatings);
    on<AddRatingEvent>(_onAddRating);
    on<UpdateRatingEvent>(_onUpdateRating);
    on<DeleteRatingEvent>(_onDeleteRating);
    on<ChangeTabEvent>(_onChangeTab);
    on<ResetRatingStateEvent>(_onResetState);
  }

  Future<void> _onLoadUserRatings(
    LoadUserRatingsEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.loading, clearError: true));

    final response = await ratingRepo.getUserRatings(ratingType: event.filterType);

    if (response.success) {
      emit(state.copyWith(
        status: RatingStatus.loaded,
        stats: response.stats,
        allRatings: response.allRatings,
        foodRatings: response.foodRatings,
        restaurantRatings: response.restaurantRatings,
        driverRatings: response.driverRatings,
      ));
    } else {
      emit(state.copyWith(
        status: RatingStatus.error,
        errorMessage: response.message ?? 'Failed to load ratings',
      ));
    }
  }

  Future<void> _onAddRating(
    AddRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.adding, clearError: true));

    final response = await ratingRepo.addRating(
      ratingType: event.ratingType,
      productId: event.productId,
      rating: event.rating,
      comment: event.comment,
      orderId: event.orderId,
    );

    if (response.success) {
      emit(state.copyWith(
        status: RatingStatus.addSuccess,
        successMessage: response.message ?? 'Rating added successfully',
      ));
      // Reload ratings
      add(const LoadUserRatingsEvent());
    } else {
      emit(state.copyWith(
        status: RatingStatus.error,
        errorMessage: response.message ?? 'Failed to add rating',
      ));
    }
  }

  Future<void> _onUpdateRating(
    UpdateRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.updating, clearError: true));

    final response = await ratingRepo.updateRating(
      ratingId: event.ratingId,
      rating: event.rating,
      comment: event.comment,
    );

    if (response.success) {
      emit(state.copyWith(
        status: RatingStatus.updateSuccess,
        successMessage: response.message ?? 'Rating updated successfully',
      ));
      // Reload ratings
      add(const LoadUserRatingsEvent());
    } else {
      emit(state.copyWith(
        status: RatingStatus.error,
        errorMessage: response.message ?? 'Failed to update rating',
      ));
    }
  }

  Future<void> _onDeleteRating(
    DeleteRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.deleting, clearError: true));

    final response = await ratingRepo.deleteRating(event.ratingId);

    if (response.success) {
      emit(state.copyWith(
        status: RatingStatus.deleteSuccess,
        successMessage: response.message ?? 'Rating deleted successfully',
      ));
      // Reload ratings
      add(const LoadUserRatingsEvent());
    } else {
      emit(state.copyWith(
        status: RatingStatus.error,
        errorMessage: response.message ?? 'Failed to delete rating',
      ));
    }
  }

  void _onChangeTab(
    ChangeTabEvent event,
    Emitter<RatingState> emit,
  ) {
    emit(state.copyWith(currentTabIndex: event.tabIndex));
  }

  void _onResetState(
    ResetRatingStateEvent event,
    Emitter<RatingState> emit,
  ) {
    emit(RatingState.initial());
  }
}
