import 'package:flutter_test/flutter_test.dart';

import 'package:user_v1/repository/hooks/fetch_orders.dart';

void main() {
  group('ClientOrderModel', () {
    test('parses an order list payload', () {
      const body = '''
      [{
        "_id":"o1","userId":"u1",
        "orderItems":[{"foodId":{"_id":"f1","title":"Margherita","time":"20 min","rating":4.5,"imageUrl":["img1"]},
                       "quantity":2,"price":900,"additives":["Cheese"],"instruction":"","_id":"oi1"}],
        "orderTotal":1800,"deliveryFee":100,"grandTotal":1900,
        "deliveryAddress":"a1","restaurantAddress":"Lahore",
        "restaurantCoords":[31.5,74.3],"recipientCoords":[31.6,74.4],
        "paymentMethod":"Cash","paymentStatus":"Pending","orderStatus":"Pending",
        "restaurantId":"r1","driverId":"","rating":3,
        "orderDate":"2026-07-21T10:00:00.000Z",
        "createdAt":"2026-07-21T10:00:00.000Z",
        "updatedAt":"2026-07-21T10:00:00.000Z","__v":0
      }]''';
      final orders = clientOrderModelFromJson(body);
      expect(orders, hasLength(1));
      expect(orders.first.orderItems.first.foodId.title, 'Margherita');
      expect(orders.first.grandTotal, 1900);
      expect(orders.first.orderStatus, 'Pending');
    });
  });
}
