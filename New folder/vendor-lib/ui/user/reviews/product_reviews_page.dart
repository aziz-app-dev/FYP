import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../bloc/user/product_reviews/product_reviews_bloc.dart';
import '../../../bloc/user/product_reviews/product_reviews_event.dart';
import '../../../bloc/user/product_reviews/product_reviews_state.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../di/service_locator.dart';
import 'widgets/widgets.dart';

class ProductReviewsPage extends StatelessWidget {
  final String productId;
  final String ratingType;

  const ProductReviewsPage({
    super.key,
    required this.productId,
    required this.ratingType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductReviewsBloc>()
        ..add(
          LoadProductReviewsEvent(productId: productId, ratingType: ratingType),
        ),
      child: _ProductReviewsView(productId: productId, ratingType: ratingType),
    );
  }
}

class _ProductReviewsView extends StatelessWidget {
  final String productId;
  final String ratingType;

  const _ProductReviewsView({
    required this.productId,
    required this.ratingType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<ProductReviewsBloc, ProductReviewsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.scaffoldBackground,
          floatingActionButton:
              (state.isLoaded || state.isLoadingMore) && state.canWriteReview
              ? FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: colors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.spMin),
                        ),
                      ),
                      builder: (_) => BlocProvider.value(
                        value: context.read<ProductReviewsBloc>(),
                        child: const WriteReviewSheet(),
                      ),
                    );
                  },
                  backgroundColor: colors.primary,
                  icon: Icon(
                    TablerIcons.message_circle_2_filled,
                    color: colors.textOnPrimary,
                  ),
                  label: Text(
                    'Write Review',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          body: ScreenWrapper(
            useMobileScaffold: false,
            mobileHeader: const CustomHeader(title: 'Reviews'),
            isLoading: state.isLoading,
            hasError: state.hasError && state.reviews.isEmpty,
            isNetworkError: isNetworkError(state.errorMessage),
            errorTitle: 'Failed to load reviews',
            errorMessage: state.errorMessage ?? 'Something went wrong',
            isEmpty:
                (state.isLoaded || state.isLoadingMore) &&
                state.reviews.isEmpty,
            emptyTitle: 'No Reviews Yet',
            emptyMessage: 'Be the first to write a review!',
            emptyIcon: Icons.rate_review_outlined,
            onRetry: () {
              context.read<ProductReviewsBloc>().add(
                LoadProductReviewsEvent(
                  productId: productId,
                  ratingType: ratingType,
                ),
              );
            },
            mobile: state.isLoaded || state.isLoadingMore
                ? _ReviewsContent(state: state)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _ReviewsContent extends StatelessWidget {
  final ProductReviewsState state;

  const _ReviewsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reviews = state.reviews;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            state.hasMore &&
            !state.isLoadingMore) {
          context.read<ProductReviewsBloc>().add(
            const LoadMoreProductReviewsEvent(),
          );
        }
        return false;
      },
      child: ListView(
        padding: EdgeInsets.only(bottom: 80.spMin),
        children: [
          SizedBox(height: 8.spMin),
          // Stats section
          ReviewStatsSection(stats: state.stats),
          SizedBox(height: 20.spMin),

          // "All Reviews" header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
            child: Text(
              'All Reviews (${state.stats.totalRatings})',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12.spMin),

          // Reviews list
          ...List.generate(reviews.length, (index) {
            return Column(
              children: [
                ReviewCard(review: reviews[index]),
                if (index < reviews.length - 1)
                  Divider(
                    height: 24.spMin,
                    indent: AppSizes.paddingLg + 52.spMin,
                    endIndent: AppSizes.paddingLg,
                    color: colors.border,
                  ),
              ],
            );
          }),

          // Loading more indicator
          if (state.isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.spMin),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
