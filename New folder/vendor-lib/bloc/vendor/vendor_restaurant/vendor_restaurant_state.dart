import 'package:equatable/equatable.dart';
import '../../../model/home/home_model.dart';

enum VendorRestaurantStatus { initial, loading, success, error }

class VendorRestaurantState extends Equatable {
  final VendorRestaurantStatus status;
  final List<RestaurantItem> restaurants;
  final RestaurantItem? selectedRestaurant;
  final String? errorMessage;
  final String? successMessage;

  const VendorRestaurantState({
    this.status = VendorRestaurantStatus.initial,
    this.restaurants = const [],
    this.selectedRestaurant,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == VendorRestaurantStatus.loading;
  bool get hasError => status == VendorRestaurantStatus.error;
  bool get isSuccess => status == VendorRestaurantStatus.success;
  bool get hasRestaurant => restaurants.isNotEmpty;
  bool get hasVerifiedRestaurant =>
      restaurants.any((r) => r.verification == 'Verified');

  RestaurantItem? get activeRestaurant =>
      selectedRestaurant ?? restaurants.firstOrNull;

  VendorRestaurantState copyWith({
    VendorRestaurantStatus? status,
    List<RestaurantItem>? restaurants,
    RestaurantItem? selectedRestaurant,
    String? errorMessage,
    String? successMessage,
  }) {
    return VendorRestaurantState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        restaurants,
        selectedRestaurant,
        errorMessage,
        successMessage,
      ];
}
