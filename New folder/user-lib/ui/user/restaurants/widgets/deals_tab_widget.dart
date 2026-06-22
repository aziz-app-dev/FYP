import 'widgets.dart';

class DealsTab extends StatelessWidget {
  final List<DealItem> deals;

  const DealsTab({super.key, required this.deals});

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) {
      return const EmptyTab(
        icon: Icons.local_offer_outlined,
        message: 'No deals available',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.paddingLg),
      itemCount: deals.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.spMin),
      itemBuilder: (context, index) => DealListCard(deal: deals[index]),
    );
  }
}

class DealListCard extends StatelessWidget {
  final DealItem deal;

  const DealListCard({super.key, required this.deal});

  Map<String, dynamic> _dealToMap() {
    return {
      'id': deal.id ?? "",
      'title': deal.title ?? "",
      'restaurantName': deal.restaurant?.title ?? "",
      'restaurantId': deal.restaurant?.id ?? "",
      'image': deal.imageUrl ?? "",
      'discountPercentage': (deal.discountPercentage ?? 0).toInt(),
      'originalPrice': deal.originalPrice ?? 0.0,
      'dealPrice': deal.dealPrice ?? 0.0,
      'validUntil': "Available now",
      'itemsIncluded':
          deal.items
              ?.map(
                (item) => {
                  'name': item.food?.title ?? "",
                  'quantity': item.quantity ?? 1,
                  'icon': 'x',
                },
              )
              .toList() ??
          <Map<String, dynamic>>[],
      'description': deal.description ?? "",
      'termsAndConditions': "",
      'category': deal.dealType ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.dealDetails,
          arguments: _dealToMap(),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.spMin),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: CachedNetworkImage(
                imageUrl: deal.imageUrl ?? '',
                width: 84.spMin,
                height: 84.spMin,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 84.spMin,
                  height: 84.spMin,
                  color: colors.surfaceVariant,
                  child: Icon(Icons.local_offer, color: colors.textSecondary),
                ),
              ),
            ),
            SizedBox(width: 12.spMin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title ?? '',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.spMin),
                  Text(
                    deal.description ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.spMin),
                  Row(
                    children: [
                      PriceText(price: deal.dealPrice ?? 0),
                      SizedBox(width: 8.spMin),
                      if ((deal.originalPrice ?? 0) > (deal.dealPrice ?? 0))
                        PriceText(
                          price: deal.originalPrice ?? 0,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textHint,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
