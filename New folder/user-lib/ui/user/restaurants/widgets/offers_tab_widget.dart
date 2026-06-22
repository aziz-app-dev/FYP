import 'widgets.dart';

class OffersTab extends StatelessWidget {
  final List<OfferItem> offers;

  const OffersTab({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const EmptyTab(
        icon: Icons.campaign_outlined,
        message: 'No offers available',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.paddingLg),
      itemCount: offers.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.spMin),
      itemBuilder: (context, index) => OfferListCard(offer: offers[index]),
    );
  }
}

class OfferListCard extends StatelessWidget {
  final OfferItem offer;

  const OfferListCard({super.key, required this.offer});

  Map<String, dynamic> _offerToMap() {
    return {
      'id': offer.id ?? "",
      'title': offer.title ?? "",
      'description': offer.description ?? "",
      'image': offer.bannerImageUrl ?? "",
      'discountPercentage': (offer.discountValue ?? 0).toInt(),
      'promoCode': offer.promoCode ?? "",
      'subDetails': offer.offerType ?? "",
      'expiryTime': "",
      'validUntil': "",
      'participatingRestaurants':
          offer.restaurants
              ?.map(
                (r) => {
                  'name': r.title ?? "",
                  'rating': r.rating ?? 0.0,
                  'deliveryTime': "30 min",
                  'image': r.imageUrl ?? "",
                },
              )
              .toList() ??
          <Map<String, dynamic>>[],
      'termsAndConditions': <String>[],
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.offerDetails,
          arguments: _offerToMap(),
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
                imageUrl: offer.bannerImageUrl ?? '',
                width: 84.spMin,
                height: 84.spMin,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 84.spMin,
                  height: 84.spMin,
                  color: colors.surfaceVariant,
                  child: Icon(Icons.campaign, color: colors.textSecondary),
                ),
              ),
            ),
            SizedBox(width: 12.spMin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title ?? '',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.spMin),
                  Text(
                    offer.description ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.spMin),
                  Row(
                    children: [
                      if ((offer.discountValue ?? 0) > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.spMin,
                            vertical: 4.spMin,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${(offer.discountValue ?? 0).toStringAsFixed(0)}% OFF',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      if ((offer.promoCode ?? '').isNotEmpty) ...[
                        SizedBox(width: 8.spMin),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.spMin,
                            vertical: 4.spMin,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.primary),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            offer.promoCode!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
