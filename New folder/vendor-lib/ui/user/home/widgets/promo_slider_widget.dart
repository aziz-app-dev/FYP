import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config/config.dart';
import '../../../../model/home/home_model.dart';
import '../../../../utils/loaders_utils.dart';
import '../../../../utils/screen_utils.dart';

class PromoSliderWidget extends StatefulWidget {
  final List<SliderItem> slides;
  final SliderStyle? style;
  final void Function(SliderItem slide)? onSlideTap;

  const PromoSliderWidget({
    super.key,
    required this.slides,
    this.style,
    this.onSlideTap,
  });

  @override
  State<PromoSliderWidget> createState() => _PromoSliderWidgetState();
}

class _PromoSliderWidgetState extends State<PromoSliderWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final autoPlay = widget.style?.autoPlay ?? true;
    final interval = widget.style?.interval ?? 4000;
    final showDots = widget.style?.showDots ?? true;

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.slides.length,
          itemBuilder: (context, index, realIndex) {
            final slide = widget.slides[index];
            return GestureDetector(
              onTap: widget.onSlideTap != null
                  ? () => widget.onSlideTap!(slide)
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: slide.imageUrl ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, _) => Container(
                        color: colors.shimmerBase,
                        child: Center(child: appLoader()),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: colors.shimmerBase,
                        child: Icon(
                          Icons.image_not_supported,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    if ((slide.title?.isNotEmpty ?? false) ||
                        (slide.subtitle?.isNotEmpty ?? false))
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(10.spMin),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: .5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (slide.title?.isNotEmpty ?? false)
                                Text(
                                  slide.title!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (slide.subtitle?.isNotEmpty ?? false)
                                Text(
                                  slide.subtitle!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(
                                      alpha: .85,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: ScreenUtils.isMobile(context)
                ? 140.spMin
                : ScreenUtils.isTablet(context)
                    ? 170.spMin
                    : 280.spMin,
            viewportFraction: 1,
            autoPlay: autoPlay,
            autoPlayInterval: Duration(milliseconds: interval),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
        ),
        if (showDots) ...[
          const SizedBox(height: 8),
          ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, index, _) => AnimatedSmoothIndicator(
              activeIndex: index,
              count: widget.slides.length,
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
