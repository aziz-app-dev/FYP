import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/user/category/category_bloc.dart';
import '../../../bloc/user/category/category_event.dart';
import '../../../bloc/user/category/category_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/home/home_model.dart';
import '../../../di/service_locator.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc = getIt<CategoryBloc>()
      ..add(FetchCategories());
  }

  @override
  void dispose() {
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider(
      create: (context) => _categoryBloc,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final categoriesResponse = state.categories;
          final isLoading = categoriesResponse.isLoading;
          final hasError = categoriesResponse.isError;
          final categories = categoriesResponse.data ?? [];
          final isEmpty = !isLoading && !hasError && categories.isEmpty;

          return ScreenWrapper(
            mobileHeader: CustomHeader(title: 'Categories'),
            isLoading: isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(categoriesResponse.message),
            errorTitle: 'Failed to load categories',
            errorMessage: categoriesResponse.message ?? 'Something went wrong',
            onRetry: () => _categoryBloc.add(FetchCategories()),
            isEmpty: isEmpty,
            emptyTitle: 'No Categories',
            emptyMessage: 'No categories available at the moment',
            emptyIcon: Icons.category_outlined,
            mobile: _buildCategoriesGrid(context, categories, colors),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    List<CategoryItem> categories,
    ThemeColors colors,
  ) {
    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshCategories,
      onRefresh: () async {
        _categoryBloc.add(FetchCategories());
      },
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.spMin),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.spMin,
          mainAxisSpacing: 12.spMin,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(category, colors);
        },
      ),
    );
  }

  Widget _buildCategoryCard(CategoryItem category, ThemeColors colors) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.categoryFoods,
          arguments: {
            'categoryId': category.id,
            'categoryName': category.title,
          },
        );
      },
      child: Card(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
              child: CachedNetworkImage(
                imageUrl: category.imageUrl ?? '',
                width: 70.spMin,
                height: 70.spMin,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 70.spMin,
                  height: 70.spMin,
                  color: colors.shimmerBase,
                  child: Center(child: appLoader(size: 20)),
                ),
                errorWidget: (_, _, _) => Container(
                  width: 70.spMin,
                  height: 70.spMin,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fastfood,
                    color: colors.primary,
                    size: 32.spMin,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.spMin),

            // Category Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.spMin),
              child: Text(
                category.title ?? '',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
