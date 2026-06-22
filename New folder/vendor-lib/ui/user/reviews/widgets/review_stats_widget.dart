import 'widgets.dart';

class ReviewStatsSection extends StatelessWidget {
  final ProductReviewStats stats;

  const ReviewStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Column(
        children: [
          // Top row: large rating number + star distribution
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSm),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: big rating number + stars + count
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      stats.averageRating.toStringAsFixed(1),
                      style: AppTextStyles.displayLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    _StarRow(
                      rating: stats.averageRating,
                      size: 18.spMin,
                      colors: colors,
                    ),
                    SizedBox(height: 6.spMin),
                    Text(
                      '${stats.totalRatings} Reviews',
                      style: AppTextStyles.bodyMedium.copyWith(),
                    ),
                  ],
                ),
                SizedBox(width: 24.spMin),
                // Right: star distribution bars
                Expanded(
                  child: Column(
                    children: [
                      for (int star = 5; star >= 1; star--)
                        _DistributionBar(
                          star: star,
                          count: stats.distribution[star] ?? 0,
                          total: stats.totalRatings,
                          colors: colors,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  final int star;
  final int count;
  final int total;
  final ThemeColors colors;

  const _DistributionBar({
    required this.star,
    required this.count,
    required this.total,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? count / total : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.spMin),
      child: Row(
        children: [
          SizedBox(
            width: 12.spMin,
            child: Text(
              '$star',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 4.spMin),
          Icon(Icons.star, size: 12.spMin, color: Colors.amber),
          SizedBox(width: 8.spMin),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8.spMin,
                backgroundColor: colors.border,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
          ),
          SizedBox(width: 8.spMin),
          SizedBox(
            width: 24.spMin,
            child: Text(
              '$count',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  final ThemeColors colors;

  const _StarRow({
    required this.rating,
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isActive = rating >= starValue - 0.5;
        return Icon(
          Icons.star,
          size: size,
          color: isActive ? Colors.amber : colors.textDisabled,
        );
      }),
    );
  }
}
