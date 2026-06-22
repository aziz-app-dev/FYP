import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/widgets/deal_card.dart';
import 'section_title.dart';

class DealsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> deals;
  final String title;
  final void Function()? onTap;

  const DealsSectionWidget({
    super.key,
    required this.deals,
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
            itemCount: deals.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.spMin),
            itemBuilder: (context, index) {
              final deal = deals[index];
              return DealCard(
                title: deal['title'] as String,
                restaurantName: deal['restaurantName'] as String,
                imageUrl: deal['image'] as String,
                originalPrice: deal['originalPrice'] as double,
                discountedPrice: deal['discountedPrice'] as double,
                validUntil: deal['validUntil'] as String,
                onTap: deal['onTap'] as VoidCallback?,
              );
            },
          ),
        ),
      ],
    );
  }
}
