import 'widgets.dart';

class MenuTab extends StatelessWidget {
  final List<FoodItem> foods;

  const MenuTab({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const EmptyTab(
        icon: Icons.restaurant_menu_outlined,
        message: 'No menu items yet',
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppSizes.paddingLg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.spMin,
        mainAxisSpacing: 12.spMin,
        childAspectRatio: 0.72,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) => FoodGridCard(food: foods[index]),
    );
  }
}

class FoodGridCard extends StatelessWidget {
  final FoodItem food;

  const FoodGridCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.foodDetails,
          arguments: food.id ?? '',
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusLg),
                ),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    color: colors.surfaceVariant,
                    child: Icon(
                      Icons.fastfood,
                      color: colors.textSecondary,
                      size: 32.spMin,
                    ),
                  ),
                ),
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.title ?? '',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.spMin),
                    Text(
                      food.description ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceText(price: food.price ?? 0),
                        Container(
                          padding: EdgeInsets.all(4.spMin),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: colors.textOnPrimary,
                            size: 16.spMin,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
