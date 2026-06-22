import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../const/app_url.dart';
import '../../../model/rating/rating_model.dart';
import '../../../services/session/session_manger.dart';

class RatingRepo {
  final SessionManager _sessionManager = SessionManager();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _sessionManager.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get all user ratings with optional filter by type
  Future<RatingResponse> getUserRatings({RatingType? ratingType}) async {
    try {
      String url = AppUrl.userRatingsUrl;
      if (ratingType != null) {
        url += '?ratingType=${_ratingTypeToString(ratingType)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final responseData = data['data'];

        // Parse stats
        final stats = responseData['stats'] != null
            ? RatingStats.fromJson(responseData['stats'])
            : const RatingStats();

        // Parse all ratings
        final List<RatingModel> allRatings = [];
        if (responseData['ratings'] != null) {
          for (final r in responseData['ratings']) {
            allRatings.add(RatingModel.fromJson(r));
          }
        }

        // Parse categorized ratings
        final List<RatingModel> foodRatings = [];
        if (responseData['foodRatings'] != null) {
          for (final r in responseData['foodRatings']) {
            foodRatings.add(RatingModel.fromJson(r));
          }
        }

        final List<RatingModel> restaurantRatings = [];
        if (responseData['restaurantRatings'] != null) {
          for (final r in responseData['restaurantRatings']) {
            restaurantRatings.add(RatingModel.fromJson(r));
          }
        }

        final List<RatingModel> driverRatings = [];
        if (responseData['driverRatings'] != null) {
          for (final r in responseData['driverRatings']) {
            driverRatings.add(RatingModel.fromJson(r));
          }
        }

        return RatingResponse(
          success: true,
          stats: stats,
          allRatings: allRatings,
          foodRatings: foodRatings,
          restaurantRatings: restaurantRatings,
          driverRatings: driverRatings,
        );
      }

      return RatingResponse(
        success: false,
        message: data['message'] ?? 'Failed to load ratings',
      );
    } catch (e) {
      return RatingResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Add a new rating
  Future<RatingActionResponse> addRating({
    required RatingType ratingType,
    required String productId,
    required double rating,
    String? comment,
    String? orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.ratingUrl),
        headers: await _getHeaders(),
        body: jsonEncode({
          'ratingType': _ratingTypeToString(ratingType),
          'product': productId,
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
          if (orderId != null) 'orderId': orderId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RatingActionResponse(
          success: data['status'] == true,
          message: data['message'] ?? 'Rating added successfully',
        );
      }

      return RatingActionResponse(
        success: false,
        message: data['message'] ?? 'Failed to add rating',
      );
    } catch (e) {
      return RatingActionResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Update an existing rating
  Future<RatingActionResponse> updateRating({
    required String ratingId,
    double? rating,
    String? comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.ratingUrl}/$ratingId'),
        headers: await _getHeaders(),
        body: jsonEncode({
          if (rating != null) 'rating': rating,
          if (comment != null) 'comment': comment,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return RatingActionResponse(
          success: data['status'] == true,
          message: data['message'] ?? 'Rating updated successfully',
        );
      }

      return RatingActionResponse(
        success: false,
        message: data['message'] ?? 'Failed to update rating',
      );
    } catch (e) {
      return RatingActionResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Delete a rating
  Future<RatingActionResponse> deleteRating(String ratingId) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppUrl.ratingUrl}/$ratingId'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return RatingActionResponse(
          success: data['status'] == true,
          message: data['message'] ?? 'Rating deleted successfully',
        );
      }

      return RatingActionResponse(
        success: false,
        message: data['message'] ?? 'Failed to delete rating',
      );
    } catch (e) {
      return RatingActionResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Check if user has rated a product
  Future<RatingCheckResponse> checkRating({
    required RatingType ratingType,
    required String productId,
  }) async {
    try {
      final url =
          '${AppUrl.ratingUrl}?ratingType=${_ratingTypeToString(ratingType)}&product=$productId';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return RatingCheckResponse(
          success: true,
          hasRated: data['status'] == true,
          existingRating: data['data']?['rating']?.toDouble(),
          message: data['message'],
        );
      }

      return RatingCheckResponse(
        success: false,
        hasRated: false,
        message: data['message'] ?? 'Failed to check rating',
      );
    } catch (e) {
      return RatingCheckResponse(
        success: false,
        hasRated: false,
        message: e.toString(),
      );
    }
  }

  /// Check if user can review a product (has delivered order + hasn't already rated)
  Future<CanReviewResponse> checkCanReview({
    required RatingType ratingType,
    required String productId,
  }) async {
    try {
      final url =
          '${AppUrl.ratingUrl}/can-review?ratingType=${_ratingTypeToString(ratingType)}&product=$productId';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final responseData = data['data'];
        return CanReviewResponse(
          success: true,
          canReview: responseData?['canReview'] ?? false,
          hasRated: responseData?['hasRated'] ?? false,
          existingRating: responseData?['existingRating']?.toDouble(),
        );
      }

      return const CanReviewResponse(
        success: false,
        canReview: false,
        hasRated: false,
      );
    } catch (e) {
      return const CanReviewResponse(
        success: false,
        canReview: false,
        hasRated: false,
      );
    }
  }

  String _ratingTypeToString(RatingType type) {
    switch (type) {
      case RatingType.food:
        return 'Food';
      case RatingType.restaurant:
        return 'Restaurant';
      case RatingType.driver:
        return 'Driver';
    }
  }
}

/// Response class for getUserRatings
class RatingResponse {
  final bool success;
  final String? message;
  final RatingStats stats;
  final List<RatingModel> allRatings;
  final List<RatingModel> foodRatings;
  final List<RatingModel> restaurantRatings;
  final List<RatingModel> driverRatings;

  const RatingResponse({
    required this.success,
    this.message,
    this.stats = const RatingStats(),
    this.allRatings = const [],
    this.foodRatings = const [],
    this.restaurantRatings = const [],
    this.driverRatings = const [],
  });
}

/// Response class for add/update/delete actions
class RatingActionResponse {
  final bool success;
  final String? message;

  const RatingActionResponse({
    required this.success,
    this.message,
  });
}

/// Response class for checking if user has rated
class RatingCheckResponse {
  final bool success;
  final bool hasRated;
  final double? existingRating;
  final String? message;

  const RatingCheckResponse({
    required this.success,
    required this.hasRated,
    this.existingRating,
    this.message,
  });
}

/// Response class for checking if user can review
class CanReviewResponse {
  final bool success;
  final bool canReview;
  final bool hasRated;
  final double? existingRating;

  const CanReviewResponse({
    required this.success,
    required this.canReview,
    required this.hasRated,
    this.existingRating,
  });
}
