import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/widgets/resturnt_card.dart';
import '../../../../routes/route_name.dart';
import 'section_title.dart';

class RestaurantsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> random;
  final String title;
  final void Function()? onTap;

  const RestaurantsSectionWidget({
    super.key,
    required this.random,
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
          height: 190.spMin,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: random.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.spMin),
            itemBuilder: (context, index) {
              final rest = random[index];

              return GestureDetector(
                onTap: () {
                  final id = rest['id']?.toString() ?? '';
                  if (id.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      RouteName.restaurantDetails,
                      arguments: id,
                    );
                  }
                },
                child: ResturentCard(
                  name: rest['name'].toString(),
                  rating: rest['rating'].toString(),
                  logoUrl: rest['logoUrl'].toString(),
                  imageUrl: rest['image'].toString(),
                  timing: rest['timing']?.toString(),
                  isOpen: rest['isOpen'] ?? true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
