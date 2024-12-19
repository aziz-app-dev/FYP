import 'package:flutter/material.dart';

import '../../../models/address/address_respose_model.dart';

class FetchAddressHook {
  final List<AddressResponseModel>? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchAddressHook(
      {required this.data,
      required this.isLoading,
      required this.error,
      required this.refetch});
}
