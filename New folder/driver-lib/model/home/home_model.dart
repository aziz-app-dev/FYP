import 'dart:convert';
import '../settings/common_config.dart';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));
String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  final bool? status;
  final String? message;
  final HomeData? data;

  HomeModel({this.status, this.message, this.data});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json["status"],
    message: json["message"]?.toString(),
    data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class HomeData {
  final HomeConfig? config;
  final List<HomeSection>? sections;
  final String? timestamp;

  HomeData({this.config, this.sections, this.timestamp});

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    config: json["config"] == null ? null : HomeConfig.fromJson(json["config"]),
    sections: json["sections"] == null
        ? []
        : List<HomeSection>.from(
            json["sections"]!.map((x) => HomeSection.fromJson(x)),
          ),
    timestamp: json["timestamp"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "config": config?.toJson(),
    "sections": sections == null
        ? []
        : List<dynamic>.from(sections!.map((x) => x.toJson())),
    "timestamp": timestamp,
  };

  // Helper methods to get specific sections
  List<CarouselItem> get carousel {
    final section = sections?.firstWhere(
      (s) => s.type == "carousel",
      orElse: () => HomeSection(type: "carousel", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => CarouselItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<CategoryItem> get categories {
    final section = sections?.firstWhere(
      (s) => s.type == "categories",
      orElse: () => HomeSection(type: "categories", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<FoodItem> get topFoods {
    final section = sections?.firstWhere(
      (s) => s.type == "topFoods",
      orElse: () => HomeSection(type: "topFoods", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<DealItem> get deals {
    final section = sections?.firstWhere(
      (s) => s.type == "deals",
      orElse: () => HomeSection(type: "deals", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => DealItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<OfferItem> get offers {
    final section = sections?.firstWhere(
      (s) => s.type == "offers",
      orElse: () => HomeSection(type: "offers", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => OfferItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<RestaurantItem> get topRestaurants {
    final section = sections?.firstWhere(
      (s) => s.type == "topRestaurants",
      orElse: () => HomeSection(type: "topRestaurants", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => RestaurantItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<RestaurantItem> get randomRestaurants {
    final section = sections?.firstWhere(
      (s) => s.type == "randomRestaurants",
      orElse: () => HomeSection(type: "randomRestaurants", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => RestaurantItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<FoodItem> get randomFoods {
    final section = sections?.firstWhere(
      (s) => s.type == "randomFoods",
      orElse: () => HomeSection(type: "randomFoods", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<BannerItem> get banner {
    final section = sections?.firstWhere(
      (s) => s.type == "banner",
      orElse: () => HomeSection(type: "banner", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<SliderItem> get slider {
    final section = sections?.firstWhere(
      (s) => s.type == "slider",
      orElse: () => HomeSection(type: "slider", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => SliderItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<RecentOrderItem> get recentOrders {
    final section = sections?.firstWhere(
      (s) => s.type == "recentOrders",
      orElse: () => HomeSection(type: "recentOrders", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => RecentOrderItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<RecentReservationItem> get recentReservations {
    final section = sections?.firstWhere(
      (s) => s.type == "recentReservations",
      orElse: () => HomeSection(type: "recentReservations", data: []),
    );
    if (section?.data == null || section!.data is! List) return [];
    return (section.data as List)
        .map((e) => RecentReservationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class HomeConfig {
  final String? serviceMode;
  final bool? enableOrdering;
  final String? defaultRestaurantId;
  final bool? showCarousel;
  final bool? showCategories;
  final bool? showTopFoods;
  final bool? showRandomFoods;
  final bool? showDeals;
  final bool? showOffers;
  final bool? showTopRestaurants;
  final bool? showRandomRestaurants;
  final bool? showBanner;
  final bool? showSlider;
  final bool? showRecentOrders;
  final List<String>? sectionOrder;
  final CategoryStyle? categoryStyle;
  final CarouselStyle? carouselStyle;
  final SliderStyle? sliderStyle;

  HomeConfig({
    this.serviceMode,
    this.enableOrdering,
    this.defaultRestaurantId,
    this.showCarousel,
    this.showCategories,
    this.showTopFoods,
    this.showRandomFoods,
    this.showDeals,
    this.showOffers,
    this.showTopRestaurants,
    this.showRandomRestaurants,
    this.showBanner,
    this.showSlider,
    this.showRecentOrders,
    this.sectionOrder,
    this.categoryStyle,
    this.carouselStyle,
    this.sliderStyle,
  });

  factory HomeConfig.fromJson(Map<String, dynamic> json) => HomeConfig(
    serviceMode: json["serviceMode"]?.toString(),
    enableOrdering: json["enableOrdering"],
    defaultRestaurantId: json["defaultRestaurantId"]?.toString(),
    showCarousel: json["showCarousel"],
    showCategories: json["showCategories"],
    showTopFoods: json["showTopFoods"],
    showRandomFoods: json["showRandomFoods"],
    showDeals: json["showDeals"],
    showOffers: json["showOffers"],
    showTopRestaurants: json["showTopRestaurants"],
    showRandomRestaurants: json["showRandomRestaurants"],
    showBanner: json["showBanner"],
    showSlider: json["showSlider"],
    showRecentOrders: json["showRecentOrders"],
    sectionOrder: json["sectionOrder"] == null
        ? []
        : List<String>.from(json["sectionOrder"]!.map((x) => x.toString())),
    categoryStyle: json["categoryStyle"] == null
        ? null
        : CategoryStyle.fromJson(json["categoryStyle"]),
    carouselStyle: json["carouselStyle"] == null
        ? null
        : CarouselStyle.fromJson(json["carouselStyle"]),
    sliderStyle: json["sliderStyle"] == null
        ? null
        : SliderStyle.fromJson(json["sliderStyle"]),
  );

  Map<String, dynamic> toJson() => {
    "serviceMode": serviceMode,
    "enableOrdering": enableOrdering,
    "defaultRestaurantId": defaultRestaurantId,
    "showCarousel": showCarousel,
    "showCategories": showCategories,
    "showTopFoods": showTopFoods,
    "showRandomFoods": showRandomFoods,
    "showDeals": showDeals,
    "showOffers": showOffers,
    "showTopRestaurants": showTopRestaurants,
    "showRandomRestaurants": showRandomRestaurants,
    "showBanner": showBanner,
    "showSlider": showSlider,
    "showRecentOrders": showRecentOrders,
    "sectionOrder": sectionOrder == null
        ? []
        : List<dynamic>.from(sectionOrder!.map((x) => x)),
    "categoryStyle": categoryStyle?.toJson(),
    "carouselStyle": carouselStyle?.toJson(),
    "sliderStyle": sliderStyle?.toJson(),
  };
}

// CategoryStyle is imported from common_config.dart

// CarouselStyle is imported from common_config.dart

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

class HomeSection {
  final String? type;
  final dynamic data;

  HomeSection({this.type, this.data});

  factory HomeSection.fromJson(Map<String, dynamic> json) =>
      HomeSection(type: json["type"]?.toString(), data: json["data"]);

  Map<String, dynamic> toJson() => {"type": type, "data": data};
}

// Carousel Item
class CarouselItem {
  final String? imageUrl;
  final String? title;

  CarouselItem({this.imageUrl, this.title});

  factory CarouselItem.fromJson(Map<String, dynamic> json) => CarouselItem(
    imageUrl: json["imageUrl"]?.toString(),
    title: json["title"]?.toString(),
  );

  Map<String, dynamic> toJson() => {"imageUrl": imageUrl, "title": title};
}

// Banner Item
class BannerItem {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? linkType;
  final String? linkId;
  final String? linkUrl;

  BannerItem({
    this.imageUrl,
    this.title,
    this.subtitle,
    this.linkType,
    this.linkId,
    this.linkUrl,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
    imageUrl: json["imageUrl"]?.toString(),
    title: json["title"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
    linkType: json["linkType"]?.toString(),
    linkId: json["linkId"]?.toString(),
    linkUrl: json["linkUrl"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "title": title,
    "subtitle": subtitle,
    "linkType": linkType,
    "linkId": linkId,
    "linkUrl": linkUrl,
  };
}

// Slider Item
class SliderItem {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? linkType;
  final String? linkId;
  final String? linkUrl;

  SliderItem({
    this.imageUrl,
    this.title,
    this.subtitle,
    this.linkType,
    this.linkId,
    this.linkUrl,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) => SliderItem(
    imageUrl: json["imageUrl"]?.toString(),
    title: json["title"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
    linkType: json["linkType"]?.toString(),
    linkId: json["linkId"]?.toString(),
    linkUrl: json["linkUrl"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "title": title,
    "subtitle": subtitle,
    "linkType": linkType,
    "linkId": linkId,
    "linkUrl": linkUrl,
  };
}

// Recent Order Item
class RecentOrderItem {
  final String? id;
  final double? orderTotal;
  final double? grandTotal;
  final String? orderStatus;
  final String? orderDate;
  final RecentOrderRestaurant? restaurant;
  final List<RecentOrderFood>? items;
  final int? itemCount;

  RecentOrderItem({
    this.id,
    this.orderTotal,
    this.grandTotal,
    this.orderStatus,
    this.orderDate,
    this.restaurant,
    this.items,
    this.itemCount,
  });

  factory RecentOrderItem.fromJson(Map<String, dynamic> json) =>
      RecentOrderItem(
        id: json["_id"]?.toString(),
        orderTotal: (json["orderTotal"] as num?)?.toDouble(),
        grandTotal: (json["grandTotal"] as num?)?.toDouble(),
        orderStatus: json["orderStatus"]?.toString(),
        orderDate: json["orderDate"]?.toString(),
        restaurant: json["restaurant"] == null
            ? null
            : (json["restaurant"] is Map<String, dynamic>
                  ? RecentOrderRestaurant.fromJson(json["restaurant"])
                  : null),
        items: json["items"] == null
            ? []
            : List<RecentOrderFood>.from(
                json["items"]!
                    .where((x) => x is Map<String, dynamic>)
                    .map((x) => RecentOrderFood.fromJson(x)),
              ),
        itemCount: json["itemCount"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "orderTotal": orderTotal,
    "grandTotal": grandTotal,
    "orderStatus": orderStatus,
    "orderDate": orderDate,
    "restaurant": restaurant?.toJson(),
    "items": items?.map((i) => i.toJson()).toList(),
    "itemCount": itemCount,
  };
}

class RecentOrderRestaurant {
  final String? id;
  final String? title;
  final String? logoUrl;
  final String? imageUrl;

  RecentOrderRestaurant({this.id, this.title, this.logoUrl, this.imageUrl});

  factory RecentOrderRestaurant.fromJson(Map<String, dynamic> json) =>
      RecentOrderRestaurant(
        id: json["_id"]?.toString(),
        title: json["title"]?.toString(),
        logoUrl: _getImageUrl(json["logoUrl"]),
        imageUrl: _getImageUrl(json["imageUrl"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "logoUrl": logoUrl,
    "imageUrl": imageUrl,
  };
}

class RecentOrderFood {
  final String? id;
  final int? quantity;
  final double? price;
  final RecentOrderFoodItem? food;

  RecentOrderFood({this.id, this.quantity, this.price, this.food});

  factory RecentOrderFood.fromJson(Map<String, dynamic> json) =>
      RecentOrderFood(
        id: json["_id"]?.toString(),
        quantity: json["quantity"],
        price: (json["price"] as num?)?.toDouble(),
        food: json["food"] == null
            ? null
            : (json["food"] is Map<String, dynamic>
                  ? RecentOrderFoodItem.fromJson(json["food"])
                  : null),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "quantity": quantity,
    "price": price,
    "food": food?.toJson(),
  };
}

class RecentOrderFoodItem {
  final String? id;
  final String? title;
  final String? imageUrl;
  final double? price;

  RecentOrderFoodItem({this.id, this.title, this.imageUrl, this.price});

  factory RecentOrderFoodItem.fromJson(Map<String, dynamic> json) =>
      RecentOrderFoodItem(
        id: json["_id"]?.toString(),
        title: json["title"]?.toString(),
        imageUrl: _getImageUrl(json["imageUrl"]),
        price: (json["price"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "imageUrl": imageUrl,
    "price": price,
  };
}

// Category Item
class CategoryItem {
  final String? id;
  final String? title;
  final String? value;
  final String? imageUrl;

  CategoryItem({this.id, this.title, this.value, this.imageUrl});

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: json["_id"]?.toString(),
    title: json["title"]?.toString(),
    value: json["value"]?.toString(),
    imageUrl: json["imageUrl"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "value": value,
    "imageUrl": imageUrl,
  };
}

// Helper function to get first image URL from various formats
String? _getImageUrl(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List && value.isNotEmpty) return value.first?.toString();
  return value.toString();
}

// Food Size for FoodItem
class FoodItemSize {
  final String? id;
  final String? name;
  final String? weight;
  final double? price;

  FoodItemSize({this.id, this.name, this.weight, this.price});

  factory FoodItemSize.fromJson(Map<String, dynamic> json) => FoodItemSize(
    id: json["_id"]?.toString() ?? json["id"]?.toString(),
    name: json["name"]?.toString(),
    weight: json["weight"]?.toString(),
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "weight": weight,
    "price": price,
  };
}

// Food Additive for FoodItem
class FoodItemAdditive {
  final String? id;
  final String? title;
  final double? price;

  FoodItemAdditive({this.id, this.title, this.price});

  factory FoodItemAdditive.fromJson(Map<String, dynamic> json) =>
      FoodItemAdditive(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        title: json["title"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {"_id": id, "title": title, "price": price};
}

// Food Sauce for FoodItem
class FoodItemSauce {
  final String? id;
  final String? name;
  final double? price;

  FoodItemSauce({this.id, this.name, this.price});

  factory FoodItemSauce.fromJson(Map<String, dynamic> json) => FoodItemSauce(
    id: json["_id"]?.toString() ?? json["id"]?.toString(),
    name: json["name"]?.toString(),
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "price": price};
}

// Drink Item for FoodItem
class FoodItemDrink {
  final String? id;
  final String? name;
  final double? price;
  final List<String>? sizes;

  FoodItemDrink({this.id, this.name, this.price, this.sizes});

  factory FoodItemDrink.fromJson(Map<String, dynamic> json) => FoodItemDrink(
    id: json["_id"]?.toString() ?? json["id"]?.toString(),
    name: json["name"]?.toString(),
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
    sizes: json["sizes"] == null
        ? []
        : List<String>.from(json["sizes"]!.map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
    "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
  };
}

// Dessert Item for FoodItem
class FoodItemDessert {
  final String? id;
  final String? name;
  final double? price;

  FoodItemDessert({this.id, this.name, this.price});

  factory FoodItemDessert.fromJson(Map<String, dynamic> json) =>
      FoodItemDessert(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        name: json["name"]?.toString(),
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "price": price};
}

// Food Item
class FoodItem {
  final String? id;
  final String? title;
  final String? imageUrl;
  final List<String>? imageUrls; // Full list of images
  final double? price;
  final double? rating;
  final String? ratingCount;
  final String? description;
  final List<String>? foodTags;
  final List<String>? foodType;
  final String? category;
  final RestaurantItem? restaurant;
  final String? time;
  final int? calories;
  final List<FoodItemSize>? sizes;
  final List<FoodItemAdditive>? additives;
  final List<FoodItemSauce>? sauces;
  final List<FoodItemDrink>? drinks;
  final List<FoodItemDessert>? desserts;
  final bool? isAvailable;

  FoodItem({
    this.id,
    this.title,
    this.imageUrl,
    this.imageUrls,
    this.price,
    this.rating,
    this.ratingCount,
    this.description,
    this.foodTags,
    this.foodType,
    this.category,
    this.restaurant,
    this.time,
    this.calories,
    this.sizes,
    this.additives,
    this.sauces,
    this.drinks,
    this.desserts,
    this.isAvailable,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    // Handle imageUrl which can be String or List
    String? singleImageUrl;
    List<String>? allImageUrls;

    final imgValue = json["imageUrl"];
    if (imgValue is List) {
      allImageUrls = List<String>.from(imgValue.map((x) => x.toString()));
      singleImageUrl = allImageUrls.isNotEmpty ? allImageUrls.first : null;
    } else if (imgValue != null) {
      singleImageUrl = imgValue.toString();
      allImageUrls = [singleImageUrl];
    }

    return FoodItem(
      id: json["_id"]?.toString() ?? json["id"]?.toString(),
      title: json["title"]?.toString(),
      imageUrl: singleImageUrl,
      imageUrls: allImageUrls,
      price: (json["price"] as num?)?.toDouble(),
      rating: (json["rating"] as num?)?.toDouble(),
      ratingCount: json["ratingCount"]?.toString(),
      description: json["description"]?.toString(),
      foodTags: json["foodTags"] == null
          ? []
          : List<String>.from(json["foodTags"]!.map((x) => x.toString())),
      foodType: json["foodType"] == null
          ? []
          : List<String>.from(json["foodType"]!.map((x) => x.toString())),
      category: json["category"]?.toString(),
      restaurant: json["restaurant"] == null
          ? null
          : (json["restaurant"] is Map<String, dynamic>
                ? RestaurantItem.fromJson(json["restaurant"])
                : null),
      time: json["time"]?.toString(),
      calories: json["calories"],
      sizes: json["sizes"] == null
          ? null
          : List<FoodItemSize>.from(
              json["sizes"]!.map((x) => FoodItemSize.fromJson(x)),
            ),
      additives: json["additives"] == null
          ? null
          : List<FoodItemAdditive>.from(
              json["additives"]!.map((x) => FoodItemAdditive.fromJson(x)),
            ),
      sauces: json["sauces"] == null
          ? null
          : List<FoodItemSauce>.from(
              json["sauces"]!.map((x) => FoodItemSauce.fromJson(x)),
            ),
      drinks: json["drinks"] == null
          ? null
          : List<FoodItemDrink>.from(
              json["drinks"]!.map((x) => FoodItemDrink.fromJson(x)),
            ),
      desserts: json["desserts"] == null
          ? null
          : List<FoodItemDessert>.from(
              json["desserts"]!.map((x) => FoodItemDessert.fromJson(x)),
            ),
      isAvailable: json["isAvailable"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "imageUrl": imageUrls ?? (imageUrl != null ? [imageUrl!] : []),
    "price": price,
    "rating": rating,
    "ratingCount": ratingCount,
    "description": description,
    "foodTags": foodTags == null
        ? []
        : List<dynamic>.from(foodTags!.map((x) => x)),
    "foodType": foodType == null
        ? []
        : List<dynamic>.from(foodType!.map((x) => x)),
    "category": category,
    "restaurant": restaurant?.toJson(),
    "time": time,
    "calories": calories,
    "sizes": sizes == null
        ? []
        : List<dynamic>.from(sizes!.map((x) => x.toJson())),
    "additives": additives == null
        ? []
        : List<dynamic>.from(additives!.map((x) => x.toJson())),
    "sauces": sauces == null
        ? []
        : List<dynamic>.from(sauces!.map((x) => x.toJson())),
    "drinks": drinks == null
        ? []
        : List<dynamic>.from(drinks!.map((x) => x.toJson())),
    "desserts": desserts == null
        ? []
        : List<dynamic>.from(desserts!.map((x) => x.toJson())),
    "isAvailable": isAvailable,
  };
}

// Deal Item
class DealItem {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final double? originalPrice;
  final double? dealPrice;
  final double? discountPercentage;
  final String? dealType;
  final List<String>? tags;
  final double? rating;
  final RestaurantItem? restaurant;
  final List<DealFood>? items;

  DealItem({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.originalPrice,
    this.dealPrice,
    this.discountPercentage,
    this.dealType,
    this.tags,
    this.rating,
    this.restaurant,
    this.items,
  });

  factory DealItem.fromJson(Map<String, dynamic> json) => DealItem(
    id: json["_id"]?.toString(),
    title: json["title"]?.toString(),
    description: json["description"]?.toString(),
    imageUrl: _getImageUrl(json["imageUrl"]),
    originalPrice: (json["originalPrice"] as num?)?.toDouble(),
    dealPrice: (json["dealPrice"] as num?)?.toDouble(),
    discountPercentage: (json["discountPercentage"] as num?)?.toDouble(),
    dealType: json["dealType"]?.toString(),
    tags: json["tags"] == null
        ? []
        : List<String>.from(json["tags"]!.map((x) => x.toString())),
    rating: (json["rating"] as num?)?.toDouble(),
    restaurant: json["restaurant"] == null
        ? null
        : (json["restaurant"] is Map<String, dynamic>
              ? RestaurantItem.fromJson(json["restaurant"])
              : null),
    items: json["items"] == null
        ? []
        : List<DealFood>.from(
            json["items"]!
                .where((x) => x is Map<String, dynamic>)
                .map((x) => DealFood.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "imageUrl": imageUrl,
    "originalPrice": originalPrice,
    "dealPrice": dealPrice,
    "discountPercentage": discountPercentage,
    "dealType": dealType,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "rating": rating,
    "restaurant": restaurant?.toJson(),
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class DealFood {
  final FoodItem? food;
  final int? quantity;
  final String? size;

  DealFood({this.food, this.quantity, this.size});

  factory DealFood.fromJson(Map<String, dynamic> json) => DealFood(
    food: json["food"] == null
        ? null
        : (json["food"] is Map<String, dynamic>
              ? FoodItem.fromJson(json["food"])
              : null),
    quantity: json["quantity"],
    size: json["size"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "food": food?.toJson(),
    "quantity": quantity,
    "size": size,
  };
}

// Offer Item
class OfferItem {
  final String? id;
  final String? title;
  final String? description;
  final String? bannerImageUrl;
  final String? offerType;
  final String? discountType;
  final double? discountValue;
  final String? promoCode;
  final int? priority;
  final List<String>? tags;
  final List<RestaurantItem>? restaurants;

  OfferItem({
    this.id,
    this.title,
    this.description,
    this.bannerImageUrl,
    this.offerType,
    this.discountType,
    this.discountValue,
    this.promoCode,
    this.priority,
    this.tags,
    this.restaurants,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
    id: json["_id"]?.toString(),
    title: json["title"]?.toString(),
    description: json["description"]?.toString(),
    bannerImageUrl: _getImageUrl(json["bannerImageUrl"]),
    offerType: json["offerType"]?.toString(),
    discountType: json["discountType"]?.toString(),
    discountValue: (json["discountValue"] as num?)?.toDouble(),
    promoCode: json["promoCode"]?.toString(),
    priority: json["priority"],
    tags: json["tags"] == null
        ? []
        : List<String>.from(json["tags"]!.map((x) => x.toString())),
    restaurants: json["restaurants"] == null
        ? []
        : List<RestaurantItem>.from(
            json["restaurants"]!
                .where((x) => x is Map<String, dynamic>)
                .map((x) => RestaurantItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "bannerImageUrl": bannerImageUrl,
    "offerType": offerType,
    "discountType": discountType,
    "discountValue": discountValue,
    "promoCode": promoCode,
    "priority": priority,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "restaurants": restaurants == null
        ? []
        : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
  };
}

// Restaurant Item
class RestaurantItem {
  final String? id;
  final String? title;
  final String? time;
  final String? imageUrl;
  final String? logoUrl;
  final String? phone;
  final String? description;
  final bool? pickup;
  final bool? delivery;
  final double? rating;
  final String? ratingCount;
  final Coords? coords;
  final String? verification;
  final String? verificationMessage;
  final String? bannerUrl;
  final double? deliveryFee;
  final String? openingTime;
  final String? closingTime;
  final bool? tableReservationEnabled;
  final int? reservationSlotDuration;
  final String? openingTimeReservation;
  final String? closingTimeReservation;
  final List<RestaurantTable>? tables;
  final List<RestaurantRoom>? rooms;
  final List<String>? seatingAreas;
  final bool? isAvailable;
  final String? code;

  RestaurantItem({
    this.id,
    this.title,
    this.time,
    this.imageUrl,
    this.logoUrl,
    this.phone,
    this.description,
    this.pickup,
    this.delivery,
    this.rating,
    this.ratingCount,
    this.coords,
    this.verification,
    this.verificationMessage,
    this.bannerUrl,
    this.deliveryFee,
    this.openingTime,
    this.closingTime,
    this.tableReservationEnabled,
    this.reservationSlotDuration,
    this.openingTimeReservation,
    this.closingTimeReservation,
    this.tables,
    this.rooms,
    this.seatingAreas,
    this.isAvailable,
    this.code,
  });

  int get totalTables => tables?.length ?? 0;
  int get totalRooms => rooms?.length ?? 0;
  int get totalSeatingCapacity =>
      tables?.fold<int>(0, (sum, t) => sum + (t.capacity ?? 0)) ?? 0;

  factory RestaurantItem.fromJson(Map<String, dynamic> json) => RestaurantItem(
    id: json["_id"]?.toString(),
    title: json["title"]?.toString(),
    time: json["time"]?.toString(),
    imageUrl: _getImageUrl(json["imageUrl"]),
    logoUrl: _getImageUrl(json["logoUrl"]),
    phone: json["phone"]?.toString(),
    description: json["description"]?.toString(),
    pickup: json["pickup"],
    delivery: json["delivery"],
    rating: (json["rating"] as num?)?.toDouble(),
    ratingCount: json["ratingCount"]?.toString(),
    coords: json["coords"] == null
        ? null
        : (json["coords"] is Map<String, dynamic>
              ? Coords.fromJson(json["coords"])
              : null),
    verification: json["verification"]?.toString(),
    verificationMessage: json["verificationMessage"]?.toString(),
    bannerUrl: _getImageUrl(json["bannerUrl"]),
    deliveryFee: (json["deliveryFee"] as num?)?.toDouble(),
    openingTime: json["openingTime"]?.toString(),
    closingTime: json["closingTime"]?.toString(),
    tableReservationEnabled: json["tableReservationEnabled"],
    reservationSlotDuration: json["reservationSlotDuration"],
    openingTimeReservation: json["openingTimeReservation"]?.toString(),
    closingTimeReservation: json["closingTimeReservation"]?.toString(),
    tables: json["tables"] == null
        ? null
        : List<RestaurantTable>.from(
            json["tables"]!.map((x) => RestaurantTable.fromJson(x)),
          ),
    rooms: json["rooms"] == null
        ? null
        : List<RestaurantRoom>.from(
            json["rooms"]!.map((x) => RestaurantRoom.fromJson(x)),
          ),
    seatingAreas: json["seatingAreas"] == null
        ? null
        : List<String>.from(json["seatingAreas"]!.map((x) => x.toString())),
    isAvailable: json["isAvailable"],
    code: json["code"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "time": time,
    "imageUrl": imageUrl,
    "logoUrl": logoUrl,
    "phone": phone,
    "description": description,
    "pickup": pickup,
    "delivery": delivery,
    "rating": rating,
    "ratingCount": ratingCount,
    "coords": coords?.toJson(),
    "verification": verification,
    "verificationMessage": verificationMessage,
    "bannerUrl": bannerUrl,
    "deliveryFee": deliveryFee,
    "openingTime": openingTime,
    "closingTime": closingTime,
    "tableReservationEnabled": tableReservationEnabled,
    "reservationSlotDuration": reservationSlotDuration,
    "openingTimeReservation": openingTimeReservation,
    "closingTimeReservation": closingTimeReservation,
    "tables": tables?.map((t) => t.toJson()).toList(),
    "rooms": rooms?.map((r) => r.toJson()).toList(),
    "seatingAreas": seatingAreas,
    "isAvailable": isAvailable,
    "code": code,
  };
}

class RestaurantTable {
  final String? id;
  final int? tableNumber;
  final int? capacity;
  final String? area;
  final String? description;
  final bool? isAvailable;

  RestaurantTable({
    this.id,
    this.tableNumber,
    this.capacity,
    this.area,
    this.description,
    this.isAvailable,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      RestaurantTable(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        tableNumber: json["tableNumber"],
        capacity: json["capacity"],
        area: json["area"]?.toString(),
        description: json["description"]?.toString(),
        isAvailable: json["isAvailable"] ?? true,
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "tableNumber": tableNumber,
    "capacity": capacity,
    "area": area,
    "description": description,
    "isAvailable": isAvailable,
  };
}

class RestaurantRoom {
  final String? id;
  final int? roomNumber;
  final int? capacity;
  final String? area;
  final String? description;
  final bool? isAvailable;
  final List<String>? amenities;

  RestaurantRoom({
    this.id,
    this.roomNumber,
    this.capacity,
    this.area,
    this.description,
    this.isAvailable,
    this.amenities,
  });

  factory RestaurantRoom.fromJson(Map<String, dynamic> json) => RestaurantRoom(
    id: json["_id"]?.toString() ?? json["id"]?.toString(),
    roomNumber: json["roomNumber"],
    capacity: json["capacity"],
    area: json["area"]?.toString(),
    description: json["description"]?.toString(),
    isAvailable: json["isAvailable"] ?? true,
    amenities: json["amenities"] == null
        ? null
        : List<String>.from(json["amenities"]!.map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "roomNumber": roomNumber,
    "capacity": capacity,
    "area": area,
    "description": description,
    "isAvailable": isAvailable,
    "amenities": amenities,
  };
}

class Coords {
  final String? id;
  final double? latitude;
  final double? longitude;
  final double? longitudeDelta;
  final double? latitudeDelta;
  final String? address;
  final String? title;

  Coords({
    this.id,
    this.latitude,
    this.longitude,
    this.longitudeDelta,
    this.latitudeDelta,
    this.address,
    this.title,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
    id: json["id"]?.toString(),
    latitude: (json["latitude"] as num?)?.toDouble(),
    longitude: (json["longitude"] as num?)?.toDouble(),
    longitudeDelta: (json["longitudeDelta"] as num?)?.toDouble(),
    latitudeDelta: (json["latitudeDelta"] as num?)?.toDouble(),
    address: json["address"]?.toString(),
    title: json["title"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "longitudeDelta": longitudeDelta,
    "latitudeDelta": latitudeDelta,
    "address": address,
    "title": title,
  };
}

// ═══════════════════════════════════════════════════════════════
// Recent Reservation Item (for home page section)
// ═══════════════════════════════════════════════════════════════

class RecentReservationItem {
  final String? id;
  final DateTime? date;
  final String? timeSlot;
  final int? numberOfGuests;
  final String? reservationType;
  final String? status;
  final String? areaPreference;
  final ReservationRestaurantBrief? restaurant;

  RecentReservationItem({
    this.id,
    this.date,
    this.timeSlot,
    this.numberOfGuests,
    this.reservationType,
    this.status,
    this.areaPreference,
    this.restaurant,
  });

  factory RecentReservationItem.fromJson(Map<String, dynamic> json) =>
      RecentReservationItem(
        id: json["_id"]?.toString(),
        date: json["date"] != null
            ? DateTime.tryParse(json["date"].toString())
            : null,
        timeSlot: json["timeSlot"]?.toString(),
        numberOfGuests: json["numberOfGuests"],
        reservationType: json["reservationType"]?.toString(),
        status: json["status"]?.toString(),
        areaPreference: json["areaPreference"]?.toString(),
        restaurant: json["restaurant"] != null
            ? ReservationRestaurantBrief.fromJson(json["restaurant"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "date": date?.toIso8601String(),
    "timeSlot": timeSlot,
    "numberOfGuests": numberOfGuests,
    "reservationType": reservationType,
    "status": status,
    "areaPreference": areaPreference,
    "restaurant": restaurant?.toJson(),
  };
}

class ReservationRestaurantBrief {
  final String? id;
  final String? title;
  final String? logoUrl;
  final String? imageUrl;

  ReservationRestaurantBrief({
    this.id,
    this.title,
    this.logoUrl,
    this.imageUrl,
  });

  factory ReservationRestaurantBrief.fromJson(Map<String, dynamic> json) =>
      ReservationRestaurantBrief(
        id: json["_id"]?.toString(),
        title: json["title"]?.toString(),
        logoUrl: json["logoUrl"]?.toString(),
        imageUrl: json["imageUrl"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "logoUrl": logoUrl,
    "imageUrl": imageUrl,
  };
}
