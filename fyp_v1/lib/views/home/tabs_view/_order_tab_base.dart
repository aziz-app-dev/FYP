import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/vendor_order_view_model.dart';
import '../order_details_view.dart';
import '../widgets/vendor_order_tile.dart';

/// Generic vendor order tab.
///
/// - `status` is the server-side `orderStatus` string this tab filters by.
/// - `primaryLabel` / `primaryNextStatus`: button that moves the order
///    forward in the pipeline.
/// - `secondaryLabel` / `secondaryNextStatus`: optional second button
///    (usually "Cancel"). Null on terminal tabs.
class OrderTabBase extends StatefulWidget {
  final String status;
  final String? primaryLabel;
  final String? primaryNextStatus;
  final String? secondaryLabel;
  final String? secondaryNextStatus;

  const OrderTabBase({
    super.key,
    required this.status,
    this.primaryLabel,
    this.primaryNextStatus,
    this.secondaryLabel,
    this.secondaryNextStatus,
  });

  @override
  State<OrderTabBase> createState() => _OrderTabBaseState();
}

class _OrderTabBaseState extends State<OrderTabBase>
    with AutomaticKeepAliveClientMixin {
  late final VendorOrderController _ctrl =
      Get.put(VendorOrderController(), tag: widget.status);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _ctrl.fetchByStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () => _ctrl.fetchByStatus(widget.status),
      child: Obx(() {
        if (_ctrl.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimary),
          );
        }
        if (_ctrl.orders.isEmpty) {
          // Centered empty state — still scrollable so pull-to-refresh works.
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 56.spMin,
                          color: kGray,
                        ),
                        SizedBox(height: 12.h),
                        ReuseableText(
                          text: 'No ${widget.status.toLowerCase()} orders',
                          fontSize: 14.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        ReuseableText(
                          text: 'Pull down to refresh.',
                          fontSize: 11.spMin,
                          fontWeight: FontWeight.w400,
                          textColor: kGray,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          itemCount: _ctrl.orders.length,
          itemBuilder: (context, i) {
            final o = _ctrl.orders[i];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.to(
                () => VendorOrderDetailsScreen(
                  order: o,
                  tabStatus: widget.status,
                  primaryLabel: widget.primaryLabel,
                  primaryNextStatus: widget.primaryNextStatus,
                  secondaryLabel: widget.secondaryLabel,
                  secondaryNextStatus: widget.secondaryNextStatus,
                ),
                transition: Transition.rightToLeft,
              ),
              child: VendorOrderTile(
                order: o,
                primaryLabel: widget.primaryLabel,
                onPrimary: widget.primaryNextStatus == null
                    ? null
                    : () =>
                        _ctrl.updateStatus(o.id, widget.primaryNextStatus!),
                secondaryLabel: widget.secondaryLabel,
                onSecondary: widget.secondaryNextStatus == null
                    ? null
                    : () =>
                        _ctrl.updateStatus(o.id, widget.secondaryNextStatus!),
              ),
            );
          },
        );
      }),
    );
  }
}
