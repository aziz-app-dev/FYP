// ignore_for_file: file_names

import 'dart:developer';

import '../../../../di/service_locator.dart';
import '../widgets/bottom_widget.dart';
import '../widgets/food_detail_section_builder.dart';
import '../widgets/widgets.dart';

class TwoFoodDetailsPage extends StatelessWidget {
  final String foodId;

  const TwoFoodDetailsPage({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    log('Navigated to Food Details Page 2 with foodId: $foodId');
    return BlocProvider(
      create: (context) =>
          getIt<FoodDetailsBloc>()..add(LoadFoodDetailsEvent(foodId: foodId)),
      child: _FoodDetailsView(foodId: foodId),
    );
  }
}

class _FoodDetailsView extends StatelessWidget {
  final String foodId;

  const _FoodDetailsView({required this.foodId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodDetailsBloc, FoodDetailsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == FoodDetailsStatus.addedToCart ||
              current.status == FoodDetailsStatus.error),
      listener: (context, state) {
        if (state.status == FoodDetailsStatus.addedToCart) {
          ToastUtils.showSuccess(context, message: 'Added to cart!');
          Navigator.pop(context);
        } else if (state.status == FoodDetailsStatus.error &&
            state.foodDetails != null) {
          ToastUtils.showError(
            context,
            message: state.errorMessage ?? 'Failed to add to cart',
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.status == FoodDetailsStatus.loading ||
            state.status == FoodDetailsStatus.initial;
        final hasError =
            state.status == FoodDetailsStatus.error &&
            state.foodDetails == null;

        return ScreenWrapper(
          topSafeArea: false,
          useMobileScaffold: true,
          isLoading: isLoading,
          mobileHeader: SizedBox.shrink(),
          hasError: hasError,
          isNetworkError: isNetworkError(state.errorMessage),
          errorTitle: 'Failed to load food details',
          errorMessage: state.errorMessage ?? 'Something went wrong',
          onRetry: () {
            context.read<FoodDetailsBloc>().add(
              LoadFoodDetailsEvent(foodId: foodId),
            );
          },
          mobile: _FoodDetailsContent(state: state),
        );
      },
    );
  }
}

class _FoodDetailsContent extends StatelessWidget {
  final FoodDetailsState state;

  const _FoodDetailsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final food = state.foodDetails;
    final colors = context.colors;
    if (food == null) return const SizedBox.shrink();

    final config = SessionManager().foodDetailsConfig;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image (style 2)
                OneImageWidget2(food: food),

                // Dynamic sections from config
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                    vertical: 6.spMin,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FoodDetailSectionBuilder(state: state, config: config),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Add to Cart Bar
          if (SessionManager().isOrderingEnabled)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomCartBar(
                totalPrice: state.totalPrice,
                quantity: state.quantity,
                minQuantity: state.minQuantity,
                maxQuantity: state.maxQuantity,
                isAvailable: state.foodDetails?.isAvailable ?? true,
                hasRequiredCustomizations: state.hasAllRequiredCustomizations,
                title: food.title ?? 'Food Item',
                basePrice: state.basePrice,
              ),
            ),
        ],
      ),
    );
  }
}
