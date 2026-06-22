import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/user/category/category_bloc.dart';
import '../../../bloc/user/category/category_event.dart';
import '../../../bloc/user/category/category_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/home/home_model.dart';
import '../../../di/service_locator.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';

class CategoryFoodsPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const CategoryFoodsPage({super.key, this.categoryId, this.categoryName});

  @override
  State<CategoryFoodsPage> createState() => _CategoryFoodsPageState();
}

class _CategoryFoodsPageState extends State<CategoryFoodsPage> {
  late CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc = getIt<CategoryBloc>();
    if (widget.categoryId != null) {
      _categoryBloc.add(FetchCategoryFoods(categoryId: widget.categoryId!));
    }
  }

  @override
  void dispose() {
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Handle missing categoryId
    if (widget.categoryId == null) {
      return ScreenWrapper(
        mobileHeader: CustomHeader(title: widget.categoryName ?? 'Foods'),
        hasError: true,
        errorTitle: 'Category not found',
        errorMessage: 'The category you are looking for does not exist',
        mobile: const SizedBox.shrink(),
      );
    }

    return BlocProvider(
      create: (context) => _categoryBloc,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final foodsResponse = state.categoryFoods;
          final isLoading = foodsResponse.isLoading;
          final hasError = foodsResponse.isError;
          final foods = foodsResponse.data ?? [];
          final isEmpty = !isLoading && !hasError && foods.isEmpty;

          return ScreenWrapper(
            mobileHeader: CustomHeader(title: widget.categoryName ?? 'Foods'),
            isLoading: isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(foodsResponse.message),
            errorTitle: 'Failed to load foods',
            errorMessage: foodsResponse.message ?? 'Something went wrong',
            onRetry: () => _categoryBloc.add(
              FetchCategoryFoods(categoryId: widget.categoryId!),
            ),
            isEmpty: isEmpty,
            emptyTitle: 'No Foods Found',
            emptyMessage: 'No foods available in this category',
            emptyIcon: Icons.fastfood_outlined,
            mobile: _buildFoodsGrid(context, foods, colors),
          );
        },
      ),
    );
  }

  Widget _buildFoodsGrid(
    BuildContext context,
    List<FoodItem> foods,
    ThemeColors colors,
  ) {
    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshCategoryFoods,
      onRefresh: () async {
        _categoryBloc.add(FetchCategoryFoods(categoryId: widget.categoryId!));
      },
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.spMin),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.spMin,
          mainAxisSpacing: 12.spMin,
          childAspectRatio: 0.75,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return _buildFoodCard(food, colors);
        },
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food, ThemeColors colors) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.foodDetails2,
          arguments: food.id ?? '',
        );
      },
      child: Card(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusCard),
                ),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: colors.shimmerBase,
                    child: Center(child: appLoader(size: 20)),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: colors.shimmerBase,
                    child: Icon(
                      Icons.fastfood,
                      color: colors.primary,
                      size: 40.spMin,
                    ),
                  ),
                ),
              ),
            ),

            // Food Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      food.title ?? '',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceText(price: food.price ?? 0),

                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.spMin,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 2.spMin),
                            Text(
                              (food.rating ?? 0).toStringAsFixed(1),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
