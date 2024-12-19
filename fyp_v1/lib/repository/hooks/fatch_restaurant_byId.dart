// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/error/error_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_restaurant.dart';

FetchRestaurant useFetchRestaurantById(String restaurantId) {
  final restaurants = useState<RestaurantModel?>(null);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url =
          Uri.parse('${AppUrl.baseUrl}/api/restaurant/byId/$restaurantId');
      // '${AppUrl.baseUrl}/api/restaurant/byId/669baffc7963ebe3f866dba5');

      final response = await http.get(url);

      // !
      // if (kDebugMode) {
      //   print(response.statusCode);
      // }

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        restaurants.value = RestaurantModel.fromJson(data);
        // !
        // if (kDebugMode) {
        //   print(data);
        // }
      } else {
        apiError.value = errorModelFromJson(response.body);
      }
      // }
      //  on SocketException {
      //   Get.to(() => const InterNetExceptionWidget());
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      Get.to(() => const GeneralExceptionWidget());
      if (e is Exception) {
        error.value = e;
        if (kDebugMode) {
          print(e.toString());
        }
      } else {
        error.value = Exception('An unexpected error occurred: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchRestaurant(
    data: restaurants.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}



// import 'dart:convert';

// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:htbv_v1/models/error/error_model.dart';
// import 'package:htbv_v1/models/restaurant/restaurant_model.dart';
// import 'package:htbv_v1/repository/hooks/hook_model/hook_restaurant.dart';
// import 'package:htbv_v1/res/app_url/app_url.dart';
// import 'package:http/http.dart' as http;

// FetchRestaurant useFetchResById() {
//   final restaurant = useState<RestaurantModel?>(null);
//   final isLoading = useState<bool>(false);
//   final apiError = useState<ErrorModel?>(null);
//   final error = useState<Exception?>(null);

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       Uri url = Uri.parse(
//           'http://192.168.9.100:5000/api/restaurant/byId/669bb02a7963ebe3f866dba7');
//       // Uri url = Uri.parse('${AppUrl.baseUrl}/api/category/');
//       final response = await http.get(url);
//       print(response.statusCode);
//       print(response.body);
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         print('this api called data>>>>>>>>:$data');
//         restaurant.value = RestaurantModel.fromJson(data);
//       } else {
//         apiError.value = errorModelFromJson(response.body);
//       }
//     } catch (e) {
//       if (e is Exception) {
//         error.value = e;
//       } else {
//         error.value = Exception('An unexpected error occurred: $e');
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   useEffect(() {
//     fetchData();
//     return null;
//   }, []);

//   void refetch() {
//     isLoading.value = true;
//     fetchData();
//   }

//   return FetchRestaurant(
//     data: restaurant.value,
//     isLoading: isLoading.value,
//     error: error.value,
//     refetch: refetch,
//   );
// }
