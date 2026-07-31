import 'dart:convert';

/// Users as returned by GET /api/user/admin/all
/// -> { status, count, users: [...] }
AdminUsersResponse adminUsersResponseFromJson(String str) =>
    AdminUsersResponse.fromJson(json.decode(str));

class AdminUsersResponse {
  final bool status;
  final int count;
  final List<AdminUser> users;

  AdminUsersResponse({
    required this.status,
    required this.count,
    required this.users,
  });

  factory AdminUsersResponse.fromJson(Map<String, dynamic> json) =>
      AdminUsersResponse(
        status: json["status"] ?? false,
        count: json["count"] ?? 0,
        users: json["users"] == null
            ? []
            : List<AdminUser>.from(
                json["users"].map((x) => AdminUser.fromJson(x))),
      );
}

class AdminUser {
  final String id;
  final String username;
  final String email;
  final bool verification;
  final String phone;
  final bool phoneVerification;
  final String userType;
  final String profile;
  final DateTime? createdAt;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.verification,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json["_id"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        verification: json["verification"] ?? false,
        phone: json["phone"] ?? '',
        phoneVerification: json["phoneVerification"] ?? false,
        userType: json["userType"] ?? '',
        profile: json["profile"] ?? '',
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
      );
}
