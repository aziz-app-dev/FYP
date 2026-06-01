import 'package:flutter/material.dart';
import '../../../models/cart/cart_response_model.dart';

class FetchCartHook {
  final List<CartResponseModel>? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchCartHook(
      {required this.data,
      required this.isLoading,
      required this.error,
      required this.refetch});
}
