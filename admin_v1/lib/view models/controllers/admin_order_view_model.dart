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
import '../../models/order/admin_order_model.dart';

/// Backend uses these exact strings in the `orderStatus` field.
class OrderStatus {
  static const String all = ''; // no filter -> every order
  static const String pending = 'Pending';
  static const String preparing = 'Preparing';
  static const String ready = 'Ready';
  static const String pickedUp = 'Out For Delivery';
  static const String delivering = 'Delivering';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';

  /// Every status the admin may set on an order.
  static const List<String> settable = [
    pending,
    preparing,
    ready,
    pickedUp,
    delivering,
    delivered,
    cancelled,
  ];
}

/// One controller per admin Orders tab (same registry pattern as the
/// vendor app): each tab keeps its own list, and after any status
/// update every registered sibling refetches so no tab goes stale.
class AdminOrderController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<AdminOrder> orders = <AdminOrder>[].obs;

  /// Status this controller is bound to ('' = all orders).
  String _boundStatus = '';
  bool _bound = false;

  static final Set<AdminOrderController> _registry = {};

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

  /// GET /api/order/admin?orderStatus=XYZ (or unfiltered when [status]
  /// is empty). Registers this controller so sibling tabs can ask it
  /// to refetch after their own updates.
  Future<void> fetchByStatus(String status) async {
    _boundStatus = status;
    _bound = true;
    _registry.add(this);
    _isLoading.value = true;
    try {
      final query = status.isEmpty ? '' : '?orderStatus=$status';
      final response = await http.get(
        Uri.parse('${AppUrl.adminOrdersApi}$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          orders.assignAll(
              decoded.map((e) => AdminOrder.fromJson(e)).toList());
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

  /// PUT /api/order/:id with { orderStatus: newStatus }. Admin can set
  /// any status (the backend lets admins override the cancel guard).
  Future<bool> updateStatus(String orderId, String newStatus) async {
    if (newStatus == OrderStatus.cancelled) {
      final confirmed = await _confirmCancel();
      if (confirmed != true) return false;
    }

    try {
      final response = await http.put(
        Uri.parse(AppUrl.orderStatusApi(orderId)),
        headers: _headers,
        body: jsonEncode({'orderStatus': newStatus}),
      );
      if (response.statusCode == 200) {
        Utils.showSuccess('Updated', 'Order moved to "$newStatus"');
        // Refetch every registered tab (including this one) so both the
        // source and destination tabs show fresh data.
        for (final ctrl in _registry) {
          if (!ctrl._bound) continue;
          // ignore: unawaited_futures
          ctrl.fetchByStatus(ctrl._boundStatus);
        }
        return true;
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Update failed', err.message);
        return false;
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    }
  }

  Future<bool?> _confirmCancel() {
    return Get.dialog<bool>(
      Dialog(
        backgroundColor: kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(254, 16, 77, 0.12),
                ),
                child: const Icon(Icons.cancel_outlined, color: kRed, size: 28),
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
                    'As admin you can cancel at any stage. The customer and the vendor will see the order in Cancelled.',
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
