import 'package:flutter/foundation.dart';

import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/order/order_model.dart';

class OrderRepo {
  final api = NetworkServicesApi();

  /// Parse a list of orders, skipping any that fail to parse
  List<OrderModel> _parseOrders(List<dynamic> data) {
    final orders = <OrderModel>[];
    for (final json in data) {
      try {
        orders.add(OrderModel.fromJson(json));
      } catch (e) {
        debugPrint('Skipping order parse error: $e');
      }
    }
    return orders;
  }

  /// Get all user orders
  /// Endpoint: GET /api/order
  Future<List<OrderModel>> getUserOrders(String token) async {
    final response = await api.getApiWithAuth(AppUrl.orderUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return _parseOrders(data);
  }

  /// Get active orders (Pending, Placed, Preparing, Ready, Out For Delivery)
  /// Endpoint: GET /api/order/active
  Future<List<OrderModel>> getActiveOrders(String token) async {
    final response = await api.getApiWithAuth(AppUrl.activeOrdersUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return _parseOrders(data);
  }

  /// Get order history with pagination
  /// Endpoint: GET /api/order/history?page=1&limit=10
  Future<OrderHistoryResponse> getOrderHistory(
    String token, {
    int page = 1,
    int limit = 10,
  }) async {
    final url = '${AppUrl.orderHistoryUrl}?page=$page&limit=$limit';
    final response = await api.getApiWithAuth(url, token);
    return OrderHistoryResponse.fromJson(response['data'] ?? {});
  }

  /// Get single order by ID
  /// Endpoint: GET /api/order/:id
  Future<OrderModel> getOrderById(String orderId, String token) async {
    final url = '${AppUrl.orderUrl}/$orderId';
    final response = await api.getApiWithAuth(url, token);
    return OrderModel.fromJson(response['data']);
  }

  /// Place a new order
  /// Endpoint: POST /api/order
  Future<String> placeOrder(Map<String, dynamic> orderData, String token) async {
    final response = await api.postApiWithAuth(AppUrl.orderUrl, orderData, token);
    return response['data']['orderId']?.toString() ?? '';
  }

  /// Update order status (cancel order)
  /// Endpoint: PUT /api/order/:id
  Future<OrderModel?> updateOrderStatus(
    String orderId,
    String status,
    String token,
  ) async {
    final url = '${AppUrl.orderUrl}/$orderId';
    final response = await api.putApiWithAuth(
      url,
      {'orderStatus': status},
      token,
    );
    if (response['data'] != null) {
      return OrderModel.fromJson(response['data']);
    }
    return null;
  }

  /// Verify order by verification code
  /// Endpoint: GET /api/order/verify/:verificationCode
  Future<OrderModel> verifyOrderByCode(String code, String token) async {
    final url = '${AppUrl.orderVerifyUrl}/$code';
    final response = await api.getApiWithAuth(url, token);
    return OrderModel.fromJson(response['data']);
  }

  /// Cancel order
  /// Endpoint: PUT /api/order/:id with status "Cancelled"
  Future<bool> cancelOrder(String orderId, String token) async {
    try {
      await updateOrderStatus(orderId, 'Cancelled', token);
      return true;
    } catch (e) {
      return false;
    }
  }
}
