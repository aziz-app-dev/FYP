import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../model/order/order_model.dart';

class DriverTaskDetailsPage extends StatelessWidget {
  final OrderModel order;

  const DriverTaskDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final restaurantLatLng = order.restaurantLatLng;
    final customerLatLng = order.deliveryLatLng;
    final driverLatLng = order.driverLatLng;
    final points = <LatLng>[
      if (restaurantLatLng != null) LatLng(restaurantLatLng[0], restaurantLatLng[1]),
      if (driverLatLng != null) LatLng(driverLatLng[0], driverLatLng[1]),
      if (customerLatLng != null) LatLng(customerLatLng[0], customerLatLng[1]),
    ];

    final center = points.isNotEmpty ? points.first : const LatLng(33.6844, 73.0479);

    return Scaffold(
      appBar: AppBar(
        title: Text(order.verificationCode ?? 'Order Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(initialCenter: center, initialZoom: 13),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.food',
                  ),
                  if (points.length >= 2)
                    PolylineLayer(
                      polylines: [
                        Polyline(points: points, strokeWidth: 4, color: Colors.blue),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      if (restaurantLatLng != null)
                        Marker(
                          width: 42,
                          height: 42,
                          point: LatLng(restaurantLatLng[0], restaurantLatLng[1]),
                          child: const Icon(Icons.restaurant, color: Colors.red),
                        ),
                      if (driverLatLng != null)
                        Marker(
                          width: 42,
                          height: 42,
                          point: LatLng(driverLatLng[0], driverLatLng[1]),
                          child: const Icon(Icons.delivery_dining, color: Colors.blue),
                        ),
                      if (customerLatLng != null)
                        Marker(
                          width: 42,
                          height: 42,
                          point: LatLng(customerLatLng[0], customerLatLng[1]),
                          child: const Icon(Icons.home, color: Colors.green),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Pickup'),
              subtitle: Text(order.restaurant?.title ?? order.restaurantAddress),
              trailing: const Icon(Icons.restaurant),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Drop'),
              subtitle: Text(
                order.deliveryAddress?.fullAddress.isNotEmpty == true
                    ? order.deliveryAddress!.fullAddress
                    : 'Customer address',
              ),
              trailing: const Icon(Icons.home),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Payment'),
              subtitle: Text('${order.paymentMethod.value} · ${order.paymentStatus.value}'),
              trailing: Text('\$${order.grandTotal.toStringAsFixed(0)}'),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timeline',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _step('Order Ready', order.orderStatus != OrderStatus.pending),
                  _step(
                    'Out For Delivery',
                    order.orderStatus == OrderStatus.outForDelivery ||
                        order.orderStatus == OrderStatus.delivery,
                  ),
                  _step('Delivered', order.orderStatus == OrderStatus.delivery),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(String title, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
