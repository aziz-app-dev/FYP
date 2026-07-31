import 'package:flutter_test/flutter_test.dart';

import 'package:fyp_v1/models/order/vendor_order_model.dart';

void main() {
  group('VendorOrder', () {
    test('parses a vendor order payload', () {
      const body = '''
      [{
        "_id":"o1","userId":"u1",
        "orderItems":[{"foodId":{"_id":"f1","title":"Margherita","time":"20 min","imageUrl":["img1"]},
                       "quantity":2,"price":900,"additives":["Cheese"],"instruction":"no onions"}],
        "orderTotal":1800,"deliveryFee":100,"grandTotal":1900,
        "deliveryAddress":"a1","restaurantAddress":"Lahore",
        "restaurantCoords":[31.5,74.3],"recipientCoords":[31.6,74.4],
        "paymentMethod":"Cash","paymentStatus":"Pending","orderStatus":"Pending",
        "restaurantId":"r1","createdAt":"2026-07-21T10:00:00.000Z"
      }]''';
      final orders = vendorOrdersFromJson(body);
      expect(orders, hasLength(1));
      expect(orders.first.orderItems.first.foodTitle, 'Margherita');
      expect(orders.first.grandTotal, 1900);
      expect(orders.first.orderStatus, 'Pending');
    });

    test('does not crash on unpopulated foodId', () {
      const body = '''
      [{"_id":"o2","userId":"u1",
        "orderItems":[{"foodId":"f9","quantity":1,"price":100}],
        "orderTotal":100,"deliveryFee":0,"grandTotal":100,
        "restaurantAddress":"X","restaurantId":"r1","orderStatus":"Ready"}]''';
      final orders = vendorOrdersFromJson(body);
      expect(orders.first.orderItems.first.foodId, 'f9');
      expect(orders.first.orderStatus, 'Ready');
    });
  });
}
