import 'dart:convert';

RatingResquestModel ratingResquestModelFromJson(String str) =>
    RatingResquestModel.fromJson(json.decode(str));

String ratingResquestModelToJson(RatingResquestModel data) =>
    json.encode(data.toJson());

class RatingResquestModel {
  final String product;
  final double rating;
  final String ratingType;

  RatingResquestModel({
    required this.product,
    required this.rating,
    required this.ratingType,
  });

  factory RatingResquestModel.fromJson(Map<String, dynamic> json) =>
      RatingResquestModel(
        product: json["product"],
        rating: json["rating"]?.toDouble(),
        ratingType: json["ratingType"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "rating": rating,
        "ratingType": ratingType,
      };
}
