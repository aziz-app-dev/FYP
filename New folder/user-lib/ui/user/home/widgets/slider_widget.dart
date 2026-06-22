import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/config.dart';
import '../../../../utils/loaders_utils.dart';

class ImageCarouselWithIndicator extends StatefulWidget {
  final List<String> imgList;
  final bool autoPlay;
  final int autoPlayInterval;
  final bool showDots;
  final double? height;

  const ImageCarouselWithIndicator({
    super.key,
    required this.imgList,
    this.autoPlay = true,
    this.autoPlayInterval = 3000,
    this.showDots = true,
    this.height,
  });

  @override
  State<ImageCarouselWithIndicator> createState() =>
      _ImageCarouselWithIndicatorState();
}

class _ImageCarouselWithIndicatorState
    extends State<ImageCarouselWithIndicator> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = widget.imgList;
    final colors = context.colors;

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: imgList.length,
          itemBuilder: (context, index, realIndex) {
            final url = imgList[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, _) => Container(
                  color: colors.shimmerBase,
                  child: Center(child: appLoader()),
                ),
                errorWidget: (_, _, _) => Container(
                  color: colors.shimmerBase,
                  child: Icon(Icons.error, color: colors.error),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: ScreenUtils.isMobile(context)
                ? 150.spMin
                : ScreenUtils.isTablet(context)
                    ? 190.spMin
                    : 310.spMin,
            viewportFraction: 1,
            autoPlay: widget.autoPlay,
            autoPlayInterval: Duration(
              milliseconds: widget.autoPlayInterval,
            ),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
        ),
        if (widget.showDots) ...[
          const SizedBox(height: 8),
          ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, index, _) => AnimatedSmoothIndicator(
              activeIndex: index,
              count: imgList.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotColor: colors.primary,
                dotColor: colors.border.withValues(alpha: .4),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
