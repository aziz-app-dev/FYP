import '../../../../utils/utils.dart';

import '../../../../di/service_locator.dart';
import '0_all_profile_view.dart';

class FavoriteFoodsPage extends StatefulWidget {
  const FavoriteFoodsPage({super.key});

  @override
  State<FavoriteFoodsPage> createState() => _FavoriteFoodsPageState();
}

class _FavoriteFoodsPageState extends State<FavoriteFoodsPage> {
  late WishlistBloc _wishlistBloc;

  @override
  void initState() {
    super.initState();
    _wishlistBloc = getIt<WishlistBloc>()..add(LoadWishlistEvent());
  }

  @override
  void dispose() {
    _wishlistBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _wishlistBloc,
      child: BlocConsumer<WishlistBloc, WishlistState>(
        listenWhen: (previous, current) => previous.status != current.status,
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.items != current.items,
        listener: (context, state) {
          if (state.status == WishlistStatus.removeSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Removed from favorites',
            );
          }
          if (state.status == WishlistStatus.error &&
              state.errorMessage != null) {
            ToastUtils.showError(context, message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          final hasError =
              state.status == WishlistStatus.error && state.items.isEmpty;

          return ScreenWrapper(
            mobileHeader: CustomHeader(
              title: 'Favorite Foods',
              // action: state.hasItems
              //     ? Container(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 12.spMin,
              //           vertical: 6.spMin,
              //         ),
              //         decoration: BoxDecoration(
              //           color: colors.primary.withValues(alpha: .1),
              //           borderRadius: BorderRadius.circular(20.r),
              //         ),
              //         child: Text(
              //           '${state.itemCount} items',
              //           style: TextStyle(
              //             color: colors.primary,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       )
              //     : null,
            ),
            isLoading: state.isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(state.errorMessage),
            errorMessage: state.errorMessage ?? 'Unable to load favorites',
            onRetry: () => _wishlistBloc.add(LoadWishlistEvent()),
            isEmpty: !state.isLoading && !hasError && !state.hasItems,
            emptyTitle: 'No Favorites Yet',
            emptyMessage: 'Start adding your favorite foods\nto see them here',
            emptyLottie: 'assets/lottie/Add to favorites.json',
            emptyIcon: Icons.favorite_border_rounded,
            mobile: _buildMobileGrid(context, state, colors),
            tablet: _buildTabletDesktopGrid(context, state, colors, 600.spMin),
            desktop: _buildTabletDesktopGrid(context, state, colors, 800.spMin),
          );
        },
      ),
    );
  }

  Widget _buildMobileGrid(
    BuildContext context,
    WishlistState state,
    ThemeColors colors,
  ) {
    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshFavorites,
      onRefresh: () async {
        _wishlistBloc.add(LoadWishlistEvent());
      },
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSizes.paddingAllMd,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.spMin,
          mainAxisSpacing: 8.spMin,
          childAspectRatio: 0.75,
        ),
        itemCount: state.foods.length,
        itemBuilder: (context, index) {
          final food = state.foods[index];
          return _buildFoodCard(context, food, state);
        },
      ),
    );
  }

  Widget _buildFoodCard(
    BuildContext context,
    FoodItem food,
    WishlistState state,
  ) {
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
      isFavorite: food.id != null && state.isFavorite(food.id!),
      onFavoritePressed: () {
        if (food.id != null) {
          context.read<WishlistBloc>().add(ToggleWishlistEvent(food.id!));
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
  }

  Widget _buildTabletDesktopGrid(
    BuildContext context,
    WishlistState state,
    ThemeColors colors,
    double maxWidth,
  ) {
    return SizedBox(
      width: maxWidth,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: AppSizes.paddingAllMd,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ScreenUtils.isTablet(context) ? 3 : 7,
          crossAxisSpacing: 8.spMin,
          mainAxisSpacing: 8.spMin,
          childAspectRatio: ScreenUtils.isTablet(context)
              ? 0.75.spMin
              : 0.99.spMin,
        ),
        itemCount: state.foods.length,
        itemBuilder: (context, index) {
          final food = state.foods[index];
          return _buildFoodCard(context, food, state);
        },
      ),
    );
  }
}
