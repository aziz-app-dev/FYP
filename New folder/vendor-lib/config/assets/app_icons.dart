import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Centralized icon registry for the Food Delivery App.
/// All icons used throughout the project are defined here with
/// documentation of their usage location.
class AppIcons {
  AppIcons._();

  // ╔══════════════════════════════════════════════════╗
  // ║  NAVIGATION & APP SHELL                         ║
  // ║  Screen: MainScreen (bottom_nav)                ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData navHome = TablerIcons.smart_home;
  static const IconData navCart = Icons.shopping_basket_rounded;
  static const IconData navOrders = Icons.receipt_long_rounded;
  static const IconData navProfile = Icons.person_rounded;

  // Back / Close
  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData backTabler = TablerIcons.chevron_left;
  static const IconData close = Icons.close;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData arrowForward = Icons.arrow_forward_ios;

  // ╔══════════════════════════════════════════════════╗
  // ║  HOME PAGE                                      ║
  // ║  Screen: HomeScreen                             ║
  // ║  Widget: HeaderWidget, CategoriesSection,       ║
  // ║          ImageCarouselWithIndicator              ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData homeProfile = Icons.person;
  static const IconData homeLocationDropdown =
      Icons.keyboard_arrow_down_rounded;
  static const IconData homeLocation = Icons.location_on;
  static const IconData homeNotifications = Icons.notifications_none_rounded;
  static const IconData homeSearch = Icons.search_rounded;
  static const IconData homeCategoryPlaceholder = Icons.fastfood;
  static const IconData homeCarouselError = Icons.error;

  // ╔══════════════════════════════════════════════════╗
  // ║  AUTHENTICATION                                 ║
  // ║  Screens: LoginScreen, RegisterScreen,          ║
  // ║           ForgotPasswordScreen, OtpScreen       ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData authLogo = Icons.restaurant_menu;
  static const IconData authGoogle = TablerIcons.brand_google;
  static const IconData authUserType = Icons.person_outline;
  static const IconData authStoreType = Icons.store_outlined;
  static const IconData authEmail = Icons.email_outlined;
  static const IconData authLock = Icons.lock_outline;
  static const IconData authVisibilityOn = Icons.visibility_outlined;
  static const IconData authVisibilityOff = Icons.visibility_off_outlined;
  static const IconData authPin = Icons.pin_outlined;
  static const IconData authPhone = Icons.phone_outlined;
  static const IconData authCheck = Icons.check;
  static const IconData authKey = Icons.key;
  static const IconData authLockReset = Icons.lock_reset;
  static const IconData authEmailRead = Icons.mark_email_read_outlined;
  static const IconData authInfo = Icons.info_outline;
  static const IconData authErrorOutline = Icons.error_outline;
  static const IconData authCheckCircle = Icons.check_circle_outline;
  static const IconData authSave = Icons.save;

  // ╔══════════════════════════════════════════════════╗
  // ║  FOOD DETAILS                                   ║
  // ║  Screens: OneFoodDetailsPage, TwoFoodDetailsPage║
  // ║  Widgets: TopImageWidget, SizeSelection,        ║
  // ║           ExtraWidget, SaucesWidget, etc.       ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData foodPlaceholder = Icons.fastfood;
  static const IconData foodFavorite = Icons.favorite_border;
  static const IconData foodFavoriteFilled = Icons.favorite;
  static const IconData foodStar = Icons.star;
  static const IconData foodTime = Icons.access_time;
  static const IconData foodSpice = Icons.local_fire_department;
  static const IconData foodLocation = Icons.location_on_outlined;
  static const IconData foodCheck = Icons.check;
  static const IconData foodUnselected = Icons.circle_outlined;
  static const IconData foodImagePlaceholder = Icons.image_outlined;
  static const IconData foodIngredients = Icons.egg_outlined;
  static const IconData foodQuantityAdd = Icons.add;
  static const IconData foodQuantityRemove = Icons.remove;
  static const IconData foodAddToCart = Icons.shopping_bag;
  static const IconData foodRestaurant = Icons.restaurant;

