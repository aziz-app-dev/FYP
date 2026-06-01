import 'dart:convert';

import '../address/address_respose_model.dart';
import '../category/category_model.dart';
import '../food/food_model.dart';
import '../restaurant/restaurant_model.dart';
import '../user/user_info_model.dart';

HomeDataModel homeDataModelFromJson(String str) =>
    HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  final bool status;
  final List<CategoryModel> categories;
  final List<RestaurantModel> restaurants;
  final List<FoodModel> foods;
  final UserInformationModel? user;
  final int cartCount;
  final AddressResponseModel? defaultAddress;

  HomeDataModel({
    required this.status,
    required this.categories,
    required this.restaurants,
    required this.foods,
    this.user,
    required this.cartCount,
    this.defaultAddress,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        status: json["status"] ?? false,
        categories: json["categories"] != null
            ? List<CategoryModel>.from(
                json["categories"].map((x) => CategoryModel.fromJson(x)))
            : [],
        restaurants: json["restaurants"] != null
            ? List<RestaurantModel>.from(
                json["restaurants"].map((x) => RestaurantModel.fromJson(x)))
            : [],
        foods: json["foods"] != null
            ? List<FoodModel>.from(
                json["foods"].map((x) => FoodModel.fromJson(x)))
            : [],
        user: json["user"] != null
            ? UserInformationModel.fromJson(json["user"])
            : null,
        cartCount: json["cartCount"] ?? 0,
        defaultAddress: json["defaultAddress"] != null
            ? AddressResponseModel.fromJson(json["defaultAddress"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "user": user?.toJson(),
        "cartCount": cartCount,
        "defaultAddress": defaultAddress?.toJson(),
      };
}
