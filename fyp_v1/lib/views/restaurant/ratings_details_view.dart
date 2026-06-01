import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../models/rating/rating_summary_model.dart';
import '../../view models/controllers/rating_view_model.dart';

/// Ratings + Reviews detail page. Mirrors the design in the user's
/// reference screenshot: big average on the left, 5-to-1 bar
/// breakdown on the right, then a scrollable list of recent reviews.
class RatingsDetailsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RatingsDetailsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RatingsDetailsScreen> createState() => _RatingsDetailsScreenState();
}

class _RatingsDetailsScreenState extends State<RatingsDetailsScreen> {
  final _rating = Get.put(RatingController());

  @override
  void initState() {
    super.initState();
    _rating.fetch(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Ratings & Reviews',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
      ),
      body: Obx(() {
        if (_rating.isLoading && _rating.summary == null) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimary),
          );
        }
        final s = _rating.summary ??
            RatingSummary(
                average: 0, count: 0, breakdown: [0, 0, 0, 0, 0], reviews: []);
        return RefreshIndicator(
          onRefresh: () => _rating.fetch(widget.restaurantId),
          child: ListView(
            padding: EdgeInsets.all(14.r),
            children: [
              _summaryCard(s),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                child: ReuseableText(
                  text: 'Recent reviews',
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kGray,
                ),
              ),
              if (s.reviews.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: ReuseableText(
                      text: 'No reviews yet',
                      fontSize: 13.spMin,
                      fontWeight: FontWeight.w400,
                      textColor: kGray,
                    ),
                  ),
                )
              else
                ...s.reviews.map((r) => _reviewCard(r)),
            ],
          ),
        );
      }),
    );
  }

  Widget _summaryCard(RatingSummary s) {
    final maxInBreakdown = s.breakdown.fold<int>(0, (m, v) => v > m ? v : m);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Row(
        children: [
          // Left column — big average + stars + review count.
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ReuseableText(
                  text: s.average.toStringAsFixed(1),
                  fontSize: 34.spMin,
                  fontWeight: FontWeight.w800,
                  textColor: kDark,
                ),
                SizedBox(height: 2.h),
                _starsRow(s.average),
                SizedBox(height: 4.h),
                ReuseableText(
                  text: '(${_formatCount(s.count)} reviews)',
                  fontSize: 10.spMin,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          // Right column — bar breakdown 5 -> 1.
          Expanded(
            flex: 3,
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final value = s.countFor(star);
                final ratio = maxInBreakdown == 0 ? 0.0 : value / maxInBreakdown;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                        child: ReuseableText(
                          text: '$star',
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: kOffWhite,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: ratio,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kSecondary,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _starsRow(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final full = i < rating.floor();
        final half = !full && (i < rating);
        return Icon(
          full
              ? Icons.star_rounded
              : (half ? Icons.star_half_rounded : Icons.star_border_rounded),
          color: kSecondary,
          size: 16.spMin,
        );
      }),
    );
  }

  Widget _reviewCard(Review r) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppNetworkAvatar(
                imageUrl: r.userPhoto,
                radius: 18.r,
                backgroundColor: kOffWhite,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReuseableText(
                      text: r.username.isEmpty ? 'User' : r.username,
                      fontSize: 13.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: kDark,
                    ),
                    SizedBox(height: 1.h),
                    ReuseableText(
                      text: _formatDate(r.createdAt),
                      fontSize: 10.spMin,
                      fontWeight: FontWeight.w400,
                      textColor: kGray,
                    ),
                  ],
                ),
              ),
              _starsRow(r.rating),
            ],
          ),
          if (r.comment.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ReuseableText(
              text: r.comment,
              fontSize: 12.spMin,
              fontWeight: FontWeight.w400,
              textColor: kDark,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _formatCount(int count) {
    if (count < 1000) return '$count';
    final k = (count / 1000);
    return '${k.toStringAsFixed(k < 10 ? 1 : 0)}k';
  }
}
