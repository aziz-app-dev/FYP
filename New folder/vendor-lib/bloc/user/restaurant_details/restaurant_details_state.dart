import 'package:equatable/equatable.dart';
import '../../../model/home/home_model.dart';

enum RestaurantDetailsStatus { initial, loading, success, error }

class RestaurantDetailsState extends Equatable {
  final RestaurantDetailsStatus status;
  final String? restaurantId;
  final RestaurantItem? restaurant;
  final List<FoodItem> foods;
  final List<FoodItem> bestFoods;
  final List<DealItem> deals;
  final List<OfferItem> offers;
  final String? errorMessage;

  const RestaurantDetailsState({
    this.status = RestaurantDetailsStatus.initial,
    this.restaurantId,
    this.restaurant,
    this.foods = const [],
    this.bestFoods = const [],
    this.deals = const [],
    this.offers = const [],
    this.errorMessage,
  });

  bool get isLoading => status == RestaurantDetailsStatus.loading;
  bool get hasError => status == RestaurantDetailsStatus.error;
  bool get isSuccess => status == RestaurantDetailsStatus.success;

  RestaurantDetailsState copyWith({
    RestaurantDetailsStatus? status,
    String? restaurantId,
    RestaurantItem? restaurant,
    List<FoodItem>? foods,
    List<FoodItem>? bestFoods,
    List<DealItem>? deals,
    List<OfferItem>? offers,
    String? errorMessage,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant ?? this.restaurant,
      foods: foods ?? this.foods,
      bestFoods: bestFoods ?? this.bestFoods,
      deals: deals ?? this.deals,
      offers: offers ?? this.offers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, restaurantId, restaurant, foods, bestFoods, deals, offers, errorMessage];
}