  // ╔══════════════════════════════════════════════════╗
  // ║  RESTAURANT DETAILS                             ║
  // ║  Screen: RestaurantDetailsPage                  ║
  // ║  Widgets: InfoColumn, MenuTab, DealsTab, etc.   ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData restaurantPlaceholder = Icons.restaurant;
  static const IconData restaurantLocation = Icons.location_on;
  static const IconData restaurantStar = Icons.star_rounded;
  static const IconData restaurantDirections = Icons.directions_outlined;
  static const IconData restaurantMenu = Icons.restaurant_menu_outlined;
  static const IconData restaurantVerified = Icons.check_circle_outline;
  static const IconData restaurantPickup = Icons.shopping_bag_outlined;
  static const IconData restaurantTable = Icons.table_restaurant;
  static const IconData restaurantTableOutlined =
      Icons.table_restaurant_outlined;
  static const IconData restaurantRoom = Icons.meeting_room;
  static const IconData restaurantRoomOutlined = Icons.meeting_room_outlined;
  static const IconData restaurantSeats = Icons.chair;
  static const IconData restaurantPlace = Icons.place_outlined;

  // ╔══════════════════════════════════════════════════╗
  // ║  CART & CHECKOUT                                ║
  // ║  Screens: CartPage, CheckoutPage                ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData cartEmpty = Icons.shopping_cart_outlined;
  static const IconData cartDelete = Icons.delete_outline;
  static const IconData cartAdd = Icons.add;
  static const IconData cartRemove = Icons.remove;
  static const IconData cartCash = Icons.money;
  static const IconData cartCard = Icons.credit_card;
  static const IconData cartCheckCircle = Icons.check_circle;
  static const IconData cartDelivery = Icons.local_shipping_outlined;
  static const IconData cartWarning = Icons.warning_amber_rounded;
  static const IconData cartEditAddress = Icons.edit_outlined;

  // ╔══════════════════════════════════════════════════╗
  // ║  DEALS & OFFERS                                 ║
  // ║  Screens: AllDealsPage, DealDetailsPage,        ║
  // ║           AllOffersPage, OfferDetailsPage       ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData dealOffer = Icons.local_offer;
  static const IconData dealOfferRounded = Icons.local_offer_rounded;
  static const IconData dealRestaurant = Icons.restaurant_rounded;
  static const IconData dealMenuAccess = Icons.restaurant_menu_rounded;
  static const IconData dealTime = Icons.access_time_filled_rounded;
  static const IconData dealCategory = Icons.category_rounded;
  static const IconData dealInfo = Icons.info_rounded;
  static const IconData dealTerms = Icons.rule_rounded;
  static const IconData dealExpandUp = Icons.keyboard_arrow_up_rounded;
  static const IconData dealExpandDown = Icons.keyboard_arrow_down_rounded;
  static const IconData dealPurchase = Icons.shopping_bag_rounded;
  static const IconData offerPercent = Icons.percent_rounded;
  static const IconData offerSchedule = Icons.schedule_rounded;
  static const IconData offerShare = Icons.ios_share;
  static const IconData offerCampaign = Icons.campaign;
  static const IconData offerCampaignOutlined = Icons.campaign_outlined;

  // ╔══════════════════════════════════════════════════╗
  // ║  ORDERS & ORDER TRACKING                        ║
  // ║  Screens: OrdersPage, OrderTrackingScreen,      ║
  // ║           OrderDetailsPage                      ║
  // ║  Widgets: ActiveOrderWidget, OrderCard          ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData orderEmpty = Icons.receipt_long_outlined;
  static const IconData orderDelivery = Icons.local_shipping_rounded;
  static const IconData orderHistory = Icons.history_rounded;
  static const IconData orderPending = Icons.hourglass_bottom_rounded;
  static const IconData orderCooking = Icons.restaurant_rounded;
  static const IconData orderCompleted = Icons.check_circle_rounded;
  static const IconData orderOutForDelivery = Icons.delivery_dining_rounded;
  static const IconData orderInfoOutline = Icons.info_outline_rounded;
  static const IconData orderRefresh = Icons.refresh_rounded;
  static const IconData orderReorder = Icons.refresh_rounded;
  static const IconData orderReceipt = Icons.receipt_rounded;
  static const IconData orderPayment = Icons.payment_rounded;
  static const IconData orderCalendar = Icons.calendar_today_rounded;
  static const IconData orderArrowForward = Icons.arrow_forward_rounded;
  // Order Tracking Map
  static const IconData trackingDriver = Icons.delivery_dining_rounded;
  static const IconData trackingRestaurant = Icons.restaurant_rounded;
  static const IconData trackingHome = Icons.home_rounded;
  static const IconData trackingTime = Icons.access_time_rounded;
  static const IconData trackingPerson = Icons.person_rounded;
  static const IconData trackingPhone = Icons.phone_rounded;
  static const IconData trackingCheck = Icons.check;

