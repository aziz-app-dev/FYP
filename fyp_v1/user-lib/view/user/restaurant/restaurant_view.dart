import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../models/address/address_respose_model.dart';
import '../../../models/distance_time.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../res/res_imports.dart';
import '../../../view_models/services/distance.dart';
import '../main/main_view.dart';
import 'widget/diraction.dart';
import 'widget/explore_foods.dart';
import 'widget/rating_page.dart';
import 'widget/restaurant_menu.dart';

class RestaurantScreen extends StatefulWidget {
  final RestaurantModel? restaurants;
  final AddressResponseModel? address;

  const RestaurantScreen({super.key, this.restaurants, required this.address});

  // const RestaurantScreen({super.key, required this.restaurants});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    // ! address
    // var addressTrigger = box.read('defultAddress');
    // final addressHookResult = useDefaultAddress(context);
    // final address = addressHookResult.data;
    var restaurant = widget.restaurants;

    if (widget.address == null) {
      showAddressSheet(context);
    }
    DistanceTime data = Distance().calculateDistanceTimePrice(
        widget.restaurants!.coords.latitude,
        widget.restaurants!.coords.longitude,
        widget.address!.latitude,
        widget.address!.longitude,
        10,
        2);
    print(widget.address);
    print(data);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kLightWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                    height: 250.h,
                    width: width, // Use double.infinity to fill the width
                    child: Image.network(
                      restaurant!.imageUrl,
                      fit: BoxFit.cover,
                    )
                    // child: CachedNetworkImage(
                    //   imageUrl: restaurant!.imageUrl,
                    //   fit: BoxFit.cover, // Adjust image fit
                    //   placeholder: (context, url) =>
                    //       const Center(child: CircularProgressIndicator()),
                    //   errorWidget: (context, url, error) =>
                    //       const Icon(Icons.error),
                    // ),
                    ),
                Positioned(
                    bottom: 0,
                    child: RestaurantBottomBar(
                        restaurants: restaurant,
                        rating: restaurant.rating.toDouble())),
                Positioned(
                    top: 25.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Get.back();
                              Get.offAll(() => const MainScreen());
                            },
                            child: Icon(
                              Ionicons.chevron_back_circle,
                              size: 35.spMin,
                              color: kPrimary,
                            ),
                          ),
                          // ReuseableText(
                          //   text: restaurant.title,
                          //   fontSize: 14,
                          //   textColor: Colors.black,
                          //   fontWeight: FontWeight.w600,
                          // ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const DiractionPage());
                            },
                            child: Icon(
                              Ionicons.location,
                              size: 25.spMin,
                              color: kLightWhite,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReuseableText(
                    text: restaurant.title,
                    fontSize: 18,
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  Divider(
                    thickness: 0.7.sp,
                  ),
                  TextRow(
                    first: 'Distance to Restaurant',
                    second: data.distance.toStringAsFixed(2),
                    // second: "2.7 km",
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextRow(
                    first: 'Estimate Price',
                    second: "\$ ${data.price.toStringAsFixed(2)}",
                    // second: "\$ 2.7",
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextRow(
                    first: 'Estimate Time',
                    second: '${data.time.toStringAsExponential(2)} mins',
                    // second: "30 min",
                  ),
                  Divider(
                    thickness: 0.7.sp,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                height: 25.h,
                width: width,
                decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  labelPadding: EdgeInsets.zero,
                  labelColor: kLightWhite,
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: SizedBox(
                        width: width / 2,
                        height: 25.h,
                        child: const Center(
                          child: Text('Menu'),
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: width / 2,
                        height: 25.h,
                        child: const Center(
                          child: Text('Explore'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                height: height,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RestaurantMenuWidget(
                      resturantId: restaurant.id,
                    ),
                    ExploreWidget(
                      resturantId: restaurant.id,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RestaurantBottomBar extends StatelessWidget {
  const RestaurantBottomBar({
    super.key,
    required this.rating,
    this.restaurants,
  });

  final double rating;
  final RestaurantModel? restaurants;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //  ! rating
          RatingBarIndicator(
            itemCount: 5,
            itemSize: 25,
            rating: rating,
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star,
                color: Colors.yellow,
              );
            },
          ),
          RoundButton(
            title: 'Rate Restaurant',
            onPress: () {
              Get.to(() => RateRestaurantPage(
                    restaurant: restaurants,
                  ));
            },
            height: 30.h,
            width: width / 3,
          )
        ],
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  const TextRow({super.key, required this.first, required this.second});
  final String first;
  final String second;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReuseableText(
          text: first,
          fontSize: 10,
          textColor: kGray,
          fontWeight: FontWeight.w500,
        ),
        ReuseableText(
          text: second,
          fontSize: 10,
          textColor: kGray,
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }
}
