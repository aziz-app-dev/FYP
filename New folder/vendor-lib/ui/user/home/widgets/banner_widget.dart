import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../model/home/home_model.dart';
import '../../../../utils/loaders_utils.dart';

class HomeBannerWidget extends StatelessWidget {
  final BannerItem banner;
  final VoidCallback? onTap;

  const HomeBannerWidget({super.key, required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (banner.imageUrl == null || banner.imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: banner.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 160.spMin,
              placeholder: (_, _) => Container(
                height: 160.spMin,
                color: colors.shimmerBase,
                child: Center(child: appLoader()),
              ),
              errorWidget: (_, _, _) => Container(
                height: 160.spMin,
                color: colors.shimmerBase,
                child: Icon(
                  Icons.image_not_supported,
                  color: colors.textSecondary,
                ),
              ),
            ),
            // Overlay text if title or subtitle exist
            if ((banner.title?.isNotEmpty ?? false) ||
                (banner.subtitle?.isNotEmpty ?? false))
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12.spMin),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: .6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (banner.title?.isNotEmpty ?? false)
                        Text(
                          banner.title!,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (banner.subtitle?.isNotEmpty ?? false) ...[
                        SizedBox(height: 2.spMin),
                        Text(
                          banner.subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: .9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
