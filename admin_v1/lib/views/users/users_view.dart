import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/empty_state.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../models/user/admin_user_model.dart';
import '../../view models/controllers/admin_users_view_model.dart';

/// Every account on the platform, filterable by role.
class UsersView extends StatelessWidget {
  UsersView({super.key});

  final AdminUsersController controller = Get.put(AdminUsersController());

  static const List<(String label, String value)> _filters = [
    ('All', ''),
    ('Customers', 'Client'),
    ('Vendors', 'Vendor'),
    ('Admins', 'Admin'),
    ('Drivers', 'Driver'),
  ];

  static final _date = DateFormat('dd MMM yyyy');

  static Color _roleColor(String userType) {
    switch (userType) {
      case 'Admin':
        return kRed;
      case 'Vendor':
        return kSecondary;
      case 'Driver':
        return kTertiary;
      default:
        return kPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kWhite,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: _filters.map((f) {
                  final selected = controller.filter.value == f.$2;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f.$1),
                      selected: selected,
                      onSelected: (_) => controller.setFilter(f.$2),
                      labelStyle: TextStyle(
                        color: selected ? kWhite : kGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      selectedColor: kPrimary,
                      backgroundColor: kOffWhite,
                      side: BorderSide.none,
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: kPrimary,
            onRefresh: controller.fetchUsers,
            child: Obx(() {
              if (controller.isLoading && controller.users.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: kPrimary));
              }
              if (controller.users.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 80),
                    EmptyState(
                      icon: Icons.people_outline,
                      title: 'No users found',
                      message: 'Pull down to refresh.',
                    ),
                  ],
                );
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.users.length,
                itemBuilder: (context, index) =>
                    _userCard(controller.users[index]),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _userCard(AdminUser user) {
    final roleColor = _roleColor(user.userType);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 48,
              height: 48,
              child: user.profile.isEmpty
                  ? Container(
                      color: kOffWhite,
                      child: const Icon(Icons.person_outline,
                          color: kGrayLight),
                    )
                  : CachedNetworkImage(
                      imageUrl: user.profile,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: kOffWhite,
                        child: const Icon(Icons.person_outline,
                            color: kGrayLight),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ReuseableText(
                        text: user.username.isEmpty ? '—' : user.username,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: kDark,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ReuseableText(
                        text: user.userType,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        textColor: roleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ReuseableText(
                  text: user.email,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      user.verification
                          ? Icons.verified_outlined
                          : Icons.error_outline,
                      size: 14,
                      color: user.verification ? kPrimary : kGrayLight,
                    ),
                    const SizedBox(width: 4),
                    ReuseableText(
                      text: user.verification ? 'Verified' : 'Unverified',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      textColor: kGray,
                    ),
                    const Spacer(),
                    if (user.createdAt != null)
                      ReuseableText(
                        text:
                            'Joined ${_date.format(user.createdAt!.toLocal())}',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        textColor: kGrayLight,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
