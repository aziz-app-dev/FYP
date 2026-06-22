import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/user/rating/rating_bloc.dart';
import '../../bloc/user/rating/rating_event.dart';
import '../../bloc/user/rating/rating_state.dart';
import '../../model/rating/rating_model.dart';
import '../config.dart';

class RatingCard extends StatelessWidget {
  final RatingModel rating;
  final ThemeColors colors;
  final RatingState state;
  const RatingCard({
    super.key,
    required this.rating,
    required this.colors,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isBusy = state.isBusy;
    IconData typeIcon;
    switch (rating.ratingType) {
      case RatingType.food:
        typeIcon = Icons.fastfood_rounded;
        break;
      case RatingType.restaurant:
        typeIcon = Icons.restaurant_rounded;
        break;
      case RatingType.driver:
        typeIcon = Icons.delivery_dining_rounded;
        break;
    }
    return Container(
      padding: EdgeInsets.all(12.spMin),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: rating.imageUrl != null && rating.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: rating.imageUrl!,
                        width: 35.spMin,
                        height: 35.spMin,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            _buildPlaceholderImage(colors, typeIcon),
                        errorWidget: (_, _, _) =>
                            _buildPlaceholderImage(colors, typeIcon),
                      )
                    : _buildPlaceholderImage(colors, typeIcon),
              ),
              SizedBox(width: 8.spMin),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rating.displayName,
                      style: AppTextStyles.titleMedium.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.spMin),
                    Row(
                      children: [
                        // Stars
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14.spMin,
                          ),
                        ),
                        // SizedBox(width: 8.w),
                        // Text(
                        //   rating.formattedDate,
                        //   style: AppTextStyles.labelSmall.copyWith(
                        //     color: colors.textTertiary,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                menuPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                color: colors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                enabled: !isBusy,
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditDialog(context, rating);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(context, rating);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 20.sp,
                          color: colors.textPrimary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Edit',
                          style: TextStyle(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: colors.error,
                        ),
                        SizedBox(width: 12.w),
                        Text('Delete', style: TextStyle(color: colors.error)),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: colors.textSecondary,
                  size: 18.spMin,
                ),
              ),
            ],
          ),

          // Comment
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            SizedBox(height: 6.spMin),
            Text(
              rating.comment!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Restaurant name (for food items)
          if (rating.productData?.restaurantName != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.store_rounded,
                  size: 14.spMin,
                  color: colors.textTertiary,
                ),
                SizedBox(width: 4.w),
                Text(
                  rating.productData!.restaurantName!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Widget _buildPlaceholderImage(ThemeColors colors, IconData icon) {
  return Container(
    width: 70.spMin,
    height: 70.spMin,
    decoration: BoxDecoration(
      color: colors.primary.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Icon(icon, color: colors.primary, size: 24.sp),
  );
}

void _showEditDialog(BuildContext context, RatingModel rating) {
  final colors = context.colors;
  double newRating = rating.rating;
  final commentController = TextEditingController(text: rating.comment ?? '');

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        backgroundColor: colors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Edit Review',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rating',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    setDialogState(() => newRating = starValue.toDouble());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      starValue <= newRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32.sp,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            Text(
              'Comment',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                contentPadding: EdgeInsets.all(12.w),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          BlocBuilder<RatingBloc, RatingState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (rating.id != null) {
                    context.read<RatingBloc>().add(
                      UpdateRatingEvent(
                        ratingId: rating.id!,
                        rating: newRating,
                        comment: commentController.text.trim(),
                      ),
                    );
                  }
                },
                child: Text('Save', style: TextStyle(color: colors.primary)),
              );
            },
          ),
        ],
      ),
    ),
  );
}

void _showDeleteConfirmation(BuildContext context, RatingModel rating) {
  final colors = context.colors;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: colors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'Delete Review',
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this review?',
        style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        BlocBuilder<RatingBloc, RatingState>(
          builder: (context, state) {
            return TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (rating.id != null) {
                  context.read<RatingBloc>().add(DeleteRatingEvent(rating.id!));
                }
              },
              child: Text('Delete', style: TextStyle(color: colors.error)),
            );
          },
        ),
      ],
    ),
  );
}
