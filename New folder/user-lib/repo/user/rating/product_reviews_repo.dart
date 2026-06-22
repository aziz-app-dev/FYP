import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../const/app_url.dart';
import '../../../model/rating/product_review_model.dart';
import '../../../services/session/session_manger.dart';

class ProductReviewsRepo {
  final SessionManager _sessionManager = SessionManager();

  Map<String, String> get _headers {
    final token = _sessionManager.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ProductReviewsResponse> getProductReviews({
    required String productId,
    required String ratingType,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          '${AppUrl.productRatingsUrl}/$productId?ratingType=$ratingType&page=$page&limit=$limit';

      final response = await http.get(Uri.parse(url), headers: _headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final responseData = data['data'];

        final stats = responseData['stats'] != null
            ? ProductReviewStats.fromJson(
                responseData['stats'] as Map<String, dynamic>)
            : const ProductReviewStats();

        final List<ProductReview> reviews = [];
        if (responseData['ratings'] != null) {
          for (final r in responseData['ratings']) {
            reviews.add(ProductReview.fromJson(r as Map<String, dynamic>));
          }
        }

        final pagination =
            responseData['pagination'] as Map<String, dynamic>? ?? {};

        return ProductReviewsResponse(
          success: true,
          stats: stats,
          reviews: reviews,
          currentPage: pagination['currentPage'] ?? 1,
          totalPages: pagination['totalPages'] ?? 1,
          hasMore: pagination['hasMore'] ?? false,
        );
      }

      return ProductReviewsResponse(
        success: false,
        message: data['message'] ?? 'Failed to load reviews',
      );
    } catch (e) {
      return ProductReviewsResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}

class ProductReviewsResponse {
  final bool success;
  final String? message;
  final ProductReviewStats stats;
  final List<ProductReview> reviews;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ProductReviewsResponse({
    required this.success,
    this.message,
    this.stats = const ProductReviewStats(),
    this.reviews = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });
}
