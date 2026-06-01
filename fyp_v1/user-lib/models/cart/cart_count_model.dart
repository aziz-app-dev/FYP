import 'dart:convert';

CartCountModel cartCountModelFromJson(String str) =>
    CartCountModel.fromJson(json.decode(str));

String cartCountModelToJson(CartCountModel data) => json.encode(data.toJson());

class CartCountModel {
  final bool status;
  final int cartCount;

  CartCountModel({
    required this.status,
    required this.cartCount,
  });

  factory CartCountModel.fromJson(Map<String, dynamic> json) => CartCountModel(
        status: json["status"],
        cartCount: json["cartCount"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cartCount": cartCount,
      };
}
