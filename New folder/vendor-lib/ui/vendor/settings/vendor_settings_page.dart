import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_event.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_state.dart';
import '../../../routes/route_name.dart';
import '../../../utils/toast_utils.dart';

class VendorSettingsPage extends StatelessWidget {
  const VendorSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Settings')),
      body: BlocConsumer<VendorRestaurantBloc, VendorRestaurantState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ToastUtils.showSuccess(context, message: state.successMessage!);
          }
        },
        builder: (context, state) {
          final restaurant = state.activeRestaurant;
          if (restaurant == null) {
            return const Center(child: Text('No restaurant selected'));
          }

          return ListView(
            padding: EdgeInsets.all(16.spMin),
            children: [
              // Restaurant Status
              Card(
                child: SwitchListTile(
                  title: const Text('Restaurant Open'),
                  subtitle: Text(
                    restaurant.isAvailable == true
                        ? 'Accepting orders'
                        : 'Not accepting orders',
                  ),
                  value: restaurant.isAvailable ?? false,
                  onChanged: (_) {
                    context.read<VendorRestaurantBloc>().add(
                          ToggleRestaurantAvailability(
                            restaurantId: restaurant.id!,
                          ),
                        );
                  },
                ),
              ),

              SizedBox(height: 12.spMin),

              // Info
              _SectionHeader(title: 'Restaurant Info'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: Text(restaurant.title ?? 'N/A'),
                      subtitle: const Text('Restaurant Name'),
                    ),
                    if (restaurant.phone != null)
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(restaurant.phone!),
                        subtitle: const Text('Phone'),
                      ),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(
                        '${restaurant.openingTime ?? "N/A"} - ${restaurant.closingTime ?? "N/A"}',
                      ),
                      subtitle: const Text('Working Hours'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delivery_dining),
                      title: Text('${restaurant.deliveryFee ?? 0}'),
                      subtitle: const Text('Delivery Fee'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.spMin),

              // Reservation Settings
              _SectionHeader(title: 'Table Reservation'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Table Reservation'),
                      value: restaurant.tableReservationEnabled ?? false,
                      onChanged: (val) {
                        context.read<VendorRestaurantBloc>().add(
                              UpdateRestaurant(
                                restaurantId: restaurant.id!,
                                data: {'tableReservationEnabled': val},
                              ),
                            );
                      },
                    ),
                    ListTile(
                      title: const Text('Manage Tables'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteName.tableManagement,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.spMin),

              // Delivery Settings
              _SectionHeader(title: 'Delivery'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Delivery'),
                      value: restaurant.delivery ?? true,
                      onChanged: (val) {
                        context.read<VendorRestaurantBloc>().add(
                              UpdateRestaurant(
                                restaurantId: restaurant.id!,
                                data: {'delivery': val},
                              ),
                            );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Pickup'),
                      value: restaurant.pickup ?? true,
                      onChanged: (val) {
                        context.read<VendorRestaurantBloc>().add(
                              UpdateRestaurant(
                                restaurantId: restaurant.id!,
                                data: {'pickup': val},
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.spMin, left: 4.spMin),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.spMin,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
