import 'package:flutter/material.dart';
import '../../../models/food/food_model.dart';

class FetchFood {
  final List<FoodModel>? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchFood(
      {required this.data,
      required this.isLoading,
      required this.error,
      required this.refetch});
}
