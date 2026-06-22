import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/home/home_model.dart';
import '../../../repo/user/restaurant/restaurant_repo.dart';
import 'restaurant_details_event.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsBloc
    extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  final RestaurantRepo restaurantRepo;

  RestaurantDetailsBloc({required this.restaurantRepo})
      : super(const RestaurantDetailsState()) {
    on<LoadRestaurantDetailsEvent>(_onLoadRestaurantDetails);
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetailsEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    emit(state.copyWith(
      status: RestaurantDetailsStatus.loading,
      restaurantId: event.restaurantId,
    ));

    try {
      final restaurant = await restaurantRepo.fetchRestaurantById(event.restaurantId);
      final results = await Future.wait<dynamic>([
        restaurantRepo.fetchFoodsByRestaurant(event.restaurantId).catchError((_) => <FoodItem>[]),
        restaurantRepo.fetchDealsByRestaurant(event.restaurantId).catchError((_) => <DealItem>[]),
        restaurantRepo.fetchOffersByRestaurant(event.restaurantId).catchError((_) => <OfferItem>[]),
      ]);

      final foods = (results[0] as List).cast<FoodItem>();
      final bestFoods = List<FoodItem>.from(foods)
        ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

      emit(state.copyWith(
        status: RestaurantDetailsStatus.success,
        restaurant: restaurant,
        foods: foods,
        bestFoods: bestFoods.take(8).toList(),
        deals: (results[1] as List).cast<DealItem>(),
        offers: (results[2] as List).cast<OfferItem>(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RestaurantDetailsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
