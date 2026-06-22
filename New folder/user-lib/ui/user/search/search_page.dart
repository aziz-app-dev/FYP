import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/user/search/search_bloc.dart';
import '../../../bloc/user/search/search_event.dart';
import '../../../bloc/user/search/search_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../di/service_locator.dart';
import '../../../model/home/home_model.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';
import 'search_filter_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _searchText = ValueNotifier<String>('');
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = getIt<SearchBloc>();
    _searchController.addListener(() {
      _searchText.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchText.dispose();
    _searchBloc.close();
    super.dispose();
  }

  void _openFilterPage() async {
    final result = await Navigator.push<SearchFilters>(
      context,
      MaterialPageRoute(
        builder: (_) => SearchFilterPage(
          initialFilters: _searchBloc.state.filters,
        ),
      ),
    );
    if (result != null) {
      _searchBloc.add(UpdateFilters(result));
    }
  }

  void _performSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      _searchBloc.add(SearchFoods(query: _searchController.text));
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _searchBloc,
      child: ScreenWrapper(
        useMobileScaffold: true,
        mobileHeader: CustomHeader(
          title: 'Search',
          showBackButton: false,
          verticalPadding: HeaderVerticalPadding.bottom,
        ),
        mobile: Column(
          children: [
            // Search Input + Filter button
            Padding(
              padding: EdgeInsets.fromLTRB(16.spMin, 0, 16.spMin, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _searchText,
                      builder: (context, text, _) => TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _performSearch(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.spMin,
                          vertical: 12.spMin,
                        ),
                        fillColor: colors.fillColor,
                        filled: true,
                        hintText: 'Search for foods, restaurants...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textHint,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 1.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colors.iconSecondary,
                          size: 22.spMin,
                        ),
                        suffixIcon: text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: colors.iconSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchBloc.add(ClearSearch());
                                },
                              )
                            : null,
                      ),
                    ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Filter button
                  BlocBuilder<SearchBloc, SearchState>(
                    buildWhen: (prev, curr) => prev.filters != curr.filters,
                    builder: (context, state) {
                      final hasFilters = state.filters.hasActiveFilters;
                      return GestureDetector(
                        onTap: _openFilterPage,
                        child: Container(
                          width: 48.spMin,
                          height: 48.spMin,
                          decoration: BoxDecoration(
                            color: hasFilters
                                ? colors.primary
                                : colors.fillColor,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                color: hasFilters
                                    ? colors.textOnPrimary
                                    : colors.iconSecondary,
                                size: 22.spMin,
                              ),
                              if (hasFilters)
                                Positioned(
                                  top: 6.spMin,
                                  right: 6.spMin,
                                  child: Container(
                                    width: 16.spMin,
                                    height: 16.spMin,
                                    decoration: BoxDecoration(
                                      color: colors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${state.filters.activeFilterCount}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.spMin,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Active filter chips
            BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (prev, curr) => prev.filters != curr.filters,
              builder: (context, state) {
                if (!state.filters.hasActiveFilters) {
                  return const SizedBox.shrink();
                }
                return _buildFilterChips(state.filters, colors);
              },
            ),

            // Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return _buildContent(context, state, colors);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(SearchFilters filters, ThemeColors colors) {
    final labels = filters.activeFilterLabels;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: labels.length + 1,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            if (index == labels.length) {
              return GestureDetector(
                onTap: () => _searchBloc.add(ClearFilters()),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.clear_all_rounded,
                          size: 16.spMin, color: colors.error),
                      SizedBox(width: 4.w),
                      Text(
                        'Clear',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final entry = labels.entries.elementAt(index);
            return GestureDetector(
              onTap: () => _searchBloc.add(RemoveFilter(entry.key)),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.value,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.close_rounded,
                        size: 14.spMin, color: colors.primary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SearchState state,
    ThemeColors colors,
  ) {
    final searchResults = state.searchResults;

    if (searchResults.isLoading) {
      return Center(child: appLoader());
    }

    if (searchResults.isError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.spMin,
                height: 120.spMin,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 60.spMin,
                  color: colors.error,
                ),
              ),
              SizedBox(height: 24.spMin),
              Text(
                'Something went wrong',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.spMin),
              Text(
                'Unable to search. Please try again.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.spMin),
              ElevatedButton.icon(
                onPressed: () {
                  _searchBloc.add(SearchFoods(query: state.query));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.spMin,
                    vertical: 12.spMin,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (searchResults.isInitial) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/Search (1).json',
                width: 200.spMin,
                height: 200.spMin,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16.spMin),
              Text(
                'Search for Foods',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.spMin),
              Text(
                'Find your favorite foods,\nrestaurants and more',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final foods = searchResults.data ?? [];

    if (foods.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150.spMin,
                height: 150.spMin,
                decoration: BoxDecoration(
                  color: colors.textHint.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 70.spMin,
                  color: colors.textHint,
                ),
              ),
              SizedBox(height: 16.spMin),
              Text(
                'No Results Found',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.spMin),
              Text(
                state.filters.hasActiveFilters
                    ? 'Try adjusting your filters\nor search for something else'
                    : 'Try a different search term\nor check your spelling',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (state.filters.hasActiveFilters) ...[
                SizedBox(height: 16.spMin),
                TextButton.icon(
                  onPressed: () => _searchBloc.add(ClearFilters()),
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: const Text('Clear Filters'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.spMin, 12.spMin, 16.spMin, 100.spMin),
      itemCount: foods.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.spMin),
      itemBuilder: (context, index) {
        final food = foods[index];
        return _buildFoodCard(food, colors);
      },
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
        child: Padding(
          padding: EdgeInsets.all(12.spMin),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl ?? '',
                  width: 80.spMin,
                  height: 80.spMin,
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
                      size: 32.spMin,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.spMin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.title ?? '',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.spMin),
                    if (food.restaurant?.title != null)
                      Text(
                        food.restaurant!.title!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 8.spMin),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceText(price: food.price ?? 0),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16.spMin,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4.spMin),
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
            ],
          ),
        ),
      ),
    );
  }
}
