import 'package:equatable/equatable.dart';

abstract class ProductReviewsEvent extends Equatable {
  const ProductReviewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductReviewsEvent extends ProductReviewsEvent {
  final String productId;
  final String ratingType;

  const LoadProductReviewsEvent({
    required this.productId,
    required this.ratingType,
  });

  @override
  List<Object?> get props => [productId, ratingType];
}

class LoadMoreProductReviewsEvent extends ProductReviewsEvent {
  const LoadMoreProductReviewsEvent();
}

class AddReviewEvent extends ProductReviewsEvent {
  final double rating;
  final String? comment;

  const AddReviewEvent({required this.rating, this.comment});

  @override
  List<Object?> get props => [rating, comment];
}
