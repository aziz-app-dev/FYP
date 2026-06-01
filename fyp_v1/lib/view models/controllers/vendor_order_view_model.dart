import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/order/vendor_order_model.dart';

/// Backend uses these exact strings in the `orderStatus` field.
class OrderStatus {
  static const String pending = 'Pending'; // "New" for vendor
  static const String preparing = 'Preparing';
  static const String ready = 'Ready';
  static const String pickedUp = 'Out For Delivery';
  static const String delivering = 'Delivering';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
}

/// One controller per vendor-app tab. Each tab `Get.put`s its own instance
/// tagged by status and keeps its own orders list.
///
/// To avoid stale caches across tabs (e.g., moving "Preparing" -> "Ready"
/// wouldn't show up on the Ready tab until manual refresh), every
/// instance registers itself in a static set and `updateStatus` asks
/// every registered controller to refetch after the backend update
/// succeeds.
class VendorOrderController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<VendorOrder> orders = <VendorOrder>[].obs;

  /// The status string this controller is bound to (set by the tab via
  /// [bind]). Used to refetch this specific instance after any other
  /// tab triggers an update.
  String _boundStatus = '';

  /// All registered tab controllers — used to broadcast refetches.
  static final Set<VendorOrderController> _registry = {};

  /// Read-only view of every registered tab controller. External
  /// callers (e.g. the analytics controller) use this to trigger
  /// a refetch across every open tab.
  static Iterable<VendorOrderController> get allRegistered => _registry;

  /// Refetch this controller's own bound status — useful for external
  /// callers that don't know the status string.
  Future<void> refetch() {
    if (_boundStatus.isEmpty) return Future.value();
    return fetchByStatus(_boundStatus);
  }

  @override
  void onClose() {
    _registry.remove(this);
    super.onClose();
  }

  Map<String, String> get _headers {
    final String? token = box.read('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /api/order/vendor?orderStatus=XYZ. Also records this
  /// controller as the owner of [status] so sibling tabs can refetch
  /// it after any update.
  Future<void> fetchByStatus(String status) async {
    _boundStatus = status;
    _registry.add(this);
    _isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/order/vendor?orderStatus=$status'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          orders.assignAll(
              decoded.map((e) => VendorOrder.fromJson(e)).toList());
        } else {
          orders.clear();
        }
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to load orders', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  /// PUT /api/order/:id  with { orderStatus: newStatus }.
  ///
  /// - Shows a "Are you sure?" dialog when the action is Cancel.
  /// - On success, removes the order from this tab's local list AND
  ///   asks every other registered tab controller to refetch its list
  ///   so the order reappears on the destination tab.
  Future<void> updateStatus(String orderId, String newStatus) async {
    // Confirm before cancelling — irreversible destructive action.
    if (newStatus == OrderStatus.cancelled) {
      final confirmed = await _confirmCancel();
      if (confirmed != true) return;
    }

    // Confirm before restoring a cancelled order (transition from
    // the Cancelled tab back to New Orders).
    final current = orders.firstWhereOrNull((o) => o.id == orderId);
    if (current?.orderStatus == OrderStatus.cancelled &&
        newStatus == OrderStatus.pending) {
      final confirmed = await _confirmRestore();
      if (confirmed != true) return;
    }

    try {
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/api/order/$orderId'),
        headers: _headers,
        body: jsonEncode({'orderStatus': newStatus}),
      );
      if (response.statusCode == 200) {
        // Local optimistic removal from source tab.
        orders.removeWhere((o) => o.id == orderId);
        Utils.showSuccess('Updated', 'Order moved to "$newStatus"');

        // Refetch every OTHER registered tab so the destination
        // tab sees the newly-moved order next time it's shown and
        // sibling tabs don't keep stale state.
        for (final ctrl in _registry) {
          if (identical(ctrl, this)) continue;
          if (ctrl._boundStatus.isEmpty) continue;
          // ignore: unawaited_futures
          ctrl.fetchByStatus(ctrl._boundStatus);
        }
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Update failed', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    }
  }

  /// Confirmation popup shown before restoring a cancelled order
  /// back to Pending.
  Future<bool?> _confirmRestore() {
    return Get.dialog<bool>(
      Dialog(
        backgroundColor: kWhite,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(48, 185, 178, 0.12),
                ),
                child: const Icon(Icons.undo_rounded,
                    color: kPrimary, size: 28),
              ),
              const SizedBox(height: 16),
              const ReuseableText(
                text: 'Restore this order ?',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: kDark,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const ReuseableText(
                text:
                    'The order will be moved back to New Orders and will need to be processed again.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: kGray,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(131, 130, 154, 0.4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const ReuseableText(
                          text: 'Keep Cancelled',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: true),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const ReuseableText(
                          text: 'Yes, restore',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: kLightWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  /// Reusable confirmation popup for Cancel actions.
  Future<bool?> _confirmCancel() {
    return Get.dialog<bool>(
      Dialog(
        backgroundColor: kWhite,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(254, 16, 77, 0.12),
                ),
                child: const Icon(Icons.cancel_outlined,
                    color: kRed, size: 28),
              ),
              const SizedBox(height: 16),
              const ReuseableText(
                text: 'Cancel this order ?',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: kDark,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const ReuseableText(
                text:
                    'This cannot be undone. The customer will be notified and the order will move to the Cancelled tab.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: kGray,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(131, 130, 154, 0.4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const ReuseableText(
                          text: 'Keep',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: true),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: kRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const ReuseableText(
                          text: 'Yes, cancel',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: kLightWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
