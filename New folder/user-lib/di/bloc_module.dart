import 'package:get_it/get_it.dart';

import '../bloc/shared/profile/profile_bloc.dart';
import '../bloc/user/address/address_bloc.dart';
import '../bloc/user/cart/cart_bloc.dart';
import '../bloc/user/category/category_bloc.dart';
import '../bloc/user/change_password/change_password_bloc.dart';
import '../bloc/user/edit_profile/edit_profile_bloc.dart';
import '../bloc/user/food_details/food_details_bloc.dart';
import '../bloc/user/forgot_password/forgot_password_bloc.dart';
import '../bloc/user/home/home_bloc.dart';
import '../bloc/user/login/login_bloc.dart';
import '../bloc/user/main/main_bloc.dart';
import '../bloc/user/onbording/onbording_bloc.dart';
import '../bloc/user/order/order_bloc.dart';
import '../bloc/user/rating/rating_bloc.dart';
import '../bloc/user/register/register_bloc.dart';
import '../bloc/user/reservation/reservation_bloc.dart';
import '../bloc/user/restaurant_details/restaurant_details_bloc.dart';
import '../bloc/user/search/search_bloc.dart';
import '../bloc/user/wishlist/wishlist_bloc.dart';
import '../bloc/user/product_reviews/product_reviews_bloc.dart';
import '../repo/user/address/address_repo.dart';
import '../repo/user/auth/auth_repo.dart';
import '../repo/user/cart/cart_repo.dart';
import '../repo/user/category/category_http_repo.dart';
import '../repo/user/food/food_http_repo.dart';
import '../repo/user/home/home_http_repo.dart';
import '../repo/user/offer/offer_repo.dart';
import '../repo/user/order/order_repo.dart';
import '../repo/user/profile/profile_repo.dart';
import '../repo/user/rating/product_reviews_repo.dart';
import '../repo/user/rating/rating_repo.dart';
import '../repo/user/reservation/reservation_repo.dart';
import '../repo/user/restaurant/restaurant_http_repo.dart';
import '../repo/user/search/search_http_repo.dart';
import '../repo/user/wishlist/wishlist_repo.dart';
import '../services/session/session_manger.dart';
import '../services/socket/socket_service.dart';
import '../services/notification/notification_service.dart';

void registerBlocs(GetIt sl) {
  // Shared
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());

  // User feature BLoCs
  sl.registerFactory<AddressBloc>(
    () => AddressBloc(
      addressRepo: sl<AddressRepo>(),
      sessionManager: SessionManager(),
    ),
  );

  sl.registerFactory<CartBloc>(
    () => CartBloc(
      cartRepository: sl<CartRepository>(),
      offerRepo: sl<OfferRepo>(),
    ),
  );

  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(categoryRepo: sl<CategoryHttpRepo>()),
  );

  sl.registerFactory<ChangePasswordBloc>(
    () => ChangePasswordBloc(authRepo: sl<AuthRepo>()),
  );

  sl.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(profileRepo: sl<ProfileRepo>()),
  );

  sl.registerFactory<FoodDetailsBloc>(
    () => FoodDetailsBloc(
      foodRepo: sl<FoodHttpRepo>(),
      cartRepo: sl<CartRepository>(),
    ),
  );

  sl.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(authRepo: sl<AuthRepo>()),
  );

  sl.registerFactory<HomeBloc>(
    () => HomeBloc(homeHttpRepo: sl<HomeHttpRepo>()),
  );

  sl.registerFactory<LoginBloc>(() => LoginBloc(authRepo: sl<AuthRepo>()));

  sl.registerFactory<MainBloc>(() => MainBloc());

  sl.registerFactory<OnbordingBloc>(() => OnbordingBloc());

  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      orderRepo: sl<OrderRepo>(),
      socketService: sl<SocketService>(),
      notificationService: sl<NotificationService>(),
    ),
  );

  sl.registerFactory<RatingBloc>(
    () => RatingBloc(ratingRepo: sl<RatingRepo>()),
  );

  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(authRepo: sl<AuthRepo>()),
  );

  sl.registerFactory<ReservationBloc>(
    () => ReservationBloc(reservationRepo: sl<ReservationRepo>()),
  );

  sl.registerFactory<RestaurantDetailsBloc>(
    () => RestaurantDetailsBloc(restaurantRepo: sl<RestaurantHttpRepo>()),
  );

  sl.registerFactory<SearchBloc>(
    () => SearchBloc(searchRepo: sl<SearchHttpRepo>()),
  );

  sl.registerFactory<WishlistBloc>(
    () => WishlistBloc(
      wishlistRepo: sl<WishlistRepo>(),
      sessionManager: SessionManager(),
    ),
  );

  sl.registerFactory<ProductReviewsBloc>(
    () => ProductReviewsBloc(
      reviewsRepo: sl<ProductReviewsRepo>(),
      ratingRepo: sl<RatingRepo>(),
    ),
  );
}
