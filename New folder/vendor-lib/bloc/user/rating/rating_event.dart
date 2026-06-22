import 'package:equatable/equatable.dart';

import '../../../model/rating/rating_model.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}

/// Load all user ratings
class LoadUserRatingsEvent extends RatingEvent {
  final RatingType? filterType;

  const LoadUserRatingsEvent({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

/// Add a new rating
class AddRatingEvent extends RatingEvent {
  final RatingType ratingType;
  final String productId;
  final double rating;
  final String? comment;
  final String? orderId;

  const AddRatingEvent({
    required this.ratingType,
    required this.productId,
    required this.rating,
    this.comment,
    this.orderId,
  });

  @override
  List<Object?> get props => [ratingType, productId, rating, comment, orderId];
}

/// Update an existing rating
class UpdateRatingEvent extends RatingEvent {
  final String ratingId;
  final double? rating;
  final String? comment;

  const UpdateRatingEvent({
    required this.ratingId,
    this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [ratingId, rating, comment];
}

/// Delete a rating
class DeleteRatingEvent extends RatingEvent {
  final String ratingId;

  const DeleteRatingEvent(this.ratingId);

  @override
  List<Object> get props => [ratingId];
}

/// Change the current tab
class ChangeTabEvent extends RatingEvent {
  final int tabIndex;

  const ChangeTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

/// Reset rating state
class ResetRatingStateEvent extends RatingEvent {}
