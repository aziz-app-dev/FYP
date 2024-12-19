import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../../models/food/food_model.dart';
import '../aditives/additives_iew_model.dart';

class FoodsController extends GetxController {
  RxList<FoodModel> foodsList = <FoodModel>[].obs;
  RxList<FoodModel> foodByResIdList = <FoodModel>[].obs;
  Rx<Status> rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxInt currentPage = 0.obs;
  RxInt count = 1.obs; // default quantity to 1
  final RxDouble _totalPrice = 0.0.obs;

  bool intialChech = false;

  double get additivesPrice => _totalPrice.value;

  var additivesList = <AdditivesObs>[].obs;

  set setTotalPrice(double newPrice) {
    _totalPrice.value = newPrice;
  }

  void changePage(int index) {
    currentPage.value = index;
  }

  void increment() {
    count.value++;
    getTotalPrice(); // recalculate the total price when count changes
  }

  void decrement() {
    if (count.value > 1) {
      count.value--;
      getTotalPrice(); // recalculate the total price when count changes
    }
  }

  void loadAdditives(List<Additive> additives) {
    // Clear additives first
    additivesList.clear();

    // Use addPostFrameCallback to ensure that the widget build is complete before updating the state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var additivesInfo in additives) {
        double parsedPrice = 0.0;
        try {
          parsedPrice = double.parse(additivesInfo.price.toString().trim());
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing price: ${additivesInfo.price}");
          }
        }

        var additive = AdditivesObs(
          id: additivesInfo.id,
          title: additivesInfo.title,
          price: parsedPrice,
          checked: intialChech,
        );

        // Only add if it doesn't already exist in the list
        if (!additivesList.contains(additive)) {
          additivesList.add(additive);
        }
      }

      // Call getTotalPrice after additives are loaded
      getTotalPrice();
    });
  }

// !
  List<String> getCartAditives() {
    List<String> additives = [];
    for (var additive in additivesList) {
      if (additive.isChecked.value && !additives.contains(additive.title)) {
        additives.add(additive.title);
      } else if (!additive.isChecked.value &&
          additives.contains(additive.title)) {
        additives.remove(additive.title);
      }
    }
    return additives;
  }

  List<String> getList() {
    List<String> ads = [];
    for (var additive in additivesList) {
      if (additive.isChecked.value && !ads.contains(additive.title)) {
        ads.add(additive.title);
      } else if (!additive.isChecked.value && ads.contains(additive.title)) {
        ads.remove(additive.title);
      }
    }
    return ads;
  }

  double getTotalPrice() {
    double totalPrice = 0.0;

    for (var additive in additivesList) {
      if (additive.isChecked.value) {
        totalPrice += additive.price;
      }
    }

    setTotalPrice = totalPrice;
    return totalPrice;
  }
}
