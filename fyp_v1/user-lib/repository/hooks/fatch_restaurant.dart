// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../models/error/error_model.dart';
// import '../../models/restaurant/restaurant_model.dart';
// import '../../res/app_url/app_url.dart';
// import '../../res/components/general_exception.dart';
// import 'hook_model/hook_result.dart';

// FetchHook useFetchRestaurant() {
//   final categoryItems = useState<List<RestaurantModel>?>([]);
//   final isLoading = useState<bool>(false);
//   final apiError = useState<ErrorModel?>(null);
//   final error = useState<Exception?>(null);

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       Uri url = Uri.parse('${AppUrl.baseUrl}/api/restaurant/lahr');
//       final response = await http.get(url);
//       // print(response.statusCode);
//       // print(response.body);
//       if (response.statusCode == 200) {
//         categoryItems.value = restaurantModelFromJson(response.body);
//       } else {
//         apiError.value = errorModelFromJson(response.body);
//       }
//       // } on SocketException {
//       //   Get.to(() => const InterNetExceptionWidget());
//     } on http.ClientException {
//       Get.to(() => const GeneralExceptionWidget());
//     } catch (e) {
//       Get.to(() => const GeneralExceptionWidget());
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

//   return FetchHook(
//     data: categoryItems.value,
//     isLoading: isLoading.value,
//     error: error.value,
//     refetch: refetch,
//   );
// }
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Needed for BuildContext
import '../../models/error/error_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_result.dart';

FetchHook useFetchRestaurant(BuildContext context) {
  final categoryItems = useState<List<RestaurantModel>?>([]);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/restaurant/lahr');
      final response = await http.get(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 && context.mounted) {
        categoryItems.value = restaurantModelFromJson(response.body);
      } else if (context.mounted) {
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      if (context.mounted) {
        Get.to(() => const GeneralExceptionWidget());
      }
    } catch (e) {
      if (context.mounted) {
        Get.to(() => const GeneralExceptionWidget());
        if (e is Exception) {
          error.value = e;
        } else {
          error.value = Exception('An unexpected error occurred: $e');
        }
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
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

  return FetchHook(
    data: categoryItems.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
