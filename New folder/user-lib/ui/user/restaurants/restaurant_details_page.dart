import 'package:latlong2/latlong.dart' as latlong;

import '../../../bloc/user/restaurant_details/restaurant_details_bloc.dart';
import '../../../bloc/user/restaurant_details/restaurant_details_event.dart';
import '../../../bloc/user/restaurant_details/restaurant_details_state.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../di/service_locator.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../reservation/book_table_sheet.dart';
import 'widgets/widgets.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<RestaurantDetailsBloc>()
            ..add(LoadRestaurantDetailsEvent(restaurantId: restaurantId)),
      child: _RestaurantDetailsView(restaurantId: restaurantId),
    );
  }
}

class _RestaurantDetailsView extends StatelessWidget {
  final String restaurantId;

  const _RestaurantDetailsView({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsBloc, RestaurantDetailsState>(
      builder: (context, state) {
        return ScreenWrapper(
          topSafeArea: false,
          useMobileScaffold: true,
          isLoading: state.isLoading,
          mobileHeader: const SizedBox.shrink(),
          hasError: state.hasError && state.restaurant == null,
          isNetworkError: isNetworkError(state.errorMessage),
          errorTitle: 'Failed to load restaurant',
          errorMessage: state.errorMessage ?? 'Something went wrong',
          onRetry: () {
            context.read<RestaurantDetailsBloc>().add(
              LoadRestaurantDetailsEvent(restaurantId: restaurantId),
            );
          },
          mobile: state.isSuccess
              ? _RestaurantDetailsContent(state: state)
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _RestaurantDetailsContent extends StatefulWidget {
  final RestaurantDetailsState state;

  const _RestaurantDetailsContent({required this.state});

  @override
  State<_RestaurantDetailsContent> createState() =>
      _RestaurantDetailsContentState();
}

class _RestaurantDetailsContentState extends State<_RestaurantDetailsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _tabCountForState(RestaurantDetailsState state) {
    var count = 2; // Menu + Best Foods
    if (state.deals.isNotEmpty) count++;
    if (state.offers.isNotEmpty) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabCountForState(widget.state),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant _RestaurantDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCount = _tabCountForState(oldWidget.state);
    final newCount = _tabCountForState(widget.state);

    if (oldCount != newCount) {
      final nextIndex = _tabController.index.clamp(0, newCount - 1);
      _tabController.dispose();
      _tabController = TabController(
        length: newCount,
        vsync: this,
        initialIndex: nextIndex,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.state.restaurant!;
    final colors = context.colors;
    final tabs = <Widget>[
      const Tab(text: 'Menu'),
      const Tab(text: 'Best Foods'),
      if (widget.state.deals.isNotEmpty) const Tab(text: 'Deals'),
      if (widget.state.offers.isNotEmpty) const Tab(text: 'Offers'),
    ];
    final tabViews = <Widget>[
      MenuTab(foods: widget.state.foods),
      MenuTab(foods: widget.state.bestFoods),
      if (widget.state.deals.isNotEmpty) DealsTab(deals: widget.state.deals),
      if (widget.state.offers.isNotEmpty)
        OffersTab(offers: widget.state.offers),
    ];

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Hero Image + Logo
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Total height = image (250) + logo overflow (30)
                SizedBox(height: 280.spMin, width: double.infinity),
                // Cover image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250.spMin,
                  child: CachedNetworkImage(
                    imageUrl: restaurant.bannerUrl ?? restaurant.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(
                      color: colors.surfaceVariant,
                      child: Icon(
                        Icons.restaurant,
                        size: 60.spMin,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250.spMin,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.spMin,
                  left: 8.spMin,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.spMin),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.spMin,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                // Logo - half on image, half below
                Positioned(
                  left: 20.spMin,
                  top: 200.spMin,
                  child: Container(
                    width: 80.spMin,
                    height: 80.spMin,
                    decoration: BoxDecoration(
                      color: colors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: colors.scaffoldBackground,
                        width: 4.spMin,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 8.spMin,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.logoUrl ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Icon(
                          Icons.restaurant,
                          color: colors.primary,
                          size: 28.spMin,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.paddingLg,
                12.spMin,
                AppSizes.paddingLg,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    restaurant.title ?? 'Restaurant',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.spMin),

                  // Address + Rating row
                  Row(
                    children: [
                      if (restaurant.coords?.address != null) ...[
                        Icon(
                          Icons.location_on,
                          size: 18.spMin,
                          color: colors.primary,
                        ),
                        SizedBox(width: 4.spMin),
                        Expanded(
                          child: Text(
                            restaurant.coords!.address!,
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.spMin),
                      ],
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.productReviews,
                            arguments: <String, String>{
                              'productId': restaurant.id ?? '',
                              'ratingType': 'Restaurant',
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 18.spMin,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 2.spMin),
                            Text(
                              (restaurant.rating ?? 0).toStringAsFixed(1),
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                            if (restaurant.ratingCount != null) ...[
                              SizedBox(width: 4.spMin),
                              Text(
                                '(${restaurant.ratingCount})',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.spMin),

                  // Info row — value on top, label below, separated by dividers
                  Builder(
                    builder: (context) {
                      // Calculate distance
                      final userAddress = SessionManager().displayAddress;
                      double? distanceKm;
                      if (userAddress?.latitude != null &&
                          userAddress?.longitude != null &&
                          restaurant.coords?.latitude != null &&
                          restaurant.coords?.longitude != null) {
                        final distance = const latlong.Distance();
                        distanceKm = distance.as(
                          latlong.LengthUnit.Kilometer,
                          latlong.LatLng(
                            userAddress!.latitude!,
                            userAddress.longitude!,
                          ),
                          latlong.LatLng(
                            restaurant.coords!.latitude!,
                            restaurant.coords!.longitude!,
                          ),
                        );
                      }
                      // Est. delivery time (~3 min per km, minimum 10 min)
                      final estMinutes = distanceKm != null
                          ? (distanceKm * 3).ceil().clamp(10, 120)
                          : null;

                      // Distance display
                      final distanceText = distanceKm != null
                          ? (distanceKm < 1
                                ? '${(distanceKm * 1000).toInt()} m'
                                : '${distanceKm.toStringAsFixed(1)} km')
                          : '--';

                      // Delivery fee display
                      final feeText = restaurant.deliveryFee != null
                          ? (restaurant.deliveryFee == 0
                                ? 'Free'
                                : formatPrice(restaurant.deliveryFee!))
                          : '--';

                      // Est. delivery time display
                      final timeText = estMinutes != null
                          ? '$estMinutes min'
                          : '--';

                      // Opening hours display
                      final hoursText = restaurant.openingTime != null
                          ? '${restaurant.openingTime}${restaurant.closingTime != null ? ' - ${restaurant.closingTime}' : ''}'
                          : '--';

                      final items = [
                        InfoColumnData(value: timeText, label: 'Delivery time'),
                        InfoColumnData(value: feeText, label: 'Delivery fee'),
                        InfoColumnData(value: distanceText, label: 'Distance'),
                        InfoColumnData(value: hoursText, label: 'Hours'),
                      ];

                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            for (int i = 0; i < items.length; i++) ...[
                              Expanded(child: InfoColumn(data: items[i])),
                              // if (i < items.length - 1)
                              //   VerticalDivider(
                              //     width: 1,
                              //     thickness: 1,
                              //     color: colors.border,
                              //   ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

                  // // Delivery / Pickup badges
                  // if (restaurant.delivery == true ||
                  //     restaurant.pickup == true) ...[
                  //   SizedBox(height: 10.spMin),
                  //   Row(
                  //     children: [
                  //       if (restaurant.delivery == true)
                  //         _BadgeChip(
                  //           icon: Icons.check_circle_outline,
                  //           label: 'Delivery',
                  //           color: colors.success,
                  //           colors: colors,
                  //         ),
                  //       if (restaurant.delivery == true &&
                  //           restaurant.pickup == true)
                  //         SizedBox(width: 8.spMin),
                  //       if (restaurant.pickup == true)
                  //         _BadgeChip(
                  //           icon: Icons.shopping_bag_outlined,
                  //           label: 'Pickup',
                  //           color: colors.info,
                  //           colors: colors,
                  //         ),
                  //     ],
                  //   ),
                  // ],

                  // Reservation section
                  if (SessionManager().isTableReservationEnabled &&
                      restaurant.tableReservationEnabled == true) ...[
                    SizedBox(height: 12.spMin),
                    _ReservationInfoBar(restaurant: restaurant, colors: colors),
                  ],

                  SizedBox(height: 16.spMin),
                ],
              ),
            ),
          ),

          // Pinned Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: RestaurantTabBarDelegate(
              tabBar: buildRestaurantTabBar(
                controller: _tabController,
                tabs: tabs,
                colors: colors,
              ),
              backgroundColor: colors.scaffoldBackground,
            ),
          ),
        ],
        body: TabBarView(controller: _tabController, children: tabViews),
      ),
    );
  }
}

class _ReservationInfoBar extends StatelessWidget {
  final RestaurantItem restaurant;
  final ThemeColors colors;

  const _ReservationInfoBar({required this.restaurant, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.spMin),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(12.spMin),
        border: Border.all(color: colors.primary.withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          // Table/Room info row
          Row(
            children: [
              Icon(
                Icons.table_restaurant,
                size: 20.spMin,
                color: colors.primary,
              ),
              SizedBox(width: 8.spMin),
              Expanded(
                child: Row(
                  children: [
                    if (restaurant.totalTables > 0)
                      Text(
                        '${restaurant.totalTables} Tables',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (restaurant.totalTables > 0 && restaurant.totalRooms > 0)
                      Text(
                        '  |  ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    if (restaurant.totalRooms > 0)
                      Text(
                        '${restaurant.totalRooms} Rooms',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (restaurant.totalSeatingCapacity > 0) ...[
                      Text(
                        '  |  ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        '${restaurant.totalSeatingCapacity} Seats',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Seating areas
          if (restaurant.seatingAreas != null &&
              restaurant.seatingAreas!.isNotEmpty) ...[
            SizedBox(height: 8.spMin),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 16.spMin,
                  color: colors.textSecondary,
                ),
                SizedBox(width: 6.spMin),
                Expanded(
                  child: Text(
                    restaurant.seatingAreas!.join(', '),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 10.spMin),
          // Reserve button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BookTableSheet(
                    restaurantId: restaurant.id ?? '',
                    restaurantName: restaurant.title ?? 'Restaurant',
                  ),
                );
              },
              icon: Icon(Icons.table_restaurant, size: 18.spMin),
              label: const Text('Reserve a Table'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.spMin),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.spMin),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
