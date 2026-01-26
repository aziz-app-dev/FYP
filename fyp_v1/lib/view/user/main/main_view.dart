import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../res/res_imports.dart';

import '../../../view_models/controller/cart/cart_view_model.dart';
import '../../../view_models/controller/login/login_view_model.dart';
import '../../../view_models/controller/main/mian_view_model.dart';
import '../../../view_models/controller/user/user_view_model.dart';
import '../cart/cart_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../search/search_view.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cartController = Get.put(CartController());
  final userInfoController = Get.put(UserInformation());
  List<Widget> pageList = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];
  @override
  void initState() {
    super.initState();
    cartController.fetchCartCount();
    final userInfoController = Get.put(UserInformation());
    userInfoController.fetchUserData();
    // final box1 = GetStorage();
    // String? accessToken = box1.read("token");
    // final String? accessToken = box1.read("token");
    // print('tokens in main page:$accessToken');
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final userInfoController = Get.put(UserInformation());
    final loginController = Get.put(LoginController());
    cartController.fetchCartCount();
    userInfoController.fetchUserData();

    final box = GetStorage();
    String? token = box.read('token');
    print('$token : 222');
    if (token != null) {
      var user = loginController.getUserInfo();

      print(user!.email);
      print('$token : 333');
    }
    final controller = Get.put(TabIndexController());
    // print(cartController.count);
    return Scaffold(
        body: Obx(
      () => Stack(
        children: [
          Container(child: pageList[controller.tabIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
                data: Theme.of(context).copyWith(canvasColor: kPrimary),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.black38),
                  selectedIconTheme: const IconThemeData(color: kSecondary),
                  onTap: (value) {
                    controller.setTabIndex = value;
                  },
                  currentIndex: controller.tabIndex,
                  items: [
                    BottomNavigationBarItem(
                        icon: controller.tabIndex == 0
                            ? const Icon(Icons.grid_view_rounded)
                            // ? Image.asset('assets/grid.png')
                            : const Icon(Icons.grid_view_outlined),
                        label: 'Home'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: 'Search'),
                    BottomNavigationBarItem(
                        icon: Obx(
                          () => Badge(
                              label: Text(cartController.count.toString()),
                              child: const Icon(FontAwesome.opencart)),
                        ),
                        label: 'Cart'),
                    BottomNavigationBarItem(
                        icon: controller.tabIndex == 3
                            ? const Icon(FontAwesome.user_circle)
                            : const Icon(FontAwesome.user_circle_o),
                        label: 'Profile'),
                  ],
                )),
          )
        ],
      ),
    ));
  }
}
