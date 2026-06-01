import 'dart:convert';

RatingResponseModel ratingResponseModelFromJson(String str) =>
    RatingResponseModel.fromJson(json.decode(str));

String ratingResponseModelToJson(RatingResponseModel data) =>
    json.encode(data.toJson());

class RatingResponseModel {
  final bool status;
  final String message;

  RatingResponseModel({
    required this.status,
    required this.message,
  });

  factory RatingResponseModel.fromJson(Map<String, dynamic> json) =>
      RatingResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