  // ╔══════════════════════════════════════════════════╗
  // ║  PROFILE & SETTINGS                             ║
  // ║  Screens: ProfilePage, AppSettingsPage          ║
  // ║  Widgets: ProfileMenuTile, ThemeSwitchWidget,   ║
  // ║           VerificationAlert, ProfileAvatar      ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData profileEdit = Icons.person_outline;
  static const IconData profileFavorites = Icons.favorite_border;
  static const IconData profileOrders = Icons.receipt_long_outlined;
  static const IconData profileReviews = Icons.star_border_rounded;
  static const IconData profileAddresses = Icons.location_on_outlined;
  static const IconData profileReservations = Icons.table_restaurant_outlined;
  static const IconData profilePayment = Icons.credit_card_outlined;
  static const IconData profileNotifications = Icons.notifications_none_rounded;
  static const IconData profileCardStyle = Icons.style_outlined;
  static const IconData profileSettings = Icons.settings_outlined;
  static const IconData profileHelp = Icons.help_outline_rounded;
  static const IconData profilePhone = Icons.phone_outlined;
  static const IconData profileEmail = Icons.email_outlined;
  static const IconData profileTileArrow = Icons.arrow_forward_ios_rounded;
  // Theme
  static const IconData themeBrush = TablerIcons.brush;
  static const IconData themeLight = Icons.light_mode_outlined;
  static const IconData themeDark = Icons.dark_mode_outlined;
  static const IconData themeSun = TablerIcons.sun;
  static const IconData themeMoon = TablerIcons.moon;
  static const IconData themeDropdown = Icons.arrow_drop_down;
  // Avatar
  static const IconData avatarCamera = Icons.camera_alt;
  static const IconData avatarGallery = Icons.photo_library;
  static const IconData avatarDefault = Icons.person;
  // Address
  static const IconData addressLocation = Icons.location_on_rounded;
  static const IconData addressMore = Icons.more_vert;
  static const IconData addressEdit = Icons.edit_outlined;
  static const IconData addressDefault = Icons.check_circle_outline;
  static const IconData addressDelete = Icons.delete_outline;
  static const IconData addressAdd = Icons.add;
  // Settings Page
  static const IconData settingsGeneral = Icons.settings_outlined;
  static const IconData settingsDelivery = Icons.delivery_dining_outlined;
  static const IconData settingsHome = Icons.home_outlined;
  static const IconData settingsFood = Icons.restaurant_menu_outlined;
  static const IconData settingsPayment = Icons.payment_outlined;
  static const IconData settingsOrder = Icons.receipt_long_outlined;
  static const IconData settingsExpand = Icons.keyboard_arrow_down_rounded;

  // ╔══════════════════════════════════════════════════╗
  // ║  SEARCH                                         ║
  // ║  Screen: SearchPage                             ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData searchIcon = Icons.search_rounded;
  static const IconData searchClear = Icons.clear;
  static const IconData searchError = Icons.error_outline_rounded;
  static const IconData searchRefresh = Icons.refresh;
  static const IconData searchNoResults = Icons.search_off_rounded;

  // ╔══════════════════════════════════════════════════╗
  // ║  CATEGORIES                                     ║
  // ║  Screens: CategoriesPage, CategoryFoodsPage     ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData categoryEmpty = Icons.category_outlined;
  static const IconData categoryFoodPlaceholder = Icons.fastfood;
  static const IconData categoryFoodOutlined = Icons.fastfood_outlined;

  // ╔══════════════════════════════════════════════════╗
  // ║  REVIEWS                                        ║
  // ║  Screen: ProductReviewsPage                     ║
  // ║  Widgets: ReviewCard, ReviewStats               ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData reviewIcon = TablerIcons.message_circle_2_filled;
  static const IconData reviewEmpty = Icons.rate_review_outlined;
  static const IconData reviewStarFull = Icons.star_rounded;
  static const IconData reviewStarHalf = Icons.star_half_rounded;
  static const IconData reviewStarEmpty = Icons.star_border_rounded;
  static const IconData reviewStar = Icons.star;
  static const IconData reviewMore = Icons.more_vert;
  static const IconData reviewEdit = Icons.edit_outlined;
  static const IconData reviewDelete = Icons.delete_outline;
  static const IconData reviewStore = Icons.store_rounded;

