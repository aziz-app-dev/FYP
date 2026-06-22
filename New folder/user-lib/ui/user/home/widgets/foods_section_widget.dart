import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/wishlist/wishlist_bloc.dart';
import '../../../../bloc/user/wishlist/wishlist_event.dart';
import '../../../../bloc/user/wishlist/wishlist_state.dart';
import '../../../../config/widgets/food_card.dart';
import '../../../../model/home/home_model.dart';
import '../../../../routes/route_name.dart';
import 'section_title.dart';

class FoodsSectionWidget extends StatelessWidget {
  final List<FoodItem> foods;
  final String title;
  final void Function()? onTap;
  const FoodsSectionWidget({
    super.key,
    required this.foods,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title, onTap: onTap, context: context),
        SizedBox(height: 10.spMin),
        SizedBox(
          height: 200.spMin,
          child: BlocSelector<WishlistBloc, WishlistState, Set<String>>(
            selector: (state) => state.wishlistFoodIds,
            builder: (context, favIds) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: foods.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.spMin),
                itemBuilder: (context, index) {
                  final food = foods[index];
                  final isFav = food.id != null && favIds.contains(food.id);
                  return FoodCard(
                    imageUrl: food.imageUrl ?? "",
                    name: food.title ?? "",
                    rating: (food.rating ?? 0.0).toString(),
                    price: food.price ?? 0.0,
                    time: food.time,
                    description: food.description,
                    foodType: food.foodType,
                    restaurantName: food.restaurant?.title,
                    restaurantLogo: food.restaurant?.logoUrl,
                    isFavorite: isFav,
                    onFavoritePressed: () {
                      if (food.id != null) {
                        context.read<WishlistBloc>().add(
                          ToggleWishlistEvent(food.id!),
                        );
                      }
                    },
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.foodDetails2,
                        arguments: food.id ?? "",
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
