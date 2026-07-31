import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:admin_v1/models/login/login_response_model.dart';
import 'package:admin_v1/models/order/admin_order_model.dart';
import 'package:admin_v1/models/restaurant/restaurant_model.dart';
import 'package:admin_v1/models/stats/admin_stats_model.dart';
import 'package:admin_v1/models/user/admin_user_model.dart';

void main() {
  group('LoginResponseModel', () {
    test('parses admin login payload', () {
      const body = '''
      {"_id":"66aa","username":"Super Admin","email":"admin@fyp.com",
       "verification":true,"fmc":"none","phone":"0123456789",
       "phoneVerification":true,"userType":"Admin",
       "profile":"http://x/y.png","userToken":"jwt123"}''';
      final user = loginResponseModelFromJson(body);
      expect(user.userType, 'Admin');
      expect(user.userToken, 'jwt123');
      expect(user.verification, true);
      // round-trips through storage
      final again =
          loginResponseModelFromJson(loginResponseModelToJson(user));
      expect(again.id, '66aa');
    });
  });

  group('AdminOrder', () {
    test('parses populated userId/restaurantId/foodId', () {
      const body = '''
      [{
        "_id":"o1",
        "userId":{"_id":"u1","username":"Ali","email":"ali@x.com","phone":"0300","profile":"p"},
        "restaurantId":{"_id":"r1","title":"Pizza Palace","logoUrl":"l","imageUrl":"i","verification":"Verified"},
        "orderItems":[{"foodId":{"_id":"f1","title":"Margherita","time":"20 min","rating":4.5,"imageUrl":["img1"],"price":900},
                       "quantity":2,"price":900,"additives":["Cheese"],"instruction":"extra hot"}],
        "orderTotal":1800,"deliveryFee":100,"grandTotal":1900,
        "deliveryAddress":"a1","restaurantAddress":"Lahore",
        "paymentMethod":"Cash","paymentStatus":"Pending","orderStatus":"Pending",
        "createdAt":"2026-07-21T10:00:00.000Z"
      }]''';
      final orders = adminOrderListFromJson(body);
      expect(orders, hasLength(1));
      final o = orders.first;
      expect(o.user.username, 'Ali');
      expect(o.restaurant.title, 'Pizza Palace');
      expect(o.orderItems.first.foodTitle, 'Margherita');
      expect(o.orderItems.first.quantity, 2);
      expect(o.grandTotal, 1900);
      expect(o.orderStatus, 'Pending');
      expect(o.createdAt, isNotNull);
    });

    test('does not crash on unpopulated ObjectId refs', () {
      const body = '''
      [{
        "_id":"o2","userId":"u9","restaurantId":"r9",
        "orderItems":[{"foodId":"f9","quantity":1,"price":100}],
        "orderTotal":100,"deliveryFee":0,"grandTotal":100,
        "restaurantAddress":"X","orderStatus":"Delivered"
      }]''';
      final orders = adminOrderListFromJson(body);
      final o = orders.first;
      expect(o.user.id, 'u9');
      expect(o.user.username, '');
      expect(o.restaurant.id, 'r9');
      expect(o.orderItems.first.foodId, 'f9');
      expect(o.createdAt, isNull);
    });
  });

  group('AdminStatsModel', () {
    test('parses the stats endpoint payload', () {
      const body = '''
      {"status":true,"totalOrders":12,
       "orders":{"Pending":3,"Delivered":8,"Cancelled":1},
       "revenue":{"grandTotal":25400,"orderTotal":24000,"deliveryFee":1400},
       "totalUsers":7,"users":{"Client":4,"Vendor":2,"Admin":1},
       "totalRestaurants":3,"restaurants":{"Pending":1,"Verified":2}}''';
      final stats = adminStatsModelFromJson(body);
      expect(stats.totalOrders, 12);
      expect(stats.orders['Delivered'], 8);
      expect(stats.revenueGrandTotal, 25400);
      expect(stats.users['Admin'], 1);
      expect(stats.restaurants['Verified'], 2);
    });

    test('handles empty database gracefully', () {
      final stats = AdminStatsModel.fromJson(jsonDecode('{"status":true}'));
      expect(stats.totalOrders, 0);
      expect(stats.orders, isEmpty);
      expect(stats.revenueGrandTotal, 0);
    });
  });

  group('AdminUsersResponse', () {
    test('parses users list', () {
      const body = '''
      {"status":true,"count":2,"users":[
        {"_id":"u1","username":"Ali","email":"a@x.com","verification":true,
         "phone":"0300","phoneVerification":false,"userType":"Client",
         "profile":"p","createdAt":"2026-01-01T00:00:00.000Z"},
        {"_id":"u2","username":"Vend","email":"v@x.com","userType":"Vendor"}
      ]}''';
      final parsed = adminUsersResponseFromJson(body);
      expect(parsed.count, 2);
      expect(parsed.users[0].userType, 'Client');
      expect(parsed.users[1].verification, false);
    });
  });

  group('RestaurantModel', () {
    test('parses admin/all restaurant entry', () {
      const body = '''
      {"_id":"r1","title":"Pizza Palace","time":"30 min","imageUrl":"i",
       "logoUrl":"l","owner":"u2","code":"lahr","isAvailable":true,
       "rating":4.2,"verification":"Pending",
       "verificationMessage":"Under review",
       "coords":{"latitude":31.5,"longitude":74.3,"address":"Lahore","title":"PP"}}''';
      final r = RestaurantModel.fromJson(jsonDecode(body));
      expect(r.title, 'Pizza Palace');
      expect(r.verification, 'Pending');
      expect(r.coords.address, 'Lahore');
    });
  });
}