  // ╔══════════════════════════════════════════════════╗
  // ║  RESERVATIONS                                   ║
  // ║  Screens: MyReservationsPage, BookTableSheet    ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData reservationEmpty = Icons.table_restaurant_outlined;
  static const IconData reservationPending = Icons.schedule;
  static const IconData reservationConfirmed = Icons.check_circle;
  static const IconData reservationCancelled = Icons.cancel;
  static const IconData reservationCompleted = Icons.done_all;
  static const IconData reservationInfo = Icons.info;
  static const IconData reservationCalendar = Icons.calendar_today;
  static const IconData reservationTime = Icons.access_time;
  static const IconData reservationGuests = Icons.people;
  static const IconData reservationGroup = Icons.group;
  static const IconData reservationTag = Icons.tag;
  static const IconData reservationAmenities = Icons.star_outline;
  // Area icons
  static const IconData areaIndoor = Icons.restaurant_outlined;
  static const IconData areaOutdoor = Icons.park_outlined;
  static const IconData areaRooftop = Icons.roofing_outlined;
  static const IconData areaGarden = Icons.local_florist_outlined;
  static const IconData areaWindow = Icons.window_outlined;
  static const IconData areaBalcony = Icons.balcony_outlined;
  static const IconData areaVip = Icons.star_outline;
  static const IconData areaPrivate = Icons.lock_outline;
  static const IconData areaAll = Icons.all_inclusive;

  // ╔══════════════════════════════════════════════════╗
  // ║  COMMON / SHARED WIDGETS                        ║
  // ║  Widgets: ScreenWrapper, FoodCard, DealCard,    ║
  // ║           RestaurantCard, RatingCard, ErrorWidget║
  // ╚══════════════════════════════════════════════════╝
  // ScreenWrapper / Error states
  static const IconData errorRefresh = Icons.refresh;
  static const IconData errorWifiOff = Icons.wifi_off_rounded;
  static const IconData errorCloudOff = Icons.cloud_off_rounded;
  static const IconData errorGeneral = Icons.error_outline_rounded;
  static const IconData emptyInbox = Icons.inbox_outlined;
  // Food Card
  static const IconData foodCardTime = Icons.access_time_rounded;
  static const IconData foodCardDelivery = TablerIcons.truck_delivery;
  // Restaurant Card
  static const IconData restaurantCardStar = Icons.star_rounded;
  static const IconData restaurantCardTime = Icons.access_time_rounded;
  // Deal Card
  static const IconData dealCardOffer = Icons.local_offer_rounded;
  static const IconData dealCardTime = Icons.access_time_rounded;
  static const IconData dealCardRestaurant = Icons.restaurant_rounded;
  static const IconData dealCardDelivery = TablerIcons.truck_delivery;
  // Rating Card
  static const IconData ratingCardFood = Icons.fastfood_rounded;
  static const IconData ratingCardRestaurant = Icons.restaurant_rounded;
  static const IconData ratingCardDelivery = Icons.delivery_dining_rounded;
  // Fav Card
  static const IconData favHeart = Icons.favorite;
  static const IconData favAdd = Icons.add;

  // ╔══════════════════════════════════════════════════╗
  // ║  REFRESH INDICATOR                              ║
  // ║  Used by AppRefreshIndicator — shows page icon  ║
  // ║  centred inside a circular progress ring.       ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData refreshHome = TablerIcons.home;
  static const IconData refreshCategories = Icons.category_rounded;
  static const IconData refreshCategoryFoods = Icons.fastfood_rounded;
  static const IconData refreshOrders = Icons.receipt_long_rounded;
  static const IconData refreshOrderHistory = Icons.history_rounded;
  static const IconData refreshFavorites = Icons.favorite_rounded;
  static const IconData refreshReviews = Icons.star_rounded;
  static const IconData refreshAddresses = Icons.location_on_rounded;
  static const IconData refreshPaginated = Icons.list_rounded;

  // ╔══════════════════════════════════════════════════╗
  // ║  VENDOR                                         ║
  // ║  Screens: VendorDashboard, VendorOrders,        ║
  // ║           VendorMenu, VendorSettings             ║
  // ╚══════════════════════════════════════════════════╝
  static const IconData vendorDashboard = Icons.dashboard_rounded;
  static const IconData vendorOrders = Icons.receipt_long_rounded;
  static const IconData vendorMenu = Icons.restaurant_menu_rounded;
  static const IconData vendorStore = Icons.store_outlined;
  static const IconData vendorAnalytics = Icons.analytics_outlined;
  static const IconData vendorTable = Icons.table_restaurant_outlined;
  static const IconData vendorBecome = Icons.storefront_outlined;
  static const IconData vendorReservations = Icons.table_restaurant_rounded;
}
