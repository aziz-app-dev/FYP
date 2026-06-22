import 'package:equatable/equatable.dart';

import '../../../model/rating/rating_model.dart';

enum RatingStatus {
  initial,
  loading,
  loaded,
  adding,
  addSuccess,
  updating,
  updateSuccess,
  deleting,
  deleteSuccess,
  error,
}

class RatingState extends Equatable {
  final RatingStatus status;
  final RatingStats stats;
  final List<RatingModel> allRatings;
  final List<RatingModel> foodRatings;
  final List<RatingModel> restaurantRatings;
  final List<RatingModel> driverRatings;
  final int currentTabIndex;
  final String? errorMessage;
  final String? successMessage;

  const RatingState({
    this.status = RatingStatus.initial,
    this.stats = const RatingStats(),
    this.allRatings = const [],
    this.foodRatings = const [],
    this.restaurantRatings = const [],
    this.driverRatings = const [],
    this.currentTabIndex = 0,
    this.errorMessage,
    this.successMessage,
  });

  factory RatingState.initial() {
    return const RatingState();
  }

  RatingState copyWith({
    RatingStatus? status,
    RatingStats? stats,
    List<RatingModel>? allRatings,
    List<RatingModel>? foodRatings,
    List<RatingModel>? restaurantRatings,
    List<RatingModel>? driverRatings,
    int? currentTabIndex,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return RatingState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      allRatings: allRatings ?? this.allRatings,
      foodRatings: foodRatings ?? this.foodRatings,
      restaurantRatings: restaurantRatings ?? this.restaurantRatings,
      driverRatings: driverRatings ?? this.driverRatings,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  /// Check if loading
  bool get isLoading => status == RatingStatus.loading;

  /// Check if adding
  bool get isAdding => status == RatingStatus.adding;

  /// Check if updating
  bool get isUpdating => status == RatingStatus.updating;

  /// Check if deleting
  bool get isDeleting => status == RatingStatus.deleting;

  /// Check if any operation is in progress
  bool get isBusy => isLoading || isAdding || isUpdating || isDeleting;

  /// Check if has any ratings
  bool get hasRatings => allRatings.isNotEmpty;

  /// Get current tab ratings
  List<RatingModel> get currentTabRatings {
    switch (currentTabIndex) {
      case 0:
        return foodRatings;
      case 1:
        return restaurantRatings;
      case 2:
        return driverRatings;
      default:
        return allRatings;
    }
  }

  /// Get tab count
  int getTabCount(int index) {
    switch (index) {
      case 0:
        return foodRatings.length;
      case 1:
        return restaurantRatings.length;
      case 2:
        return driverRatings.length;
      default:
        return allRatings.length;
    }
  }

  @override
  List<Object?> get props => [
        status,
        stats,
        allRatings,
        foodRatings,
        restaurantRatings,
        driverRatings,
        currentTabIndex,
        errorMessage,
        successMessage,
      ];
}
