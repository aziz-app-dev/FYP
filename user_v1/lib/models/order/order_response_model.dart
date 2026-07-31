import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) =>
    OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) =>
    json.encode(data.toJson());

class OrderResponseModel {
  final bool status;
  final String message;
  final String orderId;

  OrderResponseModel({
    required this.status,
    required this.message,
    required this.orderId,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderResponseModel(
        status: json["status"],
        message: json["message"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "orderId": orderId,
      };
}
