import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/user/rating/product_reviews_repo.dart';
import '../../../repo/user/rating/rating_repo.dart';
import '../../../model/rating/rating_model.dart';
import 'product_reviews_event.dart';
import 'product_reviews_state.dart';

class ProductReviewsBloc
    extends Bloc<ProductReviewsEvent, ProductReviewsState> {
  final ProductReviewsRepo reviewsRepo;
  final RatingRepo ratingRepo;

  ProductReviewsBloc({
    required this.reviewsRepo,
    required this.ratingRepo,
  }) : super(const ProductReviewsState()) {
    on<LoadProductReviewsEvent>(_onLoadReviews);
    on<LoadMoreProductReviewsEvent>(_onLoadMore);
    on<AddReviewEvent>(_onAddReview);
  }

  Future<void> _onLoadReviews(
    LoadProductReviewsEvent event,
    Emitter<ProductReviewsState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductReviewsStatus.loading,
      productId: event.productId,
      ratingType: event.ratingType,
    ));

    try {
      final response = await reviewsRepo.getProductReviews(
        productId: event.productId,
        ratingType: event.ratingType,
        page: 1,
      );

      if (response.success) {
        // Check if user can review this product
        final canReviewResponse = await ratingRepo.checkCanReview(
          ratingType: _parseRatingType(event.ratingType),
          productId: event.productId,
        );

        emit(state.copyWith(
          status: ProductReviewsStatus.loaded,
          stats: response.stats,
          reviews: response.reviews,
          currentPage: response.currentPage,
          hasMore: response.hasMore,
          canReview: canReviewResponse.canReview,
          hasRated: canReviewResponse.hasRated,
        ));
      } else {
        emit(state.copyWith(
          status: ProductReviewsStatus.error,
          errorMessage: response.message ?? 'Failed to load reviews',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductReviewsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProductReviewsEvent event,
    Emitter<ProductReviewsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(status: ProductReviewsStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final response = await reviewsRepo.getProductReviews(
        productId: state.productId!,
        ratingType: state.ratingType!,
        page: nextPage,
      );

      if (response.success) {
        emit(state.copyWith(
          status: ProductReviewsStatus.loaded,
          reviews: [...state.reviews, ...response.reviews],
          currentPage: response.currentPage,
          hasMore: response.hasMore,
        ));
      } else {
        emit(state.copyWith(status: ProductReviewsStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: ProductReviewsStatus.loaded));
    }
  }

  RatingType _parseRatingType(String type) {
    switch (type) {
      case 'Restaurant':
        return RatingType.restaurant;
      case 'Driver':
        return RatingType.driver;
      default:
        return RatingType.food;
    }
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ProductReviewsState> emit,
  ) async {
    emit(state.copyWith(status: ProductReviewsStatus.submitting, clearError: true));

    try {
      final response = await ratingRepo.addRating(
        ratingType: _parseRatingType(state.ratingType!),
        productId: state.productId!,
        rating: event.rating,
        comment: event.comment,
      );

      if (response.success) {
        emit(state.copyWith(
          status: ProductReviewsStatus.submitSuccess,
          successMessage: response.message ?? 'Review added successfully',
        ));
        // Reload reviews to show the new one
        add(LoadProductReviewsEvent(
          productId: state.productId!,
          ratingType: state.ratingType!,
        ));
      } else {
        emit(state.copyWith(
          status: ProductReviewsStatus.loaded,
          errorMessage: response.message ?? 'Failed to add review',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductReviewsStatus.loaded,
        errorMessage: e.toString(),
      ));
    }
  }
}
