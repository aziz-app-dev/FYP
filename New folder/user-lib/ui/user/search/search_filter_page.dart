import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/user/search/search_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/app_btn.dart';
import '../../../config/widgets/screen_wapper.dart';

class SearchFilterPage extends StatefulWidget {
  final SearchFilters initialFilters;

  const SearchFilterPage({super.key, required this.initialFilters});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final ValueNotifier<String?> _selectedCategory = ValueNotifier<String?>(null);
  final ValueNotifier<double?> _minPrice = ValueNotifier<double?>(null);
  final ValueNotifier<double?> _maxPrice = ValueNotifier<double?>(null);
  final ValueNotifier<double?> _minRating = ValueNotifier<double?>(null);
  final ValueNotifier<String?> _sortBy = ValueNotifier<String?>(null);
  final ValueNotifier<List<String>> _selectedFoodTypes = ValueNotifier<List<String>>([]);

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  final _categories = [
    'Pizza',
    'Burger',
    'Sushi',
    'Pasta',
    'Salad',
    'Dessert',
    'Drinks',
    'Sandwich',
    'Chinese',
    'Indian',
    'Mexican',
    'Thai',
  ];

  final _foodTypes = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Halal',
    'Spicy',
    'Healthy',
    'Fast Food',
  ];

  final _sortOptions = {
    'price_low': 'Price: Low to High',
    'price_high': 'Price: High to Low',
    'rating': 'Highest Rated',
    'name': 'Name A-Z',
  };

  final _ratingOptions = [4.5, 4.0, 3.5, 3.0];

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _selectedCategory.value = f.category;
    _minPrice.value = f.minPrice;
    _maxPrice.value = f.maxPrice;
    _minRating.value = f.minRating;
    _sortBy.value = f.sortBy;
    _selectedFoodTypes.value = List.from(f.foodTypes);

    if (_minPrice.value != null) {
      _minPriceController.text = _minPrice.value!.toInt().toString();
    }
    if (_maxPrice.value != null) {
      _maxPriceController.text = _maxPrice.value!.toInt().toString();
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _selectedCategory.dispose();
    _minPrice.dispose();
    _maxPrice.dispose();
    _minRating.dispose();
    _sortBy.dispose();
    _selectedFoodTypes.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _selectedCategory.value != null ||
      _minPrice.value != null ||
      _maxPrice.value != null ||
      _minRating.value != null ||
      _sortBy.value != null ||
      _selectedFoodTypes.value.isNotEmpty;

  void _clearAll() {
    _selectedCategory.value = null;
    _minPrice.value = null;
    _maxPrice.value = null;
    _minRating.value = null;
    _sortBy.value = null;
    _selectedFoodTypes.value = [];
    _minPriceController.clear();
    _maxPriceController.clear();
  }

  void _applyFilters() {
    // Parse price fields
    final minP = double.tryParse(_minPriceController.text);
    final maxP = double.tryParse(_maxPriceController.text);

    final filters = SearchFilters(
      category: _selectedCategory.value,
      minPrice: minP,
      maxPrice: maxP,
      minRating: _minRating.value,
      sortBy: _sortBy.value,
      foodTypes: _selectedFoodTypes.value,
    );
    Navigator.pop(context, filters);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _selectedCategory,
        _minPrice,
        _maxPrice,
        _minRating,
        _sortBy,
        _selectedFoodTypes,
      ]),
      builder: (context, _) => ScreenWrapper(
      useMobileScaffold: true,
      mobileHeader: CustomHeader(
        title: 'Filters',
        action: _hasFilters
            ? GestureDetector(
                onTap: _clearAll,
                child: Text(
                  'Clear All',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
      mobile: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              children: [
                // Sort By
                _buildSectionTitle('Sort By', colors),
                SizedBox(height: 10.h),
                _buildSortOptions(colors),

                SizedBox(height: 24.h),

                // Category
                _buildSectionTitle('Category', colors),
                SizedBox(height: 10.h),
                _buildCategoryChips(colors),

                SizedBox(height: 24.h),

                // Price Range
                _buildSectionTitle('Price Range', colors),
                SizedBox(height: 10.h),
                _buildPriceRange(colors),

                SizedBox(height: 24.h),

                // Rating
                _buildSectionTitle('Minimum Rating', colors),
                SizedBox(height: 10.h),
                _buildRatingOptions(colors),

                SizedBox(height: 24.h),

                // Food Type
                _buildSectionTitle('Food Type', colors),
                SizedBox(height: 10.h),
                _buildFoodTypeChips(colors),

                SizedBox(height: 40.h),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
            child: AppButton(
              text: _hasFilters ? 'Apply Filters' : 'Show All Results',
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeColors colors) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
    );
  }

  Widget _buildSortOptions(ThemeColors colors) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _sortOptions.entries.map((entry) {
        final isSelected = _sortBy.value == entry.key;
        return _FilterChip(
          label: entry.value,
          isSelected: isSelected,
          colors: colors,
          onTap: () {
            _sortBy.value = isSelected ? null : entry.key;
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChips(ThemeColors colors) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory.value == cat;
        return _FilterChip(
          label: cat,
          isSelected: isSelected,
          colors: colors,
          onTap: () {
            _selectedCategory.value = isSelected ? null : cat;
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceRange(ThemeColors colors) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Min',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: colors.textHint,
              ),
              prefixText: '\$ ',
              prefixStyle: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.fillColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '—',
            style: AppTextStyles.titleMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Max',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: colors.textHint,
              ),
              prefixText: '\$ ',
              prefixStyle: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.fillColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingOptions(ThemeColors colors) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _ratingOptions.map((rating) {
        final isSelected = _minRating.value == rating;
        return _FilterChip(
          label: '$rating+',
          icon: Icons.star_rounded,
          iconColor: Colors.amber,
          isSelected: isSelected,
          colors: colors,
          onTap: () {
            _minRating.value = isSelected ? null : rating;
          },
        );
      }).toList(),
    );
  }

  Widget _buildFoodTypeChips(ThemeColors colors) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _foodTypes.map((type) {
        final list = _selectedFoodTypes.value;
        final isSelected = list.contains(type);
        return _FilterChip(
          label: type,
          isSelected: isSelected,
          colors: colors,
          onTap: () {
            final updated = List<String>.from(_selectedFoodTypes.value);
            if (isSelected) {
              updated.remove(type);
            } else {
              updated.add(type);
            }
            _selectedFoodTypes.value = updated;
          },
        );
      }).toList(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ThemeColors colors;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: .12)
              : colors.fillColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.spMin, color: iconColor ?? colors.primary),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.check_rounded,
                size: 16.spMin,
                color: colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
