import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class LocationService {
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }

class LocationServiceError {
  final String message;

  LocationServiceError(this.message);
}

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          LocationServiceError('Location services are disabled.'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            LocationServiceError('Location permissions are denied'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(LocationServiceError(
          'Location permissions are permanently denied, we cannot request permissions.'));
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}

class AddressService {
  Future<Map<String, String>> getAddressFromCoordinates(
      Position position) async {
    Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //  !
      if (kDebugMode) {
        print(url);
        print(response.statusCode);
        print(data);
      }
      // !
      return {
        "addressLine1": data["address"]["road"] ?? "",
        "city": data["address"]["city"] ?? data["address"]["town"] ?? "",
        "district": data["address"]["suburb"] ?? "",
        "province": data["address"]["state"] ?? "",
        "postalCode": data["address"]["postcode"] ?? "",
        "country": data["address"]["country"] ?? ""
      };
    } else {
      throw Exception('Failed to load address');
    }
  }
}
