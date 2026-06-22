import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../model/address/address_model.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

class HeaderWidget extends StatefulWidget {
  final TextEditingController controller;
  const HeaderWidget({super.key, required this.controller});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final SessionManager _session = SessionManager();
  final ValueNotifier<int> _refreshTick = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  void dispose() {
    _refreshTick.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    await _session.loadAddresses();
    if (mounted) _refreshTick.value++;
  }

  void _navigateToAddresses() async {
    await Navigator.pushNamed(context, RouteName.myAddresses);
    // Refresh addresses after returning from address page
    await _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _refreshTick,
      builder: (context, _, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.colors;
    final user = _session.user;
    final profileImage = user?.profile;
    // ignore: unused_local_variable
    final username = user?.username ?? 'Guest';

    // Get display address
    final AddressModel? displayAddress = _session.displayAddress;
    final String addressText =
        displayAddress?.shortAddress ?? 'Add delivery address';
    final bool hasAddress = displayAddress != null;

    return Padding(
      padding: EdgeInsets.all(8.spMin),
      child: Column(
        spacing: 10.spMin,
        children: [
          Row(
            spacing: 5.spMin,
            children: [
              Container(
                padding: EdgeInsets.all(2.spMin),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20.spMin,
                  backgroundColor: colors.card,
                  child: profileImage != null && profileImage.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profileImage,
                            width: 36.spMin,
                            height: 36.spMin,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Icon(
                              Icons.person,
                              size: 20.spMin,
                              color: colors.primary,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 20.spMin,
                              color: colors.primary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 20.spMin,
                          color: colors.primary,
                        ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: _navigateToAddresses,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        " Deliver To",
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              color: colors.primary,
                                              letterSpacing: 0,
                                              height: 0,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(width: 2.spMin),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: colors.primary,
                                        size: 18.spMin,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.spMin),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (hasAddress)
                                        Icon(
                                          Icons.location_on,
                                          color: colors.primary,
                                          size: 12.spMin,
                                        ),
                                      if (hasAddress) SizedBox(width: 4.spMin),
                                      Flexible(
                                        child: Text(
                                          addressText,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: hasAddress
                                                    ? colors.textPrimary
                                                    : colors.textSecondary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6.spMin),
                      decoration: BoxDecoration(
                        color: colors.fillColor,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCircular,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: colors.iconPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RouteName.search),
                  child: Container(
                    height: 40.spMin,
                    padding: EdgeInsets.symmetric(horizontal: 12.spMin),
                    decoration: BoxDecoration(
                      color: colors.fillColor,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: colors.iconSecondary,
                          size: 20.spMin,
                        ),
                        SizedBox(width: 8.spMin),
                        Text(
                          'Search...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.spMin),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteName.restaurantQrScanner,
                ),
                child: Container(
                  width: 40.spMin,
                  height: 40.spMin,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 20.spMin,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getGreetingEmoji() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return '☀️';
  } else if (hour >= 12 && hour < 17) {
    return '🌤';
  } else if (hour >= 17 && hour < 21) {
    return '🌇';
  } else {
    return '🌙';
  }
}
