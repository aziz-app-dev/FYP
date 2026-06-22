import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../ui/user/home/widgets/cat_widget.dart';
import '../../../ui/user/home/widgets/foods_section_widget.dart';
import '../../../ui/user/home/widgets/slider_widget.dart';
import '../../../ui/user/home/widgets/deals_section_widget.dart';
import '../../../ui/user/home/widgets/offers_section_widget.dart';
import '../../../utils/loaders_utils.dart';

import '../../../bloc/user/home/home_bloc.dart';
import '../../../bloc/user/home/home_events.dart';
import '../../../bloc/user/home/home_state.dart';
import '../../../bloc/user/wishlist/wishlist_bloc.dart';
import '../../../bloc/user/wishlist/wishlist_event.dart';
import '../../../config/config.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/home/home_model.dart';
import '../../../di/service_locator.dart';
import '../../../routes/route_name.dart';
import 'widgets/banner_widget.dart';
import 'widgets/header_widget.dart';
import 'widgets/promo_slider_widget.dart';
import 'widgets/recent_orders_widget.dart';
import 'widgets/recent_reservations_widget.dart';
import 'widgets/resturents_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  late WishlistBloc wishlistBloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeBloc = getIt<HomeBloc>();
    homeBloc.add(FetchHomeData());
    wishlistBloc = getIt<WishlistBloc>()..add(LoadWishlistEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    homeBloc.close();
    wishlistBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeBloc),
        BlocProvider.value(value: wishlistBloc),
      ],
      child: ScreenWrapper(
        showHeaderDecoration: false,
        mobileHeader: HeaderWidget(controller: _controller),
        mobile: BlocBuilder<HomeBloc, HomeStates>(
          buildWhen: (prev, curr) => prev.homeData != curr.homeData,
          builder: (context, state) {
            // Loading state - centered loader
            if (state.homeData.isLoading) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: Center(child: appLoader()),
              );
            }

            // Error state - check if network error
            if (state.homeData.isError) {
              final errorMessage = state.homeData.message;
              final isNetwork = isNetworkError(errorMessage);

              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: Center(
                  child: isNetwork
                      ? AppErrorWidget.noInternet(
                          onRetry: () => homeBloc.add(FetchHomeData()),
                        )
                      : AppErrorWidget.general(
                          message: errorMessage,
                          onRetry: () => homeBloc.add(FetchHomeData()),
                        ),
                ),
              );
            }

            // No data state
            final homeData = state.homeData.data;
            if (homeData == null) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: Center(
                  child: AppErrorWidget.general(
                    title: "No Data",
                    message: "No data available at the moment",
                    onRetry: () => homeBloc.add(FetchHomeData()),
                  ),
                ),
              );
            }

            // Success state - show content
            return LayoutBuilder(
              builder: (context, constraints) {
                // Check if we have bounded height (mobile) or unbounded (tablet/desktop)
                final hasBoundedHeight =
                    constraints.maxHeight != double.infinity;

                if (hasBoundedHeight) {
                  // Mobile: Use regular ListView with RefreshIndicator
                  return AppRefreshIndicator(
                    pageIcon: AppIcons.refreshHome,
                    onRefresh: () async {
                      homeBloc.add(FetchHomeData());
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppSizes.paddingAllMd,
                      children: _buildSectionsList(context, homeData, state),
                    ),
                  );
                } else {
                  // Tablet/Desktop: Use Column (parent handles scrolling)
                  return Padding(
                    padding: AppSizes.paddingAllMd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildSectionsList(context, homeData, state),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSectionsList(
    BuildContext context,
    HomeData homeData,
    HomeStates state,
  ) {
    final List<Widget> sections = [];
    final sectionOrder =
        homeData.config?.sectionOrder ?? _getDefaultSectionOrder();

    for (final sectionType in sectionOrder) {
      final widget = _buildSection(context, sectionType, homeData);
      if (widget != null) {
        sections.add(widget);
        sections.add(
          SizedBox(height: 25.spMin),
        ); // Add spacing between sections
      }
    }

    sections.add(SizedBox(height: 120.h));

    return sections;
  }

  List<String> _getDefaultSectionOrder() {
    return [
      "banner",
      "carousel",
      "categories",
      "slider",
      "deals",
      "offers",
      "recentOrders",
      "recentReservations",
      "topFoods",
      "randomFoods",
      "topRestaurants",
      "randomRestaurants",
    ];
  }

  Widget? _buildSection(
    BuildContext context,
    String sectionType,
    HomeData homeData,
  ) {
    switch (sectionType) {
      case "carousel":
        final carousel = homeData.carousel;
        if (carousel.isEmpty) return null;
        final carouselStyle = homeData.config?.carouselStyle;
        return ImageCarouselWithIndicator(
          imgList: carousel.map((e) => e.imageUrl ?? "").toList(),
          autoPlay: carouselStyle?.autoPlay ?? true,
          autoPlayInterval: carouselStyle?.interval ?? 3000,
          showDots: carouselStyle?.showDots ?? true,
          height: carouselStyle?.height?.toDouble(),
        );

      case "categories":
        final categories = homeData.categories;
        if (categories.isEmpty) return null;
        return CategoriesSection(
          styleConfig: homeData.config?.categoryStyle,
          categories: categories
              .map(
                (e) => {
                  'id': e.id ?? "",
                  'image': e.imageUrl ?? "",
                  'label': e.title ?? "",
                },
              )
              .toList(),
        );

      case "deals":
        final deals = homeData.deals;
        if (deals.isEmpty) return null;
        return DealsSectionWidget(
          deals: deals.map((deal) {
            return {
              'id': deal.id ?? "",
              'title': deal.title ?? "",
              'restaurantName': deal.restaurant?.title ?? "",
              'restaurantId': deal.restaurant?.id ?? "",
              'image': deal.imageUrl ?? "",
              'discountPercentage': (deal.discountPercentage ?? 0).toInt(),
              'originalPrice': deal.originalPrice ?? 0.0,
              'discountedPrice': deal.dealPrice ?? 0.0,
              'validUntil': "",
              'itemsIncluded':
                  deal.items
                      ?.map(
                        (item) => {
                          'name': item.food?.title ?? "",
                          'quantity': item.quantity ?? 1,
                          'icon': '🍽️',
                        },
                      )
                      .toList() ??
                  [],
              'description': deal.description ?? "",
              'termsAndConditions': "",
              'category': deal.dealType ?? "",
              'onTap': () {
                Navigator.pushNamed(
                  context,
                  RouteName.dealDetails,
                  arguments: _dealToMap(deal),
                );
              },
            };
          }).toList(),
          title: "Special Deals",
          onTap: () => Navigator.pushNamed(context, RouteName.allDeals),
        );

      case "offers":
        final offers = homeData.offers;
        if (offers.isEmpty) return null;
        return OffersSectionWidget(
          offers: offers.map((offer) {
            return {
              'id': offer.id ?? "",
              'title': offer.title ?? "",
              'description': offer.description ?? "",
              'image': offer.bannerImageUrl ?? "",
              'discountPercentage': (offer.discountValue ?? 0).toInt(),
              'promoCode': offer.promoCode ?? "",
              'subDetails': offer.offerType ?? "",
              'expiryTime': "",
              'validUntil': "",
              'participatingRestaurants':
                  offer.restaurants
                      ?.map(
                        (r) => {
                          'name': r.title ?? "",
                          'rating': r.rating ?? 0.0,
                          'deliveryTime': "30 min",
                          'image': r.imageUrl ?? "",
                        },
                      )
                      .toList() ??
                  [],
              'termsAndConditions': <String>[],
              'onTap': () {
                Navigator.pushNamed(
                  context,
                  RouteName.offerDetails,
                  arguments: _offerToMap(offer),
                );
              },
            };
          }).toList(),
          title: "Limited Time Offers",
          onTap: () => Navigator.pushNamed(context, RouteName.allOffers),
        );

      case "topFoods":
        final topFoods = homeData.topFoods;
        if (topFoods.isEmpty) return null;
        return FoodsSectionWidget(
          foods: topFoods,
          title: "Top Rated Foods",
          onTap: () => Navigator.pushNamed(context, RouteName.topRatedFoods),
        );

      case "randomFoods":
        final randomFoods = homeData.randomFoods;
        if (randomFoods.isEmpty) return null;
        return FoodsSectionWidget(
          foods: randomFoods,
          title: "Explore Foods",
          onTap: () => Navigator.pushNamed(context, RouteName.allFoods),
        );

      case "topRestaurants":
        final topRestaurants = homeData.topRestaurants;
        if (topRestaurants.isEmpty) return null;
        return RestaurantsSectionWidget(
          random: topRestaurants
              .map(
                (r) => {
                  'id': r.id ?? "",
                  'name': r.title ?? "",
                  'tags': r.verification ?? "",
                  'image': r.imageUrl ?? "",
                  'logoUrl': r.logoUrl ?? "",
                  'rating': r.rating ?? 0.0,
                  'timing': r.time,
                  'isOpen': true,
                },
              )
              .toList(),
          title: "Top Restaurants",
          onTap: () => Navigator.pushNamed(context, RouteName.allRestaurants),
        );

      case "randomRestaurants":
        final randomRestaurants = homeData.randomRestaurants;
        if (randomRestaurants.isEmpty) return null;
        return RestaurantsSectionWidget(
          random: randomRestaurants
              .map(
                (r) => {
                  'id': r.id ?? "",
                  'name': r.title ?? "",
                  'tags': r.verification ?? "",
                  'image': r.imageUrl ?? "",
                  'logoUrl': r.logoUrl ?? "",
                  'rating': r.rating ?? 0.0,
                  'timing': r.time,
                  'isOpen': true,
                },
              )
              .toList(),
          title: "Nearby Restaurants",
          onTap: () => Navigator.pushNamed(context, RouteName.allRestaurants),
        );

      case "banner":
        final bannerItems = homeData.banner;
        if (bannerItems.isEmpty) return null;
        return HomeBannerWidget(banner: bannerItems.first);

      case "slider":
        final sliderItems = homeData.slider;
        if (sliderItems.isEmpty) return null;
        final sliderStyle = homeData.config?.sliderStyle;
        return PromoSliderWidget(slides: sliderItems, style: sliderStyle);

      case "recentOrders":
        final recentOrders = homeData.recentOrders;
        if (recentOrders.isEmpty) return null;
        return RecentOrdersSectionWidget(orders: recentOrders);

      case "recentReservations":
        final recentReservations = homeData.recentReservations;
        if (recentReservations.isEmpty) return null;
        return RecentReservationsSectionWidget(
          reservations: recentReservations,
          onViewAll: () =>
              Navigator.pushNamed(context, RouteName.myReservations),
        );

      default:
        return null;
    }
  }

  Map<String, dynamic> _dealToMap(DealItem deal) {
    return {
      'id': deal.id ?? "",
      'title': deal.title ?? "",
      'restaurantName': deal.restaurant?.title ?? "",
      'restaurantId': deal.restaurant?.id ?? "",
      'image': deal.imageUrl ?? "",
      'discountPercentage': (deal.discountPercentage ?? 0).toInt(),
      'originalPrice': deal.originalPrice ?? 0.0,
      'discountedPrice': deal.dealPrice ?? 0.0,
      'validUntil': "",
      'itemsIncluded':
          deal.items
              ?.map(
                (item) => {
                  'name': item.food?.title ?? "",
                  'quantity': item.quantity ?? 1,
                  'icon': '🍽️',
                },
              )
              .toList() ??
          [],
      'description': deal.description ?? "",
      'termsAndConditions': "",
      'category': deal.dealType ?? "",
    };
  }

  Map<String, dynamic> _offerToMap(OfferItem offer) {
    return {
      'id': offer.id ?? "",
      'title': offer.title ?? "",
      'description': offer.description ?? "",
      'image': offer.bannerImageUrl ?? "",
      'discountPercentage': (offer.discountValue ?? 0).toInt(),
      'promoCode': offer.promoCode ?? "",
      'subDetails': offer.offerType ?? "",
      'expiryTime': "",
      'validUntil': "",
      'participatingRestaurants':
          offer.restaurants
              ?.map(
                (r) => {
                  'name': r.title ?? "",
                  'rating': r.rating ?? 0.0,
                  'deliveryTime': "30 min",
                  'image': r.imageUrl ?? "",
                },
              )
              .toList() ??
          [],
      'termsAndConditions': <String>[],
    };
  }
}
