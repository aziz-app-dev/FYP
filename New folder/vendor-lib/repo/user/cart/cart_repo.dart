import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../const/app_url.dart';
import '../../../model/cart/cart_model.dart';
import '../../../services/session/session_manger.dart';

class CartRepository {
  final SessionManager _sessionManager = SessionManager();

  /// Get authorization headers (async to read token from secure storage)
  Future<Map<String, String>> _getHeaders() async {
    final token = await _sessionManager.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Fetch user's cart items
  Future<List<CartItem>> fetchCart() async {
    try {
      final headers = await _getHeaders();

      log('🛒 FETCH CART REQUEST');
      log('  URL: ${AppUrl.cartUrl}');
      log('  Token: ${headers['Authorization']?.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse(AppUrl.cartUrl),
        headers: headers,
      );

      log('🛒 FETCH CART RESPONSE');
      log('  Status: ${response.statusCode}');
      log('  Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List<dynamic> cartData = data['data'] ?? [];
        log('🛒 Cart items count: ${cartData.length}');
        return cartData.map((item) => CartItem.fromJson(item)).toList();
      } else {
        log('🛒 FETCH CART FAILED: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch cart');
      }
    } catch (e) {
      log('🛒 FETCH CART ERROR: $e');
      throw Exception('Error fetching cart: $e');
    }
  }

  /// Get cart count
  Future<int> getCartCount() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppUrl.cartUrl}/count'),
        headers: headers,
      );

      final data = json.decode(response.body);

      log('🛒 CART COUNT: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 && data['status'] == true) {
        return data['data']['cartCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      log('🛒 CART COUNT ERROR: $e');
      return 0;
    }
  }

  /// Add product to cart
  Future<int> addToCart(AddToCartRequest request) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode(request.toJson());

      log('🛒 ADD TO CART REQUEST');
      log('  URL: ${AppUrl.cartUrl}');
      log('  Body: $body');

      final response = await http.post(
        Uri.parse(AppUrl.cartUrl),
        headers: headers,
        body: body,
      );

      final data = json.decode(response.body);

      log('🛒 ADD TO CART RESPONSE');
      log('  Status: ${response.statusCode}');
      log('  Body: ${response.body}');

      if (response.statusCode == 201 && data['status'] == true) {
        log('🛒 Cart count: ${data['data']['count']}');
        return data['data']['count'] ?? 0;
      } else {
        log('🛒 ADD TO CART FAILED: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      log('🛒 ADD TO CART ERROR: $e');
      throw Exception('Error adding to cart: $e');
    }
  }

  /// Remove product from cart
  Future<int> removeFromCart(String cartItemId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppUrl.cartUrl}/delete/$cartItemId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return data['data']['cartCount'] ?? 0;
      } else {
        throw Exception(data['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      throw Exception('Error removing from cart: $e');
    }
  }

  /// Decrement product quantity
  Future<int> decrementQuantity(String productId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppUrl.cartUrl}/decrement/$productId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return data['data']?['cartCount'] ?? -1;
      } else {
        throw Exception(data['message'] ?? 'Failed to decrement quantity');
      }
    } catch (e) {
      throw Exception('Error decrementing quantity: $e');
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppUrl.cartUrl}/clear'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200 || data['status'] != true) {
        throw Exception(data['message'] ?? 'Failed to clear cart');
      }
    } catch (e) {
      throw Exception('Error clearing cart: $e');
    }
  }
}
