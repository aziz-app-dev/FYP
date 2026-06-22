import 'dart:convert';
import 'food_details_config.dart';
import 'common_config.dart';

SettingsModel settingsModelFromJson(String str) =>
    SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  final String? serviceMode;
  final String? defaultRestaurantId;
  final bool? allowVendorRegistration;
  final bool? enableOrdering;
  final String? appName;
  final String? currency;
  final String? currencySymbol;
  final double? deliveryFee;
  final double? taxRate;
  final HomeConfig? homeConfig;
  final PaymentConfig? paymentConfig;
  final OrderConfig? orderConfig;
  final FoodDetailsConfig? foodDetailsConfig;
  final ReservationConfig? reservationConfig;
  final ApiKeysConfig? apiKeys;
  final NotificationTemplatesConfig? notificationTemplates;
  final bool? rtl;
  final String? language;

  SettingsModel({
    this.serviceMode,
    this.defaultRestaurantId,
    this.allowVendorRegistration,
    this.enableOrdering,
    this.appName,
    this.currency,
    this.currencySymbol,
    this.deliveryFee,
    this.taxRate,
    this.homeConfig,
    this.paymentConfig,
    this.orderConfig,
    this.foodDetailsConfig,
    this.reservationConfig,
    this.apiKeys,
    this.notificationTemplates,
    this.rtl,
    this.language,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    serviceMode: json["serviceMode"],
    defaultRestaurantId: json["defaultRestaurantId"],
    allowVendorRegistration: json["allowVendorRegistration"],
    enableOrdering: json["enableOrdering"],
    appName: json["appName"],
    currency: json["currency"],
    currencySymbol: json["currencySymbol"],
    deliveryFee: json["deliveryFee"]?.toDouble(),
    taxRate: json["taxRate"]?.toDouble(),
    homeConfig: json["homeConfig"] != null
        ? HomeConfig.fromJson(json["homeConfig"])
        : null,
    paymentConfig: json["paymentConfig"] != null
        ? PaymentConfig.fromJson(json["paymentConfig"])
        : null,
    orderConfig: json["orderConfig"] != null
        ? OrderConfig.fromJson(json["orderConfig"])
        : null,
    foodDetailsConfig: json["foodDetailsConfig"] != null
        ? FoodDetailsConfig.fromJson(Map<String, dynamic>.from(json["foodDetailsConfig"]))
        : null,
    reservationConfig: json["reservationConfig"] != null
        ? ReservationConfig.fromJson(json["reservationConfig"])
        : null,
    apiKeys: json["apiKeys"] != null
        ? ApiKeysConfig.fromJson(json["apiKeys"])
        : null,
    notificationTemplates: json["notificationTemplates"] != null
        ? NotificationTemplatesConfig.fromJson(json["notificationTemplates"])
        : null,
    rtl: json["rtl"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "serviceMode": serviceMode,
    "defaultRestaurantId": defaultRestaurantId,
    "allowVendorRegistration": allowVendorRegistration,
    "enableOrdering": enableOrdering,
    "appName": appName,
    "currency": currency,
    "currencySymbol": currencySymbol,
    "deliveryFee": deliveryFee,
    "taxRate": taxRate,
    "homeConfig": homeConfig?.toJson(),
    "paymentConfig": paymentConfig?.toJson(),
    "orderConfig": orderConfig?.toJson(),
    "foodDetailsConfig": foodDetailsConfig?.toJson(),
    "reservationConfig": reservationConfig?.toJson(),
    "apiKeys": apiKeys?.toJson(),
    "notificationTemplates": notificationTemplates?.toJson(),
    "rtl": rtl,
    "language": language,
  };

  SettingsModel patch(Map<String, dynamic> updates) {
    return SettingsModel.fromJson({...toJson(), ...updates});
  }

  /// Check if cash on delivery is enabled
  bool get isCashOnDeliveryEnabled =>
      paymentConfig?.enableCashOnDelivery ?? true;

  /// Check if online payment is enabled
  bool get isOnlinePaymentEnabled =>
      paymentConfig?.enableOnlinePayment ?? false;

  /// Get the default payment method
  String get defaultPaymentMethod =>
      paymentConfig?.defaultPaymentMethod ?? 'cash';

  /// Get available payment methods
  List<String> get availablePaymentMethods {
    final methods = <String>[];
    if (isCashOnDeliveryEnabled) methods.add('cash');
    if (isOnlinePaymentEnabled) methods.add('online');
    return methods;
  }

  /// Check if only one payment method is available
  bool get hasSinglePaymentMethod => availablePaymentMethods.length == 1;

  /// Check if ordering is enabled
  bool get isOrderingEnabled => enableOrdering ?? true;

  /// Check if table reservation is enabled globally
  bool get isTableReservationEnabled =>
      reservationConfig?.enableTableReservation ?? false;
}

/// Payment Configuration
class PaymentConfig {
  final bool? enableCashOnDelivery;
  final bool? enableOnlinePayment;
  final String? defaultPaymentMethod;
  final OnlinePaymentProviders? onlinePaymentProviders;
  final double? minOrderForOnlinePayment;
  final double? codExtraCharge;
  final double? maxCodAmount;

  PaymentConfig({
    this.enableCashOnDelivery,
    this.enableOnlinePayment,
    this.defaultPaymentMethod,
    this.onlinePaymentProviders,
    this.minOrderForOnlinePayment,
    this.codExtraCharge,
    this.maxCodAmount,
  });

  factory PaymentConfig.fromJson(Map<String, dynamic> json) => PaymentConfig(
    enableCashOnDelivery: json["enableCashOnDelivery"],
    enableOnlinePayment: json["enableOnlinePayment"],
    defaultPaymentMethod: json["defaultPaymentMethod"],
    onlinePaymentProviders: json["onlinePaymentProviders"] != null
        ? OnlinePaymentProviders.fromJson(json["onlinePaymentProviders"])
        : null,
    minOrderForOnlinePayment: json["minOrderForOnlinePayment"]?.toDouble(),
    codExtraCharge: json["codExtraCharge"]?.toDouble(),
    maxCodAmount: json["maxCodAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "enableCashOnDelivery": enableCashOnDelivery,
    "enableOnlinePayment": enableOnlinePayment,
    "defaultPaymentMethod": defaultPaymentMethod,
    "onlinePaymentProviders": onlinePaymentProviders?.toJson(),
    "minOrderForOnlinePayment": minOrderForOnlinePayment,
    "codExtraCharge": codExtraCharge,
    "maxCodAmount": maxCodAmount,
  };
}

/// Online Payment Providers Configuration
class OnlinePaymentProviders {
  final PaymentProviderConfig? stripe;
  final PaymentProviderConfig? paypal;
  final PaymentProviderConfig? flutterwave;
  final PaymentProviderConfig? jazzcash;
  final PaymentProviderConfig? easypaisa;

  OnlinePaymentProviders({
    this.stripe,
    this.paypal,
    this.flutterwave,
    this.jazzcash,
    this.easypaisa,
  });

  factory OnlinePaymentProviders.fromJson(Map<String, dynamic> json) =>
      OnlinePaymentProviders(
        stripe: json["stripe"] != null
            ? PaymentProviderConfig.fromJson(json["stripe"])
            : null,
        paypal: json["paypal"] != null
            ? PaymentProviderConfig.fromJson(json["paypal"])
            : null,
        flutterwave: json["flutterwave"] != null
            ? PaymentProviderConfig.fromJson(json["flutterwave"])
            : null,
        jazzcash: json["jazzcash"] != null
            ? PaymentProviderConfig.fromJson(json["jazzcash"])
            : null,
        easypaisa: json["easypaisa"] != null
            ? PaymentProviderConfig.fromJson(json["easypaisa"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "stripe": stripe?.toJson(),
    "paypal": paypal?.toJson(),
    "flutterwave": flutterwave?.toJson(),
    "jazzcash": jazzcash?.toJson(),
    "easypaisa": easypaisa?.toJson(),
  };

  /// Get list of enabled providers
  List<String> get enabledProviders {
    final providers = <String>[];
    if (stripe?.enabled == true) providers.add('stripe');
    if (paypal?.enabled == true) providers.add('paypal');
    if (flutterwave?.enabled == true) providers.add('flutterwave');
    if (jazzcash?.enabled == true) providers.add('jazzcash');
    if (easypaisa?.enabled == true) providers.add('easypaisa');
    return providers;
  }
}

/// Individual Payment Provider Configuration
class PaymentProviderConfig {
  final bool? enabled;
  final String? publishableKey;
  final String? clientId;
  final String? secretKey;
  final String? publicKey;
  final String? encryptionKey;
  final String? merchantId;
  final String? storeId;

  PaymentProviderConfig({
    this.enabled,
    this.publishableKey,
    this.clientId,
    this.secretKey,
    this.publicKey,
    this.encryptionKey,
    this.merchantId,
    this.storeId,
  });

  factory PaymentProviderConfig.fromJson(Map<String, dynamic> json) =>
      PaymentProviderConfig(
        enabled: json["enabled"],
        publishableKey: json["publishableKey"],
        clientId: json["clientId"],
        secretKey: json["secretKey"],
        publicKey: json["publicKey"],
        encryptionKey: json["encryptionKey"],
        merchantId: json["merchantId"],
        storeId: json["storeId"],
      );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "publishableKey": publishableKey,
    "clientId": clientId,
    "secretKey": secretKey,
    "publicKey": publicKey,
    "encryptionKey": encryptionKey,
    "merchantId": merchantId,
    "storeId": storeId,
  };
}

/// Order Configuration
class OrderConfig {
  final double? minOrderAmount;
  final double? maxOrderAmount;
  final double? freeDeliveryThreshold;
  final int? estimatedDeliveryTime;
  final bool? allowScheduledOrders;
  final bool? allowOrderNotes;
  final bool? allowTips;
  final List<int>? tipOptions;

  OrderConfig({
    this.minOrderAmount,
    this.maxOrderAmount,
    this.freeDeliveryThreshold,
    this.estimatedDeliveryTime,
    this.allowScheduledOrders,
    this.allowOrderNotes,
    this.allowTips,
    this.tipOptions,
  });

  factory OrderConfig.fromJson(Map<String, dynamic> json) => OrderConfig(
    minOrderAmount: json["minOrderAmount"]?.toDouble(),
    maxOrderAmount: json["maxOrderAmount"]?.toDouble(),
    freeDeliveryThreshold: json["freeDeliveryThreshold"]?.toDouble(),
    estimatedDeliveryTime: json["estimatedDeliveryTime"],
    allowScheduledOrders: json["allowScheduledOrders"],
    allowOrderNotes: json["allowOrderNotes"],
    allowTips: json["allowTips"],
    tipOptions: json["tipOptions"] != null
        ? List<int>.from(json["tipOptions"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "minOrderAmount": minOrderAmount,
    "maxOrderAmount": maxOrderAmount,
    "freeDeliveryThreshold": freeDeliveryThreshold,
    "estimatedDeliveryTime": estimatedDeliveryTime,
    "allowScheduledOrders": allowScheduledOrders,
    "allowOrderNotes": allowOrderNotes,
    "allowTips": allowTips,
    "tipOptions": tipOptions,
  };
}

class HomeConfig {
  final bool? showCarousel;
  final bool? showCategories;
  final bool? showTopFoods;
  final bool? showDeals;
  final bool? showOffers;
  final bool? showTopRestaurants;
  final bool? showRandomRestaurants;
  final bool? showBanner;
  final bool? showSlider;
  final bool? showRecentOrders;
  final BannerImage? bannerImage;
  final List<BannerImage>? sliderImages;
  final SliderStyle? sliderStyle;
  final int? recentOrdersLimit;
  final List<String>? sectionOrder;
  final CategoryStyle? categoryStyle;
  final CarouselStyle? carouselStyle;
  final int? topFoodsLimit;
  final int? dealsLimit;
  final int? offersLimit;
  final int? topRestaurantsLimit;
  final int? randomRestaurantsLimit;

  HomeConfig({
    this.showCarousel,
    this.showCategories,
    this.showTopFoods,
    this.showDeals,
    this.showOffers,
    this.showTopRestaurants,
    this.showRandomRestaurants,
    this.showBanner,
    this.showSlider,
    this.showRecentOrders,
    this.bannerImage,
    this.sliderImages,
    this.sliderStyle,
    this.recentOrdersLimit,
    this.sectionOrder,
    this.categoryStyle,
    this.carouselStyle,
    this.topFoodsLimit,
    this.dealsLimit,
    this.offersLimit,
    this.topRestaurantsLimit,
    this.randomRestaurantsLimit,
  });

  factory HomeConfig.fromJson(Map<String, dynamic> json) => HomeConfig(
    showCarousel: json["showCarousel"],
    showCategories: json["showCategories"],
    showTopFoods: json["showTopFoods"],
    showDeals: json["showDeals"],
    showOffers: json["showOffers"],
    showTopRestaurants: json["showTopRestaurants"],
    showRandomRestaurants: json["showRandomRestaurants"],
    showBanner: json["showBanner"],
    showSlider: json["showSlider"],
    showRecentOrders: json["showRecentOrders"],
    bannerImage: json["bannerImage"] != null ? BannerImage.fromJson(json["bannerImage"]) : null,
    sliderImages: json["sliderImages"] != null ? List<BannerImage>.from(json["sliderImages"].map((x) => BannerImage.fromJson(x))) : null,
    sliderStyle: json["sliderStyle"] != null ? SliderStyle.fromJson(json["sliderStyle"]) : null,
    recentOrdersLimit: json["recentOrdersLimit"],
    sectionOrder: json["sectionOrder"] != null
        ? List<String>.from(json["sectionOrder"])
        : null,
    categoryStyle: json["categoryStyle"] != null
        ? CategoryStyle.fromJson(json["categoryStyle"])
        : null,
    carouselStyle: json["carouselStyle"] != null
        ? CarouselStyle.fromJson(json["carouselStyle"])
        : null,
    topFoodsLimit: json["topFoodsLimit"],
    dealsLimit: json["dealsLimit"],
    offersLimit: json["offersLimit"],
    topRestaurantsLimit: json["topRestaurantsLimit"],
    randomRestaurantsLimit: json["randomRestaurantsLimit"],
  );

  Map<String, dynamic> toJson() => {
    "showCarousel": showCarousel,
    "showCategories": showCategories,
    "showTopFoods": showTopFoods,
    "showDeals": showDeals,
    "showOffers": showOffers,
    "showTopRestaurants": showTopRestaurants,
    "showRandomRestaurants": showRandomRestaurants,
    "showBanner": showBanner,
    "showSlider": showSlider,
    "showRecentOrders": showRecentOrders,
    "bannerImage": bannerImage?.toJson(),
    "sliderImages": sliderImages != null ? List<dynamic>.from(sliderImages!.map((x) => x.toJson())) : null,
    "sliderStyle": sliderStyle?.toJson(),
    "recentOrdersLimit": recentOrdersLimit,
    "sectionOrder": sectionOrder,
    "categoryStyle": categoryStyle?.toJson(),
    "carouselStyle": carouselStyle?.toJson(),
    "topFoodsLimit": topFoodsLimit,
    "dealsLimit": dealsLimit,
    "offersLimit": offersLimit,
    "topRestaurantsLimit": topRestaurantsLimit,
    "randomRestaurantsLimit": randomRestaurantsLimit,
  };
}

class SliderStyle {
  final bool? autoPlay;
  final int? interval;
  final bool? showDots;
  final int? height;

  SliderStyle({this.autoPlay, this.interval, this.showDots, this.height});

  factory SliderStyle.fromJson(Map<String, dynamic> json) => SliderStyle(
    autoPlay: json["autoPlay"],
    interval: json["interval"],
    showDots: json["showDots"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "autoPlay": autoPlay,
    "interval": interval,
    "showDots": showDots,
    "height": height,
  };
}

class BannerImage {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? linkType;
  final String? linkId;
  final String? linkUrl;
  final int? order;

  BannerImage({
    this.imageUrl,
    this.title,
    this.subtitle,
    this.linkType,
    this.linkId,
    this.linkUrl,
    this.order,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
    imageUrl: json["imageUrl"],
    title: json["title"],
    subtitle: json["subtitle"],
    linkType: json["linkType"],
    linkId: json["linkId"],
    linkUrl: json["linkUrl"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "title": title,
    "subtitle": subtitle,
    "linkType": linkType,
    "linkId": linkId,
    "linkUrl": linkUrl,
    "order": order,
  };
}

// CarouselStyle and CategoryStyle moved to common_config.dart

/// Reservation Configuration
class ReservationConfig {
  final bool? enableTableReservation;

  ReservationConfig({this.enableTableReservation});

  factory ReservationConfig.fromJson(Map<String, dynamic> json) =>
      ReservationConfig(enableTableReservation: json["enableTableReservation"]);

  Map<String, dynamic> toJson() => {
    "enableTableReservation": enableTableReservation,
  };
}

class ApiKeysConfig {
  final String? mapboxKey;
  final String? googleMapsKey;
  final String? admobBannerKey;
  final String? admobNativeKey;
  final String? admobInterstitialKey;
  final String? stripePublishableKey;
  final String? stripeSecretKey;
  final String? paypalClientId;
  final String? paypalSecretKey;
  final String? flutterwavePublicKey;
  final String? flutterwaveSecretKey;
  final String? flutterwaveEncryptionKey;

  ApiKeysConfig({
    this.mapboxKey,
    this.googleMapsKey,
    this.admobBannerKey,
    this.admobNativeKey,
    this.admobInterstitialKey,
    this.stripePublishableKey,
    this.stripeSecretKey,
    this.paypalClientId,
    this.paypalSecretKey,
    this.flutterwavePublicKey,
    this.flutterwaveSecretKey,
    this.flutterwaveEncryptionKey,
  });

  factory ApiKeysConfig.fromJson(Map<String, dynamic> json) => ApiKeysConfig(
    mapboxKey: json["mapboxKey"],
    googleMapsKey: json["googleMapsKey"],
    admobBannerKey: json["admobBannerKey"],
    admobNativeKey: json["admobNativeKey"],
    admobInterstitialKey: json["admobInterstitialKey"],
    stripePublishableKey: json["stripePublishableKey"],
    stripeSecretKey: json["stripeSecretKey"],
    paypalClientId: json["paypalClientId"],
    paypalSecretKey: json["paypalSecretKey"],
    flutterwavePublicKey: json["flutterwavePublicKey"],
    flutterwaveSecretKey: json["flutterwaveSecretKey"],
    flutterwaveEncryptionKey: json["flutterwaveEncryptionKey"],
  );

  Map<String, dynamic> toJson() => {
    "mapboxKey": mapboxKey,
    "googleMapsKey": googleMapsKey,
    "admobBannerKey": admobBannerKey,
    "admobNativeKey": admobNativeKey,
    "admobInterstitialKey": admobInterstitialKey,
    "stripePublishableKey": stripePublishableKey,
    "stripeSecretKey": stripeSecretKey,
    "paypalClientId": paypalClientId,
    "paypalSecretKey": paypalSecretKey,
    "flutterwavePublicKey": flutterwavePublicKey,
    "flutterwaveSecretKey": flutterwaveSecretKey,
    "flutterwaveEncryptionKey": flutterwaveEncryptionKey,
  };
}

class NotificationTemplatesConfig {
  final String? restaurantRequestTitle;
  final String? restaurantRequestBody;
  final String? restaurantApprovedTitle;
  final String? restaurantApprovedBody;
  final String? restaurantRejectedTitle;
  final String? restaurantRejectedBody;

  NotificationTemplatesConfig({
    this.restaurantRequestTitle,
    this.restaurantRequestBody,
    this.restaurantApprovedTitle,
    this.restaurantApprovedBody,
    this.restaurantRejectedTitle,
    this.restaurantRejectedBody,
  });

  factory NotificationTemplatesConfig.fromJson(Map<String, dynamic> json) =>
      NotificationTemplatesConfig(
        restaurantRequestTitle: json["restaurantRequestTitle"]?.toString(),
        restaurantRequestBody: json["restaurantRequestBody"]?.toString(),
        restaurantApprovedTitle: json["restaurantApprovedTitle"]?.toString(),
        restaurantApprovedBody: json["restaurantApprovedBody"]?.toString(),
        restaurantRejectedTitle: json["restaurantRejectedTitle"]?.toString(),
        restaurantRejectedBody: json["restaurantRejectedBody"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "restaurantRequestTitle": restaurantRequestTitle,
    "restaurantRequestBody": restaurantRequestBody,
    "restaurantApprovedTitle": restaurantApprovedTitle,
    "restaurantApprovedBody": restaurantApprovedBody,
    "restaurantRejectedTitle": restaurantRejectedTitle,
    "restaurantRejectedBody": restaurantRejectedBody,
  };
}
