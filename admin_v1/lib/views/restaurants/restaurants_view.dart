import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/empty_state.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/components/status_chip.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../view models/controllers/admin_restaurants_view_model.dart';

/// Restaurant applications: approve / reject pending vendors, and
/// review already verified or rejected restaurants.
class RestaurantsView extends StatelessWidget {
  RestaurantsView({super.key});

  final AdminRestaurantsController controller =
      Get.put(AdminRestaurantsController());

  static const _tabs = ['Pending', 'Verified', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        children: [
          Container(
            color: kWhite,
            child: TabBar(
              labelColor: kPrimary,
              unselectedLabelColor: kGray,
              indicatorColor: kPrimary,
              indicatorWeight: 3,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              tabs: [for (final t in _tabs) Tab(text: t)],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final t in _tabs) _RestaurantList(verification: t),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantList extends StatelessWidget {
  final String verification;

  const _RestaurantList({required this.verification});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminRestaurantsController>();
    return RefreshIndicator(
      color: kPrimary,
      onRefresh: controller.fetchRestaurants,
      child: Obx(() {
        if (controller.isLoading && controller.restaurants.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimary));
        }
        final list = controller.byVerification(verification);
        if (list.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 80),
              EmptyState(
                icon: Icons.storefront_outlined,
                title: 'No $verification restaurants',
                message: 'Pull down to refresh.',
              ),
            ],
          );
        }
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _RestaurantCard(restaurant: list[index]),
        );
      }),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminRestaurantsController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: restaurant.logoUrl.isEmpty
                      ? Container(
                          color: kOffWhite,
                          child: const Icon(Icons.storefront_outlined,
                              color: kGrayLight),
                        )
                      : CachedNetworkImage(
                          imageUrl: restaurant.logoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: kOffWhite,
                            child: const Icon(Icons.storefront_outlined,
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
                            text: restaurant.title,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            textColor: kDark,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusChip(label: restaurant.verification),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (restaurant.coords.address.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: kGrayLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ReuseableText(
                              text: restaurant.coords.address,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: kGray,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: kGrayLight),
                        const SizedBox(width: 4),
                        ReuseableText(
                          text: restaurant.time.isEmpty
                              ? '—'
                              : restaurant.time,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: kGray,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          restaurant.isAvailable
                              ? Icons.check_circle_outline
                              : Icons.do_not_disturb_on_outlined,
                          size: 14,
                          color:
                              restaurant.isAvailable ? kPrimary : kGrayLight,
                        ),
                        const SizedBox(width: 4),
                        ReuseableText(
                          text: restaurant.isAvailable ? 'Open' : 'Closed',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: kGray,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final updating = controller.updatingId.value == restaurant.id;
            return Row(
              children: [
                if (restaurant.verification != 'Verified')
                  Expanded(
                    child: _actionButton(
                      label: 'Approve',
                      color: kPrimary,
                      loading: updating,
                      onTap: () => controller.setVerification(
                          restaurant.id, 'Verified'),
                    ),
                  ),
                if (restaurant.verification != 'Verified' &&
                    restaurant.verification != 'Rejected')
                  const SizedBox(width: 10),
                if (restaurant.verification != 'Rejected')
                  Expanded(
                    child: _actionButton(
                      label: 'Reject',
                      color: kRed,
                      loading: updating,
                      onTap: () => controller.setVerification(
                          restaurant.id, 'Rejected'),
                    ),
                  ),
                if (restaurant.verification == 'Rejected') ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      label: 'Move to Pending',
                      color: kSecondary,
                      loading: updating,
                      onTap: () => controller.setVerification(
                          restaurant.id, 'Pending'),
                    ),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: color),
              )
            : ReuseableText(
                text: label,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                textColor: color,
              ),
      ),
    );
  }
}
