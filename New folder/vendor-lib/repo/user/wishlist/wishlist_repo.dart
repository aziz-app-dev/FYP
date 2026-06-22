import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/wishlist/wishlist_model.dart';

class WishlistRepo {
  final api = NetworkServicesApi();

  /// Get user's wishlist
  /// Endpoint: GET /api/wishlist
  Future<List<WishlistItem>> getWishlist(String token) async {
    final response = await api.getApiWithAuth(AppUrl.wishlistUrl, token);
    // Response format: {"data": {"items": [...], "count": N}}
    final dataObj = response['data'] as Map<String, dynamic>? ?? {};
    final items = dataObj['items'] as List<dynamic>? ?? [];
    return items.map((json) => WishlistItem.fromJson(json)).toList();
  }

  /// Add food to wishlist
  /// Endpoint: POST /api/wishlist
  Future<WishlistItem> addToWishlist(String foodId, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.wishlistUrl,
      {'foodId': foodId},
      token,
    );
    return WishlistItem.fromJson(response['data']);
  }

  /// Remove food from wishlist
  /// Endpoint: DELETE /api/wishlist/:foodId
  Future<bool> removeFromWishlist(String foodId, String token) async {
    await api.deleteApiWithAuth(
      '${AppUrl.wishlistUrl}/$foodId',
      token,
    );
    return true;
  }

  /// Check if food is in wishlist
  /// Endpoint: GET /api/wishlist/check/:foodId
  Future<bool> isInWishlist(String foodId, String token) async {
    try {
      final response = await api.getApiWithAuth(
        '${AppUrl.wishlistUrl}/check/$foodId',
        token,
      );
      return response['data']?['isInWishlist'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Toggle wishlist status (add if not in wishlist, remove if in wishlist)
  Future<bool> toggleWishlist(
    String foodId,
    bool currentlyInWishlist,
    String token,
  ) async {
    if (currentlyInWishlist) {
      await removeFromWishlist(foodId, token);
      return false;
    } else {
      await addToWishlist(foodId, token);
      return true;
    }
  }
}
