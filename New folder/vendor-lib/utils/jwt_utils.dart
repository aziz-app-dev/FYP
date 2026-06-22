import 'dart:convert';

/// Utility class for JWT token operations
class JwtUtils {
  /// Decode JWT token payload without verification
  /// JWT format: header.payload.signature
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decode payload (middle part)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if token is expired
  /// Returns true if expired or invalid, false if valid
  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) {
      return true;
    }

    try {
      final payload = decodeToken(token);
      if (payload == null) {
        return true;
      }

      // JWT 'exp' claim is in seconds since Unix epoch
      final exp = payload['exp'];
      if (exp == null) {
        // No expiration claim - consider it valid
        return false;
      }

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // Token is expired if expiration date is before now
      return expirationDate.isBefore(now);
    } catch (e) {
      // If any error occurs, consider token expired for safety
      return true;
    }
  }

  /// Get token expiration date
  static DateTime? getExpirationDate(String? token) {
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final payload = decodeToken(token);
      if (payload == null) {
        return null;
      }

      final exp = payload['exp'];
      if (exp == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }

  /// Get remaining time until token expires
  static Duration? getTimeUntilExpiration(String? token) {
    final expirationDate = getExpirationDate(token);
    if (expirationDate == null) {
      return null;
    }

    final now = DateTime.now();
    if (expirationDate.isBefore(now)) {
      return Duration.zero;
    }

    return expirationDate.difference(now);
  }

  /// Check if token will expire within given duration
  static bool willExpireSoon(String? token, Duration threshold) {
    final remaining = getTimeUntilExpiration(token);
    if (remaining == null) {
      return false;
    }
    return remaining <= threshold;
  }
}
