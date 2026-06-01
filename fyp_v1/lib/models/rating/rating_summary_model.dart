import 'dart:convert';

RatingSummary ratingSummaryFromJson(String str) =>
    RatingSummary.fromJson(json.decode(str));

class RatingSummary {
  final double average;
  final int count;

  /// Count per bucket — index 0 = 1-star count, index 4 = 5-star count.
  final List<int> breakdown;
  final List<Review> reviews;

  RatingSummary({
    required this.average,
    required this.count,
    required this.breakdown,
    required this.reviews,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) => RatingSummary(
        average: (json["average"] ?? 0).toDouble(),
        count: json["count"] ?? 0,
        breakdown: List<int>.from(
            (json["breakdown"] ?? [0, 0, 0, 0, 0]).map((x) => (x ?? 0) as int)),
        reviews: List<Review>.from(
            (json["reviews"] ?? []).map((x) => Review.fromJson(x))),
      );

  /// Count for a specific star value (1..5).
  int countFor(int star) {
    if (star < 1 || star > 5) return 0;
    return breakdown[star - 1];
  }
}

class Review {
  final String id;
  final String userId;
  final String username;
  final String userPhoto;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.username,
    required this.userPhoto,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"]?.toString() ?? '',
        userId: json["userId"]?.toString() ?? '',
        username: (json["username"] ?? '').toString(),
        userPhoto: (json["userPhoto"] ?? '').toString(),
        rating: (json["rating"] ?? 0).toDouble(),
        comment: (json["comment"] ?? '').toString(),
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"].toString())
            : null,
      );
}
