import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/widgets/offer_card.dart';
import 'section_title.dart';

class OffersSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> offers;
  final String title;
  final void Function()? onTap;

  const OffersSectionWidget({
    super.key,
    required this.offers,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title, onTap: onTap, context: context),
        SizedBox(height: 10.spMin),
        SizedBox(
          height: 215.spMin,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.spMin),
            itemBuilder: (context, index) {
              final offer = offers[index];
              return OfferCard(
                title: offer['title'] as String,
                description: offer['description'] as String,
                imageUrl: offer['image'] as String,
                discountPercentage: offer['discountPercentage'] as int,
                validUntil: offer['validUntil'] as String,
                onTap: offer['onTap'] as VoidCallback?,
              );
            },
          ),
        ),
      ],
    );
  }
}
