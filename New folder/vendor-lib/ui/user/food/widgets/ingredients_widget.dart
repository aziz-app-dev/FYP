import 'widgets.dart';

/// Ingredients section with images
class IngredientsSection extends StatelessWidget {
  final List<FoodIngredient> ingredients;

  const IngredientsSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 100.spMin,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.spMin),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return Stack(
            children: [
              Container(
                // width: 85.spMin,
                decoration: BoxDecoration(
                  // color: colors.surface,
                  // borderRadius: BorderRadius.circular(AppSizes.radiusRound),
                  // border: Border.all(color: colors.border),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: colors.shadow,
                  //     blurRadius: 4,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ingredient image
                    SizedBox(
                      width: 55.spMin,
                      height: 55.spMin,
                      // decoration: BoxDecoration(
                      //   color: colors.surfaceVariant,
                      //   borderRadius: BorderRadius.circular(
                      //     AppSizes.radiusRound,
                      //   ),
                      // ),
                      child: ingredient.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ingredient.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Center(
                                  child: Icon(
                                    Icons.egg_outlined,
                                    size: 24.spMin,
                                    color: colors.iconSecondary,
                                  ),
                                ),
                                errorWidget: (_, _, _) => Center(
                                  child: Icon(
                                    Icons.egg_outlined,
                                    size: 24.spMin,
                                    color: colors.iconSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.egg_outlined,
                                size: 24.spMin,
                                color: colors.iconSecondary,
                              ),
                            ),
                    ),
                    SizedBox(height: 8.spMin),
                    // Ingredient name
                    Text(
                      ingredient.name ?? '',
                      style: TextStyle(
                        fontSize: 11.spMin,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Quantity if available
                    if (ingredient.quantity != null)
                      Text(
                        ingredient.quantity!,
                        style: TextStyle(
                          fontSize: 9.spMin,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              // ! Allergen indicator (if ingredient is an allergen)
              // Positioned(
              //   top: 10.spMin,
              //   right: 10.spMin,
              //   child: // Allergen indicator
              //   ingredient.isAllergen
              //       ? Container(
              //           margin: EdgeInsets.only(top: 2.spMin),
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 4.spMin,
              //             vertical: 1.spMin,
              //           ),
              //           decoration: BoxDecoration(
              //             color: colors.warningLight,
              //             borderRadius: BorderRadius.circular(4.r),
              //           ),
              //           child: Text(
              //             'Allergen',
              //             style: TextStyle(
              //               fontSize: 7.spMin,
              //               color: colors.warning,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         )
              //       : SizedBox.shrink(),
              // ),
            ],
          );
        },
      ),
    );
  }
}

/// Ingredients section with images
class IngredientsSection2 extends StatelessWidget {
  final List<FoodIngredient> ingredients;

  const IngredientsSection2({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 40.spMin,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.spMin),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.spMin,
                  vertical: 6.spMin,
                ),
                // width: 85.spMin,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusRound),
                  border: Border.all(color: colors.border),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: colors.shadow,
                  //     blurRadius: 4,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4.spMin,
                  children: [
                    // Ingredient image
                    SizedBox(
                      width: 25.spMin,
                      height: 25.spMin,

                      child: ingredient.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ingredient.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Center(
                                  child: Icon(
                                    Icons.egg_outlined,
                                    size: 24.spMin,
                                    color: colors.iconSecondary,
                                  ),
                                ),
                                errorWidget: (_, _, _) => Center(
                                  child: Icon(
                                    Icons.egg_outlined,
                                    size: 24.spMin,
                                    color: colors.iconSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.egg_outlined,
                                size: 24.spMin,
                                color: colors.iconSecondary,
                              ),
                            ),
                    ),
                    SizedBox(height: 8.spMin),
                    // Ingredient name
                    Text(
                      ingredient.name ?? '',
                      style: TextStyle(
                        fontSize: 11.spMin,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Quantity if available
                    if (ingredient.quantity != null)
                      Text(
                        ingredient.quantity!,
                        style: TextStyle(
                          fontSize: 9.spMin,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              // ! Allergen indicator (if ingredient is an allergen)
              // Positioned(
              //   top: 10.spMin,
              //   right: 10.spMin,
              //   child: // Allergen indicator
              //   ingredient.isAllergen
              //       ? Container(
              //           margin: EdgeInsets.only(top: 2.spMin),
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 4.spMin,
              //             vertical: 1.spMin,
              //           ),
              //           decoration: BoxDecoration(
              //             color: colors.warningLight,
              //             borderRadius: BorderRadius.circular(4.r),
              //           ),
              //           child: Text(
              //             'Allergen',
              //             style: TextStyle(
              //               fontSize: 7.spMin,
              //               color: colors.warning,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         )
              //       : SizedBox.shrink(),
              // ),
            ],
          );
        },
      ),
    );
  }
}
