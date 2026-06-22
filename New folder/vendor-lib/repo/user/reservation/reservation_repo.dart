import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_url.dart';
import '../../../model/reservation/reservation_model.dart';
import '../../../services/session/session_manger.dart';

class ReservationRepo {
  final SessionManager _sessionManager = SessionManager();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _sessionManager.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Create a new reservation
  Future<ReservationResponse> createReservation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.reservationUrl),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ReservationResponse(
          success: true,
          message: json['message'] ?? 'Reservation created',
          reservation: json['data'] != null
              ? ReservationModel.fromJson(json['data'])
              : null,
        );
      }
      return ReservationResponse(
        success: false,
        message: json['message'] ?? 'Failed to create reservation',
      );
    } catch (e) {
      debugPrint('ReservationRepo.createReservation error: $e');
      return ReservationResponse(success: false, message: e.toString());
    }
  }

  /// Get user's reservations
  Future<ReservationListResponse> getUserReservations({String? status}) async {
    try {
      var url = AppUrl.userReservationsUrl;
      if (status != null) url += '?status=$status';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final json = jsonDecode(response.body);
      if (json['status'] == true) {
        final List<dynamic> data = json['data'] ?? [];
        return ReservationListResponse(
          success: true,
          reservations: data.map((r) => ReservationModel.fromJson(r)).toList(),
        );
      }
      return ReservationListResponse(
        success: false,
        message: json['message'] ?? 'Failed to load reservations',
      );
    } catch (e) {
      debugPrint('ReservationRepo.getUserReservations error: $e');
      return ReservationListResponse(success: false, message: e.toString());
    }
  }

  /// Cancel a reservation
  Future<ReservationResponse> cancelReservation(String reservationId) async {
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.reservationUrl}/$reservationId/cancel'),
        headers: await _getHeaders(),
      );

      final json = jsonDecode(response.body);
      if (json['status'] == true) {
        return ReservationResponse(
          success: true,
          message: json['message'] ?? 'Reservation cancelled',
        );
      }
      return ReservationResponse(
        success: false,
        message: json['message'] ?? 'Failed to cancel reservation',
      );
    } catch (e) {
      debugPrint('ReservationRepo.cancelReservation error: $e');
      return ReservationResponse(success: false, message: e.toString());
    }
  }

  /// Get available slots for a restaurant on a date
  Future<SlotsResponse> getAvailableSlots({
    required String restaurantId,
    required String date,
    int guests = 1,
    String? area,
    String type = 'table',
  }) async {
    try {
      var url = '${AppUrl.reservationSlotsUrl}/$restaurantId?date=$date&guests=$guests&type=$type';
      if (area != null) url += '&area=$area';

      final response = await http.get(Uri.parse(url));

      final json = jsonDecode(response.body);
      if (json['status'] == true && json['data'] != null) {
        return SlotsResponse(
          success: true,
          data: ReservationSlotsResponse.fromJson(json['data']),
        );
      }
      return SlotsResponse(
        success: false,
        message: json['message'] ?? 'Failed to load slots',
      );
    } catch (e) {
      debugPrint('ReservationRepo.getAvailableSlots error: $e');
      return SlotsResponse(success: false, message: e.toString());
    }
  }

  /// Get restaurant reservation info (tables, rooms, areas)
  Future<ReservationInfoResponse> getRestaurantReservationInfo(String restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.reservationInfoUrl}/$restaurantId'),
      );

      final json = jsonDecode(response.body);
      if (json['status'] == true && json['data'] != null) {
        return ReservationInfoResponse(
          success: true,
          info: ReservationRestaurantInfo.fromJson(json['data']),
        );
      }
      return ReservationInfoResponse(
        success: false,
        message: json['message'] ?? 'Failed to load reservation info',
      );
    } catch (e) {
      debugPrint('ReservationRepo.getRestaurantReservationInfo error: $e');
      return ReservationInfoResponse(success: false, message: e.toString());
    }
  }
}

class ReservationResponse {
  final bool success;
  final String? message;
  final ReservationModel? reservation;

  ReservationResponse({required this.success, this.message, this.reservation});
}

class ReservationListResponse {
  final bool success;
  final String? message;
  final List<ReservationModel> reservations;

  ReservationListResponse({
    required this.success,
    this.message,
    this.reservations = const [],
  });
}

class SlotsResponse {
  final bool success;
  final String? message;
  final ReservationSlotsResponse? data;

  SlotsResponse({required this.success, this.message, this.data});
}

class ReservationInfoResponse {
  final bool success;
  final String? message;
  final ReservationRestaurantInfo? info;

  ReservationInfoResponse({required this.success, this.message, this.info});
}
