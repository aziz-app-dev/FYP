import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/address/address_respose_model.dart';
import '../../models/error/error_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/address_bottom_sheet.dart';
import '../../res/components/general_exception.dart';
import 'hook_model/hook_result.dart';

FetchHook useDefaultAddress(BuildContext context) {
  final box = GetStorage();
  String? accessToken = box.read("token");
  final addresses = useState<AddressResponseModel?>(null);
  final isLoading = useState<bool>(false);
  final apiError = useState<ErrorModel?>(null);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/address/default');
      final response = await http.get(url, headers: headers);
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        box.write('defultAddress', true);
        var data = json.decode(response.body);
        addresses.value = AddressResponseModel.fromJson(data);
      } else {
        box.write('defultAddress', false);
        showAddressSheet(context);
        apiError.value = errorModelFromJson(response.body);
      }
    } on http.ClientException {
      if (!context.mounted) return;
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      if (!context.mounted) return;
      Get.to(() => const GeneralExceptionWidget());
      if (e is Exception) {
        error.value = e;
      } else {
        box.write('defultAddress', false);
        error.value = Exception('An unexpected error occurred: $e');
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
    data: addresses.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../models/address/address_respose_model.dart';
// import '../../models/error/error_model.dart';
// import '../../res/app_url/app_url.dart';
// import '../../res/components/general_exception.dart';
// import 'hook_model/hook_result.dart';

// FetchHook useDefaultAddress(BuildContext context) {
//   final box = GetStorage();
//   String? accessToken = box.read("token");
//   final addresses = useState<AddressResponseModel?>(null);
//   final isLoading = useState<bool>(false);
//   final apiError = useState<ErrorModel?>(null);
//   final error = useState<Exception?>(null);

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $accessToken'
//     };
//     try {
//       Uri url = Uri.parse('${AppUrl.baseUrl}/api/address/default');
//       final response = await http.get(url, headers: headers);
//       if (response.statusCode == 200) {
//         box.write('defultAddress', true);
//         var data = json.decode(response.body);
//         // Check if the widget is still mounted before updating the state
//         if (context.mounted) {
//           addresses.value = AddressResponseModel.fromJson(data);
//         }
//       } else {
//         box.write('defultAddress', false);
//         if (context.mounted) {
//           apiError.value = errorModelFromJson(response.body);
//         }
//       }
//     } on http.ClientException {
//       if (context.mounted) {
//         Get.to(() => const GeneralExceptionWidget());
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Get.to(() => const GeneralExceptionWidget());
//         if (e is Exception) {
//           error.value = e;
//         } else {
//           box.write('defultAddress', false);
//           error.value = Exception('An unexpected error occurred: $e');
//         }
//       }
//     } finally {
//       if (context.mounted) {
//         isLoading.value = false;
//       }
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
//     data: addresses.value,
//     isLoading: isLoading.value,
//     error: error.value,
//     refetch: refetch,
//   );
// }
