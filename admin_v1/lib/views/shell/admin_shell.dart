import 'package:flutter/material.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../dashboard/dashboard_view.dart';
import '../orders/orders_view.dart';
import '../profile/profile_view.dart';
import '../restaurants/restaurants_view.dart';
import '../users/users_view.dart';

/// Root screen after login: bottom navigation over the five admin areas.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _titles = [
    'Dashboard',
    'Orders',
    'Restaurants',
    'Users',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardView(),
      const OrdersView(),
      RestaurantsView(),
      UsersView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0.5,
        centerTitle: true,
        title: ReuseableText(
          text: _titles[_index],
          fontSize: 17,
          fontWeight: FontWeight.w800,
          textColor: kDark,
        ),
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: kWhite,
        indicatorColor: kPrimary.withValues(alpha: 0.15),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: kPrimary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: kPrimary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded, color: kPrimary),
            label: 'Restaurants',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people_rounded, color: kPrimary),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded, color: kPrimary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
