import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/config.dart';
import '../../../../const/app_url.dart';
import '../../../../model/order/order_model.dart';

class TrackingMapWidget extends StatelessWidget {
  final OrderModel order;
  final MapController mapController;
  final AnimationController pulseController;

  const TrackingMapWidget({
    super.key,
    required this.order,
    required this.mapController,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final restaurantCoords = order.restaurantLatLng;
    final deliveryCoords = order.deliveryLatLng;
    final driverCoords = order.driverLatLng;

    // Determine map center
    LatLng center;
    if (driverCoords != null) {
      center = LatLng(driverCoords[0], driverCoords[1]);
    } else if (restaurantCoords != null) {
      center = LatLng(restaurantCoords[0], restaurantCoords[1]);
    } else if (deliveryCoords != null) {
      center = LatLng(deliveryCoords[0], deliveryCoords[1]);
    } else {
      center = const LatLng(31.5204, 74.3587); // Default: Lahore
    }

    // Build tile URL — use Mapbox if token is configured, otherwise OpenStreetMap
    final token = AppUrl.mapboxAccessToken;
    final hasMapbox = token != 'YOUR_MAPBOX_ACCESS_TOKEN' && token.isNotEmpty;
    final mapStyle = colors.isDark ? 'mapbox/dark-v11' : 'mapbox/streets-v12';

    final tileUrl = hasMapbox
        ? 'https://api.mapbox.com/styles/v1/$mapStyle/tiles/{z}/{x}/{y}@2x?access_token=$token'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    // Build markers list
    final markers = <Marker>[];

    // Restaurant marker
    if (restaurantCoords != null) {
      markers.add(
        Marker(
          point: LatLng(restaurantCoords[0], restaurantCoords[1]),
          width: 50.w,
          height: 50.w,
          child: _buildMarker(colors, Icons.restaurant_rounded, colors.primary),
        ),
      );
    }

    // Delivery location marker
    if (deliveryCoords != null) {
      markers.add(
        Marker(
          point: LatLng(deliveryCoords[0], deliveryCoords[1]),
          width: 50.w,
          height: 50.w,
          child: _buildMarker(colors, Icons.home_rounded, colors.success),
        ),
      );
    }

    // Driver marker (animated)
    if (driverCoords != null) {
      markers.add(
        Marker(
          point: LatLng(driverCoords[0], driverCoords[1]),
          width: 80.w,
          height: 80.w,
          child: _buildDriverMarker(colors),
        ),
      );
    }

    double zoom = markers.length >= 2 ? 13.0 : 14.0;

    return Positioned.fill(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: zoom,
          minZoom: 5,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            userAgentPackageName: 'com.example.food',
          ),
          // Route polyline
          if (restaurantCoords != null && deliveryCoords != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [
                    LatLng(restaurantCoords[0], restaurantCoords[1]),
                    if (driverCoords != null)
                      LatLng(driverCoords[0], driverCoords[1]),
                    LatLng(deliveryCoords[0], deliveryCoords[1]),
                  ],
                  color: colors.primary.withValues(alpha: .6),
                  strokeWidth: 4,
                ),
              ],
            ),
          if (markers.isNotEmpty) MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  Widget _buildMarker(ThemeColors colors, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20.spMin),
      ),
    );
  }

  Widget _buildDriverMarker(ThemeColors colors) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.2);
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: .5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.delivery_dining_rounded,
                  color: Colors.white,
                  size: 24.spMin,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
