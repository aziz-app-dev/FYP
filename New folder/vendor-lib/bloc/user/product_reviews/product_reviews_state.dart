import 'package:equatable/equatable.dart';

import '../../../model/rating/product_review_model.dart';

enum ProductReviewsStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  submitting,
  submitSuccess,
  error,
}

class ProductReviewsState extends Equatable {
  final ProductReviewsStatus status;
  final ProductReviewStats stats;
  final List<ProductReview> reviews;
  final String? productId;
  final String? ratingType;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;
  final String? successMessage;
  final bool canReview;
  final bool hasRated;

  const ProductReviewsState({
    this.status = ProductReviewsStatus.initial,
    this.stats = const ProductReviewStats(),
    this.reviews = const [],
    this.productId,
    this.ratingType,
    this.currentPage = 1,
    this.hasMore = false,
    this.errorMessage,
    this.successMessage,
    this.canReview = false,
    this.hasRated = false,
  });

  bool get isLoading => status == ProductReviewsStatus.loading;
  bool get isLoadingMore => status == ProductReviewsStatus.loadingMore;
  bool get isLoaded => status == ProductReviewsStatus.loaded;
  bool get isSubmitting => status == ProductReviewsStatus.submitting;
  bool get hasError => status == ProductReviewsStatus.error;

  /// Whether user can write a new review (has ordered + hasn't reviewed yet)
  bool get canWriteReview => canReview && !hasRated;

  ProductReviewsState copyWith({
    ProductReviewsStatus? status,
    ProductReviewStats? stats,
    List<ProductReview>? reviews,
    String? productId,
    String? ratingType,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
    String? successMessage,
    bool? canReview,
    bool? hasRated,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProductReviewsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      reviews: reviews ?? this.reviews,
      productId: productId ?? this.productId,
      ratingType: ratingType ?? this.ratingType,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      canReview: canReview ?? this.canReview,
      hasRated: hasRated ?? this.hasRated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stats,
        reviews,
        productId,
        ratingType,
        currentPage,
        hasMore,
        errorMessage,
        successMessage,
        canReview,
        hasRated,
      ];
}
