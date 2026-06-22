import 'package:get_it/get_it.dart';

import '../repo/user/address/address_repo.dart';
import '../repo/user/auth/auth_repo.dart';
import '../repo/user/auth/verification_repo.dart';
import '../repo/user/cart/cart_repo.dart';
import '../repo/user/category/category_http_repo.dart';
import '../repo/user/deal/deal_repo.dart';
import '../repo/user/fav/fav_repo.dart';
import '../repo/user/food/food_http_repo.dart';
import '../repo/user/home/home_http_repo.dart';
import '../repo/shared/movies/movies_http_repo.dart';
import '../repo/user/offer/offer_repo.dart';
import '../repo/user/order/order_repo.dart';
import '../repo/shared/post/posts_repo.dart';
import '../repo/user/profile/profile_repo.dart';
import '../repo/user/rating/product_reviews_repo.dart';
import '../repo/user/rating/rating_repo.dart';
import '../repo/user/reservation/reservation_repo.dart';
import '../repo/user/restaurant/restaurant_http_repo.dart';
import '../repo/user/search/search_http_repo.dart';
import '../repo/user/settings/settings_repo.dart';
import '../repo/user/wishlist/wishlist_repo.dart';

void registerRepositories(GetIt sl) {
  sl.registerLazySingleton<AddressRepo>(() => AddressRepo());
  sl.registerLazySingleton<AuthRepo>(() => AuthRepo());
  sl.registerLazySingleton<VerificationRepo>(() => VerificationRepo());
  sl.registerLazySingleton<CartRepository>(() => CartRepository());
  sl.registerLazySingleton<CategoryHttpRepo>(() => CategoryHttpRepo());
  sl.registerLazySingleton<DealRepo>(() => DealRepo());
  sl.registerLazySingleton<FavRepo>(() => FavRepo());
  sl.registerLazySingleton<FoodHttpRepo>(() => FoodHttpRepo());
  sl.registerLazySingleton<HomeHttpRepo>(() => HomeHttpRepo());
  sl.registerLazySingleton<MoviesHttpRepo>(() => MoviesHttpRepo());
  sl.registerLazySingleton<OfferRepo>(() => OfferRepo());
  sl.registerLazySingleton<OrderRepo>(() => OrderRepo());
  sl.registerLazySingleton<PostsRepo>(() => PostsRepo());
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepo());
  sl.registerLazySingleton<ProductReviewsRepo>(() => ProductReviewsRepo());
  sl.registerLazySingleton<RatingRepo>(() => RatingRepo());
  sl.registerLazySingleton<ReservationRepo>(() => ReservationRepo());
  sl.registerLazySingleton<RestaurantHttpRepo>(() => RestaurantHttpRepo());
  sl.registerLazySingleton<SearchHttpRepo>(() => SearchHttpRepo());
  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepo());
  sl.registerLazySingleton<WishlistRepo>(() => WishlistRepo());
}
