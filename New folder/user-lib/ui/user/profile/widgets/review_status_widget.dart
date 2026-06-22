import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/rating/rating_bloc.dart';
import '../../../../bloc/user/rating/rating_state.dart';
import '../../../../config/config.dart';

Widget buildStatsCard(BuildContext context, ThemeColors colors) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.spMin),
    child: Container(
      padding: EdgeInsets.all(8.spMin),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: .3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('${state.stats.totalRatings}', 'Reviews'),
              Container(height: 40.h, width: 1, color: Colors.white30),
              _buildStat(
                state.stats.avgRating.toStringAsFixed(1),
                'Avg Rating',
              ),
              Container(height: 40.h, width: 1, color: Colors.white30),
              _buildStat(
                '${state.stats.foodCount + state.stats.restaurantCount}',
                'Items Rated',
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget _buildStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.spMin,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 11.spMin),
      ),
    ],
  );
}
