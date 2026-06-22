import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/user/product_reviews/product_reviews_bloc.dart';
import '../../../../bloc/user/product_reviews/product_reviews_event.dart';
import '../../../../bloc/user/product_reviews/product_reviews_state.dart';
import '../../../../utils/toast_utils.dart';
import 'widgets.dart';

class WriteReviewSheet extends StatefulWidget {
  const WriteReviewSheet({super.key});

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  final ValueNotifier<double> _rating = ValueNotifier<double>(0);
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<ProductReviewsBloc, ProductReviewsState>(
      listener: (context, state) {
        if (state.status == ProductReviewsStatus.submitSuccess) {
          Navigator.pop(context);
          ToastUtils.showSuccess(context, message: state.successMessage ?? 'Review added!');
        } else if (state.errorMessage != null &&
            state.status == ProductReviewsStatus.loaded) {
          ToastUtils.showError(context, message: state.errorMessage!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.paddingLg,
          right: AppSizes.paddingLg,
          top: 16.spMin,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.spMin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.spMin,
                height: 4.spMin,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.spMin),

            // Title
            Text(
              'Write a Review',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 20.spMin),

            // Star selector
            Text(
              'Rating',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.spMin),
            ValueListenableBuilder<double>(
              valueListenable: _rating,
              builder: (context, rating, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimatedStarSelector(
                    rating: rating,
                    onChanged: (value) => _rating.value = value,
                  ),
                  SizedBox(height: 4.spMin),
                  Text(
                    rating > 0
                        ? '${rating.toStringAsFixed(1)} / 5.0'
                        : 'Tap to rate',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: rating > 0 ? colors.textSecondary : colors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.spMin),

            // Comment field
            Text(
              'Comment (optional)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.spMin),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textHint,
                ),
                contentPadding: EdgeInsets.all(12.spMin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 20.spMin),

            // Submit button
            BlocBuilder<ProductReviewsBloc, ProductReviewsState>(
              builder: (context, state) {
                final isSubmitting = state.isSubmitting;
                return ValueListenableBuilder<double>(
                  valueListenable: _rating,
                  builder: (context, rating, _) => SizedBox(
                  width: double.infinity,
                  height: 48.spMin,
                  child: ElevatedButton(
                    onPressed: rating == 0 || isSubmitting
                        ? null
                        : () {
                            context.read<ProductReviewsBloc>().add(
                                  AddReviewEvent(
                                    rating: rating,
                                    comment:
                                        _commentController.text.trim().isEmpty
                                            ? null
                                            : _commentController.text.trim(),
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      disabledBackgroundColor:
                          colors.primary.withValues(alpha: .4),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 20.spMin,
                            height: 20.spMin,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.textOnPrimary,
                            ),
                          )
                        : Text(
                            'Submit Review',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: colors.textOnPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated star selector with scale + color transitions.
/// Supports half-star selection: tap left half = 0.5, tap right half = 1.0.
class _AnimatedStarSelector extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _AnimatedStarSelector({
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final starSize = 40.spMin;

    return Row(
      children: List.generate(5, (index) {
        final fullValue = (index + 1).toDouble();
        final halfValue = index + 0.5;
        final isFullSelected = rating >= fullValue;
        final isHalfSelected = rating >= halfValue && rating < fullValue;
        final isActive = isFullSelected || isHalfSelected;

        IconData icon;
        Color color;
        if (isFullSelected) {
          icon = Icons.star_rounded;
          color = Colors.amber;
        } else if (isHalfSelected) {
          icon = Icons.star_half_rounded;
          color = Colors.amber;
        } else {
          icon = Icons.star_border_rounded;
          color = Colors.grey.shade400;
        }

        return GestureDetector(
          onTapDown: (details) {
            if (details.localPosition.dx < starSize / 2) {
              onChanged(halfValue);
            } else {
              onChanged(fullValue);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 8.spMin),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 1.0,
                end: isActive ? 1.2 : 1.0,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      icon,
                      key: ValueKey('$index-$isFullSelected-$isHalfSelected'),
                      color: color,
                      size: starSize,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
