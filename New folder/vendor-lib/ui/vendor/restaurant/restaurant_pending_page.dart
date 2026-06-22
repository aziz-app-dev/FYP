import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_event.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_state.dart';
import '../../../config/widgets/app_btn.dart';

class RestaurantPendingPage extends StatelessWidget {
  const RestaurantPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Status')),
      body: BlocBuilder<VendorRestaurantBloc, VendorRestaurantState>(
        builder: (context, state) {
          final restaurant = state.activeRestaurant;
          final status = restaurant?.verification ?? 'Pending';
          final message = restaurant?.verificationMessage;

          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.spMin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == 'Rejected'
                        ? Icons.cancel_outlined
                        : Icons.hourglass_empty,
                    size: 80.spMin,
                    color: status == 'Rejected' ? Colors.red : Colors.orange,
                  ),
                  SizedBox(height: 24.spMin),
                  Text(
                    status == 'Rejected'
                        ? 'Application Rejected'
                        : 'Application Under Review',
                    style: TextStyle(
                      fontSize: 22.spMin,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.spMin),
                  Text(
                    message ??
                        (status == 'Rejected'
                            ? 'Your restaurant application has been rejected.'
                            : 'Your restaurant is being reviewed. We will notify you once approved.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.spMin,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 32.spMin),
                  AppButton(
                    onPressed: () {
                      context.read<VendorRestaurantBloc>().add(
                            LoadMyRestaurants(),
                          );
                    },
                    text: 'Refresh Status',
                  ),
                  if (status == 'Rejected') ...[
                    SizedBox(height: 12.spMin),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/create-restaurant'),
                      child: const Text('Edit & Resubmit'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
