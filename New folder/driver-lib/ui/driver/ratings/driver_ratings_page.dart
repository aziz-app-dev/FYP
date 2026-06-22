import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../bloc/driver/driver_cubit.dart';
import '../../../bloc/driver/driver_state.dart';
import '../../../config/config.dart';
import '../../../di/service_locator.dart';

class DriverRatingsPage extends StatelessWidget {
  const DriverRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DriverCubit>()..bootstrap(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Driver Ratings')),
        body: BlocBuilder<DriverCubit, DriverState>(
          builder: (context, state) {
            if (state.loading && state.ratings.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.ratings.isEmpty) {
              return const Center(child: Text('No ratings yet.'));
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemBuilder: (context, index) {
                final rating = state.ratings[index];
                final time = rating.createdAt == null
                    ? 'Unknown'
                    : DateFormat('dd MMM yyyy').format(rating.createdAt!);
                return Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rating.userName ?? 'Customer',
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                          Icon(Icons.star, color: context.colors.star),
                          SizedBox(width: 4.w),
                          Text(rating.rating.toStringAsFixed(1)),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        rating.review?.isNotEmpty == true
                            ? rating.review!
                            : 'No written feedback.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        time,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemCount: state.ratings.length,
            );
          },
        ),
      ),
    );
  }
}
