import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/res_imports.dart';

import '../../../models/restaurant/restaurant_model.dart';
import '../../../repository/hooks/fatch_all_res_hook.dart';
import '../../../repository/hooks/fetch_defult_address.dart';
import 'widget/rec-food_tilte.dart';

class AllNearByRestaurant extends StatefulHookWidget {
  const AllNearByRestaurant({super.key});

  @override
  State<AllNearByRestaurant> createState() => _AllNearByRestaurantState();
}

class _AllNearByRestaurantState extends State<AllNearByRestaurant> {
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllRestaurant();
    List<RestaurantModel>? restaurants = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    // final box = GetStorage();
    // ! address
    // var addressTrigger = box.read('defultAddress');
    final addressHookResult = useDefaultAddress(context);
    final address = addressHookResult.data;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kSecondary,
          title: const ReuseableText(
            text: 'All Nearby Restaurants',
            fontSize: 13,
            textColor: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          elevation: 0.3,
        ),
        body: isLoading
            ? const FoodListShimmer()
            : (error != null
                ? Center(child: Text('Error: ${error.toString()}'))
                : Container(
                    color: Colors.white,
                    // height: 205.h,
                    padding:
                        EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: restaurants!.length,
                      itemBuilder: (context, index) {
                        var restaurant = restaurants[index];
                        return RestaurantTile(
                          restaurant: restaurant,
                          address: address,
                        );
                      },
                    ),
                  )));
  }
}
