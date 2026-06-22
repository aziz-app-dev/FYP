import 'package:equatable/equatable.dart';

/// A single review with embedded user info (for product reviews page)
class ProductReview extends Equatable {
  final String? id;
  final String userId;
  final String ratingType;
  final String productId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final ReviewUser? user;

  const ProductReview({
    this.id,
    required this.userId,
    required this.ratingType,
    required this.productId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.user,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString() ?? '',
      ratingType: json['ratingType']?.toString() ?? '',
      productId: json['product']?.toString() ?? '',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : 0.0,
      comment: json['comment']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      user: json['user'] != null
          ? ReviewUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String get formattedDate {
    if (createdAt == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt!.month - 1]} ${createdAt!.day}, ${createdAt!.year}';
  }

  @override
  List<Object?> get props =>
      [id, userId, ratingType, productId, rating, comment, createdAt, user];
}

/// Minimal user info embedded in a product review
class ReviewUser extends Equatable {
  final String? id;
  final String username;
  final String? profileUrl;

  const ReviewUser({
    this.id,
    required this.username,
    this.profileUrl,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['_id']?.toString(),
      username: json['username']?.toString() ?? 'Unknown',
      profileUrl: json['profile']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, username, profileUrl];
}

/// Stats for a product's reviews including star distribution
class ProductReviewStats extends Equatable {
  final int totalRatings;
  final double averageRating;
  final Map<int, int> distribution;

  const ProductReviewStats({
    this.totalRatings = 0,
    this.averageRating = 0.0,
    this.distribution = const {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
  });

  factory ProductReviewStats.fromJson(Map<String, dynamic> json) {
    final dist = json['distribution'] as Map<String, dynamic>? ?? {};
    return ProductReviewStats(
      totalRatings: json['totalRatings'] ?? 0,
      averageRating: (json['averageRating'] is num)
          ? json['averageRating'].toDouble()
          : 0.0,
      distribution: {
        5: dist['5'] ?? 0,
        4: dist['4'] ?? 0,
        3: dist['3'] ?? 0,
        2: dist['2'] ?? 0,
        1: dist['1'] ?? 0,
      },
    );
  }

  @override
  List<Object?> get props => [totalRatings, averageRating, distribution];
}
