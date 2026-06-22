import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/bloc/user/main/main_bloc.dart';
import 'package:food/utils/utils.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../bloc/user/main/main_event.dart';
import '../../../bloc/user/main/main_state.dart';
import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../services/session/session_manger.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_event.dart';
import '../cart/cart_page.dart';
import '../home/home_screen.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';
import '../reservation/my_reservations_page.dart';
import '../../vendor/dashboard/vendor_dashboard_page.dart';
import '../../vendor/orders/vendor_orders_page.dart';
import '../../vendor/menu/vendor_menu_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _indexedStackKey = GlobalKey();

  late final List<Widget> _pages;
  late final List<_TabConfig> _tabConfigs;
  late final bool _orderingEnabled;
  late final bool _isVendor;

  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    final session = SessionManager();
    _orderingEnabled = session.isOrderingEnabled;
    _isVendor = session.isVendor;

    if (_isVendor) {
      // Vendor tabs: Dashboard, Orders, Menu, Profile
      _pages = [
        VendorDashboardPage(key: GlobalKey()),
        VendorOrdersPage(key: GlobalKey()),
        VendorMenuPage(key: GlobalKey()),
        ProfilePage(key: GlobalKey()),
      ];
      _tabConfigs = const [
        _TabConfig(icon: AppIcons.vendorDashboard, label: 'Dashboard'),
        _TabConfig(icon: AppIcons.vendorOrders, label: 'Orders'),
        _TabConfig(icon: AppIcons.vendorMenu, label: 'Menu'),
        _TabConfig(
          icon: AppIcons.navProfile,
          label: 'Profile',
          isProfile: true,
        ),
      ];
    } else if (_orderingEnabled) {
      _pages = [
        HomeScreen(key: GlobalKey()),
        SearchPage(key: GlobalKey()),
        CartPage(key: GlobalKey()),
        ProfilePage(key: GlobalKey()),
      ];
      _tabConfigs = const [
        _TabConfig(icon: AppIcons.navHome, label: 'Home'),
        _TabConfig(icon: AppIcons.searchIcon, label: 'Search'),
        _TabConfig(icon: AppIcons.navCart, label: 'Cart'),
        _TabConfig(
          icon: AppIcons.navProfile,
          label: 'Profile',
          isProfile: true,
        ),
      ];
    } else {
      _pages = [
        HomeScreen(key: GlobalKey()),
        MyReservationsPage(key: GlobalKey()),
        ProfilePage(key: GlobalKey()),
      ];
      _tabConfigs = const [
        _TabConfig(icon: AppIcons.navHome, label: 'Home'),
        _TabConfig(icon: AppIcons.vendorReservations, label: 'Reservations'),
        _TabConfig(
          icon: AppIcons.navProfile,
          label: 'Profile',
          isProfile: true,
        ),
      ];
    }
  }

  /// Handle back button press
  /// Returns true if should pop (exit app), false otherwise
  Future<bool> _onWillPop(BuildContext context) async {
    final mainBloc = context.read<MainBloc>();
    final currentIndex = mainBloc.state.selectedIndex;

    // If not on home tab, go to home first
    if (currentIndex != 0) {
      mainBloc.add(IndexChangeEvent(index: 0));
      return false;
    }

    // If on home tab, check for double tap
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      // Show toast
      ToastUtils.showInfo(context, message: "Press back again to exit");

      return false;
    }

    // Double tap confirmed - exit app
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final providers = <BlocProvider>[
      BlocProvider<MainBloc>(create: (_) => getIt<MainBloc>()),
      if (_isVendor)
        BlocProvider<VendorRestaurantBloc>(
          create: (_) =>
              getIt<VendorRestaurantBloc>()..add(LoadMyRestaurants()),
        ),
    ];

    return MultiBlocProvider(
      providers: providers,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: context.isDarkMode
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: context.isDarkMode
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: colors.scaffoldBackground,
        ),
        child: Builder(
          builder: (innerContext) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              final shouldPop = await _onWillPop(innerContext);
              if (shouldPop && innerContext.mounted) {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody:
                  !ScreenUtils.isDesktop(context) ||
                  ScreenUtils.isTablet(context),
              extendBodyBehindAppBar:
                  !ScreenUtils.isDesktop(context) ||
                  ScreenUtils.isTablet(context),
              body: Builder(
                builder: (ctx) {
                  final isTablet = ScreenUtils.isTablet(ctx);
                  final isDesktop = ScreenUtils.isDesktop(ctx);

                  if (isTablet || isDesktop) {
                    return Row(
                      children: [
                        // Sidebar listens only to selectedIndex
                        BlocSelector<MainBloc, MainState, int>(
                          selector: (state) => state.selectedIndex,
                          builder: (context, selectedIndex) {
                            return _TabletSidebar(
                              selectedIndex: selectedIndex,
                              tabConfigs: _tabConfigs,
                              colors: colors,
                              onChanged: (index) {
                                context.read<MainBloc>().add(
                                  IndexChangeEvent(index: index),
                                );
                              },
                            );
                          },
                        ),
                        // Body listens only to selectedIndex
                        Expanded(
                          child: BlocSelector<MainBloc, MainState, int>(
                            selector: (state) => state.selectedIndex,
                            builder: (context, selectedIndex) {
                              return IndexedStack(
                                key: _indexedStackKey,
                                index: selectedIndex,
                                children: _pages,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        // Body listens only to selectedIndex
                        BlocSelector<MainBloc, MainState, int>(
                          selector: (state) => state.selectedIndex,
                          builder: (context, selectedIndex) {
                            return IndexedStack(
                              key: _indexedStackKey,
                              index: selectedIndex,
                              children: _pages,
                            );
                          },
                        ),
                        // Nav bar listens only to selectedIndex
                        Positioned(
                          left: 15.w,
                          right: 15.w,
                          bottom: 18.h,
                          child: SafeArea(
                            top: false,
                            child: BlocSelector<MainBloc, MainState, int>(
                              selector: (state) => state.selectedIndex,
                              builder: (context, selectedIndex) {
                                return _FloatingNavBar(
                                  selectedIndex: selectedIndex,
                                  tabConfigs: _tabConfigs,
                                  colors: colors,
                                  onChanged: (index) {
                                    context.read<MainBloc>().add(
                                      IndexChangeEvent(index: index),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabletSidebar extends StatelessWidget {
  final int selectedIndex;
  final List<_TabConfig> tabConfigs;
  final ThemeColors colors;
  final ValueChanged<int> onChanged;

  const _TabletSidebar({
    required this.selectedIndex,
    required this.tabConfigs,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final profileImage = SessionManager().user?.profile;

    return Padding(
      padding: EdgeInsets.all(6.spMin),
      child: Container(
        width: 70.spMin,
        decoration: BoxDecoration(
          color: colors.sideNav,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(12.spMin),
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  AppIcons.vendorMenu,
                  color: Colors.white,
                  size: 24.spMin,
                ),
              ),
              SizedBox(height: 24.spMin),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.spMin),
                child: Divider(color: colors.divider),
              ),
              SizedBox(height: 12.h),
              ...List.generate(tabConfigs.length, (index) {
                final tab = tabConfigs[index];
                return _TabletNavItem(
                  icon: tab.icon,
                  isSelected: selectedIndex == index,
                  onTap: () => onChanged(index),
                  colors: colors,
                  profileImage: tab.isProfile ? profileImage : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabletNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeColors colors;
  final String? profileImage;

  const _TabletNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasProfileImage = profileImage != null && profileImage!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.spMin),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.spMin),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary
                // ? colors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: hasProfileImage
              ? Container(
                  width: 26.spMin,
                  height: 26.spMin,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colors.textOnPrimary : colors.primary,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profileImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Icon(
                        icon,
                        size: 20.spMin,
                        color: isSelected
                            ? colors.primary
                            : colors.textSecondary,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        icon,
                        size: 20.spMin,
                        color: isSelected
                            ? colors.primary
                            : colors.textSecondary,
                      ),
                    ),
                  ),
                )
              : Icon(
                  icon,
                  size: 26.spMin,
                  color: isSelected
                      ? colors.textOnPrimary
                      : colors.bottomNavIcon,
                ),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<_TabConfig> tabConfigs;
  final ThemeColors colors;
  final ValueChanged<int> onChanged;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.tabConfigs,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallScreen = screenWidth < 360;
    final profileImage = SessionManager().user?.profile;
    final hasProfileImage = profileImage != null && profileImage.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.spMin, horizontal: 8.spMin),
      decoration: BoxDecoration(
        color: colors.bottomNav,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 25,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GNav(
        selectedIndex: selectedIndex,
        onTabChange: onChanged,
        rippleColor: colors.primary.withValues(alpha: .1),
        hoverColor: colors.primary.withValues(alpha: .1),
        gap: isSmallScreen ? 4.spMin : 6.spMin,
        iconSize: isSmallScreen ? 22.spMin : 24.spMin,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8.spMin : 10.spMin,
          vertical: 9.spMin,
        ),
        duration: const Duration(milliseconds: 300),
        tabBackgroundColor: colors.bottomNavIconBg,
        activeColor: colors.textOnPrimary,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: colors.textOnPrimary,
          fontSize: isSmallScreen ? 11.spMin : 13.spMin,
        ),
        tabs: tabConfigs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return GButton(
            icon: tab.icon,
            text: tab.label,
            iconColor: colors.bottomNavIcon,
            leading: tab.isProfile && hasProfileImage
                ? ProfileIcon(
                    isSmallScreen: isSmallScreen,
                    selectedIndex: selectedIndex,
                    profileTabIndex: index,
                    colors: colors,
                    profileImage: profileImage,
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  final bool isProfile;

  const _TabConfig({
    required this.icon,
    required this.label,
    this.isProfile = false,
  });
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
    required this.isSmallScreen,
    required this.selectedIndex,
    required this.profileTabIndex,
    required this.colors,
    required this.profileImage,
  });

  final bool isSmallScreen;
  final int selectedIndex;
  final int profileTabIndex;
  final ThemeColors colors;
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmallScreen ? 22.spMin : 24.spMin,
      height: isSmallScreen ? 22.spMin : 24.spMin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.textOnPrimary,
          //  selectedIndex == profileTabIndex
          //     ? colors.textOnPrimary
          //     : colors.primary,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileImage ?? "",
          fit: BoxFit.cover,
          placeholder: (context, url) => Icon(
            AppIcons.navProfile,
            size: isSmallScreen ? 16.spMin : 18.spMin,
            color: colors.bottomNavIcon,
          ),
          errorWidget: (context, url, error) => Icon(
            AppIcons.navProfile,
            size: isSmallScreen ? 16.spMin : 18.spMin,
            color: colors.bottomNavIcon,
          ),
        ),
      ),
    );
  }
}
