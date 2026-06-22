import 'widgets.dart';

class RestaurantHeroImage extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantHeroImage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        // Total height = image (250) + logo overflow (30)
        SizedBox(height: 280.spMin, width: double.infinity),
        // Cover image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 250.spMin,
          child: CachedNetworkImage(
            imageUrl: restaurant.bannerUrl ?? restaurant.imageUrl ?? '',
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => Container(
              color: colors.surfaceVariant,
              child: Icon(
                Icons.restaurant,
                size: 60.spMin,
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
        // Gradient overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 250.spMin,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: .6),
                ],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.spMin,
          left: 8.spMin,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.spMin),
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.spMin,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
        // Logo - half on image, half below
        Positioned(
          left: 20.spMin,
          top: 200.spMin,
          child: Container(
            width: 80.spMin,
            height: 80.spMin,
            decoration: BoxDecoration(
              color: colors.scaffoldBackground,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: colors.scaffoldBackground,
                width: 4.spMin,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 8.spMin,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: restaurant.logoUrl ?? '',
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Icon(
                  Icons.restaurant,
                  color: colors.primary,
                  size: 28.spMin,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
