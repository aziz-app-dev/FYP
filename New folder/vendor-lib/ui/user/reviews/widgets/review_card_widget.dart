import 'widgets.dart';

class ReviewCard extends StatelessWidget {
  final ProductReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = review.user;
    final username = user?.username ?? 'Unknown';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipOval(
            child: user?.profileUrl != null && user!.profileUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: user.profileUrl!,
                    width: 40.spMin,
                    height: 40.spMin,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _AvatarFallback(
                      initial: initial,
                      colors: colors,
                    ),
                  )
                : _AvatarFallback(initial: initial, colors: colors),
          ),
          SizedBox(width: 12.spMin),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + stars row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _SmallStarRow(rating: review.rating),
                  ],
                ),
                if (review.comment != null &&
                    review.comment!.trim().isNotEmpty) ...[
                  SizedBox(height: 6.spMin),
                  Text(
                    review.comment!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (review.formattedDate.isNotEmpty) ...[
                  SizedBox(height: 4.spMin),
                  Text(
                    review.formattedDate,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String initial;
  final ThemeColors colors;

  const _AvatarFallback({required this.initial, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.spMin,
      height: 40.spMin,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
      ),
    );
  }
}

class _SmallStarRow extends StatelessWidget {
  final double rating;

  const _SmallStarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: 14.spMin, color: Colors.amber);
      }),
    );
  }
}
