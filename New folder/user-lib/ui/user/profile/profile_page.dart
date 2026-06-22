import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/app_btn.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../bloc/user/edit_profile/edit_profile_bloc.dart';
import '../../../bloc/user/edit_profile/edit_profile_event.dart';
import '../../../bloc/user/edit_profile/edit_profile_state.dart';

import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../routes/route_name.dart';
import '../../../services/session/session_manger.dart';
import 'widgets/profile_avatar_widget.dart';
import 'widgets/thme_switch_widget.dart';
import 'widgets/tiles_widget.dart';
import 'widgets/verfiy_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SessionManager _sessionManager = SessionManager();
  late EditProfileBloc _editProfileBloc;
  final ValueNotifier<int> _refreshTick = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _editProfileBloc = getIt<EditProfileBloc>()..add(LoadProfileEvent());
    // Ensure session is loaded when profile page opens
    _sessionManager.loadSession();
  }

  @override
  void dispose() {
    _editProfileBloc.close();
    _refreshTick.dispose();
    super.dispose();
  }

  Future<void> _navigateToEmailVerification(BuildContext context) async {
    final user = _sessionManager.user;
    await Navigator.pushNamed(
      context,
      RouteName.otpVerification,
      arguments: {'email': user?.email, 'verificationType': 'email'},
    );
    // Reload session and refresh UI after returning from verification
    await _sessionManager.loadSession();
    if (mounted) _refreshTick.value++;
  }

  Future<void> _navigateToPhoneVerification(BuildContext context) async {
    final user = _sessionManager.user;
    await Navigator.pushNamed(
      context,
      RouteName.otpVerification,
      arguments: {'phoneNumber': user?.phone, 'verificationType': 'phone'},
    );
    // Reload session and refresh UI after returning from verification
    await _sessionManager.loadSession();
    if (mounted) _refreshTick.value++;
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    await _sessionManager.clearSession();
    if (mounted) {
      navigator.pushNamedAndRemoveUntil(RouteName.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _editProfileBloc,
      child: ValueListenableBuilder<int>(
        valueListenable: _refreshTick,
        builder: (context, _, _) =>
            BlocBuilder<EditProfileBloc, EditProfileState>(
              buildWhen: (previous, current) => previous.user != current.user,
              builder: (context, editState) {
                final user = editState.user ?? _sessionManager.user;
                final username = user?.username ?? 'Guest';
                final email = user?.email ?? 'No email provided';
                final isEmailVerified = user?.verification ?? false;
                final isPhoneVerified = user?.phoneVerification ?? false;
                final phone = user?.phone;

                return ScreenWrapper(
                  mobileHeader: CustomHeader(
                    title: 'Profile',
                    showBackButton: false,
                    verticalPadding: HeaderVerticalPadding.bottom,
                  ),
                  mobile: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      16.spMin,
                      4.spMin,
                      16.spMin,
                      16.spMin,
                    ),
                    child: Column(
                      spacing: 10.spMin,
                      children: [
                        ProfileAvatarWidget(
                          size: 120.spMin,
                          showEditButton: true,
                          showGlow: true,
                        ),
                        Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.spMin),
                          child: Text(
                            email,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        if (!isPhoneVerified || !isEmailVerified)
                          if (!isPhoneVerified)
                            VerificationAlert(
                              icon: Icons.phone_outlined,
                              title: 'Verify Phone Number',
                              subtitle:
                                  phone ?? 'Add a phone for account security',
                              isVerified: isPhoneVerified,
                              onVerifyTap: () =>
                                  _navigateToPhoneVerification(context),
                            ),
                        if (!isPhoneVerified && !isEmailVerified)
                          if (!isEmailVerified)
                            VerificationAlert(
                              icon: Icons.email_outlined,
                              title: 'Verify Email',
                              subtitle: email,
                              isVerified: isEmailVerified,
                              onVerifyTap: () =>
                                  _navigateToEmailVerification(context),
                            ),
                        if (!isPhoneVerified || !isEmailVerified)
                          ProfileMenuTile(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.editProfile,
                            ),
                          ),
                        if (_sessionManager.isVendor) ...[
                          ProfileMenuTile(
                            icon: Icons.store_outlined,
                            title: 'Restaurant Settings',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.vendorSettings,
                            ),
                          ),
                          ProfileMenuTile(
                            icon: Icons.analytics_outlined,
                            title: 'Analytics',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.vendorAnalytics,
                            ),
                          ),
                          ProfileMenuTile(
                            icon: Icons.table_restaurant_outlined,
                            title: 'Table Management',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.tableManagement,
                            ),
                          ),
                        ],
                        if (!_sessionManager.isVendor) ...[
                          if (_sessionManager.isOrderingEnabled) ...[
                            ProfileMenuTile(
                              icon: Icons.favorite_border,
                              title: 'Favorite Foods',
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteName.favoriteFoods,
                              ),
                            ),
                            ProfileMenuTile(
                              icon: Icons.receipt_long_outlined,
                              title: 'My Orders',
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteName.myOrders,
                              ),
                            ),
                          ],
                          ProfileMenuTile(
                            icon: Icons.star_border_rounded,
                            title: 'My Reviews',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.myReviews,
                            ),
                          ),
                          if (_sessionManager.isOrderingEnabled)
                            ProfileMenuTile(
                              icon: Icons.location_on_outlined,
                              title: 'My Addresses',
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteName.myAddresses,
                              ),
                            ),
                          if (_sessionManager.isTableReservationEnabled)
                            ProfileMenuTile(
                              icon: Icons.table_restaurant_outlined,
                              title: 'My Reservations',
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteName.myReservations,
                              ),
                            ),
                          if (_sessionManager.isOrderingEnabled)
                            const ProfileMenuTile(
                              icon: Icons.credit_card_outlined,
                              title: 'Payment Methods',
                            ),
                          ProfileMenuTile(
                            icon: Icons.storefront_outlined,
                            title: 'Become a Vendor',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.createRestaurant,
                            ),
                          ),
                        ],
                        if (_sessionManager.isOrderingEnabled)
                          ProfileMenuTile(
                            icon: Icons.qr_code_scanner_rounded,
                            title: 'Verify Order QR',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.qrScanner,
                            ),
                          ),
                        const ProfileMenuTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          hasSwitch: true,
                        ),
                        buildThemeTile(context, colors),
                        if (!_sessionManager.isVendor)
                          ProfileMenuTile(
                            icon: Icons.style_outlined,
                            title: 'Card Style Settings',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.cardStyleSettings,
                            ),
                          ),
                        ProfileMenuTile(
                          icon: Icons.settings_outlined,
                          title: 'App Settings',
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteName.appSettings,
                          ),
                        ),
                        const ProfileMenuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                        ),
                        SizedBox(height: 10.h),
                        AppButton(
                          width: double.infinity,
                          height: 50.spMin,
                          backgroundColor: colors.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderColor: colors.error,
                          textColor: colors.error,
                          text: 'Log Out',
                          onPressed: _logout,
                        ),
                        SizedBox(height: 120.h),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
